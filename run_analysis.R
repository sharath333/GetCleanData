## Set the working directory. To be removed from the final code
## setwd("~/Sharath/clean1")
## unzip("getdata_projectfiles_UCI HAR Dataset.zip",overwrite=TRUE)


## Read all the Required Datasets into data frames. Not reading Inertial folder.
df_x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
df_x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")

## First we will give column names to train and test data and later give better names
names(df_x_train)<-features$V2
names(df_x_test)<-features$V2

## Now we will add activity and subjects also to the data frames to get a stitched complete dataset
df_x_train$Activity<-y_train[,1]
df_x_test$Activity<-y_test[,1]
df_x_train$Subject<-subject_train[,1]
df_x_test$Subject<-subject_test[,1]

## Merge the train and test data to create one data set. 
## Looking at the data we find that train and test data sets use different subjects.
## sum(unique(subject_test$V1) %in% unique(subject_train$V1)) returns zero so we will use rbind
## Remove the not required objects to free memory.
df_final<-rbind(df_x_test,df_x_train)
rm(df_x_test,df_x_train,features,subject_test,subject_train,y_test,y_train)

## Now discard columns not containing mean and std while arranging columns in original way
df_final<-df_final[,sort(c(grep("mean", names(df_final)),grep("std", names(df_final)),562,563))]

## Now we will change the activity column from integer into factor with levels from activity_labels
df_final$activity<-factor(df_final$activity)
levels(df_final$activity)<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

## We will correct the column names and keep the following format - [t/f]Measurement.Sensor.Function.Axis
## This will make it easy for anyone to convert this tidy data into narrow form.
## I have also decided to keep the data in wide format as I want to keep the NA's to minimum
## We can convert this data into Narrow forms based on Measurement, Sensor, Axis or Function
## However I would like to keep data in wide format and then change it as per the required analysis
names(df_final)[1:(length(df_final)-2)]<-c("tBody.Acc.Mean.X","tBody.Acc.Mean.Y","tBody.Acc.Mean.Z","tBody.Acc.Std.X","tBody.Acc.Std.Y","tBody.Acc.Std.Z","tGravity.Acc.Mean.X","tGravity.Acc.Mean.Y","tGravity.Acc.Mean.Z","tGravity.Acc.Std.X","tGravity.Acc.Std.Y","tGravity.Acc.Std.Z","tBodyJerk.Acc.Mean.X","tBodyJerk.Acc.Mean.Y","tBodyJerk.Acc.Mean.Z","tBodyJerk.Acc.Std.X","tBodyJerk.Acc.Std.Y","tBodyJerk.Acc.Std.Z","tBody.Gyro.Mean.X","tBody.Gyro.Mean.Y","tBody.Gyro.Mean.Z","tBody.Gyro.Std.X","tBody.Gyro.Std.Y","tBody.Gyro.Std.Z","tBodyJerk.Gyro.Mean.X","tBodyJerk.Gyro.Mean.Y","tBodyJerk.Gyro.Mean.Z","tBodyJerk.Gyro.Std.X","tBodyJerk.Gyro.Std.Y","tBodyJerk.Gyro.Std.Z","tBody.Acc.Mean.Mag","tBody.Acc.Std.Mag","tGravity.Acc.Mean.Mag","tGravity.Acc.Std.Mag","tBodyJerk.Acc.Mean.Mag","tBodyJerk.Acc.Std.Mag","tBody.Gyro.Mean.Mag","tBody.Gyro.Std.Mag","tBodyJerk.Gyro.Mean.Mag","tBodyJerk.Gyro.Std.Mag","fBody.Acc.Mean.X","fBody.Acc.Mean.Y","fBody.Acc.Mean.Z","fBody.Acc.Std.X","fBody.Acc.Std.Y","fBody.Acc.Std.Z","fBody.Acc.MeanFreq.X","fBody.Acc.MeanFreq.Y","fBody.Acc.MeanFreq.Z","fBodyJerk.Acc.Mean.X","fBodyJerk.Acc.Mean.Y","fBodyJerk.Acc.Mean.Z","fBodyJerk.Acc.Std.X","fBodyJerk.Acc.Std.Y","fBodyJerk.Acc.Std.Z","fBodyJerk.Acc.MeanFreq.X","fBodyJerk.Acc.MeanFreq.Y","fBodyJerk.Acc.MeanFreq.Z","fBody.Gyro.Mean.X","fBody.Gyro.Mean.Y","fBody.Gyro.Mean.Z","fBody.Gyro.Std.X","fBody.Gyro.Std.Y","fBody.Gyro.Std.Z","fBody.Gyro.MeanFreq.X","fBody.Gyro.MeanFreq.Y","fBody.Gyro.MeanFreq.Z","fBody.Acc.Mean.Mag","fBody.Acc.Std.Mag","fBody.Acc.MeanFreq.Mag","fBodyJerk.Acc.Mean.Mag","fBodyJerk.Acc.Std.Mag","fBodyJerk.Acc.MeanFreq.Mag","fBody.Gyro.Mean.Mag","fBody.Gyro.Std.Mag","fBody.Gyro.MeanFreq.Mag","fBodyJerk.Gyro.Mean.Mag","fBodyJerk.Gyro.Std.Mag","fBodyJerk.Gyro.MeanFreq.Mag")

## Next we will aggregate a new data frame with the correct data
df_agg<-with(df_final,aggregate(df_final[,1:79],by=list(activity,subject),mean,na.rm=T))
names(df_agg)[1:2]<-c("Activity","Subject")

## Finally we save the data into tidy_data.txt
write.table(df_agg,file="tidy_data.txt", row.names=FALSE)
