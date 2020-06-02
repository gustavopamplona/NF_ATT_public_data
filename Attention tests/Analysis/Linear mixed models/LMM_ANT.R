# require(lme4)
install.packages("lme4")
library(lme4)
install.packages("glmm")
require(glmm)
require(car)
library(dplyr)
install.packages("MuMIn")
require(MuMIn)
library(MuMIn)
library(nlme)
install.packages("lmerTest")
library(lmerTest)

library(readxl)
data<-read_excel("C:/Experiment_PUK/Behav_Codes/MixedModels/MM_ANT.xls")

data$group <- as.factor(data$group)
data$subj <- as.factor(data$subj)
data$day <- as.factor(data$day)
data$trial <- as.factor(data$trial)
data$cue <- as.factor(data$cue)
data$coherence <- as.factor(data$coherence)
data$corr <- as.factor(data$corr)

# for RT
rts_dataset<-subset(data,corr=="1" & !is.na(rt))

m00 <-lmer(rt ~ day * group * cue * coherence + (1 | subj) + (1|trial), data = rts_dataset)

anova(m00)

# ploting
plot(effect("day*group",m00))

# posthoc analysis
# 1
rts_dataset$group <- relevel(rts_dataset$group,ref="CTRL")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day1")
m00 <-lmer(rt ~ day * group * cue * coherence + (1 | subj) + (1|trial), data = rts_dataset)
summary(m00)

# posthoc analysis 2
rts_dataset$group <- relevel(rts_dataset$group,ref="NF")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day2")
m00 <-lmer(rt ~ day * group * cue * coherence + (1 | subj) + (1|trial), data = rts_dataset)
summary(m00)

# for accuracy
acc_dataset<-subset(data,!is.na(rt))

m01 <- glmer(corr ~ day * group * cue * coherence + (1 | subj) + (1|trial), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))

car::Anova(m01)
plot(effect("day*group",m01))

# posthoc analysis 1
acc_dataset$group <- relevel(acc_dataset$group,ref="CTRL")
acc_dataset$day <- relevel(acc_dataset$day,ref="Day1")
m01a <- glmer(corr ~ day * group * cue * coherence + (1 | subj) + (1|trial), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))
summary(m01a)

# posthoc analysis 2
acc_dataset$group <- relevel(acc_dataset$group,ref="NF")
acc_dataset$day <- relevel(acc_dataset$day,ref="Day2")
m01b <- glmer(corr ~ day * group * cue * coherence + (1 | subj) + (1|trial), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))
summary(m01b)
