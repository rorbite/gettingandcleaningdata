setwd("C:\\Ronaldo\\Coursera\\RGetCleanData")

# initialize libraries
library(dplyr)

##
## Ex1: Merges the training and the test sets to create one data set 
##

# read features
features <- read.table(paste(getwd(),"/UCI HAR Dataset/features.txt", sep=""), header=FALSE, col.names=c("id", "name"))

# read test data and assign labels
x_test <- read.table(paste(getwd(),"/UCI HAR Dataset/test/x_test.txt", sep=""), header=FALSE)
names(x_test) <- features[,2]

# Attach the other datasets as columns
subject_test <- read.table(paste(getwd(),"/UCI HAR Dataset/test/subject_test.txt", sep=""), header=FALSE, col.names="subject")
y_test <- (read.table(paste(getwd(),"/UCI HAR Dataset/test/y_test.txt", sep=""), header=FALSE,  col.names="activity"))
test <- cbind(subject_test, y_test, x_test)

# read train data and assign labels
x_train <- read.table(paste(getwd(),"/UCI HAR Dataset/train/x_train.txt", sep=""), header=FALSE)
names(x_train) <- features[,2]

# Attach the other datasets as columns
subject_train <- read.table(paste(getwd(),"/UCI HAR Dataset/train/subject_train.txt", sep=""), header=FALSE, col.names="subject")
y_train <- read.table(paste(getwd(),"/UCI HAR Dataset/train/y_train.txt", sep=""), header=FALSE,  col.names="activity")
train <- cbind(subject_train, y_train, x_train)

## join test and train datasets
test_train <- rbind(test, train)

##
## Ex2: Extracts only the measurements on the mean and standard deviation for each measurement
##

## filter columns with mean() or std() string in the name
mean_std <- test_train[, grepl("-mean()", names(test_train), fixed=TRUE ) | grepl("-std()", names(test_train), fixed=TRUE ) ]

##
## Ex3: Uses descriptive activity names to name the activities in the data set
##

## include subject and activity columns
mean_std <- cbind(test_train[, c("subject","activity")], mean_std)

## include activity labels
activity_labels <- read.table(paste(getwd(),"/UCI HAR Dataset/activity_labels.txt", sep=""), header=FALSE, col.names=c("id", "activity.label"))
mean_std <- inner_join(mean_std, activity_labels, by=c("activity" = "id"))

##
## Ex4: Appropriately labels the data set with descriptive variable names
##

# already done when including features dataset in exercise 1

##
## Ex5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
##

## generates mean by subject and activity
result_dataset <- aggregate(mean_std, list(mean_std$subject, mean_std$activity.label), mean)

## remove unused columns and rename column groups
result_dataset<- select(result_dataset, -(activity.label), -(subject), -(activity))
colnames(result_dataset)[1] <- "subject"
colnames(result_dataset)[2] <- "activity"

## creates the result file
write.table(result_dataset, file="data.txt", row.names=FALSE) 


