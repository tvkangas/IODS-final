#Tuukka Kangas
#tuukka.kangas@helsinki.fi
#26th February, 2017

#This script is for the data wrangling for the final assignment in IODS course. 
#The data is described better in the index file.
#The used dataset is Trust and Quality of Local Governance in European cities
#Source http://data.europa.eu/euodp/en/data/dataset/jrc-coin-regio-trust-and-quality-of-local-governance-in-european-cities-2011-2014

#Needed packages
library(dplyr)

#Reading original csv-file
setwd("C:/Users/Tuukka/Desktop/IODS-final")
full_data = read.csv("gov_data_org.csv", sep=";", dec=".", header = TRUE)

####################
#Reducing varibles

#In 56 varibles there is 11 variables that contains at least one observation that have missing value.
#Because there will remain 45 variables - that is more than enough for my purposes - I removed all variables that have at least one missing value
data_narmv <- full_data[ , apply(full_data, 2, function(x) !any(is.na(x)))]

#Because the amount of variables is still quite big, I reduced the number of variables
#For the reducing I created some sum variables

#Trust, combines three variables that covers trust in different authorities
data_narmv <- mutate(data_narmv, trust = (data_narmv$rq17b_mean + data_narmv$rq17d_mean + data_narmv$rq17e_mean) / 3)
data_narmv <- dplyr::select(data_narmv, -starts_with("rq17"))

#Corruption, four variables that covers corruption in different authorities
data_narmv <- mutate(data_narmv, corruption = (data_narmv$rq18a_mean + data_narmv$rq18b_mean + data_narmv$rq18d_mean + data_narmv$rq18e_mean) / 4)
data_narmv <- dplyr::select(data_narmv, -starts_with("rq18"))

#Freedom, 12 variables that covers citicens' freedom
data_narmv$freedom <- rowMeans(subset(data_narmv, select = c(rq38c_mean, rq38d_mean, rq38e_mean, rq38f_mean, rq34a_mean, rq34b_mean, rq34c_mean, rq34d_mean, rq34e_mean, rq34f_mean, rq34g_mean, rq34h_mean)), na.rm = TRUE)
data_narmv <- dplyr::select(data_narmv, -starts_with("rq34"))
data_narmv <- dplyr::select(data_narmv, -starts_with("rq38"))

#Bribe, five variables that covers giving bribe to the authorities
data_narmv$bribe <- rowMeans(subset(data_narmv, select = c(rq36a_mean, rq36b_mean, rq36c_mean, rq36d_mean, rq36e_mean)), na.rm = TRUE)
data_narmv <- dplyr::select(data_narmv, -starts_with("rq36"))

#House demolition, two variables covering situation if the house demolition is unfair
data_narmv <- mutate(data_narmv, houdem = (data_narmv$rq1b_1_mean + (1- data_narmv$rq1b_3_mean)) / 2)
data_narmv <- dplyr::select(data_narmv, -starts_with("rq1b"))

#Business fines, two variables covering if small business are fined if let taxes paid or not do equired documentation
data_narmv <- mutate(data_narmv, busfine = (data_narmv$rq13a_mean + data_narmv$rq13b_mean) / 2)
data_narmv <- dplyr::select(data_narmv, -starts_with("rq13"))

#Openess of local government
data_narmv <- mutate(data_narmv, govopen = (data_narmv$rq15d_mean + data_narmv$rq15b_mean) / 2)
data_narmv <- dplyr::select(data_narmv, -starts_with("rq15"))

#Lawful, police and court
data_narmv$lawful <- rowMeans(subset(data_narmv, select = c(rq37a_mean, rq37b_mean, rq37c_mean, rq37d_mean)), na.rm = TRUE)
data_narmv <- dplyr::select(data_narmv, -starts_with("rq37"))

#Some variables and one case are just removed
data_narmv <- dplyr::select(data_narmv, -starts_with("rq7"))
data_narmv <- dplyr::select(data_narmv, -starts_with("rq11"))
data_narmv <- data_narmv[!(data_narmv$city=="Other"), ]

#Naming columns
colnames(data_narmv)[which(names(data_narmv) == "rq1c_mean")] <- "faircourt"
colnames(data_narmv)[which(names(data_narmv) == "rq14_mean")] <- "safe"
colnames(data_narmv)[which(names(data_narmv) == "rq30_mean")] <- "break"
colnames(data_narmv)[which(names(data_narmv) == "rq29_mean")] <- "workdis"

#After grouping and removing some variables there is still 12(+2) variables to describe the cities.
#It seems to be enough and too much data is not lost in the process

#####################
#Joining two datasets 

#I wanted also variable that describes the relative size of city (compared to country population)
#For that I had to make new data.frame containing city and country population
#Source for the populations are described in separate text file (see index file)
pop_data = read.csv("populations.csv", sep=";", dec=".", header = TRUE)
pop_data$share = pop_data$cityPop / pop_data$countryPop 

#Next step is to merge datasets

data_final <- merge(data_narmv, pop_data,by="city")

#The population of the country is not needed
data_final <- dplyr::select(data_final, -starts_with("countryP"))

#Some renaming and recoding city population to the thousands
colnames(data_final)[which(names(data_final) == "cityPop")] <- "citypop"
data_final$citypop <- data_final$citypop / 1000

write.csv(data_final, file="trustdata.csv")

########
#Summary

#After wrangling in the dataset is 17 variables.
#12 are recalcuted from the original dataset
#Two of them are joined from the external source