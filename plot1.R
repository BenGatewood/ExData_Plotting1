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
png(filename =  "plot1.png")

# Build our plot
hist(twoDays$Global_active_power,
     col = "red",
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power")

# Close the file
dev.off()

