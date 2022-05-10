// All schools lumped together
data {
  int<lower=0> J;          // # schools
  real y[J];               // estimated treatment
  real<lower=0> sigma[J];  // std err of effect
}

parameters {
  real theta;              // pooled school effect
}
model {
  y ~ normal(theta, sigma);
}
