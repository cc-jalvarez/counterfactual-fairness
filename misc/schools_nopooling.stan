// Each school treated independently
data {
  int<lower=0> J;         // # schools
  real y[J];              // estimated treatment
  real<lower=0> sigma[J]; // std err of effect
}

parameters {
  real theta[J];          // school effect
}

model {
  y ~ normal(theta, sigma); // for each j in J get y and sigma to get theta_j
}
