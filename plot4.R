#download and unzip the zip file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile = "power.zip",method = "curl")
unzip("power.zip")

#read into R
power<-read.table("household_power_consumption.txt")

#tidy the data set
library(dplyr)
library(tidyr)
library(lubridate)
power<-separate(power,V1,into=c("date","time","global active power","global reactive power", 
                                "voltage","global intensity", "sub-metering-1",
                                "sub-metering-2","sub-metering-3"), sep = ";",remove = TRUE)
#removes duplicate row names
power<-power[-1,]

#change date to date format
power$date<-dmy(power$date)
#filter only for the dates used in this assignment (Feb 1 and 2, 2007)
power<-filter(power, date %in% as.Date(c("2007-02-01","2007-02-02")))

#convert global active power into a numeric vector
power$`global active power`<-as.numeric(power$`global active power`)

power$datetime<-paste(power$date,power$time)
power$datetime<-ymd_hms(power$datetime)

#Plot 4
png(filename="plot4.png",width=480,height=480)
par(mfrow = c(2,2))
plot(power$datetime,power$`global active power`,type="l", ylab = "Global Active Power",xlab = "")
plot(power$datetime,power$voltage,type="l", ylab = "Voltage",xlab = "datetime")
plot(power$datetime,power$`sub-metering-1`,col="black",type="l", ylab = "Energy sub metering",xlab = "")
points(power$datetime,power$`sub-metering-2`,col="red",type="l")
points(power$datetime,power$`sub-metering-3`,col="blue",type="l")
legend("topright",pch = "-", col = c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
plot(power$datetime,power$`global reactive power`,xlab = "datetime",ylab = "Global_reactive_power",type="l")
dev.off()