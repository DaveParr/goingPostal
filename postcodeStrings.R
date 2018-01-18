## @knitr postcodeStrings_Libs
library(data.table)
library(stringr)

ukpostcodes <- data.table::fread("./Raw_Data/ukpostcodes.csv",
                                 verbose = FALSE,
                                 showProgress = FALSE)
ukpostcodes[, .N] # Number of rows in the table
ukpostcodes[1:3] # First three rows

## @knitr postcodeStrings_Word
ukpostcodes[, outward := stringr::word(postcode, 1)] 
ukpostcodes[, inward := stringr::word(postcode, 2)]
ukpostcodes[, sector := paste(outward, substr(inward, 1, 1))]
ukpostcodes[1:3]

## @knitr nonGeo_filter
nonGeo <- c("AB99", "BT58", "CA99", "CM92", "CM98", "CR44", "CR90", 
            "GIR", "IM99", "IV99", "JE5", "M61", "ME99", "N1C", 
            "N81", "NR99", "NW26", "PA80", "PE99", "RH77", "SL60", 
            "SO97", "SW95", "SY99", "WD99", "WF90")
ukpostcodesSub <- ukpostcodes[!outward %in% nonGeo]

## @knitr postcodeStrings_AvLL
sectorPostcodes <- ukpostcodesSub[, .(sector_latitude = mean(latitude),
                                      sector_longitude = mean(longitude)),
                                  by = sector] # catagorical grouping
sectorPostcodes[, .N]
sectorPostcodes[1:3]

## @knitr postcodeStrings_write
write.csv(sectorPostcodes, "./Processed_Data/Postcodes by sector.csv", row.names = FALSE)