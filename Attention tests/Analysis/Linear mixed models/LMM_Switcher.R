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
data<-read_excel("G:/Backup NF Experiment - PUK/Behav_Codes/MixedModels/MM_Switcher.xls")

# dataCL$ContVariable <- as.numeric(dataCL$ContVariable)
data$group <- as.factor(data$group)
data$subj <- as.factor(data$subj)
data$day <- as.factor(data$day)
data$type <- as.factor(data$type)
data$try <- as.factor(data$try)
data$corr <- as.factor(data$corr)

# for RT
rts_dataset<-subset(data,corr=="1" & !is.na(rt) & type!="0")

m00 <-lmer(rt ~ day *group * type + (1 | subj) + (1|try) , data = rts_dataset)

anova(m00)

plot(effect("day*group",m00))

# posthoc analysis 1
rts_dataset$group <- relevel(rts_dataset$group,ref="CTRL")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day1")
m00 <-lmer(rt ~ day * group * type + (1 | subj) + (1|try) , data = rts_dataset)
summary(m00)

# posthoc analysis 2
rts_dataset$group <- relevel(rts_dataset$group,ref="NF")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day2")
m00 <-lmer(rt ~ day * group * type + (1 | subj) + (1|try) , data = rts_dataset)
summary(m00)

# for computation of differences
rts_datasetNF1<-subset(rts_dataset, group=="NF" & day=="Day1")
rts_datasetNF2<-subset(rts_dataset, group=="NF" & day=="Day2")
rts_datasetTR1<-subset(rts_dataset, group=="CTRL" & day=="Day1")
rts_datasetTR2<-subset(rts_dataset, group=="CTRL" & day=="Day2")
mean(rts_datasetNF2$rt)-mean(rts_datasetNF1$rt)
mean(rts_datasetTR2$rt)-mean(rts_datasetTR1$rt)

# for accuracy
acc_dataset<-subset(data,type!="0" & !is.na(rt))

m01<-glmer(corr ~ day * group * type + (1 | subj) + (1 | try), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))

car::Anova(m01)

plot(effect("day*group",m01))

# posthoc analysis 1
acc_dataset$group <- relevel(acc_dataset$group,ref="CTRL")
acc_dataset$day <- relevel(acc_dataset$day,ref="Day1")
m01<-glmer(corr ~ day * group * type + (1 | subj) + (1 | try), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))
summary(m01)

# posthoc analysis 2
acc_dataset$group <- relevel(acc_dataset$group,ref="NF")
acc_dataset$day <- relevel(acc_dataset$day,ref="Day2")
m01<-glmer(corr ~ day * group * type + (1 | subj) + (1 | try), family = binomial(), data = acc_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))
summary(m01)

# for computation of differences
acc_dataset<-subset(data, !is.na(rt) & type!="0")
acc_datasetNF1<-subset(acc_dataset, group=="NF" & day=="Day1" & !is.na(type))
acc_datasetNF2<-subset(acc_dataset, group=="NF" & day=="Day2" & !is.na(type))
acc_datasetTR1<-subset(acc_dataset, group=="CTRL" & day=="Day1" & !is.na(type))
acc_datasetTR2<-subset(acc_dataset, group=="CTRL" & day=="Day2" & !is.na(type))
(nnzero(acc_datasetNF2$corr)/nnzero(acc_datasetNF2$group)-nnzero(acc_datasetNF1$corr)/nnzero(acc_datasetNF1$group))*100
(nnzero(acc_datasetTR2$corr)/nnzero(acc_datasetTR2$group)-nnzero(acc_datasetTR1$corr)/nnzero(acc_datasetTR1$group))*100
