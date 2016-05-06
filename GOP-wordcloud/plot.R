####This app is for interactive map  of TWEETS data#######
### using R and essentia########################################

###set working directory, please change to where your##########
###Democache fold is located##################################
setwd('/home/essentia/ShinyApps/GOP-wordcloud/')

##load libraries, please use install.packages to download#####
###################if your R session##########################
library(shiny)
library(leaflet)
library(wordcloud)
library(RColorBrewer)
##read info for counts############################
trump <- read.csv("trumpTop.csv")
hillary <- read.csv("hillaryTop.csv")
sanders <- read.csv("sandersTop.csv")
row.names(trump) <- trump$word
row.names(hillary) <- hillary$word
row.names(sanders) <- sanders$word
stop_words <- list("https","http","https…","http…","this","that","from",
                   "these","those","his","her","could","should","will",
                   "your","with","about","have","just","what","from","would",
                   "than","only","much","been","when","must","after","both")
trump <- trump[-which(tolower(row.names(trump)) %in% stop_words),]
hillary <- hillary[-which(tolower(row.names(hillary)) %in% stop_words),]
sanders <- sanders[-which(tolower(row.names(sanders)) %in% stop_words),]
print("loading ends")
      png(filename='trump.png')
      wordcloud(trump[,1],log10(trump[,2]),scale=c(4,.4),min.freq=1.2,max.words=Inf,
                random.order=FALSE,rot.per=.15,colors=brewer.pal(8,"Dark2"))
      dev.off()
print("trumpfinish")
      png(filename='hillary.png')
      wordcloud(hillary[,1],log10(hillary[,2]),scale=c(4,.4),min.freq=1.2,max.words=Inf,
                random.order=FALSE,rot.per=.15,colors=brewer.pal(8,"Dark2"))
      dev.off()
print("hillaryfinish")
      png(filename='sanders.png')
      wordcloud(sanders[,1],log10(sanders[,2]),scale=c(4,.4),min.freq=1.2,max.words=Inf,
                random.order=FALSE,rot.per=.15,colors=brewer.pal(8,"Dark2"))
      dev.off()
print("sandersfinish")
