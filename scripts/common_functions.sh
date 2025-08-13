echo() { command echo -e "[SCRIPT]: $*"; }
error() { echo "ERROR: $*"; exit 1; }
xerror() { echo "ERROR: $*\n$(cat xerr)"; exit 1; }
warn() { echo "WARNING: $*"; }

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

  if [ -d system ]; then if [ -d system/system ]; then props=system/system/build.prop; else props=system/build.prop; fi
  elif [ -d vendor ]; then props=vendor/build.prop
  fi

  brand=$(grep -m1 -oP "(?<=^ro.product.brand=).*" -hs {system,system/system,vendor}/build*.prop | head -1)
  [[ -z "${brand}" ]] && brand=$(grep -m1 -oP "(?<=^ro.product.brand.sub=).*" -hs system/system/euclid/my_product/build*.prop)
  [[ -z "${brand}" ]] && brand=$(grep -m1 -oP "(?<=^ro.product.vendor.brand=).*" -hs vendor/build*.prop | head -1)
  [[ -z "${brand}" ]] && brand=$(grep -m1 -oP "(?<=^ro.vendor.product.brand=).*" -hs vendor/build*.prop | head -1)
  [[ -z "${brand}" ]] && brand=$(grep -m1 -oP "(?<=^ro.product.system.brand=).*" -hs {system,system/system}/build*.prop | head -1)
  [[ -z "${brand}" || ${brand} == "OPPO" ]] && brand=$(grep -m1 -oP "(?<=^ro.product.system.brand=).*" -hs vendor/euclid/*/build.prop | head -1)
  [[ -z "${brand}" ]] && brand=$(grep -m1 -oP "(?<=^ro.product.product.brand=).*" -hs vendor/euclid/product/build*.prop)
  [[ -z "${brand}" ]] && brand=$(grep -m1 -oP "(?<=^ro.product.odm.brand=).*" -hs vendor/odm/etc/build*.prop)
  [[ -z "${brand}" ]] && brand=$(grep -m1 -oP "(?<=^ro.product.brand=).*" -hs {oppo_product,my_product}/build*.prop | head -1)
  [[ -z "${brand}" ]] && brand=$(grep -m1 -oP "(?<=^ro.product.brand=).*" -hs vendor/euclid/*/build.prop | head -1)
  [[ -z "${brand}" ]] && brand=$(echo "$fingerprint" | cut -d'/' -f1)

  codename=$(grep -m1 -oP "(?<=^ro.product.device=).*" -hs {vendor,system,system/system}/build*.prop | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.vendor.product.device.oem=).*" -hs vendor/euclid/odm/build.prop | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.product.vendor.device=).*" -hs vendor/build*.prop | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.vendor.product.device=).*" -hs vendor/build*.prop | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.product.system.device=).*" -hs {system,system/system}/build*.prop | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.product.system.device=).*" -hs vendor/euclid/*/build.prop | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.product.product.device=).*" -hs vendor/euclid/*/build.prop | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.product.product.model=).*" -hs vendor/euclid/*/build.prop | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.product.device=).*" -hs {oppo_product,my_product}/build*.prop | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.product.product.device=).*" -hs oppo_product/build*.prop)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.product.system.device=).*" -hs my_product/build*.prop)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.product.vendor.device=).*" -hs my_product/build*.prop)
  [[ -z "${codename}" ]] && codename=$(echo "$fingerprint" | cut -d'/' -f3 | cut -d':' -f1)
  [[ -z "${codename}" ]] && codename=$(grep -m1 -oP "(?<=^ro.build.fota.version=).*" -hs {system,system/system}/build*.prop | cut -d'-' -f1 | head -1)
  [[ -z "${codename}" ]] && codename=$(grep -oP "(?<=^ro.build.product=).*" -hs {vendor,system,system/system}/build*.prop | head -1)
  

  fingerprint=$(grep -m1 -oP "(?<=^ro.build.fingerprint=).*" -hs {system,system/system}/build*.prop)
  [[ -z "${fingerprint}" ]] && fingerprint=$(grep -m1 -oP "(?<=^ro.vendor.build.fingerprint=).*" -hs vendor/build*.prop | head -1)
  [[ -z "${fingerprint}" ]] && fingerprint=$(grep -m1 -oP "(?<=^ro.system.build.fingerprint=).*" -hs {system,system/system}/build*.prop)
  [[ -z "${fingerprint}" ]] && fingerprint=$(grep -m1 -oP "(?<=^ro.product.build.fingerprint=).*" -hs product/build*.prop)
  [[ -z "${fingerprint}" ]] && fingerprint=$(grep -m1 -oP "(?<=^ro.build.fingerprint=).*" -hs {oppo_product,my_product}/build*.prop)
  [[ -z "${fingerprint}" ]] && fingerprint=$(grep -m1 -oP "(?<=^ro.system.build.fingerprint=).*" -hs my_product/build.prop)
  [[ -z "${fingerprint}" ]] && fingerprint=$(grep -m1 -oP "(?<=^ro.vendor.build.fingerprint=).*" -hs my_product/build.prop)
  [[ -z "${fingerprint}" ]] && fingerprint=$(grep -m1 -oP "(?<=^ro.bootimage.build.fingerprint=).*" -hs vendor/build.prop)

  release=$(grep -m1 -oP "(?<=^ro.build.version.release=).*" -hs {system,system/system,vendor}/build*.prop)
  [[ -z "${release}" ]] && release=$(grep -m1 -oP "(?<=^ro.vendor.build.version.release=).*" -hs vendor/build*.prop)
  [[ -z "${release}" ]] && release=$(grep -m1 -oP "(?<=^ro.system.build.version.release=).*" -hs {system,system/system}/build*.prop)

  export BRAND="$(tr 'A-Z' 'a-z' <<< $brand)"
  export DEVICE="$(tr 'A-Z' 'a-z' <<< $codename)"
  export FINGERPRINT="$fingerprint"
  export VERSION="$release"
  
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

