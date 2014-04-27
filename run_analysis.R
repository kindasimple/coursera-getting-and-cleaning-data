## load data

X_train <- read.table("data/X_train.txt")
X_test <- read.table("data/X_test.txt")
features <- read.table("data/features.txt")


## gather important data

#Merge the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.

relevant.measurements <- grep('mean\\(|std\\(', features$V2)
tidy.1 <- rbind(X_test[, relevant.measurements], X_train[, relevant.measurements])

tidy.1.filename <- 'tidy.1.txt'
sink(tidy.1.filename)
print(tidy.1)
sink()
unlink(tidy.1.filename)

#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive activity names.

measurement.labels <- features[relevant.measurements, 2];
library("stringr")
colnames(tidy.1) <- sapply(measurement.labels, function(x) str_replace_all(x, "\\(\\)|-",""))


#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. Good luck!
y_train <- read.table("data/y_train.txt")
y_test <- read.table("data/y_test.txt")
activity_labels <- read.table("data/activity_labels.txt")

y <- rbind(y_test, y_train)

tidy.2.tmp <- split(tidy.1, y[,1])
tidy.2.tmp.1 <- sapply(tidy.2.tmp$`1`, mean)
tidy.2.tmp.2 <- sapply(tidy.2.tmp$`2`, mean)
tidy.2.tmp.3 <- sapply(tidy.2.tmp$`3`, mean)
tidy.2.tmp.4 <- sapply(tidy.2.tmp$`4`, mean)
tidy.2.tmp.5 <- sapply(tidy.2.tmp$`5`, mean)
tidy.2.tmp.6 <- sapply(tidy.2.tmp$`6`, mean)

tidy.2 <- data.frame(subject1=tidy.2.tmp.1
                   , subject2=tidy.2.tmp.2
                   , subject3=tidy.2.tmp.3
                   , subject4=tidy.2.tmp.4
                   , subject5=tidy.2.tmp.5
                   , subject6=tidy.2.tmp.6)
colnames(tidy.2) <- activity_labels[,2]

tidy.2.filename <- 'tidy.2.txt'
sink(tidy.2.filename)
print(tidy.2)
sink()
unlink(tidy.2.filename)
