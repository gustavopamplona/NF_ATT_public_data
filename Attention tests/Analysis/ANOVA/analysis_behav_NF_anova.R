library(readxl)
data <- read_excel("G:/Backup NF Experiment - PUK/Behav_Codes/behav_anova.xlsx")

data$time = as.factor(data$time)
data$subj = as.factor(data$subj)
data$group = as.factor(data$group)

m00 = aov(score~(time*group)+Error(subj/time)+group,data=data)
summary(m00)

#install.packages("ggpubr")
library("ggpubr")
ggboxplot(data, x = "group", y = "score", color = "time",
          palette = c("#00AFBB", "#E7B800"))
