#reading the test data set

testDataSet <- read.table("./test/X_test.txt")
testLabels <- read.table("./test/y_test.txt")
testSubjects <- read.table("./test/subject_test.txt")

#reading the train data set

trainDataSet <- read.table("./train/X_train.txt")
trainLabels <- read.table("./train/y_train.txt")
trainSubjects <- read.table("./train/subject_train.txt")

#gathering all the data into one set
#set row binding
dataSet <- rbind(testDataSet, trainDataSet)
#labels row binding
dataLabels <- rbind(testLabels, trainLabels)
#subjects row binding
dataSubjects <- rbind(testSubjects, trainSubjects)
#column binding
data <- cbind(dataSet, dataLabels, dataSubjects)

#extract only the measurements on the mean and st.deviation for each measurement
#required columns
columnVector <- c(1, 2, 3, 4, 5, 6, 41, 42, 43, 44, 45, 46, 81, 82, 83, 84, 85, 86, 
                  121, 122, 123, 124, 125, 126, 161, 162, 163, 164, 165, 166, 201, 202, 
                  214, 215, 227, 228, 240, 241, 253, 254, 266, 267, 268, 269, 270, 271, 
                  345, 346, 347, 348, 349, 350, 424, 425, 426, 427, 428, 429, 503, 504, 
                  516, 517, 529, 530, 542, 543, 555, 556, 557, 558, 559, 560, 561, 562, 563)
#data with required measurements
tidyData <- data[, columnVector]

#naming measurements
columnNames <- c("tBodyAcc-mean-X", "tBodyAcc-mean-Y", "tBodyAcc-mean-Z", "tBodyAcc-std-X", 
                 "tBodyAcc-std-Y", "tBodyAcc-std-Z", "tGravityAcc-mean-X", "tGravityAcc-mean-Y", 
                 "tGravityAcc-mean-Z", "tGravityAcc-std-X", "tGravityAcc-std-Y", "tGravityAcc-std-Z", 
                 "tBodyAccJerk-mean-X", "tBodyAccJerk-mean-Y", "tBodyAccJerk-mean-Z", 
                 "tBodyAccJerk-std-X", "tBodyAccJerk-std-Y", "tBodyAccJerk-std-Z", "tBodyGyro-mean-X", 
                 "tBodyGyro-mean-Y", "tBodyGyro-mean-Z", "tBodyGyro-std-X", "tBodyGyro-std-Y", 
                 "tBodyGyro-std-Z", "tBodyGyroJerk-mean-X", "tBodyGyroJerk-mean-Y", "tBodyGyroJerk-mean-Z", 
                 "tBodyGyroJerk-std-X", "tBodyGyroJerk-std-Y", "tBodyGyroJerk-std-Z", "tBodyAccMag-mean",
                 "tBodyAccMag-std", "tGravityAccMag-mean", "tGravityAccMag-std", "tBodyAccJerkMag-mean", 
                 "tBodyAccJerkMag-std", "tBodyGyroMag-mean", "tBodyGyroMag-std", "tBodyGyroJerkMag-mean", 
                 "tBodyGyroJerkMag-std", "fBodyAcc-mean-X", "fBodyAcc-mean-Y", "fBodyAcc-mean-Z", 
                 "fBodyAcc-std-X", "fBodyAcc-std-Y", "fBodyAcc-std-Z", "fBodyAccJerk-mean-X", 
                 "fBodyAccJerk-mean-Y", "fBodyAccJerk-mean-Z", "fBodyAccJerk-std-X", 
                 "fBodyAccJerk-std-Y", "fBodyAccJerk-std-Z", "fBodyGyro-mean-X", "fBodyGyro-mean-Y", 
                 "fBodyGyro-mean-Z", "fBodyGyro-std-X", "fBodyGyro-std-Y", "fBodyGyro-std-Z", 
                 "fBodyAccMag-mean", "fBodyAccMag-std", "fBodyAccJerkMag-mean", "fBodyAccJerkMag-std", 
                 "fBodyGyroMag-mean", "fBodyGyroMag-std", "fBodyGyroJerkMag-mean", "fBodyGyroJerkMag-std", 
                 "angle(tBodyAccMean, gravity)", "angle(tBodyAccJerkMean, gravityMean)", 
                 "angle(tBodyGyroMean, gravityMean)", "angle(tBodyGyroJerkMean, gravityMean)",
                 "angle(X, gravityMean)", "angle(Y, gravityMean)", "angle(Z, gravityMean)", 
                 "ActivityLabel", "Subject ID")
#naming data frame
colnames(tidyData) <- columnNames

#transforming activity names
tidyData[,74] <- ifelse(tidyData[,74] == 1, "walking", tidyData[,74])
tidyData[,74] <- ifelse(tidyData[,74] == "2", "walking_upstairs", tidyData[,74])
tidyData[,74] <- ifelse(tidyData[,74] == "3", "walking_downstairs", tidyData[,74])
tidyData[,74] <- ifelse(tidyData[,74] == "4", "sitting", tidyData[,74])
tidyData[,74] <- ifelse(tidyData[,74] == "5", "standing", tidyData[,74])
tidyData[,74] <- ifelse(tidyData[,74] == "6", "laying", tidyData[,74])



tidyData <- data.frame(tidyData)

#second, independent tidy data set with the average of each variable 
#for each activity and each subject

library(reshape2)
tidyDataMelt <- melt(tidyData, id = c("ActivityLabel", "Subject.ID"), measure.vars = 1:73)
#Average of each variable by activity
dataActivityMean <- dcast(tidyDataMelt, ActivityLabel ~ variable, mean)
#Average of each variable by Subject
dataSubjectMean <- dcast(tidyDataMelt, Subject.ID ~ variable, mean)


#saving the data

write.csv(tidyData, file = "SmartphoneMeasurements.csv", row.names = F)

write.csv(dataActivityMean, file = "AverageForActivity.csv", row.names = F)

write.csv(dataSubjectMean, file = "AverageForSubject.csv", row.names = F)

write.table(tidyData, file = "SmartphoneMeasurements.txt")
