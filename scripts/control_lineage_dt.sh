#!/usr/bin/bash
# Upload los tree
# By @YZBruh
echo "Searching for the LineageOS device tree..."

# Check BoardConfig.mk
cd /home/Auto-Dumper/lineage-device-tree
check_dt=$(basename BoardConfig.mk)
if [ $check_dt -eq 0 ]; then
  echo "The LineageOS compatible device tree has not been created.";
  echo "Pushing Canceled."
  unset check_dt
  exit 1;
fi;
echo "A LineageOS compatible device tree has been created."
echo "Pushing..."
unset check_dt

# Deleting old folder
sudo rm -rf .git

# Classic git command
g_init=$(git init)
if [ $g_init -eq 0 ]; then
  echo "Pushing failed!"
  echo "NOTE: Dump already uploaded."
  unset g_init
  exit 1;
fi;

# Branch setting
g_branch=$(git branch -M lineage-$get_codename)
if [ $g_branch -eq 0 ]; then
  echo "Pushing failed!"
  echo "NOTE: Dump already uploaded."
  unset g_init
  unset g_branch
  exit 1;
fi;

# Classic git command
g_add=$(git add .)
if [ $g_add -eq 0 ]; then
  echo "Pushing failed!"
  echo "NOTE: Dump already uploaded."
  unset g_init
  unset g_branch
  unset g_add
  exit 1;
fi;

# Commit
g_commit=$(git commit -s -m "$get_codename : LineageOS compatible device tree")
if [ $g_commit -eq 0 ]; then
  echo "Pushing failed!"
  echo "NOTE: Dump already uploaded."
  unset g_init
  unset g_branch
  unset g_add
  unset g_commit
  exit 1;
fi;

# Create repo and push
g_upload=$(gh repo create lineage_device_${{ env.DB }}_${{ env.DC }} --public --description="LineageOS compatible tree for ${{ env.DB }} ${{ env.DC }}." --source=. --remote=origin --push)
if [ $g_upload -eq 0 ]; then
  echo "Pushing failed!"
  echo "NOTE: Dump already uploaded."
  unset g_init
  unset g_branch
  unset g_add
  unset g_commit
  unset g_upload
  exit 1;
fi;

echo "Succesfull."
cd /home/Auto-Dumper
unset g_init
unset g_branch
unset g_add
unset g_commit
unset g_upload

# end of script