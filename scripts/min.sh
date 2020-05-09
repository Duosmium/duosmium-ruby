#!/bin/sh

if [ $# -gt 0 ]
then
  export MIN_BUILD=$1
else
  export MIN_BUILD=1
fi
bundle exec middleman build --no-clean "$2"
unset MIN_BUILD
