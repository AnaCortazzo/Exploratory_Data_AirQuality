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

# Subset coal combustion related NEI data
combustion <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coal <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coalComb <- (combustion & coal)
combustionSCC <- SCC[coalComb,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]

data <- combustionNEI %>%  group_by(year) %>% summarize(Emissions = sum(Emissions,na.rm = TRUE))

#plot 1 in ggplot2 system
qplot(factor(year), Emissions, fill = year, data = data) + geom_bar(stat="identity") + 
    theme(legend.position="none") +
    labs(x = "Year", y = "PM2.5 emissions") +
    labs(title = "Total emissions of PM2.5 related to coal combustion")

dev.copy(png, file = "plot4.png")
dev.off()
