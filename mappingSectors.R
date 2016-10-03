## @knitr mappingSectors_Libs
library(ggplot2)
library(ggmap)
library(data.table)

postcodeStation_match <- fread("./Processed_Data/Sector by nearest station.csv")
stationLocation <- fread("./Raw_Data/stationLocations.csv")

## @knitr mappingSectors_boundingBox
myLocation <- c(postcodeStation_match[, round(min(sector_longitude)) - 0.5],
                postcodeStation_match[, round(min(sector_latitude)) - 0.5],
                postcodeStation_match[, round(max(sector_longitude)) + 0.5],
                postcodeStation_match[, round(max(sector_latitude)) + 0.5])

## @knitr mappingSectors_tiles
myMap <- get_map(location=myLocation, 
                 source="stamen", 
                 zoom = 5, 
                 maptype = "toner-lite", 
                 messaging = FALSE)

## @knitr mappingSectors_codePoints
pointMap <- ggmap(myMap) +
  geom_point(data = postcodeStation_match,
             aes(x = sector_longitude, 
                 y = sector_latitude, 
                 colour = landstat_name_wmo)) +
  geom_point(data = stationLocation,
             aes(x = lon, 
                 y = lat), 
             colour = "black") +
  theme(legend.position = "right")
## @knitr mappingSectors_plotPoints
pointMap

## @knitr mappingSectors_calcPoly
postcodeStation_chull <- 
  postcodeStation_match[, .SD[chull(sector_latitude, sector_longitude)], 
                        by = landstat_name_wmo]
postcodeStation_chull[1:3]
postcodeStation_chull[, .N]

## @knitr mappingSectors_codePoly
polyMap <- ggmap(myMap) +
  geom_polygon(data = postcodeStation_chull,
             aes(x = sector_longitude, 
                 y = sector_latitude, 
                 colour = landstat_name_wmo, 
                 fill = landstat_name_wmo),
             alpha = 0.5)+
  geom_point(data = stationLocation,
             aes(x = lon, 
                 y = lat), 
             colour = "black") +
  theme(legend.position = "right")

## @knitr mappingSectors_plotPoly
polyMap
