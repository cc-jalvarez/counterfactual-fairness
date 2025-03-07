
data {
  
  int<lower = 0> N; // number of observations
  int<lower = 0> K; // number of covariates
  matrix[N, K]   a; // sensitive variables
  real ugpa[N]; // UGPA
  int  lsat[N]; // LSAT
  real zfya[N]; // ZFYA
  
}

transformed data {
  
 vector[K] zero_K;
 vector[K] one_K;
 
 zero_K = rep_vector(0,K);
 one_K = rep_vector(1,K);

}

parameters {

  vector[N] u;     // at each iteration will draw N u's: 'iter' x N u's
  
  // for these params, draw 'iter' of each
  real ugpa0;      // intercept of GPA
  real eta_u_ugpa; // weight of latent knowledge on UGPA
  real lsat0;      // intercept of LSAT
  real eta_u_lsat; // weight of latent knowledge on UGPA
  real eta_u_zfya; // weight of latent knowledge on ZFYA
  
  // for these params, draw K at each 'iter': a weight for each k var in K
  vector[K] eta_a_ugpa; // weight of senstive att on UGPA
  vector[K] eta_a_lsat; // weight of senstive att on LSAT
  vector[K] eta_a_zfya; // weight of senstive att on ZFYA
  
  real<lower=0> sigma_g_Sq;
}

transformed parameters  {
  
 // Population standard deviation (a positive real number)
 real<lower=0> sigma_g;
 
 // Standard deviation (derived from variance)
 sigma_g = sqrt(sigma_g_Sq);
 
}

model {
  
  // don't have data about this
  // Level 2:
  u ~ normal(0, 1);
  
  // Level 3:
  ugpa0      ~ normal(0, 1);
  eta_u_ugpa ~ normal(0, 1);
  lsat0      ~ normal(0, 1);
  eta_u_lsat ~ normal(0, 1);
  eta_u_zfya ~ normal(0, 1);

  eta_a_ugpa ~ normal(zero_K, one_K);
  eta_a_lsat ~ normal(zero_K, one_K);
  eta_a_zfya ~ normal(zero_K, one_K);

  sigma_g_Sq ~ inv_gamma(1, 1);

  // have data about these
  ugpa ~ normal(ugpa0 + eta_u_ugpa * u + a * eta_a_ugpa, sigma_g);
  lsat ~ poisson(exp(lsat0 + eta_u_lsat * u + a * eta_a_lsat));
  zfya ~ normal(eta_u_zfya * u + a * eta_a_zfya, 1);

}
