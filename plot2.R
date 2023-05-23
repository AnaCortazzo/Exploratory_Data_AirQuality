setwd("/home/anita/DataScience/RdataScience/4.EDA/proyFinal")

# load packages
library(dplyr)

# download data
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
pathDIR <- getwd()
setwd(pathDIR)
if(!file.exists("data")){
    dir.create("data") }
download.file(fileURL, file.path(pathDIR, "./data/datafiles.zip") , method="libcurl")
unzip("./data/datafiles.zip", exdir = "./data")

#load data 
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

#tidy data for plotting
data <- NEI %>% mutate(fips =as.factor(fips) ) %>%  filter(fips == "24510") %>% 
    group_by(year)%>% summarize(Emissions = sum(Emissions,na.rm = TRUE))

#plot 1 in base system
with(data, barplot(Emissions, col = year, names = year, xlab = "Year", ylab = "Total PM2.5 emissions"))

title("PM2.5 emissions per year in Baltimore")

dev.copy(png, file = "plot2.png")
dev.off()
