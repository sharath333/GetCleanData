# Description of the script

## Initalization
The script first changes working directory to where the zip file exists and then unzips the data

## Read Data
Then it reads all the files given in the raw data. For conserving memory, I have not read files from Inertial folder as we wont need to do analysis on that data.

## Create Tidy Data
Then we used the features list in features.txt as column names. We add the subject and activity from the relevant data sets. Finally we bind both the train and test datasets to get a final data set with corrected column names, subject column & activity column. I tested first to confirm that the subjects in test and train data were different and hence I directly used rbind to bind the data. Next I removed all the columns not containing "mean" or "std". Finally I changed the activity column from Integer to a Factor with six levels of activity. Finally, I changed the column names to a tidy version with the format [t/f]Measurement.Sensor.Function.Axis  
I have used the wide format of tidy data as discussed in the link:
https://class.coursera.org/getdata-007/forum/thread?thread_id=49

## Create a new data set 
Next I created a new data set df_agg with average of measurements for each activity per subject and save the data into tidy_data.txt