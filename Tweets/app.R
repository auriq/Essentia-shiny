####This app is for interactive map  of Tweets##################
### using R and essentia########################################

###set working directory, please change to where your##########
###Democache fold is located##################################
setwd('/home/essentia/ShinyApps/Tweets/')

##load libraries, please use install.packages to download#####
###################if your R session##########################
library(shiny)
library(leaflet)
library(RESS)
library(stringr)

geo <- read.csv("tweets.csv")
geo <- geo[geo$geo_lat != 0 & geo$geo_lon != 0,]
latitude  <- geo$geo_lat
longitude <- geo$geo_lon
geo$id <- str_pad(geo$id,width=17,side="left",pad="0")
ids       <- paste0("Created at: ", geo$created_at, "\n", "user location: ", geo$usr_location,
                   " Place fullname: ", geo$place_full_name, "\n", "Text: ", geo$text)

###Shiny app starts here
shinyApp(
  ui = fluidPage(
    tabsetPanel(
    tabPanel(tags$b("Map View"),  
    fluidRow(
        leafletMap(
        "map", "100%", 400,
        initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
        options=list(
          center = c(40, -100),
          zoom = 4,
          maxBounds = list(list(20, -150), list(60, -60))))),
    verbatimTextOutput("Click_text")),
    
      tabPanel(tags$b("Data view and download"),
               column(2,downloadButton('downloadData','Download',class="btn btn-primary")),
               dataTableOutput("table")))),
    
  server = function(input, output, session){
    map = createLeafletMap(session, 'map')
    session$onFlushed(once=T, function(){
      
      map$addCircleMarker(lat = latitude, lng = longitude, radius = 3,   
                          layerId=ids)
    })    
    
    observe({
      click<-input$map_marker_click
      if(is.null(click))
        return()
      text<-paste("Lattitude ", click$lat, "Longtitude ", click$lng)
      text2<-click$id
      map$clearPopups()
      map$showPopup( click$lat, click$lng, text)
      output$Click_text<-renderText({
        text2
      })
      
    })
    output$table <- renderDataTable(geo,options=list(pageLength = 10,searching=FALSE))
    output$downloadData <- downloadHandler(
      filename <- function () { paste("tweets","csv",sep = ".")},
      content <- function(file) {
        write.table(geo, file, sep = ",", row.names = FALSE)
      }
    )
    
  }
)

    
 
