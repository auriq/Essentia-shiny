###get rid of the US ids without climate data###
####set working directory where data is located####
setwd('/home/essentia/ShinyApps/Democache/getUSstations')

geo       <- read.csv("ish-history.csv")
climateid <- read.csv("uniqueid.csv")
colnames(climateid) <- "usaf_wban"

usaf  <- sprintf("%06d",geo$USAF)
wban  <- sprintf("%05d",geo$WBAN)
geo$usaf_wban <- paste0(usaf,"-",wban)
climateid$usaf_wban <- as.character(climateid$usaf_wban)

geoid <- merge(geo,climateid,by="usaf_wban",all.x = FALSE,all.y = FALSE)
geoid       <- geoid[which(geoid$LAT <= 90. & geoid$LAT >= 10.),]
geoid       <- geoid[which(geoid$LON <= -60. & geoid$LON >= -179.),]
write.csv(geoid,"geoUS.csv")
