// Estimate hyperparameters µ and σ
data {
  int<lower=0> J;         // # schools
  real y[J];              // estimated treatment
  real<lower=0> sigma[J]; // std err of effect
}

parameters {
  real theta[J];     // school effect [a theta per school]
  real mu;           // mean for schools [one mu for theta]
  real<lower=0> tau; // variance between schools [one tau for theta]
}

model {
  theta ~ normal(mu, tau);
  y ~ normal(theta, sigma);
}
