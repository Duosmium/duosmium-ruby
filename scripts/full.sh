#!/bin/sh

if [ $NETLIFY -gt 0 ]
then
  echo "In Netlify, installing Python stuff..."
  apt -y install python3-pip
  pip install PyYAML GitPython
fi
python3 "$(dirname $0)/recents-update.py"
bundle exec middleman build --verbose "$@"
cp redirects/*.html build/
