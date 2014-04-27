Code Book: Tidy UCI HAR Dataset
=======================

This is a tidy version of the dataset: Human Activity Recognition Using Smartphones Dataset (Version 1.0). It contains accelerometer measurements from Samsung Galaxy S smartphones while subjects performed various activities. For the particulars of the measurements recorded and their derivation, refer to the documentation of the dataset location in [features_info.txt](UCI%20HAR%20Dataset/features_info.txt)

This package contains two datasets. The first is a merge of both the testing and training measurements datasets filtered to include only the variables related to mean and standard deviation measurements.

The following variables are loaded from the CI HAR Dataset

* X_train
* X_test
* features

First, we determine the indicies of the columns pertaining to the mean and standard deviation by running a grep against the feature dataset selecting on `mean()` and `std()`. The indicies are saved in the vector `relevant.measures` and are used to extract the columns from the `X_train` and `X_test` data sets. The observations of these variables are merged with a call to `rbind()` and the results are stored in the `tidy.1` data frame.

The activity variables are labeled by extracting the variable names from the second column of the features data set, scrubbed to remove special characters that make the variables difficult to reference without escaping variable references, and applied to the tidy.1 data frame assigning the result to the data frame with colnames(). Special characters are removed by calling str_replace_all on each measurement name to replace parenthesis and dash characters.

The second dataset presents the average of each of the measurement variables, broken out by activity type.

The following variables are loaded from the CI HAR dataset.

* y_train
* y_test
* activity_labels

A map of the activity type for each observation is created by merging the `y_` data for testing and training in the same order as the merge for the `X_` observations. The dataset `tidy.1` is split into data frames grouped by the activity factor. A mean() is applied to each data frame to compute the average for each measurement of each activity. The resulting set of six vectors are merged as rows in a data frame, one row per activity, and the result is stored in the tidy.2 data frame. The activity variables are then named by applying the labels from the activity_labels dataset to the columns of the tidy.2 data frame.

### Sources:

Human Activity Recognition Using Smartphones Dataset (Version 1.0)

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
