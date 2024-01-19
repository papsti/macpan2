<!-- Auto-generated - do not edit by hand -->
<!-- Edit README.Rmd instead -->
macpan2
================

<!-- badges: start -->

[![R-CMD-check](https://github.com/canmod/macpan2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/canmod/macpan2/actions/workflows/R-CMD-check.yaml)
[![test
coverage](https://byob.yarr.is/canmod/macpan2/coverage)](https://github.com/canmod/macpan2/actions/workflows/test-coverage.yaml)
[![commit
activity](https://img.shields.io/github/commit-activity/m/canmod/macpan2)](https://github.com/canmod/macpan2/commits)
[![contributors](https://img.shields.io/github/contributors/canmod/macpan2)](https://github.com/canmod/macpan2/graphs/contributors)
[![release](https://img.shields.io/github/v/release/canmod/macpan2?include_prereleases)](https://github.com/canmod/macpan2/releases/latest)

[McMasterPandemic](https://github.com/mac-theobio/McMasterPandemic) was
developed to provide forecasts and insights to Canadian public health
agencies throughout the COVID-19 pandemic. [Much was
learned](https://canmod.github.io/macpan-book/index.html#vision-and-direction)
about developing general purpose compartmental modelling software during
this experience, but the pressure to deliver regular forecasts made it
difficult to focus on the software itself. The goal of this `macpan2`
project is to re-imagine `McMasterPandemic`, building it from the ground
up with architectural and technological decisions that address the many
lessons that we learned from COVID-19 about software.

Impactful applied public health modelling requires many
interdisciplinary steps along the path from epidemiological research
teams to operational decision makers. Researchers must quickly tailor a
model to an emerging public-health concern, validate and calibrate it to
data, work with decision makers to define model outputs useful for
stakeholders, configure models to generate those outputs, and package up
those insights in an appropriate format for stakeholders. Unlike
traditional modelling approaches, `macpan2` tackles this challenge from
a software-engineering perspective, which allows us to systematically
address bottlenecks along this path to impact in ways that will make
future solutions easier to achieve. The goal is to enable researchers to
focus on their core strengths and fill knowledge gaps efficiently and
effectively.

Although `macpan2` is designed as a compartmental modelling tool that is
agnostic about the underlying computational engine, it currently uses
[template model builder](https://github.com/kaskr/adcomp) as the sole
engine. Template model builder (TMB) is an `R` modelling package based
on a `C++` framework incorporating mature [automatic
differentiation](https://cppad.readthedocs.io/en/latest/user_guide.html)
and [matrix
algebra](http://eigen.tuxfamily.org/index.php?title=Main_Page)
libraries.

The [Public Health Risk Sciences
Division](https://github.com/phac-nml-phrsd) at the [Public Health
Agency of Canada](https://www.canada.ca/en/public-health.html) uses
`macpan2` (for example,
[here](https://phac-nml-phrsd.github.io/EPACmodel/)).

## Documentation

-   [Package reference](https://canmod.github.io/macpan2/)
-   [Quick-start
    guide](https://canmod.github.io/macpan2/articles/quickstart)
-   [Representation of compartmental
    models](https://canmod.github.io/macpan2/articles/model_definitions)
    \[specification document\]
-   [`TMB` engine](https://canmod.github.io/macpan2/articles/cpp_side)
    \[specification document\]
-   [Project history and
    trajectory](https://canmod.net/misc/macpan2_presentation) \[slides\]

## Installation

If you’re on a Windows system, please install `Rtools` matching your R
version from [here](https://cran.r-project.org/bin/windows/Rtools/).
This ensures you have a C++ compiler, which is required to install
`macpan2` from source (as below).

Then, install the `macpan2` package with the following R command.

    remotes::install_github("canmod/macpan2")

For projects in production one should install a specific version, as in
the following command.

    remotes::install_github("canmod/macpan2@v1.0.0")

## Hello World

The following code specifies an SI model, which is I think is the
simplest possible model of epidemiological transmission.

``` r
si = mp_tmb_model_spec(
    before = list(
        I ~ 1
      , S ~ N - I
    )
  , during = list(
        infection ~ beta * S * I / N
      , S ~ S - infection
      , I ~ I + infection
    )
  , default = list(N = 100, beta = 0.25)
)
print(si)
```

    ## ---------------------
    ## Default values:
    ## ---------------------
    ##  matrix row col  value
    ##       N         100.00
    ##    beta           0.25
    ## 
    ## ---------------------
    ## Before the simulation loop (t = 0):
    ## ---------------------
    ## 1: I ~ 1
    ## 2: S ~ N - I
    ## 
    ## ---------------------
    ## At every iteration of the simulation loop (t = 1 to T):
    ## ---------------------
    ## 1: infection ~ beta * S * I/N
    ## 2: S ~ S - infection
    ## 3: I ~ I + infection

Simulating from this model requires choosing the number of time-steps to
run and the model outputs to generate. Syntax for simulating `macpan2`
models is [designed to combine with standard data prep and plotting
tools in R](#modularity), as we demonstrate with the following code.

``` r
(si
 |> mp_simulator(time_steps = 50, outputs = c("I", "infection"))
 |> mp_trajectory()
 |> mutate(quantity = case_match(matrix
    , "I" ~ "Prevalance"
    , "infection" ~ "Incidence"
  ))
 |> ggplot() 
 + geom_line(aes(time, value)) 
 + facet_wrap(~ quantity, scales = "free")
 + theme_bw()
)
```

![](man/figures/plot-tmb-si-1.png)<!-- -->

## Product Management

The [project board](https://github.com/orgs/canmod/projects/2) tracks
the details of bugs, tasks, and feature development.
