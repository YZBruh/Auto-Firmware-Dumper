#!/usr/bin/bash
# Create dump and check samsung firmware
# By @YZBruh
echo "Trying create dump..."
cur_dir=$(pwd)
create_dump=$(bash dumper.sh $get_link 2>&1)
if [[ -z $create_dump ]]; then
  echo " "
  unset create_dump
  unset cur_dir
  exit 0
else
  echo "Dump creation failed. It is thought to be Samsung software. It's being made compatible..."
fi;
unset create_dump

# İnstall unpacker
cd /home/Auto-Dumper
wget https://github.com/YZBruh/Auto-Firmware-Dumper/raw/master/sm_firmware_tool/SAMSUNG-SOFTWARE-UNPACKER-GENER%C4%B0C-1.0.0.zip
unzip *.zip
sudo chmod -R 777 *
rm -rf *.zip
cd /home/Auto-Dumper/DumprX/input

# Get ROM file name
file_name=$(basename -z *)

# Move firmware
mv /home/Auto-Dumper/DumprX/input/$file_name /home/Auto-Dumper/$file_name
cd /home/Auto-Dumper

# Unpack
./sm-soft-unpacker-generic.sh --dumprx
cd output

# Move firmware
mv Unpacked-DumprX-Compatible-Firmware.zip /home/Auto-Dumper/DumprX/input/rom.zip
cd /home/Auto-Dumper

# Delete unpacker
sudo rm -rf *.sh
sudo rm -rf bin
cd $cur_dir
echo "ROM was successfully extracted and made compatible with DumprX."

# Try
echo "Trying create dump (2)..."
create_dump=$(bash dumper.sh $(pwd)/input/rom.zip 2>&1)
if [[ -z $create_dump ]]; then
  echo " "
else
  echo "Dump creation failed again. We can't do anything anymore..."
  unset create_dump
  unset cur_dir
  unset file_name
  exit 1;
fi;

unset create_dump
unset cur_dir
unset file_name

# end of script
