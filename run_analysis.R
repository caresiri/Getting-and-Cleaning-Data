#Project
library(dplyr)
setwd("./Desktop")
if(!file.exists("./data")){dir.create("./data")}
#download two data sets and read them both into two datadframes
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
setwd("./data")
getwd()
unzip("Dataset.zip")

# Merges the training and the test sets to create one data set.
xtrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
xtest <- read.table('./UCI HAR Dataset/test/X_test.txt')
x <- rbind(xtrain, xtest)

subj.train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subj.test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subj <- rbind(subj.train, subj.test)

ytrain <- read.table('./UCI HAR Dataset/train/y_train.txt')
ytest <- read.table('./UCI HAR Dataset/test/y_test.txt')
y <- rbind(ytrain, ytest)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table('./UCI HAR Dataset/features.txt')
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
xmean.sd <- x[, mean.sd]

# Uses descriptive activity names to name the activities in the data set
names(xmean.sd) <- features[mean.sd, 2]
names(xmean.sd) <- tolower(names(xmean.sd)) 
names(xmean.sd) <- gsub("\\(|\\)", "", names(xmean.sd))

activities <- read.table('./UCI HAR Dataset/activity_labels.txt')
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])

y[, 1] = activities[y[, 1], 2]
colnames(y) <- 'activity'
colnames(subj) <- 'subject'

# Appropriately labels the data set with descriptive activity names.
data <- cbind(subj, xmean.sd, y)
str(data)
write.table(data, './merged.txt', row.names = F)

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
average.df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
average.df <- average.df[, !(colnames(average.df) %in% c("subj", "activity"))]
str(average.df)
write.table(average.df, './average.txt', row.names = F)
