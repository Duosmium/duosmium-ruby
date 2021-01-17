# Notes to self and future maintainers

## Prerequisites
- Node.js
- Ruby
- Git
- Netlify CLI

If you are on Windows, I highly recommend using WSL. It *will* work on Windows,
but it is not fun.

## Download and initialize
```
git clone https://github.com/Duosmium/duosmium.git
cd duosmium
yarn
bundle update
```

## Build site locally
```
bundle exec middleman build
```
Site can also be built on Netlify, but this is too slow for our purposes.

## Test changes
```
bundle exec middleman
```
Then head to http://localhost:4567/results and test the site.

## Deploy site to duosmium.org
```
netlify deploy --message="$(git log -1 --oneline)" --prod
```
