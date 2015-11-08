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
png("plot4.png", width = 480, height = 480)
  par(mfrow = c(2, 2))
  with(filtered, {
    plot(Time, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
    plot(Time, Voltage, xlab = "datetime",ylab = "Voltage", type = "l")
        
    ylimits <- range(c(Sub_metering_1, Sub_metering_2, Sub_metering_3))
    plot(Time, Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "l", ylim = ylimits, col = "black")
    
    par(new = TRUE)
    plot(Time, Sub_metering_2, xlab = "", ylab = "", axes = FALSE,  type = "l", ylim = ylimits, col = "red")
    
    par(new = TRUE)
    plot(Time, Sub_metering_3, xlab = "", ylab = "", axes = FALSE,  type = "l", ylim = ylimits, col = "blue")
    
    legnedItems <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
    legend("topright",
           legend = legnedItems,
           bg = "transparent",
           bty = "n",
           lty = c(1,1,1),
           col = c("black", "red", "blue")
    )
    
    plot(Time, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")}
    )
          
dev.off()

