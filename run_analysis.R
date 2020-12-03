# Download and read the test and training sets from the txt files provided

if(!file.exists("UCI HAR Dataset")){
  dir.create("UCI HAR Dataset")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./UCI HAR Dataset.zip")
unzip("UCI HAR Dataset.zip")

path <- "/UCI HAR Dataset"

subj_train <- read.table(file.path(path, "train", "subject_train.txt" ))
X_train <- read.table(file.path(path, "train", "X_train.txt" ))
Y_train <- read.table(file.path(path, "train", "Y_train.txt" ))

subj_test <- read.table(file.path(path, "test", "subject_test.txt" ))
X_test <- read.table(file.path(path, "test", "X_test.txt" ))
Y_test <- read.table(file.path(path, "test", "Y_test.txt" ))

train<- cbind(subj_train, Y_train, X_train)
test<- cbind(subj_test, Y_test, X_test)

HumanActivity <- rbind(train, test)

features <- read.table(file.path(path, "features.txt"), as.is = TRUE)
activity_labels <- read.table(file.path(path, "activity_labels.txt"), as.is = TRUE)

colnames(HumanActivity) <- c("Subject", "Activity", features[ ,2])

HumanActivity$Activity <- factor(HumanActivity$Activity, activity_labels[,1], activity_labels[,2])

## Extracts only the measurements on the mean and standard deviation for each measurement
## and create a new datatable with the selected variables, including the "Subject ID" and "Activity"

columns_extr <- grepl("Subject|Activity|mean|sdt", colnames(HumanActivity) ) 
HumanActivity <- HumanActivity[, columns_extr]

names(HumanActivity)
HumanActivity_Cols <- colnames(HumanActivity)

## Remove special characters and typos

HumanActivity_Cols <- gsub("\\-", " ", HumanActivity_Cols)
HumanActivity_Cols <- gsub("BodyBody", "Body", HumanActivity_Cols)

## Explicit some of the indicators in the variables' names

HumanActivity_Cols <- gsub("^f", "frequencyDomain ", HumanActivity_Cols)
HumanActivity_Cols <- gsub("^t", "timeDomain ", HumanActivity_Cols)
HumanActivity_Cols <- gsub("Acc", "Accelerometer", HumanActivity_Cols)
HumanActivity_Cols <- gsub("Gyro", "Gyroscope", HumanActivity_Cols)
HumanActivity_Cols <- gsub("Mag", "Magnitude", HumanActivity_Cols)
HumanActivity_Cols <- gsub("Freq", "Frequency", HumanActivity_Cols)
HumanActivity_Cols <- gsub("mean()", "Mean", HumanActivity_Cols)
HumanActivity_Cols <- gsub("std()", "StandardDeviation", HumanActivity_Cols)

colnames(HumanActivity) <- HumanActivity_Cols

## Create a second, independent tidy set with the average of each variable for each activity and each subject

HumanActivity_Summary <- aggregate(. ~ Subject + Activity, data = HumanActivity, mean)

## Save the tidy set as a text file 

write.table(HumanActivity_Summary , "HumanActivity_Tidy_Summary.txt", row.names = FALSE)


                                       