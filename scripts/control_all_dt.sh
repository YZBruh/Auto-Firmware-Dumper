#!/usr/bin/bash
# Check all trees
# By @YZBruh
echo "Copying TWRP and LineageOS tree"
# Checking and copying los dt
check_los_dt=$(basename lineage-device-tree)
if [ $check_los_dt -eq 0 ]; then
    cp -r lineage-device-tree /home/Auto-Dumper
    unset check_los_dt
else
    echo "Lineage device tree not found!."
    unset check_los_dt
fi

# Checking and copying twrp dt
check_tw_dt=$(basename twrp-device-tree)
if [ $check_tw_dt -eq 0 ]; then
    cp -r twrp-device-tree /home/Auto-Dumper
    unset check_tw_dt
else
    echo "TWRP device tree not found!"
    unset check_tw_dt
fi;

# end of script
