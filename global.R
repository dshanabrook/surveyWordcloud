#read survey
#Input Data File Format!:
#First row data[1,] must be header.  
#strip off questions, create corpus from them
#correct logical, numeric
#add short header
#return  corpusQ, data
#https://docs.google.com/spreadsheets/d/1umh464Da62x6gY5zuEzlYa4Q2Fiq9igW78CQhVrGTtU/edit#gid=1770330013
library(SnowballC)
library(shiny)
library(tm)
library(wordcloud)
library(ggplot2)

#constants: 
#theWebPageTitle
#theDefaultExclusionWords
#theDataSource (for documentation, not the data itself as un parsed)

dataInputFile.csv <- "data/basicIncome.csv"

theWebPageTitle <- "Analyze survey responses using Word Clouds"
theWebPageTitle <- "Basic Income - What it's like, raw responses"
theDefaultExclusionWords <- "kes, give, spent, buying, remaining, pay, paid, bought, buy, also, kept, amount, join, transfer, airtime, take, will, use, made, can, get, since, given, now, able,money, receiving, transfers,"

theDataSource <- "https://docs.google.com/spreadsheets/d/1umh464Da62x6gY5zuEzlYa4Q2Fiq9igW78CQhVrGTtU/edit#gid=1770330013"


doDebug <- T

getQuestions <- function(data, questionNumber=NULL) {
	questions <- theQuestions[1,questionNumber]
	questions <- tolower(questions)
	questions <- paste(questions, sep=" ", collapse=" ") 
	questions <- strsplit(questions,split=" ")
	questions <- unlist(questions)
	return(questions)
	}

getCorpusQ <- function(questions){	
	if (doDebug) cat("getCorpusQ")
	corpusQ <- Corpus(VectorSource(questions))
	corpusQ <- tm_map(corpusQ,  content_transformer(tolower))
	corpusQ <- tm_map(corpusQ, removePunctuation)
	return(corpusQ)
	}	
changeYesNoToTFNA <- function(dataField){
	dataField[dataField =="Yes"] <- T
	dataField[dataField =="No"] <- F
	dataField[dataField =="Doesn't know or prefers not to say"] <- "NA"
	dataField <- as.logical(dataField)
	return(dataField)
}

frequencies <- function(corpus, questionNumber,maxWords=1){
	if (doDebug) cat("frequencies")
	oneCorpus <- corpus[questionNumber]
	dtm <- DocumentTermMatrix(oneCorpus)
	freq <- colSums(as.matrix(dtm))
	wf <- data.frame(word=names(freq), freq=freq) 
#	wf <- subset(wf, freq>=maxWords)  
	return(wf)	
}

trimCorpus <- function(corpusQ, noNumbers, noQuestions, wordsToExclude = "") {
	if (doDebug) cat("trimCorpus")

	corpusD <- tm_map(corpus, content_transformer(tolower))
	if (noNumbers) 
		corpusD <- tm_map(corpusD, removeNumbers)
	if (noQuestions) 
		corpusD <- tm_map(corpusD, removeWords, corpusQ[]$content)	
	corpusD <- tm_map(corpusD, removeWords, wordsToExclude)
	corpusD <- tm_map(corpusD, removeWords,stopwords("en"))	
	corpusD <- tm_map(corpusD, removePunctuation)
	corpusD <- tm_map(corpusD, stripWhitespace)
#	corpusD <- tm_map(corpusD, PlainTextDocument)
	return(corpusD)
	}

createCorpusDF <- function(corpusD) {
	if (doDebug) cat("createCorpusDF")
	corpusDF <- data.frame(text = get("content", corpusD))
	row.names(corpusDF) <- columnHeaders
	return(corpusDF)
}

#also puts in right format
removeSpaces <- function(theWords) {
	theWords <- paste(theWords, ",")
	noSpaces <- gsub(" *, *",",",theWords)
	excludeWords <- unlist(strsplit(noSpaces,","))
	return(excludeWords)	
}
data <- read.csv(dataInputFile.csv, as.is=T, header=F)
data <- data[,-4]
theQuestions <- data[1,]
names(theQuestions) <- data[1,]

#remove header
data <- data[-1,]
#create header
names(data) <- c("name","age","biggestDifference","familyInteractL","howInteract","howSpent","forProjects","changeFeelWork","whyToIndividual","problemToIndividual","howLongPayments","trustPayments","trustAffectedLifePlans")


#change yes/no questions to T F NA
data$trustPayments <- changeYesNoToTFNA(data$trustPayments)
data$familyInteractL <- changeYesNoToTFNA(data$familyInteractL)
data$age <- as.numeric(data$age)
data$howLongPayments <- as.numeric(data$howLongPayments)

columnHeaders <- names(data)
numResponses <- nrow(data)
corpus <- Corpus(VectorSource(data))

#debugging
if (F){
	wordsToRemove <- c("mary,george,joyce")
	excludeWords <- unlist(strsplit(wordsToRemove,","))
	
	theQuestion <- theQuestions[3]
	noNumbers <- F
	noQuestions <- F
	wordsToExclude <- c("difference", "biggest")
	questionNumber <- match(theQuestion, theQuestions)
	corpusQ <- getCorpusQ(getQuestions(data,questionNumber))
	corpusD <- trimCorpus(corpusQ,noNumbers, noQuestions,excludeWords)
	corpusDF <- createCorpusDF(corpusD)
	frequencies(as.character(corpusDF[2,1]))
	if (is.numeric(data[,questionNumber]))
		hist(data[,questionNumber],main=theQuestion,xlab="",col=brewer.pal(8, "Dark2"))
	else
		wordcloud(corpusDF[questionNumber, ],scale=c(4,0.5),
                   colors=brewer.pal(8, "Dark2"),
                   main=theQuestions[questionNumber])
	}
