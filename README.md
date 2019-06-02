# Unosmium Website

[![Netlify Status](https://api.netlify.com/api/v1/badges/ff03ce31-0235-4742-b95e-389ec3ebb96a/deploy-status)](https://app.netlify.com/sites/unosmium/deploys)

The official website for the Unosmium Scoring System and Unosmium Results.

Visit: [https://unosmium.netlify.com/](https://unosmium.netlify.com/)

## Unosmium Scoring System

Homepage is a work in progress (aka has not yet been started on). Will be used
to advertise the features of the Unosmium Scoring System and provide
instructions on how to use it.

## Unosmium Results

An [archive](https://unosmium.netlify.com/results/) of any tournament results
that have been output as or converted into the
[SciolyFF](https://github.com/unosmium/sciolyff) (Science Olympiad File Format). 

### Contributing

Contributions of code and tournament results are welcome.

To add new tournament results, make a [Pull
Request](https://help.github.com/en/articles/creating-a-pull-request) that adds
a YAML file in format of [SciolyFF](https://github.com/unosmium/sciolyff) in the
[data directory](/data).

If converting, the files already in the data directory should serve as an
example. For additional details on converting a file to the SciolyFF, see
[here](https://github.com/unosmium/sciolyff-conversions).

After the pull request is merged, the website will automatically generate an
HTML results page that can be viewed by clicking on the appropriate link in the
[site index](https://unosmium.netlify.com/results/).
