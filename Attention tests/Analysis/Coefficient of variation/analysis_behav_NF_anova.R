library(readxl)
data <- read_excel("G:/Backup NF Experiment - PUK/Behav_Codes/CV_analysis/CV_PVT.xls")

data$day = as.factor(data$day)
data$subj = as.factor(data$subj)
data$group = as.factor(data$group)

m00 = aov(cv~(day*group)+Error(subj/day)+group,data=data)
summary(m00)

#install.packages("ggpubr")
library("ggpubr")
ggboxplot(data, x = "group", y = "score", color = "time",
          palette = c("#00AFBB", "#E7B800"))
