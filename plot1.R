# Exploratory Data Analysis Coursera Course: Project 1
# File: plo11.R
# Mar 12 2016

# Load used libraries for script.  Common ones at top, with ones used in
# this particular script un-commented
library(lubridate) # for working with dates
library(dplyr) # for data manipulation, e.g. filter, mutate, select, distinct, arrange
# library(tidyr) # for data tidying, e.g. tbl_df, gather, separate, spread
library(ggplot2) # for specifying plot parameters, e.g. output dpi, size

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
plot1alldata <- read.table(file="household_power_consumption.txt", 
                           header = TRUE, 
                           sep=";", 
                           nrows=70000, 
                           na.strings=c("NA","?"))

# Revision 1: Make sure first column has date class, then subset for Feb 1&2, 2007
# and combine
Feb1 <- filter(plot1alldata,Date=="1/2/2007") #Searching as text char for Feb1
Feb2 <- filter(plot1alldata,Date=="2/2/2007") #Searching as text char for Feb2
plot1data <-rbind(Feb1,Feb2)

# Modify Date to be date class, Time to be H:M:S, rest numeric (bit brute force)
plot1data$Date <- dmy(plot1data$Date)
plot1data$Time <- hms(plot1data$Time)
plot1data$Global_active_power <-as.numeric(plot1data$Global_active_power)
plot1data$Global_reactive_power <-as.numeric(plot1data$Global_reactive_power)
plot1data$Voltage <-as.numeric(plot1data$Voltage )
plot1data$Global_intensity <-as.numeric(plot1data$Global_intensity )
plot1data$Sub_metering_1 <-as.numeric(plot1data$Sub_metering_1 )
plot1data$Sub_metering_2 <-as.numeric(plot1data$Sub_metering_2 )
plot1data$Sub_metering_3 <-as.numeric(plot1data$Sub_metering_3 )

# Cleaning up old data files
rm(Feb1); rm(Feb2); rm(plot1alldata)

# For the plot1.png type of plot, we want a boxplot type with 
# a "Frequency" y-axis label and a "Global Active Power (kilowatts)"
# x-axis value (Watt is normally capitalized as a unit of Power)
# main title is "Global Active Power"

# Opens the console device to save the plot to a file
png("plot1.png", width=480, height=480, units="px",
    res=72, pointsize=12, bg = "transparent")

# Create histogram, Main title set, red color, 12 boxes of data
par(mfrow=c(1,1))
hist(plot1data$Global_active_power, col="red", breaks=12,
     main = "Global Active Power",
     xlab = "Global Active Power (kiloWatts)",
     ylab = "Frequency")
# Saves the created plot with information to directory

dev.off() #closes the console device (png)

