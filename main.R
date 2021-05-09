library(tidyverse) ; library(httr) ; library(jsonlite)

# up to date
date <- format(Sys.Date(), "%Y-%m")
path <- paste("https://stats.oecd.org/SDMX-JSON/data/STLABOUR/AUT+BEL+CHL+CZE+DNK+EST+FIN+FRA+DEU+GRC+HUN+ISL+IRL+ITA+LTU+LVA+LUX+NLD+NOR+POL+PRT+SVK+SVN+ESP+SWE+CHE+GBR.LRHUTTTT.STSA.M/all?startTime=2020-01&endTime=",date,"&dimensionAtObservation=allDimensions", sep = "")

#get dataset
request <- GET(url = path)
response <- content(request, as = "text", encoding = "UTF-8")
df <- fromJSON(response)

#find month and country
coord <- names(df$dataSets$observations)
country <- list()
month <- list()
coord <- strsplit(coord,":")
for(i in 1:length(coord)){
  country[i] <- coord[[i]][1]
  month[i] <- coord[[i]][5]
}
#read first data in observations
obs <- sapply(df$dataSets$observations, "[[", 1)[1,]

#create final dataset
mat <- matrix(c(country,month,obs), ncol = 3, byrow = FALSE)

#export
write.csv(mat,"dataset.csv")
