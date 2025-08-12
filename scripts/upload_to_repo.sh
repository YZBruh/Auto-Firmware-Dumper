#!/usr/bin/bash

[ $# -lt 2 ] && error "Missing arguments"

if [ -z $3 ]; then text="$2"
else text="$3"
fi

cd "$1"
git init && git branch -M "$2-$FINGERPRINT" && git add .
git commit -s -m "$FINGERPRINT"
gh repo create "$text"_"$BRAND"_"$DEVICE" --public --source=. --remote=origin --push
cd -
