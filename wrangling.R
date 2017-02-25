#Tuukka Kangas
#tuukka.kangas@helsinki.fi
#26th February, 2017

#This script is for the data wrangling for the final assignment in IODS course. 
#The data is described better in the index file.
#The used dataset is Trust and Quality of Local Governance in European cities
#Source http://data.europa.eu/euodp/en/data/dataset/jrc-coin-regio-trust-and-quality-of-local-governance-in-european-cities-2011-2014

#Needed packages

#Reading original csv-file
setwd("C:/Users/Tuukka/Desktop/IODS-final")
full_data = read.csv("gov_data_org.csv", sep=";", dec=".", header = TRUE)

summary(full_data)
