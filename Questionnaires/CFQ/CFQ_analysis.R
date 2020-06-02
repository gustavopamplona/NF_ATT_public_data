install.packages('readxl')
library(readxl)
data <- read_excel("E:/Backup NF Experiment - PUK/Questionnaires/CFQ_data.xlsx")

shapiro.test(data$cfq_day2) # check normality
cor.test(data$cfq_day1, data$slope, method = "pearson")
#cor.test(data$cfq_day1, data$slope, method = "spearman")

# checking differences between day 1 and day 2
d <- data$cfq_day1-data$cfq_day2
qqPlot(d, dist = "norm")
shapiro.test(d) # check normality
t.test(data$cfq_day1,data$cfq_day2, alternative = "two.sided", paired = TRUE, conf.level = 0.9)
#wilcox.test(dataDay$day2, dataDay$day1, alternative = "greater", conf.level = 0.9)