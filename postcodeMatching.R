## @knitr postcodeMatching_Libs
library(data.table)
library(geosphere)

postcodesSector <- data.table::fread("./Processed_Data/Postcodes by sector.csv", verbose = FALSE, showProgress = FALSE)
stationLocation <- data.table::fread("./Raw_Data/stationLocations.csv", verbose = FALSE, showProgress = FALSE)
setnames(stationLocation, old = c("lat", "lon"), new = c("landstat_lat", "landstat_lon"))

stationLocation[1:3]

## @knitr postcodeMatching_DistM
postcodeDistances <- 
  geosphere::distm(x = postcodesSector[,.(sector_longitude,sector_latitude)], 
                   y = stationLocation[,.(landstat_lon,landstat_lat)], 
                   fun=distVincentyEllipsoid)
head(postcodeDistances, n=1)

## @knitr postcodeMatching_Melt
postcodeDistances_melt <- data.table(melt(postcodeDistances))
setnames(
  postcodeDistances_melt,
  old = c("Var1", "Var2", "value"),
  new = c("postcodeRow", "stationRowMelt", "Distance")
)
postcodeDistances_melt[1:2]

## @knitr postcodeMatching_Minimum
postcodeStation_link <- 
  postcodeDistances_melt[, .(stationRow = which.min(Distance)),
                         by = "postcodeRow"]
postcodeStation_link[, .N]

## @knitr postcodeMatching_Index
postcodesSector[, postcodeRow := .I]
stationLocation[, stationRow := .I]

## @knitr postcodeMatching_Merge
postcodeStation <- postcodesSector[postcodeStation_link, 
                                   on = "postcodeRow"]
postcodeStation <- stationLocation[postcodeStation, on="stationRow"]
postcodeStation[1:3]

## @knitr postcodeMatching_Write
write.csv(postcodeStation, "./Processed_Data/Sector by nearest station.csv", row.names = FALSE)
