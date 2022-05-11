library("rstan")
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

print(getwd())
dir = file.path(getwd(), "misc")
setwd(dir)
print(getwd())

schools_dat <- list(J = 8,
                    y = c(28,  8, -3,  7, -1,  1, 18, 12),
                    sigma = c(15, 10, 16, 11,  9, 11, 10, 18)
                    )

# Model 0 -----------------------------------------------------------------
fit_1 <- stan(file = 'schools_model0.stan', data = schools_dat)

print(fit_1)
plot(fit_1)
pairs(fit_1, pars = c("theta", "lp__"))

la_1 <- extract(fit_1, permuted = TRUE) # return a list of arrays 
la_1$theta 

# Seems like trivial theta as we haven't given it a model so we just pass
# a markov chain that must move and stabiliza btw 0 and 1...

# Separate Models ---------------------------------------------------------
fit_2 <- stan(file = 'schools_nopooling.stan', data = schools_dat)

print(fit_2)
plot(fit_2)
pairs(fit_2, pars = c("theta", "lp__"))

la_2 <- extract(fit_2, permuted = TRUE) # return a list of arrays 
la_2$theta 

# Under seperate J models, we are asking to get a theta parameter for each
# j school based on y_j and sigma_j

# Pooled Model ------------------------------------------------------------
fit_3 <- stan(file = 'schools_completepooling.stan', data = schools_dat)

print(fit_3)
plot(fit_3)
pairs(fit_3, pars = c("theta", "lp__"))

la_3 <- extract(fit_3, permuted = TRUE) # return a list of arrays 
la_3$theta 

# Now we don't specify the parameter theta as theta[J] (i.e., separate) but
# simply theta (i.e., pooled) as we then link y with theta and sigma_j
# So far no herarchical models as we don't specify hyperparameters!!!

# Partial Pooling Model ---------------------------------------------------

# Now I allow theta to vary per j school but introduce some higher structure
# that relates the schools with each other via mu and tau=25 (this last one
# as a given variable)

print(schools_dat)
schools_dat2 <- append(schools_dat, list(tau=25))
print(schools_dat2)

fit_4 <- stan(file = 'schools_partialpooling.stan', data = schools_dat2)

print(fit_4)
plot(fit_4) # plots all params, including the new mu
pairs(fit_4, pars = c("theta", "mu", "lp__"))

la_4 <- extract(fit_4, permuted = TRUE) # return a list of arrays 
la_4$theta # a distribution of thetas per j school
la_4$mu # a distribution of the 1st moment determining the draws of thetas - a measure of uncertainty under a fixed tau=25!

# by looking at mu, now i can say more about theta itself...
# before, hard to say separate vs pooled models by only looking at theta
# i can, ofc, compare the thetas for these two models one pooled theta vs 8-school-specific ones
# but i wouldn't be able to say how certain am i about these thetas
# for that i would need to go to the hyperparameter space...

plot(la_4$mu) # note: under a fixed 2nd moment for theta!!!
hist(la_4$mu)

# Hierarchical Model ------------------------------------------------------

# Now tau is a hyperparameter to be estimated from the data...
# not a variable given

fit_5 <- stan(file = 'schools_hierarchicalmodel.stan', data = schools_dat)

print(fit_5)
plot(fit_5) # plots all params, including the new mu
pairs(fit_5, pars = c("theta", "mu", "tau", "lp__"))

la_5 <- extract(fit_5, permuted = TRUE) # return a list of arrays 
la_5$theta # a distribution of thetas per j school
la_5$mu
la_5$tau

hist(la_5$mu)
hist(la_5$tau) # see that 25 was a biased guess!!!

