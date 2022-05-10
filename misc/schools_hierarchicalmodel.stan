// Estimate hyperparameters µ and σ
data {
  int<lower=0> J;         // # schools
  real y[J];              // estimated treatment
  real<lower=0> sigma[J]; // std err of effect
}

parameters {
  real theta[J];     // school effect
  real mu;           // mean for schools
  real<lower=0> tau; // variance between schools
}

model {
  theta ~ normal(mu, tau);
  y ~ normal(theta, sigma);
}
