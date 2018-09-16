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
day <- strptime(paste(newdt$Date, newdt$Time), format = "%Y-%m-%d %H:%M:%S")

# Plot 
par(mfrow = c(1,1))
img_url = "plot2.png"
png(img_url, width=480, height=480, units="px")

plot(day, newdt$Global_active_power, type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")

dev.off()