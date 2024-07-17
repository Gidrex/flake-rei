#!/bin/sh

cd "$(dirname "$0")" # ./

git add -A
if [[ -n "$(git status --porcelain)" ]]; then
  git commit -m "better"
else 
  exit 0
fi
git push origin main

cd - > /dev/null
