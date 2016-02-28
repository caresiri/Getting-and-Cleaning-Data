#Project
library(dplyr)
setwd("./Desktop")
if(!file.exists("./data")){dir.create("./data")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
setwd("./data")
getwd()
unzip("Dataset.zip")


xtrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
xtest <- read.table('./UCI HAR Dataset/test/X_test.txt')
x <- rbind(xtrain, xtest)

subj.train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subj.test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subj <- rbind(subj.train, subj.test)

ytrain <- read.table('./UCI HAR Dataset/train/y_train.txt')
ytest <- read.table('./UCI HAR Dataset/test/y_test.txt')
y <- rbind(ytrain, ytest)

features <- read.table('./UCI HAR Dataset/features.txt')
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
xmean.sd <- x[, mean.sd]

names(xmean.sd) <- features[mean.sd, 2]
names(xmean.sd) <- tolower(names(xmean.sd)) 
names(xmean.sd) <- gsub("\\(|\\)", "", names(xmean.sd))

activities <- read.table('./UCI HAR Dataset/activity_labels.txt')
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])

y[, 1] = activities[y[, 1], 2]
colnames(y) <- 'activity'
colnames(subj) <- 'subject'

data <- cbind(subj, xmean.sd, y)
str(data)
write.table(data, './merged.txt', row.names = F)

average.df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
average.df <- average.df[, !(colnames(average.df) %in% c("subj", "activity"))]
str(average.df)
write.table(average.df, './average.txt', row.names = F)
