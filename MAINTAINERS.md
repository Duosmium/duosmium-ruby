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
git clone https://github.com/unosmium/unosmium.org.git
cd unosmium.org
yarn
bundle update
```

## Build site locally
```
bundle exec middleman build
```
Site can also be built on Netlify, but this is too slow for our purposes.


## Deploy site to unosmium.org
```
netlify deploy --message="$(git log -1 --oneline)" --prod
```
