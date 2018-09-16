#set working directory
path <- getwd()

# Get the data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip <- "Dataset.zip"
if (!file.exists(path)) {
  dir.create(path)
}
download.file(url, file.path(path, zip))

# Load data 
f <- "household_power_consumption.txt"
data <- read.table(unz(file.path(path, zip), f), stringsAsFactors=FALSE, sep = ";", dec = ".", header = TRUE)
data <- transform(data, Date=as.Date(Date, format = "%d/%m/%Y"))

# Subset and convert data for plotting
newdt <- subset(data, subset = (Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")))
newdt <- transform(newdt, Global_active_power = as.numeric(Global_active_power))
newdt <- transform(newdt, Global_reactive_power = as.numeric(Global_reactive_power))
newdt <- transform(newdt, Voltage  = as.numeric(Voltage ))
newdt <- transform(newdt, Sub_metering_1 = as.numeric(Sub_metering_1))
newdt <- transform(newdt, Sub_metering_2 = as.double(Sub_metering_2))
newdt <- transform(newdt, Sub_metering_3 = as.numeric(Sub_metering_3))

day <- strptime(paste(newdt$Date, newdt$Time), format = "%Y-%m-%d %H:%M:%S")

# Plot 
par(mfrow = c(2,2))
img_url = "plot4.png"

plot(day, newdt$Global_active_power, type = "l",
     ylab = "Global Active Power (kilowatts)")

plot(day, newdt$Voltage, type = "l",
     xlab = "datatime",
     ylab = "Global Active Power (kilowatts)")

plot(day, newdt$Sub_metering_1, type = "n", 
     yaxt = "n",
     xlab = "",
     ylab = "Engery sub metering")
lines(day, newdt$Sub_metering_1, col = "black")
lines(day, newdt$Sub_metering_2, col = "red")
lines(day, newdt$Sub_metering_3, col = "blue")
axis(2, c(0, 10, 20, 30))
legend("topright", lwd = 1, lty = "solid", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

plot(day, newdt$Global_reactive_power, type = "l",
     xlab = "datatime",
     ylab = "Global_reactive_power")

dev.copy(png, file = img_url, height = 480, width = 480)
dev.off()

