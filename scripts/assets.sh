#!/bin/sh

yarn run webpack
cp -r "$(git rev-parse --show-toplevel)"/.tmp/dist/* build
