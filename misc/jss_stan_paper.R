# 16/12/2021
# Stan: A Probabilistic Programming Language 

library(rstan)

# Create data for Satn file
N <- 10
y <- c(0, 1, 0, 0, 0, 0, 0, 0, 0, 1)

# Package data as a list (names must match with .Stan file)
bernoulli_data = list(N = N,
                      y = y)

# Note: set wd to the .Stan file
current_dir <- paste0(getwd(), '/misc')
setwd(current_dir)

# Fit model for theta
fit_the_bern <- stan(file = 'independent_bernoulli_model.stan',
                     data = bernoulli_data,
                     chains = 1, 
                     seed = 1234)
print(fit_the_bern)
plot(fit_the_bern)
