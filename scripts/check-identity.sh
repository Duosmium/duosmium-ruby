#!/bin/sh

if [[ $(git log --name-status HEAD^..HEAD | grep Author | cut -d'<' -f 2- | cut -d'>' -f -1 | md5sum | cut -d' ' -f -1) == 'ba448b5e99f8ec7e606a3ec253ecda60' ]]
then
bundle exec middleman build
fi
