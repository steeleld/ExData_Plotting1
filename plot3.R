# Exploratory Data Analysis Coursera Course: Project 1
# File: plot3.R
# Mar 13 2016

# Load used libraries for script.  Common ones at top, with ones used in
# this particular script un-commented
#library(lubridate) # for working with dates
library(dplyr) # for data manipulation, e.g. filter, mutate, select, distinct, arrange
# library(tidyr) # for data tidying, e.g. tbl_df, gather, separate, spread
#library(ggplot2) # for specifying plot parameters, e.g. output dpi, size

# Setting my working data for my use (# in final script save for upload
#setwd("C:/Users/LDS/Documents/rprograms/ExploratoryDataAnalysis")

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
plotalldata <- read.table(file="household_power_consumption.txt", 
                           header = TRUE, 
                           sep=";", 
                           nrows=70000, 
                           na.strings=c("NA","?"))

# Revision 1: Make sure first column has date class, then subset for Feb 1&2, 2007
# and combine
Feb1 <- filter(plotalldata,Date=="1/2/2007") #Searching as text char for Feb1
Feb2 <- filter(plotalldata,Date=="2/2/2007") #Searching as text char for Feb2
plotdata <-rbind(Feb1,Feb2)

# Paste the day and the time information by using strptime to 
# get to a Date readable format by the graphing plot function  
DateMod<-strptime(plotdata$Date, format="%d/%m/%Y", tz="UTC")
TimeMod<-plotdata$Time
DateTimeMod<-paste(DateMod, TimeMod)
datetime<-strptime(DateTimeMod, format="%Y-%m-%d %H:%M:%S", tz="UTC")

# Binding to rest of data 
plotdata<-cbind(plotdata,datetime)

# Modify columns to be numeric 
plotdata$Sub_metering_1 <-as.numeric(plotdata$Sub_metering_1 )
plotdata$Sub_metering_2 <-as.numeric(plotdata$Sub_metering_2 )
plotdata$Sub_metering_3 <-as.numeric(plotdata$Sub_metering_3 )

# Cleaning up old data files
rm(Feb1); rm(Feb2); rm(plotalldata)
rm(DateMod); rm(TimeMod); rm(DateTimeMod)

# For the plot2.png type of plot, we want a line type with 
# a "Global Active Power" y-axis label and a x-axis variable that 
# has both the date and the time merged together such that on a 
# line graph it'll display the day of the week. 

par(mfrow=c(1,1))
par(mar=c(4,4,2,1))
# create blank plot with axes sized based on data
plot(plotdata$datetime, plotdata$Sub_metering_1, type="n", 
     ylab="Energy sub metering", xlab="", cex.lab=0.8)
# add data as a line graph
lines(plotdata$datetime, plotdata$Sub_metering_1, col="black")
lines(plotdata$datetime, plotdata$Sub_metering_2, col="red")
lines(plotdata$datetime, plotdata$Sub_metering_3, col="blue")
# add legend information to topright of graph
legend("topright", lty=1, cex=0.8,
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black", "red", "blue") )

# Saves the created plot with information to directory
# Copies the created file to the console device to save the plot to a file
dev.copy(png, file="plot3.png", width=480, height=480, units="px",
    res=72, pointsize=10, bg = "transparent")
dev.off() #closes the console device (pngther and displays
