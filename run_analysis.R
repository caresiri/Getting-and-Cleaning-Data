#Project
library(plyr)
library(dplyr)
library(reshape2)
setwd("./Desktop")
if(!file.exists("./data")){dir.create("./data")}
#download two data sets and read them both into two datadframes
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
setwd("./data")
unzip("Dataset.zip")
setwd("./UCI HAR Dataset")
getwd()



#Part 1 Merges the training and the test sets to create one data set.

ActivityLabels <- read.table("activity_labels.txt")
Features <- read.table("features.txt")

# test files

SubjectTest <- read.table("./test/subject_test.txt")
colnames(SubjectTest) <- "VolunteerID"

XTest <- read.table("./test/X_test.txt")
colnames(XTest) <- Features$V2

YTest <- read.table("./test/y_test.txt")
colnames(YTest) <- "Activity"

# training files

SubjectTrain <- read.table("./train/subject_train.txt")
colnames(SubjectTrain) <- "VolunteerID"

XTrain <- read.table("./train/X_train.txt")
colnames(XTrain) <- Features$V2

YTrain <- read.table("./train/y_train.txt")
colnames(YTrain) <- "Activity"

# combine test data
TestData <- cbind(SubjectTest, YTest, XTest)

# combine train data
TrainData <- cbind(SubjectTrain, YTrain, XTrain)

# combine TestData & TrainData
CompleteData <- rbind(TestData, TrainData)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
DataExt <- CompleteData[, grep("mean|Mean|std", names(CompleteData))]
Data <- cbind(CompleteData$VolunteerID, CompleteData$Activity, DataExt)

colnames(Data)[1] <- "VolunteerID"
colnames(Data)[2] <- "Activity"


# Part 3 Uses descriptive activity names to name the activities in the data set

Data$Activity[Data$Activity == 1] <- "walking"
Data$Activity[Data$Activity == 2] <- "walking upstairs"
Data$Activity[Data$Activity == 3] <- "walking downstairs"
Data$Activity[Data$Activity == 4] <- "sitting"
Data$Activity[Data$Activity == 5] <- "standing"
Data$Activity[Data$Activity == 6] <- "laying"


# Part 4 Appropriately labels the data set with descriptive variable names


names(Data) <- gsub("Acc", "accelerometer", names(Data))
names(Data) <- gsub("Mag", "magnitude", names(Data))
names(Data) <- gsub("Gyro", "gyroscope", names(Data))
names(Data) <- gsub("^t", "timeDomain", names(Data))
names(Data) <- gsub("^f", "frequencydomain", names(Data))
names(Data) <- gsub("std", "standarddeviation", names(Data))
names(Data) <- gsub("tBody", "timedomainbody", names(Data))


# Part 4 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


meltData <- melt(Data, id=c("VolunteerID", "Activity"))
TidyData <- dcast(meltData, VolunteerID+Activity ~ variable, mean)
colnames(TidyData)[1] <- "Subject"
head(TidyData)
View(TidyData)
write.table(TidyData, file = "TidyData.txt", row.name = FALSE)
