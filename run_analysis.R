

# Read the test and training sets from txt

path <- "UCI HAR Dataset"

subj_train <- read.table(file.path(path, "train", "subject_train.txt" ))
X_train <- read.table(file.path(path, "train", "X_train.txt" ))
Y_train <- read.table(file.path(path, "train", "Y_train.txt" ))

subj_test <- read.table(file.path(path, "test", "subject_test.txt" ))
X_test <- read.table(file.path(path, "test", "X_test.txt" ))
Y_test <- read.table(file.path(path, "test", "Y_test.txt" ))

train_dataset <- cbind(subj_train, Y_train, X_train)
test_dataset <- cbind(subj_test, Y_test, X_test)

all_dataset <- rbind(train_dataset, test_dataset)

features <- read.table(file.path(path, "features.txt"), as.is = TRUE)
activity_labels <- read.table(file.path(path, "activity_labels.txt"), as.is = TRUE)

colnames(all_dataset) <- c("Subject", "Activity", features[ ,2])

all_dataset$Activity <- factor(all_dataset$Activity, activity_labels[,1], activity_labels[,2])

##########################################################################################
## Extracts only the measurements on the mean and standard deviation for each measurement.

column_extr <- grepl("mean|sdt", colnames(all_dataset) ) 
all_subset <- all_dataset[, column_extr]

names(all_dataset)
all_dataset<- # get column names
  har_Cols <- colnames(all_dataset)

# remove special characters
humanActivityCols<- gsub("\\-", " ", har_Cols)
humanActivityCols <- gsub("BodyBody", "Body", har_Cols)
# expand abbreviations and clean up names

humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)


##############################################################################
# Create a second, independent tidy set with the average of each variable for each activity and each subject

humActivity_stats <- aggregate(. ~ Subject + Activity, data = all_dataset, mean)


##########
