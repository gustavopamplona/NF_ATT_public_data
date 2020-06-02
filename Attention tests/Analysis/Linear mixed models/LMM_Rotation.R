require(lme4)
install.packages("lme4")
library(lme4)
install.packages("glmm")
require(glmm)
install.packages("car")
require(car)
library(car)
library(dplyr)
install.packages("MuMIn")
require(MuMIn)
library(MuMIn)
library(nlme)
install.packages("lmerTest")
library(lmerTest)

library(readxl)
data<-read_excel("G:/Backup NF Experiment - PUK/Behav_Codes/MixedModels/MM_Rotation.xls")

data$group <- as.factor(data$group)
data$subj <- as.factor(data$subj)
data$day <- as.factor(data$day)
data$trial <- as.factor(data$trial)
data$cond <- as.factor(data$cond)
data$stimid <- as.factor(data$stimid)
data$rot <- as.factor(data$rot)
data$corr <- as.factor(data$corr)

# for RT
rts_dataset<-subset(data,corr=="1" & !is.na(rt))

m00 <-lmer(rt ~ group * day * cond * rot + (1 | subj) + (1|trial) + (1|stimid), data = rts_dataset)

anova(m00)

# posthoc analysis
# 1
rts_dataset$group <- relevel(rts_dataset$group,ref="CTRL")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day1")
m00 <-lmer(rt ~ group * day * cond * rot + (1 | subj) + (1|trial) + (1|stimid), data = rts_dataset)
summary(m00)

# 2
rts_dataset$group <- relevel(rts_dataset$group,ref="NF")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day2")
m00 <-lmer(rt ~ group * day * cond * rot + (1 | subj) + (1|trial) + (1|stimid), data = rts_dataset)
summary(m00)

# for computation of differences
rts_datasetNF1<-subset(rts_dataset, group=="NF" & day=="Day1")
rts_datasetNF2<-subset(rts_dataset, group=="NF" & day=="Day2")
rts_datasetTR1<-subset(rts_dataset, group=="CTRL" & day=="Day1")
rts_datasetTR2<-subset(rts_dataset, group=="CTRL" & day=="Day2")
mean(rts_datasetNF2$rt)-mean(rts_datasetNF1$rt)
mean(rts_datasetTR2$rt)-mean(rts_datasetTR1$rt)

car::Anova(m00)

# ploting
plot(effect("day*group",m00))

# comparing models
m00full <- lmer(rt ~ group * day * cond * rot + (1 | subj) + (1|trial) + (1|stimid), data = rts_dataset)

m00c <- lmer(rt ~ group * day * rot + (1 | subj) + (1|trial) + (1|stimid), data = rts_dataset)
m00d <- lmer(rt ~ group * day * cond + (1 | subj) + (1|trial) + (1|stimid), data = rts_dataset)

anova(m00full,m00a) # p is significatly different and AIC for the full model is lower --> the model with cond is better
anova(m00full,m00c) # p is significatly different and AIC for the full model is lower --> the model with cond is better
anova(m00full,m00d) # p is significatly different and AIC for the full model is lower --> the model with rot is better

# for accuracy
acc_dataset<-subset(data,!is.na(rt))

m01 <- glmer(corr ~ group * day * cond * rot + (1 | subj) + (1|trial) + (1|stimid), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))
m01 <- glmer(corr ~ day * group * cond * rot + (1 | subj) + (1|trial) + (1|stimid), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))

car::Anova(m01)

# ploting
plot(effect("day*group",m01))

# posthoc analysis 1
acc_dataset$group <- relevel(acc_dataset$group,ref="CTRL")
acc_dataset$day <- relevel(acc_dataset$day,ref="Day1")
m01a <- glmer(corr ~ group * day * cond * rot + (1 | subj) + (1|trial) + (1|stimid), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))
summary(m01a)

# posthoc analysis 2
acc_dataset$group <- relevel(acc_dataset$group,ref="NF")
acc_dataset$day <- relevel(acc_dataset$day,ref="Day2")
m01b <- glmer(corr ~ group * day * cond * rot + (1 | subj) + (1|trial) + (1|stimid), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))
summary(m01b)

# for computation of differences
acc_dataset<-subset(data, !is.na(rt))
acc_datasetNF1<-subset(acc_dataset, group=="NF" & day=="Day1" & !is.na(cond))
acc_datasetNF2<-subset(acc_dataset, group=="NF" & day=="Day2" & !is.na(cond))
acc_datasetTR1<-subset(acc_dataset, group=="CTRL" & day=="Day1" & !is.na(cond))
acc_datasetTR2<-subset(acc_dataset, group=="CTRL" & day=="Day2" & !is.na(cond))
(nnzero(acc_datasetNF2$corr)/nnzero(acc_datasetNF2$group)-nnzero(acc_datasetNF1$corr)/nnzero(acc_datasetNF1$group))*100
(nnzero(acc_datasetTR2$corr)/nnzero(acc_datasetTR2$group)-nnzero(acc_datasetTR1$corr)/nnzero(acc_datasetTR1$group))*100
