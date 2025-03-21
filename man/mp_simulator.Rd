% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tmb_model.R
\name{mp_simulator}
\alias{mp_simulator}
\title{Create a Simulator}
\usage{
mp_simulator(model, time_steps, outputs, default = list())
}
\arguments{
\item{model}{A model specification object.}

\item{time_steps}{How many time steps should be simulated when simulations
are requested?}

\item{outputs}{Character vector of names of model quantities that will be
outputted when simulations are requested.}

\item{default}{Named list of numerical objects that will update the default
values defined in the model specification object. Any number of objects
can be updated or not.}
}
\description{
Construct a simulator from a model specification object.
}
\concept{create-model-simulator}
