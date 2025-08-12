#!/usr/bin/bash

. common_functions.sh

THIS="$0"

[ -z $1 ] && error "Working directory not speficed."
WORK_DIR="$1"

cd "$WORK_DIR" || exit 1;

echo "Updating and upgrading all packages..."
sudo apt -y update &>xerr || xerror "Cannot update packages!"
sudo apt -y upgrade &>xerr || xerror "Cannot upgrade packages!"

echo "Installing required packages..."
sudo apt -y install \
  cpio \
  aria2 \
  git \
  python3 \
  neofetch \
  tar \
  gzip \
    &>xerr || xerror "Cannot install required packages!"

echo "Installing DumprX..."
git clone https://github.com/DumprX/DumprX &>xerr \
  || xerror "Cannot clone DumprX!"
cd DumprX && chmod 755 *.sh
bash setup.sh && cd ..

echo "Installing twrpdtgen and aospdtgen"
pip3 install aospdtgen &>xerr || xerror
pip3 install twrpdtgen &>xerr || xerror
pip3 install uv &>xerr || xerror

echo "Installing extract utils"
mkdir -p android/{tools,prebuilt,device}

git clone --depth=1 \
  https://github.com/LineageOS/android_tools_extract-utils \
  -b lineage-22.2 ./android/tools/extract-utils &>xerr \
  || xerror
git clone --depth=1 \
 https://github.com/LineageOS/android_prebuilts_extract-tools \
  -b lineage-22.2 ./android/prebuilts/extract-tools &>xerr \
  || xerror
