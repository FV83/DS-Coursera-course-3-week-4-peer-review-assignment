# load test datasets into R
test.set <- read.table(file = "test/X_test.txt")
test.set.activities <- read.table(file = "test/y_test.txt")
names(test.set.activities) <- "activities"
test.set.subject <- read.table(file = "test/subject_test.txt")
names(test.set.subject) <- "subject"

# load training datasets into R
train.set <- read.table(file = "train/X_train.txt")
train.set.activities <- read.table(file = "train/y_train.txt")
names(train.set.activities) <- "activities"
train.set.subject <- read.table(file = "train/subject_train.txt")
names(train.set.subject) <- "subject"

# load information on features and activity labels
features <- read.table(file = "features.txt")
activity.labels <- read.table(file = "activity_labels.txt")

# 1. Merges the training and the test sets to create one data set
merged.set <- rbind(
                cbind(test.set, test.set.activities, test.set.subject),
                cbind(train.set, train.set.activities, train.set.subject))


# 2. Filter only the measurements on the mean and std for each measurement
# keep also variables 'activities' and 'subject' in the table
std.mean.table <- merged.set[, c(
                                  paste0("V",grep("mean\\()|std\\()", features$V2)),
                                  "activities", "subject")]


# 3. Uses descriptive activity names to name the activities in the data set
names(activity.labels) <- c("activities","label_activities")
std.mean.table <- merge(std.mean.table, activity.labels, by="activities")

# 4. Appropriately labels the data set with descriptive variable names
names(std.mean.table) <- c("activities",
                       grep("mean\\()|std\\()", features$V2, value=T),
                       "subject","label_activities")
names(std.mean.table) <- sub("-mean\\()", ".average", names(std.mean.table))
names(std.mean.table) <- sub("-std\\()", ".standard deviation", names(std.mean.table))
names(std.mean.table) <- sub("-X", ".Xdirection", names(std.mean.table))
names(std.mean.table) <- sub("-Y", ".Ydirection", names(std.mean.table))
names(std.mean.table) <- sub("-Z", ".Zdirection", names(std.mean.table))
names(std.mean.table) <- sub("^t", "", names(std.mean.table))
names(std.mean.table) <- sub("^f", "", names(std.mean.table))

#5. average of each variable for each activity and each subject
library(dplyr)
names(std.mean.table) <- make.names(colnames(std.mean.table) , unique=TRUE)
output <- std.mean.table[,-1] %>% group_by(label_activities,subject) %>% summarise_all(.funs=mean)
write.table(output, file = "output.txt", row.name=FALSE)











  

