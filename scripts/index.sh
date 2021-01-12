#!/bin/sh

export INDEX_ONLY=true
bundle exec middleman build --no-clean --verbose "$@"
unset INDEX_ONLY
