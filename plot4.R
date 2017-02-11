library(readr)
library(lubridate)
library(dplyr)

## Data Prep Stage ##

# Read in the data file
rawData <- read.csv("household_power_consumption.txt",
                    sep = ";",
                    na.strings = "?")

# Add a combined datetime column
rawData <- mutate(rawData, datetime = paste(Date, Time, sep = " "))

# Convert the DateTime values to actual datetimes
rawData$datetime <- dmy_hms(rawData$datetime)
rawData$Date <- dmy(rawData$Date)

# Cut down to just the two days we're interested in
DAY1 <- as.Date("2007-02-01")
DAY2 <- as.Date("2007-02-02")

twoDays <- filter(rawData, Date == DAY1 | Date == DAY2)

## Plotting Stage ##

# Open our file device
png(filename =  "plot4.png")

# Set our 2x2 plot layout
par(mfrow = c(2,2))

### PLOT 1 ###
# Build our empty plot first
with(twoDays, plot(datetime, Global_active_power, 
                   type = "l",
                   ylab = "Global Active Power",
                   xlab = ""))

### PLOT 2 ###
with(twoDays, plot(datetime, Voltage, type = "l"))

### PLOT 3 ###
with(twoDays, plot(datetime,
                   Sub_metering_1,
                   col = "black",
                   type = "l",
                   ylab = "Energy sub metering",
                   xlab = ""))

# Add our other lines
with(twoDays, lines(datetime, Sub_metering_2, type = "l", col = "red"))
with(twoDays, lines(datetime, Sub_metering_3, type = "l", col = "blue"))

# Add our legend
legend("topright",
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1, 1, 1),
       col = c("black", "blue", "red"))
### PLOT 4 ###
with(twoDays, plot(datetime, Global_reactive_power, type = "l"))

# Close the file
dev.off()
