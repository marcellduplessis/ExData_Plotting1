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


png("plot1.png", width = 480, height = 480)
  hist(filtered$Global_active_power, col="red", main="Global Active Power", xlab="Global Acitve Power (kilowatts)", ylab="Frequency")
dev.off()
