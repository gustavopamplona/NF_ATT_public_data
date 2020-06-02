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
dataCL<-read_excel("G:/Backup NF Experiment - PUK/Behav_Codes/MixedModels/MM_CPT.xls")

# dataset$outlier <- ifelse(dataset$zscore>2.5 | dataset$zscore< -2.5, 1, 0) 
# outliers_perc<-dataset(cCFS$outlier)/length(cCFS$outlier)
# dataCL<-subset(dataset, (outlier ==0))

# dataCL$logRTs = log(dataCL$rt)

# dataCL$ContVariable <- as.numeric(dataCL$ContVariable)
dataCL$group <- as.factor(dataCL$group)
dataCL$subj <- as.factor(dataCL$subj)
dataCL$day <- as.factor(dataCL$day)
dataCL$trialType <- as.factor(dataCL$trialType)
dataCL$corr <- as.factor(dataCL$corr)
dataCL$trial <- as.factor(dataCL$trial)

# dataCL$Factor0<- NA
# dataCL$Factor0[dataCL$Factor =="Group1" ]<- 1
# dataCL$Factor0[dataCL$Factor =="Group2" ]<- -1
# mean(dataCL$Food_NonFood0)

rts_dataset<-subset(dataCL,trialType=="go" & corr=="1" & !is.na(rt)) #  we wanna consider rts only for go trials
GoTrials<-subset(dataCL,trialType=="go") #  we wanna consider accuracy only for go trials (this must be equivalent to a 3-way model [m01])
NoGoTrials<-subset(dataCL,trialType=="no go") #  we wanna consider accuracy only for nogo trials

m00 <-lmer(rt ~ day * group + (1 | subj) + (1|trial) , data = rts_dataset) # for continuous data

rts_datasetNF1<-subset(dataCL, group=="NF" & day=="Day1" & trialType=="go" & !is.na(rt))
rts_datasetNF2<-subset(dataCL, group=="NF" & day=="Day2" & trialType=="go" & !is.na(rt))
rts_datasetTR1<-subset(dataCL, group=="CTRL" & day=="Day1" & trialType=="go" & !is.na(rt))
rts_datasetTR2<-subset(dataCL, group=="CTRL" & day=="Day2" & trialType=="go" & !is.na(rt))
mean(rts_datasetNF2$rt)-mean(rts_datasetNF1$rt)
mean(rts_datasetTR2$rt)-mean(rts_datasetTR1$rt)

m01go<-glmer(corr ~ group * day + (1 | subj) + (1 | trial), family = binomial(), data = GoTrials,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5))) # for binomial data
m01nogo<-glmer(corr ~ group * day + (1 | subj) + (1 | trial), family = binomial(), data = NoGoTrials,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5))) # for binomial data
#m00<-glmer(dataCL$corr ~ dataCL$trialType * dataCL$group * dataCL$day + (1 | dataCL$subj) + (1 | dataCL$trial), family = binomial(), data = rts_dataset,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5))) # for binomial data

# posthoc analysis 1
rts_dataset$group <- relevel(rts_dataset$group,ref="CTRL")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day1")
m00 <-lmer(rt ~ day * group + (1 | subj) + (1|trial) , data = rts_dataset)
summary(m00)

# posthoc analysis 2
rts_dataset$group <- relevel(rts_dataset$group,ref="NF")
rts_dataset$day <- relevel(rts_dataset$day,ref="Day2")
m00 <-lmer(rt ~ day * group + (1 | subj) + (1|trial) , data = rts_dataset)
summary(m00)

# for accuracy
# acc_dataset<-subset(dataCL,!is.na(rt)) # R is giving me an error message during the model using this acc_dataset. I think it is because of the missing subjects. Hopefully, it deals with nan

m01<-glmer(corr ~ day * group * trialType + (1 | subj) + (1 | trial), family = binomial(), data = dataCL,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))

car::Anova(m01)

plot(effect("day*group",m01))

# posthoc analysis 1
dataCL$group <- relevel(dataCL$group,ref="CTRL")
dataCL$day <- relevel(dataCL$day,ref="Day1")
m01<-glmer(corr ~ day * group * trialType + (1 | subj) + (1 | trial), family = binomial(), data = dataCL,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5)))
summary(m01)

# posthoc analysis 2
dataCL$group <- relevel(dataCL$group,ref="NF")
dataCL$day <- relevel(dataCL$day,ref="Day2")
m01<-glmer(corr ~ trialType * day * group + (1 | subj) + (1 | trial), family = binomial(), data = dataCL,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5))) # for binomial data
summary(m01)

acc_datasetNF1<-subset(dataCL, group=="NF" & day=="Day1" & !is.na(cond))
acc_datasetNF2<-subset(dataCL, group=="NF" & day=="Day2" & !is.na(cond))
acc_datasetTR1<-subset(dataCL, group=="CTRL" & day=="Day1" & !is.na(cond))
acc_datasetTR2<-subset(dataCL, group=="CTRL" & day=="Day2" & !is.na(cond))
(nnzero(acc_datasetNF2$corr)/nnzero(acc_datasetNF2$group)-nnzero(acc_datasetNF1$corr)/nnzero(acc_datasetNF1$group))*100
(nnzero(acc_datasetTR2$corr)/nnzero(acc_datasetTR2$group)-nnzero(acc_datasetTR1$corr)/nnzero(acc_datasetTR1$group))*100

# * includes interaction and + only main effects
# (1 | blah) are random factors

# r.squaredGLMM(m00)
# r.squaredGLMM(m01)

anova(m00)

car::Anova(m01go)
car::Anova(m01nogo)

plot(effect("day*group",m00))
plot(effect("day*group",m01go))

m01full<-glmer(corr ~ trialType * day * group + (1 | subj) + (1 | trial), family = binomial(), data = dataCL,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5))) # for binomial data

m01a<-glmer(corr ~ day * group + (1 | subj) + (1 | trial), family = binomial(), data = dataCL,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5))) # for binomial data
m01b<-glmer(corr ~ trialType * group + (1 | subj) + (1 | trial), family = binomial(), data = dataCL,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5))) # for binomial data
m01c<-glmer(corr ~ trialType * day + (1 | subj) + (1 | trial), family = binomial(), data = dataCL,control=glmerControl(optimizer="bobyqa", optCtrl=list(maxfun=2e5))) # for binomial data

anova(m01full,m01a) # trialType is useful for the model (check AIC [Akaike information criterion])
anova(m01full,m01b) # day is not improving the model
anova(m01full,m01c) # group is not improving the model
