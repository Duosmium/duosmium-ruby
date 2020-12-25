#!/bin/sh

python $(dirname $0)"/recents-update.py"
bundle exec middleman build --verbose "$@"
