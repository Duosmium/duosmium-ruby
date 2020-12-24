#!/bin/sh

#if [ "$(git log --name-status HEAD^..HEAD | grep Author | cut -d'<' -f 2- | cut -d'>' -f -1 | md5sum | cut -d' ' -f -1)" = 'a546bc9a1aef658e8ae7516fba65171b' ]
if [ "$(git log --name-status HEAD^..HEAD | grep Author | cut -d'<' -f 2- | cut -d'>' -f -1 | md5sum | cut -d' ' -f -1)" = 'ba448b5e99f8ec7e606a3ec253ecda60' ]
then
  bundle exec middleman build
#else echo "$(git log --name-status HEAD^..HEAD | grep Author | cut -d'<' -f 2- | cut -d'>' -f -1 | md5sum | cut -d' ' -f -1)"
else
  mkdir -p build/results
  cp source/results/update-placeholder.html build/results/index.html
fi
