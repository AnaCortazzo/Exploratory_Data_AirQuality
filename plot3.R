setwd("/home/anita/DataScience/RdataScience/4.EDA/proyFinal")

# load packages
library(dplyr)
library(ggplot2)
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
data <- NEI %>% mutate(fips =as.factor(fips), type = as.factor(type) ) %>%  
    filter(fips == "24510") %>% group_by(year)
#Levels: NON-ROAD NONPOINT ON-ROAD POINT

#plot 1 in ggplot2 system
qplot(factor(year), Emissions, fill = year, data = data, facets = . ~ type) + 
    geom_bar(stat="identity") + theme(legend.position="none") +
    labs(x = "Year", y = "Total PM2.5 emissions") +
    labs(title = "Total PM2.5 emissions by source for Baltimore City")
dev.copy(png, file = "plot3.png")
dev.off()
