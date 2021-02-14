# Duosmium Website

[![Netlify Status](https://api.netlify.com/api/v1/badges/d7b80fa4-c65d-4e6d-bd4d-287b5ddd2473/deploy-status)](https://app.netlify.com/sites/practical-khorana-15675a/deploys)

The spiritual successor to the Unosmium Scoring System and Unosmium Results website, building off of [the original project's codebase](https://github.com/unosmium).

Visit: [https://duosmium.org/](https://duosmium.org/)

## Duosmium Scoring System

Homepage is a work in progress (aka has not yet been started on). Will be used
to advertise the features of the Duosmium Scoring System and provide
instructions on how to use it.

## Duosmium Results

An [archive](https://duosmium.org/results/) of any tournament results
that have been output as or converted into the
[SciolyFF](https://github.com/duosmium/sciolyff) (Science Olympiad File Format).

### How to view locally

Minimal instructions that will likely need to be modified depending on your
development setup:
```sh
git clone https://github.com/duosmium/duosmium.git
bundle install
yarn
bundle exec middleman build
firefox build/results/index.html
```

Check out [the Gitlab CI file](https://github.com/duosmium/duosmium/blob/master/.gitlab-ci.yml) if you're interested in setting up your own instance.

### Contributing

Contributions of code and tournament results are welcome.

To add new tournament results, make a [Pull
Request](https://help.github.com/en/articles/creating-a-pull-request) that adds
a YAML file in format of [SciolyFF](https://github.com/duosmium/sciolyff) in the
[data directory](/data).

A Google Sheets [input
template](https://duosmium.org/input-template)
can be used to generate a CSV file that then can be converted into a SciolyFF
file using the script in [this
repository](https://github.com/duosmium/sciolyff-conversions).  The files
already in the data directory should serve as an example of expected output.
Additionally, the `sciolyff` command line utility should be used to verify the
data files.

After the pull request is merged, the website will automatically generate an
HTML results page that can be viewed by clicking on the appropriate link in the
[site index](https://duosmium.org/results/). Keep in mind that this will take a while; as of right now, the process takes about 6-7 minutes.
