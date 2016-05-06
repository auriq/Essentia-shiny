####This app is for interactive map  of TWEETS data#######
### using R and essentia########################################

###set working directory, please change to where your##########
###Democache fold is located##################################
setwd('/home/essentia/ShinyApps/GOP/')

##load libraries, please use install.packages to download#####
###################if your R session##########################
library(shiny)
library(leaflet)
library(wordcloud)
library(RColorBrewer)
##read info for counts############################
trump <- read.csv("trumpTop.csv")
hillary <- read.csv("hillaryTop.csv")
row.names(trump) <- trump$word
row.names(hillary) <- hillary$word
stop_words <- list("https","http","https…","http…","this","that","from",
                   "these","those","his","her","could","should","will",
                   "your","with","about","have","just","what","from","would",
                   "than","only","much","been","when","must","after","both")
trump <- trump[-which(tolower(row.names(trump)) %in% stop_words),]
hillary <- hillary[-which(tolower(row.names(hillary)) %in% stop_words),]
###Shiny app starts here
shinyApp(
  ui = fluidPage(
    titlePanel("Tweets Trump vs Hillary"),
    tabsetPanel(
    tabPanel(tags$b("Word Cloud"),  
    fluidRow(
        column(6,plotOutput("TrumpCloud")),
        column(6,plotOutput("HillaryCloud")))),
               
    tabPanel(tags$b("Trump Data view and download"),
              column(2,downloadButton('downloadDataT','Download',class="btn btn-primary")),
              dataTableOutput("TrumpResult")),
    tabPanel(tags$b("Hillary Data view and download"),
             column(2,downloadButton('downloadDataH','Download',class="btn btn-primary")),
             dataTableOutput("HillaryResult")))),
    
  server = function(input, output, session){
    output$TrumpCloud <-renderPlot({
      wordcloud(trump[,1],log10(trump[,2]),scale=c(4,.4),min.freq=1.2,max.words=400,
                random.order=FALSE,rot.per=.15,colors=brewer.pal(8,"Dark2"))
      })
    output$HillaryCloud <-renderPlot({
      wordcloud(hillary[,1],log10(hillary[,2]),scale=c(4,.2),min.freq=1.2,max.words=400,
                random.order=FALSE,rot.per=.15,colors=brewer.pal(8,"Dark2"))
    })
    output$TrumpResult <- renderDataTable(trump,options=list(pageLength = 10,searching=TRUE))
    output$HillaryResult <- renderDataTable(hillary,options=list(pageLength = 10,searching=TRUE))
    output$downloadDataT <- downloadHandler(
      filename <- function () { paste("Trump_wordcounts","csv",sep = ".")},
      content <- function(file) {
        write.table(trump, file, sep = ",", row.names = FALSE)
      }
    )
    output$downloadDataH <- downloadHandler(
      filename <- function () { paste("Hillary_wordcounts","csv",sep = ".")},
      content <- function(file) {
        write.table(hillary, file, sep = ",", row.names = FALSE)
      }
    )
  }
)

    
 
