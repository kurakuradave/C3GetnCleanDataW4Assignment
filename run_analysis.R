library(dplyr)

##########################################3##################################
###  Task 1 Merge the training and the test sets to create one data set.  ###
#############################################################################
###                                                                       ###   
###  Steps:                                                               ###
###  1. Prepare all the required pieces by reading the text files into R  ###
###     and attaching column name(s) to the variables:                    ###
###      FILENAME            R_OBJECT         COLUMNNAMES                 ###
###      subject_train.txt   subject_train    "subject"                   ###
###      subject_test.txt    subject_test     "subject"                   ###
###      y_train.txt         y_train          "activity_code"             ###
###      y_test.txt          y_test           "activity_code"             ###
###      X_train.txt         X_train          use contents of features.txt###
###      X_test.txt          X_test           use contents of features.txt###
###                                                                       ###
###  2. Combine subject_train, y_train and X_train using cbind() to form  ###
###     train_dataset                                                     ###
###  3. Combine subject_test, y_test and X_test using cbind() to form     ###
###     test_dataset                                                      ###
###  4. Combine train_dataset and test_dataset using rbind() to form      ###
###     combined_dataset                                                  ###
###                                                                       ###
###  Please note that meaningful variable names are attached to the       ###
###  datasets since the start, I believe it's a good habit to always      ###
###  name the columns no matter how small the datasets are (Not leaving   ###
###  them as default unmeaningful names of V1, V2, V3, ... ).             ###
###  This also automatically completes task four for the script, whhich   ###
###  is: Appropriately labels the data set with descriptive variable      ###
###  names.                                                               ###
#############################################################################

### prepare subject_train and subject_test
subject_train <- tbl_df(
                     read.table( "./UCI HAR Dataset/train/subject_train.txt", sep="" )
                 )
names( subject_train ) <- "subject"

subject_test <- tbl_df(
                     read.table( "./UCI HAR Dataset/test/subject_test.txt", sep="" )
                )
names( subject_test) <- "subject"




### prepare y_train and y_test
y_train <- tbl_df(
               read.table( "./UCI HAR Dataset/train/y_train.txt" )
           )
names( y_train ) <- "activity_code"

y_test <- tbl_df(
              read.table( "./UCI HAR Dataset/test/y_test.txt" )
          )
names( y_test ) <- "activity_code"




### prepare X_train and X_test
### since we need to use contents of features.txt for the column names,
### let's first take care of this before reading the data text files.

### prepare column names for data from X_train.txt and X_test.txt
tempColnames <- read.table( "./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE )

### Note that tempColnames actually contain duplicates, if we use it as column names,
### for X_train and X_test, they won't be convertible to tbl, tbl requires
### that all column names are unique (no duplicate column names)

### find out duplicate column names
### sort it so the duplicate names will "stick" together as a series of rows 
tempColnames <- tbl_df(tempColnames) %>%
                arrange( V2 )

### loop through the sorted rows, checking for duplicate names
### i.e. name of current row is the same as name of previous row
### also, make a new unique name as we go through the rows
### manually process first row coz it can't be duplicate
tempColnames[1, "isDuplicate"] <- FALSE
tempColnames[1, "uniqueName"] <- paste( tempColnames[1, "V2"], tempColnames[1, "V1"] , sep="_" ) # combining the name with it's index number would quarantee uniqueness
### go through second row onwards in a for loop
for( i in 2:length(tempColnames$V2) ){
    if( tempColnames[i,"V2"] == tempColnames[ i-1, "V2" ] ){
        tempColnames[i, "isDuplicate"] <- TRUE
    } else {
        tempColnames[i, "isDuplicate"] <- FALSE
    }
    tempColnames[ i, "uniqueName" ] <- paste( tempColnames[i, "V2" ], tempColnames[ i,"V1"], sep="_" )
}

### duplicate column names stored in duplicates  ###
duplicates <- tempColnames$V2[which(tempColnames$isDuplicate)]

### now that we have the duplicates, sort it back to original order
tempColnames <- arrange( tempColnames, V1 )

### use the new column, uniqueName, as column names for X_train and X_test
X_colNames <- tempColnames$uniqueName

### process X_train and X_test
X_train <- tbl_df(
              read.table( "./UCI HAR Dataset/train/X_train.txt", sep="" )
           )
names( X_train ) <- X_colNames

X_test <- tbl_df(
              read.table( "./UCI HAR Dataset/test/X_test.txt", sep="" )
          )
names( X_test ) <- X_colNames




### merge train_dataset
train_dataset <- tbl_df( cbind( subject_train, y_train, X_train ) )
dim(train_dataset) #for checking
head( train_dataset[1:3, 1:5], 3 ) # for checking

### merge test_dataset
test_dataset <- tbl_df( cbind( subject_test, y_test, X_test ) )
dim( test_dataset ) #for checking
head( test_dataset[1:3, 1:5] ) #for checking




#############################################################################
###  Finally,  merge train and test to get combined_dataset
###  which completes task 1
combined_dataset <- tbl_df( rbind( train_dataset, test_dataset ) )
dim(combined_dataset ) # for checking
head( combined_dataset[1:3,1:5] ) # for checking
#############################################################################




#############################################################################
###  Task 2 Extract only the measurements on the mean and standard        ###
###  deviation for each measurement.                                      ###
#############################################################################
###                                                                       ###
###  Each column in combined_dataset is a measurement, but we need to     ###
###  extract only those which are means and standard deviations, this     ###
###  can be done using regex, matching for "mean" or "std" followed by () ###
###                                                                       ###
###  Steps:                                                               ###
###  1. obtain the column names that contain "mean" or "std" with grep()  ###
###  2. don't forget to also add the "subject" and "activity_code" columns###
###  3. extract the target columns using select()                         ###
###############################3##############################################

### obtain list of columns with names containing "mean" or "std" 
toExtract <- grep( "(mean|std)\\(\\)", names(combined_dataset), value=TRUE )    
toExtract <- c( "subject", "activity_code", toExtract ) # add the two columns subject and activity_code

###############################3##############################################
###  ans2_dataset completes task 2
ans2_dataset <- select( combined_dataset, toExtract )
###############################3##############################################




#############################################################################
###  Task 3 Use descriptive activity names to name the activities in the  ###
###  data set                                                             ###
#############################################################################
###                                                                       ###
###  Steps:                                                               ###
###  1. read in contents of activities.txt                                ###
###  2. populate the dataset with activity labels using merge()           ###
###  3. rearrange the columns since after merge, activity labels are      ###
###     placed in the last column. Also remove the activity_code column   ###
#############################################################################

### read in file which contains labels for the activities
activity_labels <- read.table( file="./UCI HAR Dataset/activity_labels.txt",
                               sep="",
                               stringsAsFactors=FALSE,
                               col.names=c( "activity_code", "activity" )
                             )

### merge activity_labels into ans2_dataset to insert the activity labels
ans3_dataset <- tbl_df( merge( ans2_dataset, activity_labels, by= "activity_code" ) )

##############################################################################
### rearrange columns,  ans3_dataset completes task 3
ans3_dataset <- ans3_dataset[ ,c(2,69,3:68) ]
###################################################################3#########




#############################################################################
###  Task 4 Appropriately labels the data set with descriptive variable   ###
###  names.                                                               ###
#############################################################################
###                                                                       ###
###  A big part of this is already done when merging the data for Task 1  ###
###  above - naming the variables with contents from features.txt         ###
###  and ensuring that there are no duplicate variable names              ###
###  here we are just removing the index number at the end of the names   ###
###  ( e.g. xxxx_123 ) and renaming for improved readability               ###
####################################3########################################
ans4_dataset <- ans3_dataset
names( ans4_dataset ) <-gsub( "\\_\\d*$", "", names( ans4_dataset ) ) # remove trailing numbers

names( ans4_dataset ) <-gsub( "\\-mean\\(\\)", "\\-Point", names( ans4_dataset ) )
names( ans4_dataset ) <-gsub( "\\-std\\(\\)", "\\-Dev", names( ans4_dataset ) ) 

### ans4_dataset completes task 4
#############################################################################




#############################################################################
### Task 5 From the data set in step 4, creates a second, independent tidy###
### data set with the average of each variable for each activity and each ###   
### subject.                                                              ###
#############################################################################
###                                                                       ###
###  Steps:                                                               ###
###  1. use dplyr group_by() and summarize_all()                          ###
###  2. save output file "submitted_dataset.csv"                          ###
#############################################################################

### tidying via group_by and summarize_all
ans5_dataset <- ans4_dataset %>%
    group_by( activity, subject ) %>%
    summarize_all( funs(mean) )

colnames( ans5_dataset )[3:68] <- paste0("Mean_", colnames( ans5_dataset )[3:68] ) # appropriately rename the summarized columns

### save output file
write.table( ans5_dataset,
           file="./submitted_dataset.csv",
           col.names=names( ans5_dataset ),
           row.names=FALSE,
           sep="," )

### example for reading the output file into R
submitted_dataset <- tbl_df(
                         read.table(
                             "./submitted_dataset.csv",
                             stringsAsFactors=FALSE,
                             sep=",",
                             header=TRUE
                         )
                     )

### ans5_dataset completes task 5, output file saved and example code for
### reading it is also provided. Thanks for reviewing, have a nice day! :)
#############################################################################

