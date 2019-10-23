
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Estimating contact-adjusted immunity levels against measles in South Korea and prospects for maintaining elimination status

This repository contains the data and code for our paper:

> June Young Chun, Wan Beom Park, Nam Joong Kim, Eun Hwa Choi, Sebastian
> Funk, Myoung-don Oh (2019). *Estimating contact-adjusted immunity
> levels against measles in South Korea and prospects for maintaining
> elimination status*.

### How to download or install

You can download the compendium as a zip from from this URL:
<https://github.com/sbfnk/sk.measles/archive/master.zip>

Or you can install this compendium as an R package, `sk.measles`, from
GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("sbfnk/sk.measles")
```

### Included data sets

The package includes all the data sets required in order to reproduce
the results: Measles seroprevalence in South Korea as measured in 2014
(`sk_seroprevalence`), vaccinaton coverage (`sk_mcv_coverage`),
demographics (`sk_population`) and a contact matrix derived from a study
in Japan (`japan_contacts`).

### Table and figures

To generate Table 1 from the paper, run

``` r
table1(japan_contacts)
```

To generate the scenarios of increasing vaccination in different age
groups used for Figure 2, use

``` r
scenarios(japan_contacts)
```

### Sensitivity analysis

To conduct sensitivity analysis where the 20-29 age group is split into
two equally sized age groups, use the `split_20_29` function:

``` r
split_contacts <- split_20_29(japan_contacts)
```

Replacing `japan_contacts` with `split_contacts` in the commands above
runs the same analyses, but with the contact matrix with split age
groups.

To conduct sensitivity analysis where equivocal samples are interpreted
as negative, use `equivocal="negative"` with any of the commands above.
