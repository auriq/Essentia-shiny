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
trump   <- read.csv("trumpTopN.csv")
hillary <- read.csv("hillaryTopN.csv")
sanders <- read.csv("sandersTopN.csv")
random  <- read.csv("randomTopN.csv")
stop_words <- read.csv("stopword.csv")
row.names(trump) <- trump$word
row.names(hillary) <- hillary$word
row.names(sanders) <- sanders$word
row.names(random) <- random$word
#stop_words <- list("https","http","https…","http…","this","that","from",
#                   "these","those","his","her","could","should","will",
#                   "your","with","about","have","just","what","from","would",
#                   "than","only","much","been","when","must","after","both")
trump   <- trump[-which(tolower(row.names(trump)) %in% stop_words$Sword),]
hillary <- hillary[-which(tolower(row.names(hillary)) %in% stop_words$Sword),]
sanders <- sanders[-which(tolower(row.names(sanders)) %in% stop_words$Sword),]
random  <- random[-which(tolower(row.names(random)) %in% stop_words$Sword),]
print("loading ends")
      png(filename='trump.png')
      wordcloud(trump[,1],log10(trump[,2]),scale=c(4,.4),min.freq=1.1,max.words=Inf,
                random.order=FALSE,rot.per=.15,colors=brewer.pal(8,"Dark2"))
      dev.off()
print("trumpfinish")
      png(filename='hillary.png')
      wordcloud(hillary[,1],log10(hillary[,2]),scale=c(4,.4),min.freq=1.1,max.words=Inf,
                random.order=FALSE,rot.per=.15,colors=brewer.pal(8,"Dark2"))
      dev.off()
print("hillaryfinish")
      png(filename='sanders.png')
      wordcloud(sanders[,1],log10(sanders[,2]),scale=c(4,.4),min.freq=1.1,max.words=Inf,
                random.order=FALSE,rot.per=.15,colors=brewer.pal(8,"Dark2"))
      dev.off()
print("sandersfinish")
png(filename='050616Fridayafternoon.png')
wordcloud(random[,1],log10(random[,2]),scale=c(4,.4),min.freq=1.1,max.words=Inf,
          random.order=FALSE,rot.per=.15,colors=brewer.pal(8,"Dark2"))
dev.off()
print("randomfinish")