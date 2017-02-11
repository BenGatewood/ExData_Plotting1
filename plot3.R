library(readr)
library(lubridate)
library(dplyr)

## Data Prep Stage ##

# Read in the data file
rawData <- read.csv("household_power_consumption.txt",
                    sep = ";",
                    na.strings = "?")

# Add a combined datetime column
rawData <- mutate(rawData, DateTime = paste(Date, Time, sep = " "))

# Convert the DateTime values to actual datetimes
rawData$DateTime <- dmy_hms(rawData$DateTime)
rawData$Date <- dmy(rawData$Date)

# Cut down to just the two days we're interested in
DAY1 <- as.Date("2007-02-01")
DAY2 <- as.Date("2007-02-02")

twoDays <- filter(rawData, Date == DAY1 | Date == DAY2)

## Plotting Stage ##

# Open our file device
png(filename =  "plot3.png")

# Build our empty plot first
with(twoDays, plot(DateTime,
                   Sub_metering_1,
                   col = "black",
                   type = "l",
                   ylab = "Energy sub metering",
                   xlab = ""))

# Add our other lines
with(twoDays, lines(DateTime, Sub_metering_2, type = "l", col = "red"))
with(twoDays, lines(DateTime, Sub_metering_3, type = "l", col = "blue"))

# Add our legend
legend("topright",
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1, 1, 1),
       col = c("black", "blue", "red"))

# Close the file
dev.off()

