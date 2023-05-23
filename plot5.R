setwd("/home/anita/DataScience/RdataScience/4.EDA/proyFinal")

# load packages
library(dplyr)
library(ggplot2)
library(RColorBrewer)
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

# Subset motor vehicle sources related NEI data
motorVehicles <- grepl("vehicles", SCC$SCC.Level.Two, ignore.case=TRUE)
motorVehiclesSCC <- SCC[motorVehicles,]$SCC
motorVehiclesNEI <- NEI[NEI$SCC %in% motorVehiclesSCC,]

data <- motorVehiclesNEI %>%  mutate(fips =as.factor(fips) ) %>%  
    filter(fips == "24510") %>%group_by(year) %>% 
    summarize(Emissions = sum(Emissions,na.rm = TRUE))

#plot 1 in ggplot2 system
qplot(factor(year), Emissions, fill = year, data = data) + geom_bar(stat="identity") + 
    theme(legend.position="none") +
    labs(x = "Year", y = "PM2.5 emissions") +
    labs(title = "Total emissions of PM2.5 related to motor vehicles in Baltimore")

dev.copy(png, file = "plot5.png")
dev.off()
