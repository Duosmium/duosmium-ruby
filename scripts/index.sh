#!/bin/sh

export INDEX_ONLY=true
bundle exec middleman build --no-clean "$@"
unset INDEX_ONLY
