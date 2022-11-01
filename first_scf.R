# need: lawTrain and mcmc estimates

# UGPA --------------------------------------------------------------------

# shared weights
test_ugpa <- as.data.frame(data.matrix(lawTrain[ , sense_cols])%*%eta_a_ugpa)

#test_ugpa <- as.data.frame(data.matrix(lawTrain[ , sense_cols])*eta_a_ugpa) - bug in the multiplication...
#data.matrix(lawTrain[ , sense_cols])%*%eta_a_ugpa

# shared intercept
test_ugpa$ugpa0 <- ugpa0

# individual error times shared error weight
test_ugpa$u <- U_TRAIN*eta_u_ugpa

test_ugpa$est_UGPA <- rowSums(test_ugpa)
test_ugpa$obs_UGPA <- lawTrain$UGPA

plot(test_ugpa$obs_UGPA - test_ugpa$est_UGPA) #understimates UGPA
summary(test_ugpa$obs_UGPA - test_ugpa$est_UGPA)
hist(test_ugpa$obs_UGPA - test_ugpa$est_UGPA)


test_ugpa_model <- lm(UGPA ~ amerind + asian + black + hisp + mexican + other + puerto + white +
                        male + female + 1, 
                      data=lawTrain)
test_ugpa_model

plot(lawTrain$UGPA - predict(test_ugpa_model))
hist(lawTrain$UGPA - predict(test_ugpa_model))

# It seems we can estimate it all with MCMC and then intervene, no?
# Try the structural counterfactual...

sens_att_weights <- lawTrain[ FALSE, sense_cols]
sens_att_weights <- rbind(sens_att_weights, eta_a_ugpa)
names(sens_att_weights) <- colnames(lawTrain[ FALSE, sense_cols])

# consider ind 1:
lawTrain[1, ]
# with UGPA (obs)
lawTrain[1, 'UGPA']
# and estimated 
test_ugpa[1, 'est_UGPA']

# do(Gender=male) (already have U|evidence)
print('factual:')
print(test_ugpa[1, ]$ugpa0 + test_ugpa[1, ]$u + sens_att_weights$white + sens_att_weights$female)
print('male')
print(test_ugpa[1, ]$ugpa0 + + test_ugpa[1, ]$u + sens_att_weights$white + sens_att_weights$male)

# LSAT --------------------------------------------------------------------

# shared weights
test_lsat <- as.data.frame(data.matrix(lawTrain[ , sense_cols])%*%eta_a_lsat)

#test_ugpa <- as.data.frame(data.matrix(lawTrain[ , sense_cols])*eta_a_ugpa) - bug in the multiplication...
#data.matrix(lawTrain[ , sense_cols])%*%eta_a_ugpa

# shared intercept
test_lsat$lsat0 <- lsat0

# individual error times shared error weight
test_lsat$u <- U_TRAIN*eta_u_lsat

test_lsat$est_LSAT <- exp(rowSums(test_lsat))
test_lsat$obs_LSAT <- lawTrain$LSAT

plot(test_lsat$obs_LSAT - test_lsat$est_LSAT)
summary(test_lsat$obs_LSAT - test_lsat$est_LSAT) # this is very imprecise! cannot say something about some ind
hist(test_lsat$obs_LSAT - test_lsat$est_LSAT)

test_lsat_model <- lm(LSAT ~ amerind + asian + black + hisp + mexican + other + puerto + white +
                        male + female + 1, 
                      data=lawTrain)
test_lsat_model

plot(lawTrain$LSAT - predict(test_lsat_model))
hist(lawTrain$LSAT - predict(test_lsat_model)) # same for a linear model!!!

# This is important as the weights will determine the scm!

#
# EOF
#
