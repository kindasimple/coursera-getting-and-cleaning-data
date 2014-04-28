Code Book: Tidy UCI HAR Dataset
=======================

This is a tidy version of the dataset: Human Activity Recognition Using Smartphones Dataset (Version 1.0). It contains accelerometer measurements from Samsung Galaxy S smartphones while subjects performed various activities. For the particulars of the measurements recorded and their derivation, refer to the documentation of the dataset location in [features_info.txt](UCI%20HAR%20Dataset/features_info.txt)

This package contains two datasets. The first is a merge of both the testing and training measurements datasets filtered to include only the variables related to mean and standard deviation measurements.

The following variables are loaded from the CI HAR Dataset

* X_train
* X_test
* features

First, we determine the indicies of the columns pertaining to the mean and standard deviation by running a grep against the feature dataset selecting on `mean()` and `std()`. The indicies are saved in the vector `relevant.measures` and are used to extract the columns from the `X_train` and `X_test` data sets. The observations of these variables are merged with a call to `rbind()` and the results are stored in the `tidy.1` data frame.

The activity variables are labeled by extracting the variable names from the second column of the features data set, scrubbed to remove special characters that make the variables difficult to reference without escaping variable references, and applied to the `tidy.measurements` data frame assigning the result to the data frame with colnames(). Special characters are removed by calling str_replace_all on each measurement name to replace parenthesis and dash characters.

The second dataset presents the average of each of the measurement variables, broken out by activity type.

The following variables are loaded from the CI HAR dataset.

* y_train
* y_test
* activity_labels

A map of the activity type for each observation is created by merging the `y_` data for testing and training in the same order as the merge for the `X_` observations.

### tidy.data.activities

The dataset `tidy.measurements` is split into data frames grouped by the activity factor. A mean() is applied to each data frame to compute the average for each measurement of each activity. The resulting set of six vectors are merged as rows in a data frame, one row per activity, and the result is stored in the `tidy.data.activities` dataset. The activity variables are then named by applying the labels from the activity_labels dataset to the columns of the `tidy.data.activities` dataset. This dataset does not satisfy the requirements of the assignment because it is not subdivided by subject.

### tidy.data.grouped

This solution is the most simple. It uses the `reshape` package to call `aggregate()` on the the `tidy.measurements`, which groups the data by the specified dimensions (activity and subject for this assignment). It required adding index columns to the measurements.

```
indexed.data <- data.frame(cbind(subject, activity, tidy.measurements))
tidy.data.grouped <- aggregate(indexed.data, by=list(activity, subject), FUN=mean)
```

The data set isn't highly structured, but for this assignment it is the best solution IMO.

```
> head(tidy.data.grouped[,1:5], n=5)
  Group.1 Group.2 subject activity tBodyAccmeanX
1       1       1       1        1     0.2773308
2       2       1       1        2     0.2554617
3       3       1       1        3     0.2891883
4       4       1       1        4     0.2612376
5       5       1       1        5     0.2789176
```
### tidy.data.nested

This is a multidimensional data structure that subdivides the data by splitting and looping over subsets, and applying the mean to the smallest subset.

```
indexed.activity.data <- split(indexed.data, activity)
indexed.activity.subject.data <- lapply(indexed.activity.data, function(x) { split(x, x$subject) })
tidy.data.nested <- lapply(indexed.activity.subject.data , function(x) { lapply(x, function(y) sapply(y, mean) )} )
```

data can be referenced with variable notation to get at individual properties, and it should be easy to get variable labels.

```
> tidy.data.nested$WALKING$`29`["tBodyAccmeanX"]
tBodyAccmeanX
    0.2719999
```

### tidy.data.melted

This approach uses the `melt()` & `cast()` functions of reshape to subset and average the data. The measurement names are stored in the `variables` variable of data frame instead of as a factor or variable name, and could probably be applied to individual data frames easily using `dcast`.

```
tidy.data.melted <- lapply(indexed.activity.data, function(x) cast(melt(x, id=c("subject")), variable ~ subject, mean))
names(tidy.data.melted) <- activity_labels[,2]
```

### Sources:

Human Activity Recognition Using Smartphones Dataset (Version 1.0)

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
