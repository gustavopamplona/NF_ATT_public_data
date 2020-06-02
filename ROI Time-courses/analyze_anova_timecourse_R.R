library(readxl)
data<-read_excel("C:/Experiment_PUK/TimeSeriesAnalysis/TimeCourseTable4.xls")

data$day <- as.factor(data$day)
data$subj <- as.factor(data$subj)
data$time <- as.factor(data$time)

# m00 <-lm(psc ~ day * time + subj, data = data)
# anova(m00)

m00 <- aov(psc~(day*time)+Error(subj/day*time), data=data)
summary(m00)

# plot(effect("day*time",m00))