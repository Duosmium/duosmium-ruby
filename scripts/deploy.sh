#!/bin/sh

netlify deploy --message="$(git log -1 --oneline)" "$@"
