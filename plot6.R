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

dataBalti <- motorVehiclesNEI %>% 
    filter(fips == "24510") %>% group_by(year, fips) %>% 
    summarize(Emissions = sum(Emissions,na.rm = TRUE)) %>%
    mutate(city = "Baltimore")
   

dataLA <- motorVehiclesNEI %>%  
    filter(fips == "06037") %>% group_by(year, fips) %>% 
    summarize(Emissions = sum(Emissions,na.rm = TRUE)) %>%
    mutate(city = "Los Ángeles")

data <- rbind(dataBalti, dataLA)

#plot 6 in ggplot2 system
qplot(factor(year), Emissions, fill = year, data = data, facets = .~city) + 
    geom_bar(stat="identity") + 
    theme(legend.position="none") +
    labs(x = "Year", y = "PM2.5 emissions") +
    labs(title = "Total emissions of PM2.5 related to motor vehicles in Baltimore and Los Ángeles")

dev.copy(png, file = "plot6.png")
dev.off()
