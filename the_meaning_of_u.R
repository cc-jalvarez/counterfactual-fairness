# Can we generate counterfactual data based on Pearl?

# Let's use Level 2 from Kusner et al.

cf_data <- as.data.frame(data.matrix(lawTrain[ , sense_cols]))
cf_data$ZFYA <- lawTrain$ZFYA
cf_data$LSAT <- lawTrain$LSAT
cf_data$UGPA <- lawTrain$UGPA

cf_data$Uhat <- U_TRAIN

mo_ugpa <- lm(UGPA ~ 
                amerind + asian + black + hisp + mexican + other + puerto + white +
                male + female + 
                Uhat + 1,
              data=cf_data)
mo_ugpa
# What's the unit of Uhat?
# In this setting, it's knowledge but what does it mean to use it in the prediction step?
# How can I propagate the changes without a model?


hist(cf_data$Uhat)
hist(cf_data$UGPA)
summary(cf_data$UGPA)

library(ggplot2)
library(dplyr)
library(hrbrthemes)

p <- cf_data %>%
  ggplot( aes(x=Uhat, fill=factor(male))) +
  geom_histogram( color="#e9ecef", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  theme_ipsum() +
  labs(fill="")
p

cf_data$DiscUGPA <- ifelse(cf_data$UGPA >= 3.5, 'GPA 3.5+',
                           ifelse(cf_data$UGPA > 3, 'GPA 3-3.5', 
                                  ifelse(cf_data$UGPA > 2.5, 'GPA 2.5-3', 'GPA 2.5-'))
                           )

p2 <- cf_data %>%
  ggplot( aes(x=Uhat, fill=factor(male))) +
  geom_histogram( color="#e9ecef", alpha=0.6, position = 'identity') +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  theme_ipsum() +
  labs(fill="") +
  facet_wrap(vars(factor(DiscUGPA)))
p2

summary(cf_data$Uhat)
table(cf_data$male)

pred_factual_gpa <- predict.glm(mo_ugpa, newdata = cf_data)
hist(pred_factual_gpa)
hist(pred_factual_gpa - cf_data$UGPA)

# how do I compute the counterfactual data? I get u hat but then what?

