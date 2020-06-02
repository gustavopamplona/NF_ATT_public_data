library(readxl)
data <- read_excel("G:/Backup NF Experiment - PUK/Questionnaires/DSSQ_anova_TIinterf.xls")

data$time = as.factor(data$time)
data$subj = as.factor(data$subj)
data$group = as.factor(data$group)

m00 = glm(score~(time*group),data=data)
summary(m00)

install.packages("ggpubr")
library("ggpubr")
ggboxplot(data, x = "group", y = "score", color = "time",
          palette = c("#00AFBB", "#E7B800"))