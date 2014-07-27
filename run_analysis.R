

setwd("UCI HAR Dataset/")

features<-read.table("features.txt")["V2"]
activitylabels<-read.table("activity_labels.txt")["V2"]


means_and_stds<-grep("mean|std",features$V2) # find columns of mean/std data 

setwd("train")
Xtrain<-read.table("X_train.txt")
names(Xtrain)<-features$V2

Ytrain<-read.table("y_train.txt")
names(Ytrain)<-names(Ytrain)<-"labels"

subjecttrain<-read.table("subject_train.txt")
names(subjecttrain)<-"subjects"

setwd("../test/")
Xtest<-read.table("X_test.txt")
names(Xtest)<-features$V2

Ytest<-read.table("y_test.txt")
names(Ytest)<-"labels"

subjecttest<-read.table("subject_test.txt")
names(subjecttest)<-"subjects"

setwd("../../")


meansstdcolnames<-colnames(Xtest)[means_and_stds]

##Extracts only the measurements on the mean and standard deviation for each measurement.
Xtestsubset<-cbind(subjecttest,Ytest,subset(Xtest,select=meansstdcolnames))
Xtrainsubset<-cbind(subjecttrain,Ytrain,subset(Xtrain,select=meansstdcolnames))

## Merges the training and the test sets to create one data set
XY<-rbind(Xtestsubset, Xtrainsubset)


## Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidy<-aggregate(XY[,3:ncol(XY)],list(Subject=XY$subjects, Activity=XY$labels), mean)
tidy<-tidy[order(tidy$Subject),]

##Uses descriptive activity names to name the activities in the data set
tidy$Activity<-activitylabels[tidy$Activity,]

##Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(tidy, file="./tidydata.txt", sep="\t", row.names=FALSE)
