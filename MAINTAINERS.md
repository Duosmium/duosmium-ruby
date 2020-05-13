# Notes to self and future maintainers

## Prerequisites
- Git
- Ruby/Bundler
- Netlify CLI

## Download and initialize
```
git clone https://github.com/unosmium/unosmium.org.git
cd unosmium.org
yarn
bundle
```

## Build site locally
```
bundle exec middleman build
```
Site can also be built on Netlify, but this is slow for our purposes.


## Deploy site to unosmium.org
```
netlify deploy --message="$(git log -1 --oneline)" --prod
```
