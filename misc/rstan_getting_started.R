# RStan

# a C++ library for Bayesian modeling and inference that
# uses the No-U-Turn sampler (NUTS) (Hoffman and Gelman 2012) to obtain
# posterior simulations given a user-specified model and data

library("rstan")
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

# 'Eight schools' example from https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
print(getwd())
dir = file.path(getwd(), "misc")
setwd(dir)
print(getwd())

# prepare the data as a named list
# where J schools, y treatment effects for each j (Y[j]), sign standard errors for each j (Sig[j])
schools_dat <- list(J = 8,
                    y = c(28,  8, -3,  7, -1,  1, 18, 12),
                    sigma = c(15, 10, 16, 11,  9, 11, 10, 18))

fit <- stan(file = 'schools.stan', data = schools_dat)

print(fit)
plot(fit)
pairs(fit, pars = c("mu", "tau", "lp__"))

la <- extract(fit, permuted = TRUE) # return a list of arrays 
mu <- la$mu 

### return an array of three dimensions: iterations, chains, parameters 
a <- extract(fit, permuted = FALSE) 

### use S3 functions on stanfit objects
a2 <- as.array(fit)
m <- as.matrix(fit)
d <- as.data.frame(fit)

#
# EOF
#
