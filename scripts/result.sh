#!/bin/sh

export RESULT_TO_BUILD="$1"
bundle exec middleman build --no-clean --verbose
unset RESULT_TO_BUILD
