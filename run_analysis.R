#
# final course project: Getting and Cleaning Data (JHU)
#
# Dirk Stallkamp


# reading "test"- and "training"-data
dataTest <- read.table("~/data/final project/X_test.txt", quote = "\"", comment.char = "")
dataTrain <- read.table("~/data/final project/X_train.txt", quote = "\"", comment.char = "")
activityTest <- read.table("~/data/final project/y_test.txt", quote = "\"", comment.char = "")
activityTrain <- read.table("~/data/final project/y_train.txt", quote = "\"", comment.char = "")
subjectTest <- read.table("~/data/final project/subject_test.txt", quote = "\"", comment.char = "")
subjectTrain <- read.table("~/data/final project/subject_train.txt", quote = "\"", comment.char = "")

# combining data sets
combinedTest <- cbind(dataTest, subjectTest, activityTest)
combinedTrain <- cbind(dataTrain, subjectTrain, activityTrain)

#merging data set
mergedData <- rbind(combinedTest, combinedTrain)

#get row names
features <- read.table("~/data/final project/features.txt", quote = "\"", comment.char = "")

#set row names in data set
names(mergedData) <- features$V2
names(mergedData)[562] <- "subject"
names(mergedData)[563] <- "activityid"

#read activity_label data
activityLabels <- read.table("~/data/final project/activity_labels.txt", quote = "\"", comment.char = "")
names(activityLabels) <- c("activityid","activityname")

#refactoring and rename activity in labels
mergedData$activityname <- factor(mergedData$activityid, levels = activityLabels$activityid, labels = activityLabels$activityname)

#Extracts only the measurements on the mean and standard deviation for each measurement
dataSelection <- mergedData[,grep("-mean\\(\\)|-std\\(\\)|subject|activityname", names(mergedData))]

#copy to second data set
finaldataSelection <- dataSelection

#tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
finaldataSelection <- reshape2::melt(data = finaldataSelection, id = c("subject", "activityname"))
finaldataSelection <- reshape2::dcast(data = finaldataSelection, subject + activityname ~ variable, fun.aggregate = mean)

#write tidy data set to HDD
write.table(finaldataSelection, "./data/final project/finaldataset.txt", row.names = FALSE)
