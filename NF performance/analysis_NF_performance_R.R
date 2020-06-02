# plot boxplot of NF performances

library(readxl)

data <- read_excel("C:/Experiment_PUK/Analysis/data.xlsx")
# include all training and transfer runs

# View(data)

# checking activation for first training run
shapiro.test(data$run1) # check normality
# t.test(data$run1, alternative = "two.sided", paired = FALSE, conf.level = 0.9)
wilcox.test(data$run1, mu = 0, alternative = "two.sided", conf.level = 0.9)

# performing linear regression
data <- read_excel("C:/Experiment_PUK/Analysis/data_reg.xlsx")
mod = lm(perf ~ run, data=data)
summary(mod)
qqPlot(resid(mod), dist = "norm")
shapiro.test(mod$residuals)

# checking differences between day 1 and day 2
dataDay <- read_excel("C:/Experiment_PUK/Analysis/data_day.xlsx")
d <- dataDay$day1-dataDay$day2
qqPlot(d, dist = "norm")
shapiro.test(d) # check normality
t.test(dataDay$day2,dataDay$day1, alternative = "greater", paired = TRUE, conf.level = 0.9)
#wilcox.test(dataDay$day2, dataDay$day1, alternative = "greater", conf.level = 0.9)

# plot physiological signal
library("ggpubr")
dataPhysio <- read_excel("C:/Experiment_PUK/Analysis/Physio_R.xlsx")
p = ggboxplot(dataPhysio, x = "Block", y = "HR", size = 1, 
              palette = c("#0000FF","#FF6600"))
p+
  font("xy.text", size = 18)+
  font("xlab", size = 18)+
  font("ylab", size = 18)

# plot scatterplot and linear fit (?)

# perform comparison between days of training (which test?)

# make bar plots (?)

# same with transfers (only before and after)