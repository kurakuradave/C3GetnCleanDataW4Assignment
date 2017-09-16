# C3GetnCleanDataW4Assignment
 John Hopkins Uni Data Science Specialization Course 3 - Getting and Cleaning Data - Assignment Week 4

This repository holds the data, script and codebook files for the above-mentioned assignment.
The focus of this assignment is getting and cleaning data for the  Human Activity Recognition Using Smartphones Data Set 

Data sources [zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), [info page](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

##Contents:
------------
* README.md - this markdown document
* run_analysis.R - the script that reads in the raw data, processes it, and produces the dataset that the assignment asked for (submitted_dataset.csv)
* submitted_dataset.csv - the tidy dataset submitted for this assignment, produced by run_analysis.R script above
* codebook.txt - the codebook which contains explanatory information about the variables in submitted_dataset.csv
* UCI HAR Dataset - the folder which contains the original raw data and codebook



## How the script works
-----------------------

###  Task 1 Merge the training and the test sets to create one data set.  
                                                                          
  Steps:                                                               
  1. Prepare all the required pieces by reading the text files into R  
     and attaching column name(s) to the variables:                    
      FILENAME            R_OBJECT         COLUMNNAMES                 
      subject_train.txt   subject_train    "subject"                   
      subject_test.txt    subject_test     "subject"                   
      y_train.txt         y_train          "activity_code"             
      y_test.txt          y_test           "activity_code"             
      X_train.txt         X_train          use contents of features.txt
      X_test.txt          X_test           use contents of features.txt
                                                                       
  2. Combine subject_train, y_train and X_train using cbind() to form  
     train_dataset                                                     
  3. Combine subject_test, y_test and X_test using cbind() to form     
     test_dataset                                                      
  4. Combine train_dataset and test_dataset using rbind() to form      
     combined_dataset                                                  
                                                                       
  Please note that meaningful variable names are attached to the       
  datasets since the start, I believe it's a good habit to always      
  name the columns no matter how small the datasets are (Not leaving   
  them as default unmeaningful names of V1, V2, V3, ... ).             
  This also automatically completes task four for the script, whhich   
  is: Appropriately labels the data set with descriptive variable      
  names.                                                               


###  Task 2 Extract only the measurements on the mean and standard deviation for each measurement.                                      
                                                                       
  Each column in combined_dataset is a measurement, but we need to     
  extract only those which are means and standard deviations, this     
  can be done using regex, matching for "mean" or "std" followed by () 
                                                                       
  Steps:                                                               
  1. obtain the column names that contain "mean" or "std" with grep()  
  2. don't forget to also add the "subject" and "activity_code" columns
  3. extract the target columns using select()                         


###  Task 3 Use descriptive activity names to name the activities in the data set                                                             
                                                                       
  Steps:                                                               
  1. read in contents of activities.txt                                
  2. populate the dataset with activity labels using merge()           
  3. rearrange the columns since after merge, activity labels are      
     placed in the last column. Also remove the activity_code column   


###  Task 4 Appropriately labels the data set with descriptive variable names.                                                               
                                                                       
  A big part of this is already done when merging the data for Task 1  
  above - naming the variables with contents from features.txt         
  and ensuring that there are no duplicate variable names              
  here we are just removing the index number at the end of the names   
  ( e.g. xxxx_123 ) and renaming by adding "Mean_" at the front, for improved readability               


### Task 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.                                                              
                                                                       
  Steps:                                                               
  1. use dplyr group_by() and summarize_all()                          
  2. save output file "submitted_dataset.txt"                          
