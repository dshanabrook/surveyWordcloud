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

#constants: 
#theWebPageTitle
#theDefaultExclusionWords
#theDataSource (for documentation, not the data itself as un parsed)

dataInputFile.csv <- "data/basicIncome.csv"

theWebPageTitle <- "Analyze survey responses using Word Clouds"
theWebPageTitle <- "Basic Income - What it's like, raw responses"
theDefaultExclusionWords <- "kes,give,spent,buying,remaining,pay,paid,bought,buy,also,kept,amount,join,transfer,airtime,take,will,use,made,can,get,since,given,now,able,"

theDataSource <- "https://docs.google.com/spreadsheets/d/1umh464Da62x6gY5zuEzlYa4Q2Fiq9igW78CQhVrGTtU/edit#gid=1770330013"

#word cloud parameter defaults:
minWords <- 1
maxWords <- 30
defaultWords <- 10

doDebug <- F

getQuestions <- function(data, questionNumber=NULL) {
	questions <- theQuestions[1,questionNumber]
	questions <- tolower(questions)
	questions <- paste(questions, sep=" ", collapse=" ") 
	questions <- strsplit(questions,split=" ")
	questions <- unlist(questions)
	return(questions)
	}

getCorpusQ <- function(questions){	
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

frequencies <- function(words){
	corpus <- Corpus(VectorSource(words))    
	dtm <- TermDocumentMatrix(corpus)
	m <- as.matrix(dtm)
	v <- sort(rowSums(m),decreasing=TRUE)
	d <- data.frame(word = names(v),freq=v)
	return(d)
}

trimCorpus <- function(corpusQ, noNumbers, noQuestions, wordsToExclude = "") {

	corpusD <- tm_map(corpus, content_transformer(tolower))
	if (noNumbers) 
		corpusD <- tm_map(corpusD, removeNumbers)
	if (noQuestions) 
		corpusD <- tm_map(corpusD, removeWords, corpusQ[]$content)	
	corpusD <- tm_map(corpusD, removeWords, wordsToExclude)
	corpusD <- tm_map(corpusD, removeWords,stopwords("en"))	
	corpusD <- tm_map(corpusD, removePunctuation)
	return(corpusD)
	}

createCorpusDF <- function(corpusD) {
	corpusDF <- data.frame(text = get("content", corpusD))
	row.names(corpusDF) <- columnHeaders
	return(corpusDF)
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
