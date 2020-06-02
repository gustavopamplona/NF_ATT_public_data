library(readxl)
# data <- read_excel("C:/Users/Gustavo/Desktop/Physio/HR_data.xls")
data <- read_excel("C:/Users/Gustavo/Desktop/Physio/RVT_data.xls")

dataset_base<-subset(data,cond=='base')
dataset_task<-subset(data,cond=='task')

# checking normality
d <- dataset_base$physio-dataset_task$physio
shapiro.test(d)

t.test(dataset_base$physio,dataset_task$physio, alternative = "two.sided", paired = TRUE, conf.level = 0.9)




