# Unosmium Website

[![Netlify Status](https://api.netlify.com/api/v1/badges/f2bad39e-665a-4733-84da-7ca982e88676/deploy-status)](https://app.netlify.com/sites/wonderful-babbage-2c3793/deploys)

A new instance of the Unosmium Scoring System and Unosmium Results, because the results on the original haven't been updated in a while.

Visit: [https://unosmium.smayya.me/](https://unosmium.smayya.me/)

## Unosmium Scoring System

Homepage is a work in progress (aka has not yet been started on). Will be used
to advertise the features of the Unosmium Scoring System and provide
instructions on how to use it.

## Unosmium Results

An [archive](https://unosmium.smayya.me/results/) of any tournament results
that have been output as or converted into the
[SciolyFF](https://github.com/unosmium/sciolyff) (Science Olympiad File Format).

### How to view locally

Minimal instructions that will likely need to be modified depending on your
development setup:
```sh
git clone https://github.com/unosmium/unosmium.org.git
bundle install
middleman build
firefox build/results/index.html
```

Check out [the Gitlab CI file](https://github.com/smayya337/unosmium.org/blob/master/.gitlab-ci.yml) to see how the production instance is built.

### Contributing

Contributions of code and tournament results are welcome.

To add new tournament results, make a [Pull
Request](https://help.github.com/en/articles/creating-a-pull-request) that adds
a YAML file in format of [SciolyFF](https://github.com/unosmium/sciolyff) in the
[data directory](/data).

A Google Sheets [input
template](https://docs.google.com/spreadsheets/d/1bkDCZD1NYYsS8L8m_e_cZ2kn9dZm2vufC4U9hNum6Hg)
can be used to generate a CSV file that then can be converted into a SciolyFF
file using the script in [this
repository](https://github.com/unosmium/sciolyff-conversions).  The files
already in the data directory should serve as an example of expected output.
Additionally, the `sciolyff` command line utility should be used to verify the
data files.

After the pull request is merged, the website will automatically generate an
HTML results page that can be viewed by clicking on the appropriate link in the
[site index](https://unosmium.smayya.me/results/). Keep in mind that this will take a while; as of right now, the process takes about eight minutes.
