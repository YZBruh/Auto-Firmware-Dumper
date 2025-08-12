echo() { command echo -e "[SCRIPT]: $*"; }
error() { echo "ERROR: $*"; exit 1; }
xerror() { echo "ERROR: $*\n$(cat xerr)"; exit 1; }
warn() { echo "WARNING: $*"; }

get_prop() {
  [ $# -lt 1 ] && error "Missing: prop name"
  grep "$1=" $(if [ -z $2 ]; then echo build.prop; else echo $2; fi) | cut -d'=' -f2
}

compress() {
  [ $# -lt 1 ] && echo "Missing: file"
  [ $(stat -c %s "$1") -gt 51380224 ] \
    && gzip -f "$1" &>xerr || xerror
  [ $(stat -c %s "$1".gz) -gt 51380224 ] \
    && rm -f "$1".gz

  echo "Compressed file: $1"
}

dump_props() {
  [ $# -lt 1 ] && error "Missing: working directory"
  cd "$1"

  if [ -d product ]; then props=product/build.prop
  elif [ -d vendor ]; then props=vendor/build.prop
  fi

  local brand="$(get_prop ro.product.brand $props)"
  [ -z "$brand" ] && brand="$(get_prop ro.vendor.product.brand $props)"

  local codename="$(get_prop ro.product.device $props)"
  [ -z "$codename" ] && codename="$(get_prop ro.vendor.product.device $props)"
  codename="$(tr -d '[:space:]' <<< $codename)"

  local fp="$(get_prop ro.product.build.fingerprint $props)"
  [ -z "$fp" ] && fp="$(get_prop ro.vendor.build.fingerprint $props)"

  local version="$(get_prop ro.product.build.version $props)"
  [ -z "$fp" ] && version="$(get_prop ro.vendor.build.version $props)"

  export BRAND="$(tr 'A-Z' 'a-z' <<< $brand)"
  export DEVICE="$(tr 'A-Z' 'a-z' <<< $codename)"
  export FINGERPRINT="$codename"
  export VERSION="$version"
  
  cd -
}

dump_props_to_env_file() {
  [ $# -lt 1 ] && error "Missing: working directory"
  dump_props "$1"
  echo "export BRAND=$BRAND" > env
  echo "export DEVICE=$DEVICE" >> env
  echo "export FINGERPRINT=$FINGERPRINT" >> env
  echo "export VERSION=$VERSION" >> env
}

compress_files() {
  [ $# < 1 ] && error "Missing: working directory"
  [ ! -d "$1" ] && error "Cannot find directory"

  find "$1" -type f -size +50M -exec compress {} \;
}

git_auth() {
  [ $# -lt 3 ] && error "Missing argument"
  unset GITHUB_TOKEN
  git config --global user.name "$1"
  git config --global user.email "$2"
  gh auth login --with-token <<< "$3"
}

