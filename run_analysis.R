#Initial code setup

if(!file.exists("./data")){dir.create("./data")}
#downloading the folder for this assignment
ProjectFolder <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(ProjectFolder,destfile="./data/ProjectData.zip")

#Unzipping the folder into a directory called /data 
unzip(zipfile="./data/ProjectData.zip",exdir="./data")


#1 Merging the training and the test sets to create one data set.


# Reading the files into R

X_training<- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_training <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

subject_training <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")


x_testing <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_testing <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

subject_testing <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Naming the columns

colnames(X_training) <- features[,2]
colnames(y_training) <-"activityId"
colnames(subject_training) <- "subjectId"

colnames(x_testing) <- features[,2] 
colnames(y_testing) <- "activityId"
colnames(subject_testing) <- "subjectId"

colnames(activity_labels) <- c('activityId','activityType')

#Merging all datasets into one

all_training <- cbind(y_training, subject_training, X_training)
all_testing <- cbind(y_testing, subject_testing, x_testing)
All_data <- rbind(all_training, all_testing)



#2 Extracting only the measurements on the mean and standard deviation for each measurement.

#Reading column names

colNames <- colnames(All_data)

#Create vector for defining ID, mean and standard deviation:

mean_sd <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#Subsetting from All_data:

All_mean_sd <- All_data[ , mean_sd == TRUE]


#3 Uses descriptive activity names to name the activities in the data set


activity_names <- merge(All_mean_sd, activity_labels,
                              by='activityId',
                              all.x=TRUE)


#4 Appropriately labels the data set with descriptive variable names.


#Done in previous steps, see 1.3,2.2 and 2.3!
mean_sd <- (grepl("activityId" , colNames) | 
              grepl("subjectId" , colNames) | 
              grepl("mean.." , colNames) | 
              grepl("std.." , colNames) 
)

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Making a second tidy data set

second_tidy_dataset <- aggregate(. ~subjectId + activityId, activity_names, mean)
second_tidy_dataset <- second_tidy_dataset[order(second_tidy_dataset$subjectId, second_tidy_dataset$activityId),]

#Creating a txt file of the second tidy dataset

write.table(second_tidy_dataset, "SecondTidyDataset.txt", row.name=FALSE)

