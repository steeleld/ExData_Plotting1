# STUCK WITH datetime -- can't get to work and plot


# Exploratory Data Analysis Coursera Course: Project 1
# File: plo12.R
# Mar 13 2016

# Load used libraries for script.  Common ones at top, with ones used in
# this particular script un-commented
library(lubridate) # for working with dates
library(dplyr) # for data manipulation, e.g. filter, mutate, select, distinct, arrange
# library(tidyr) # for data tidying, e.g. tbl_df, gather, separate, spread
#library(ggplot2) # for specifying plot parameters, e.g. output dpi, size

# Setting my working data for my use (# in final script save for upload
#setwd("C:/Users/LDS/Documents/dataScience/ExploratoryDataAnalysis")

#Download and unzip file to current working directory
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile="plot1data.zip", mode="wb")
unzip("plot1data.zip", exdir=".")

# Assumptions: 
# 1) User has downloaded and unzipped the file above: household_power_consumption.txt
# 2) plotting R file is in the working directory

# Read in data, want initially smaller data file only counts in first 70000 to 
# reduce time needs, and that's go to Feb 3/2007. Kept columns default type 
# initially as characters to help with sorting. 
plot2alldata <- read.table(file="household_power_consumption.txt", 
                           header = TRUE, 
                           sep=";", 
                           nrows=70000, 
                           na.strings=c("NA","?"))

# Revision 1: Make sure first column has date class, then subset for Feb 1&2, 2007
# and combine
Feb1 <- filter(plot2alldata,Date=="1/2/2007") #Searching as text char for Feb1
Feb2 <- filter(plot2alldata,Date=="2/2/2007") #Searching as text char for Feb2
plot2data <-rbind(Feb1,Feb2)

# Paste the day and the time information by using dplyr library to 
# mutate the Date to get the day of the week.  
plot2data <- mutate(plot2data, DateTime=paste(plot2data$Date, plot2data$Time),
                    datetime = as.Date(datetime, 
                              format="%d/%m/%Y %H:%M:%S"),
                              format="%Y-%m-%d %H:%M:%S")

# Modify columns to be numeric (bit brute force)
plot2data$Global_active_power <-as.numeric(plot2data$Global_active_power)

# Cleaning up old data files
rm(Feb1); rm(Feb2); rm(plot1data)

# For the plot2.png type of plot, we want a line type with 
# a "Global Active Power" y-axis label and a x-axis variable that 
# has both the date and the time merged together and displays
# in terms of the day of the week on the x-axis. 
# Main title is blank. 

# Create line graph
par(mfrow=c(1,1))
par(mar=c(4,4,2,1))
plot(plot2data$datetime, plot2data$Global_active_power, 
     ylab = "Global Active Power (kiloWatts)", xlab="")
# Saves the created plot with information to directory
# Copies the created file to the console device to save the plot to a file
dev.copy(png, file="plot2.png", width=480, height=480, units="px",
    res=72, pointsize=12, bg = "transparent")
dev.off() #closes the console device (png)

     
