#!/usr/bin/bash
# Check all trees
# By @YZBruh
echo "Checking TWRP and LineageOS tree"
# Checking and copying los dt
cd /home/Auto-Dumper/DumprX/out && basename lineage-device-tree
exit_code=$?
if [ $exit_code -eq 0 ]; then
    unset exit_code
else
    echo "Lineage device tree not found!."
    unset exit_code
fi

# Checking and copying twrp dt
basename twrp-device-tree
exit_code=$?
if [ $exit_code -eq 0 ]; then
    unset exit_code
else
    echo "TWRP device tree not found!"
    unset exit_code
fi;

# end of script
