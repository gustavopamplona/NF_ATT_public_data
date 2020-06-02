require(lme4)
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
data<-read_excel("G:/Backup/Backup NF Experiment - PUK/Behav_Codes/MixedModels/MM_PVT.xls")

# dataCL$ContVariable <- as.numeric(dataCL$ContVariable)
data$group <- as.factor(data$group)
data$subj <- as.factor(data$subj)
data$day <- as.factor(data$day)
#data$try <- as.factor(data$try)

# for RT
rts_dataset<-subset(data,!is.na(rt))

m00 <-lmer(rt ~ day * group * try + (1 | subj), data = rts_dataset)

anova(m00)

install.packages("cran")
library(effects)
plot(effect("day*group",m00))

# posthoc analysis 1
rts_dataset$group <- relevel(rts_dataset$group,ref="CTRL")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day1")
m00 <-lmer(rt ~ day * group * try + (1 | subj), data = rts_dataset)
summary(m00)

# posthoc analysis 2
rts_dataset$group <- relevel(rts_dataset$group,ref="NF")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day1")
m00 <-lmer(rt ~ day * group * try + (1 | subj), data = rts_dataset)
summary(m00)

# data preparation:
rts_dataset$low.try <- rts_dataset$try + sd(rts_dataset$try)
#rts_dataset$low.try <- rts_dataset$try + 20
rts_dataset$high.try <- rts_dataset$try - sd(rts_dataset$try)
#rts_dataset$high.try <- rts_dataset$try -35

# posthoc analysis 1
rts_dataset$group <- relevel(rts_dataset$group,ref="CTRL")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day1")
m01<-lmer(rt ~ day * group * low.try + (1 |subj) , data = rts_dataset)
#m01<-lmer(rt ~ day * group * try + (1 |subj) , data = rts_dataset)
summary(m01)

plot(effect("day*group*high.try",m01))

# posthoc analysis 2
rts_dataset$group <- relevel(rts_dataset$group,ref="NF")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day2")
m01<-lmer(rt ~ day * group * low.try + (1 |subj) , data = rts_dataset)
summary(m01)

# posthoc analysis 3
rts_dataset$group <- relevel(rts_dataset$group,ref="CTRL")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day1")
m01<-lmer(rt ~ day * group * high.try + (1 |subj) , data = rts_dataset)
summary(m01)

# posthoc analysis 4
rts_dataset$group <- relevel(rts_dataset$group,ref="NF")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day2")
m01<-lmer(rt ~ day * group * high.try + (1 |subj) , data = rts_dataset)
summary(m01)

