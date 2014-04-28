setwd("~/Documents/R")
## load data

X_train <- read.table("data/X_train.txt")
X_test <- read.table("data/X_test.txt")
features <- read.table("data/features.txt")


## gather important data

#Merge the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.

relevant.measurements <- grep('mean\\(|std\\(', features$V2)
tidy.measurements <- rbind(X_test[, relevant.measurements], X_train[, relevant.measurements])

#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive activity names.

measurement.labels <- features[relevant.measurements, 2];
library("stringr")
colnames(tidy.measurements) <- sapply(measurement.labels, function(x) str_replace_all(x, "\\(\\)|-",""))

write.table(tidy.measurements, 'data/tidy.measurements.txt')

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. Good luck!
y_train <- read.table("data/y_train.txt")
y_test <- read.table("data/y_test.txt")
activity_labels <- read.table("data/activity_labels.txt")
subject_test <- read.table("data/subject_test.txt")
subject_train <- read.table("data/subject_train.txt")

activity <- rbind(y_test, y_train)[[1]]
subject <- rbind(subject_test, subject_train)[[1]]

require(reshape2)

## average data in a table with index ids subject, activity
indexed.data <- data.frame(cbind(subject, activity, tidy.measurements))
tidy.data.grouped <- aggregate(indexed.data, by=list(activity, subject), FUN=mean)
write.table(tidy.data.grouped, 'data/tidy.data.grouped.txt')

## split arrays and store average data in nested objects
indexed.activity.data <- split(indexed.data, activity)
indexed.activity.subject.data <- lapply(indexed.activity.data, function(x) { split(x, x$subject) }) 
tidy.data.nested <- lapply(indexed.activity.subject.data , function(x) { lapply(x, function(y) sapply(y, mean) )} )
names(tidy.data.nested) <- activity_labels[,2]
write.table(tidy.data.nested, 'data/tidy.data.nested.txt')

library('plyr')
library('reshape')

## melted but not referencable
tidy.data.melted <- lapply(indexed.activity.data, function(x) cast(melt(x, id=c("subject")), variable ~ subject, mean))
names(tidy.data.melted) <- activity_labels[,2]
write.table(tidy.data.melted, 'data/tidy.data.melted.txt')

## Average by activity (though not by subject)

tidy.2.tmp <- split(tidy.measurements, activity)
tidy.2.tmp.1 <- sapply(tidy.2.tmp$`1`, mean)
tidy.2.tmp.2 <- sapply(tidy.2.tmp$`2`, mean)
tidy.2.tmp.3 <- sapply(tidy.2.tmp$`3`, mean)
tidy.2.tmp.4 <- sapply(tidy.2.tmp$`4`, mean)
tidy.2.tmp.5 <- sapply(tidy.2.tmp$`5`, mean)
tidy.2.tmp.6 <- sapply(tidy.2.tmp$`6`, mean)

tidy.data.activities <- data.frame(activity1=tidy.2.tmp.1
                   , activity2=tidy.2.tmp.2
                   , activity3=tidy.2.tmp.3
                   , activity4=tidy.2.tmp.4
                   , activity5=tidy.2.tmp.5
                   , activity6=tidy.2.tmp.6)
colnames(tidy.data.activities) <- activity_labels[,2]

write.table(tidy.data.activities, 'data/tidy.data.activities.txt')