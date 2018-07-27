# STEP 0a. Download data

zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

# STEP 0b. Unzip zip file containing data if data directory doesn't already exist

if (!file.exists("UCI HAR Dataset")) {
  unzip(zipFile)
}

# STEP 1a. Read training data

training <- read.table("train/X_train.txt")
traininglabels <- read.table("train/y_train.txt")
trainingsubject <- read.table("train/subject_train.txt")

# STEP 1b. Read test data

test <- read.table("test/X_test.txt")
testlabels <- read.table("test/y_test.txt")
testsubject <- read.table("test/subject_test.txt")

# STEP 1c. Merge training and test datasets

merged <- rbind(cbind(trainingsubject,traininglabels,training),cbind(testsubject,testlabels,test))

# STEP 2a. Add activity names to the Activity column of the dataset

activity <- read.table("activity_labels.txt")
merged$Activity <- factor(merged$Activity, levels=activity[,1], labels=activity[,2])

# STEP 2b. Add feature names to the dataset variables

features <- read.table("features.txt")
names(merged) <- c("Subject","Activity",as.character(features[,2]))

# STEP 3. Extracts only measurements for mean and standard deviation

merged_meansd <- merged[,grepl("Subject|Activity|mean|std",names(merged))]

# STEP 4. Create tidy dataset with the average of each variable for each activity and each subject.

library(dplyr)
human_activity <- merged_meansd %>%
  group_by(Subject, Activity) %>%
  summarise_each(funs(mean))

write.table(human_activity, "tidy.txt", row.names = FALSE, quote = FALSE)
