#!/usr/bin/bash
# Check all trees
# By @YZBruh
echo "Copying TWRP and LineageOS tree"
# Checking and copying los dt
cd /home/Auto-Dumper/DumprX/out && basename lineage-device-tree
exit_code=$?
if [ $exit_code -eq 0 ]; then
    cp -r lineage-device-tree /home/Auto-Dumper
    unset exit_code
else
    echo "Lineage device tree not found!."
    unset exit_code
fi

# Checking and copying twrp dt
basename twrp-device-tree
exit_code=$?
if [ $exit_code -eq 0 ]; then
    cp -r twrp-device-tree /home/Auto-Dumper
    unset exit_code
else
    echo "TWRP device tree not found!"
    unset exit_code
fi;

# end of script
