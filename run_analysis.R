library(dplyr)
library(data.table)

features <- read.table("features.txt", header=FALSE)
activities <- read.table("activity_labels.txt", header = FALSE)

subjectTest <- read.table("test/subject_test.txt", header = FALSE)
xTest <- read.table('test/X_test.txt', header=FALSE)
yTest <- read.table('test/y_test.txt', header=FALSE)

subjectTrain <- read.table("train/subject_train.txt", header = FALSE)
xTrain <- read.table('train/X_train.txt', header=FALSE)
yTrain <- read.table('train/y_train.txt', header=FALSE)

subject <- rbind(subjectTrain, subjectTest)
x <- rbind(xTrain, xTest)
y <- rbind(yTrain, yTest)

colnames(x) <- t(features[2])
colnames(y) <- "Activity"
colnames(subject) <- "Subject"

data <- cbind(x,y,subject)

colsMeanSTD <- grep(".*Mean.*|.*Std.*", names(data), ignore.case=TRUE)
reqCols <- c(colsMeanSTD, 562, 563)
dim(data)

extData <- data[,reqCols]
dim(extData)

extData$Activity <- as.character(extData$Activity)
for (i in 1:6){
    extData$Activity[extData$Activity == i] <- as.character(activities[i,2])
}
extData$Activity <- as.factor(extData$Activity)
extData$Subject <- as.factor(extData$Subject)
extData <- data.table(extData)
tidyData <- aggregate(. ~Subject + Activity, extData, mean)
tidyData <- tidyData[order(tidyData$Subject, tidyData$Activity),]
write.table(tidyData, file = "tidy.txt", row.names = FALSE)