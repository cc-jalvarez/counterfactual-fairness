// see https://astrostatistics.psu.edu/su14/lectures/Daniel-Lee-Stan-2.pdf
data {
  int<lower=0> J;          // # schools
  real y[J];               // estimated treatment
  real<lower=0> sigma[J];  // std err of effect
}

parameters {
  real<lower=0, upper=1> theta; // school treatment effects
}

model {
}
