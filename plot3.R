# setup
setwd("C:\\Users\\mduplessis.TOOLBOX\\Desktop\\Data Science\\ExporatoryDataAnalisys")
zipfileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# target location

zipfileLocation <- file.path(getwd(),"household_power_consumption.zip")
txtfileLocation <- file.path(getwd(),"household_power_consumption.txt")

# prepare the sourcefile
curl::curl_download(fileUrl, fileLocation)
unzip(fileLocation)


# read into table and apply the colclasses we can. I'm not applying classes to the DATE/Time because I can't figure out how. I'll coerce them below.
t <- read.table(txtfileLocation, header = TRUE, sep=";", na.strings="?", colClasses = c("character", "character", "numeric", "numeric","numeric","numeric","numeric","numeric","numeric"))

# coerce data.
t$Date <- as.Date(t$Date,"%d/%m/%Y")

# filetering to the 2 days applicable because coercing Time takes very long on the full dataset.
filtered<-t[t$Date %in% as.Date(c("2007-02-01","2007-02-02")),]

# remove "t" from memory because we will no longer need it.
rm("t")

# ceorece "Time"
filtered$Time <- strptime(
                  paste(filtered$Date, filtered$Time, sep=" ")
                  , "%Y-%m-%d %H:%M:%S")


# export the chart to png.
png("plot3.png", width = 480, height = 480)
  plot(as.POSIXct(filtered$Time),filtered$Sub_metering_1, xlab="", type="l", ylab="Energy sub metering")
  lines(as.POSIXct(filtered$Time),filtered$Sub_metering_3,col="blue") 
  lines(as.POSIXct(filtered$Time),filtered$Sub_metering_2,col="red")
  
  # legend 
  legendItems <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
  legend("topright", cex=1, col=c("black", "red", "blue"), 
       lwd=1,y.intersp=1,xjust=1,text.width = max(strwidth(legendItems)),
       legend=legendItems)
dev.off()

