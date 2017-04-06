#test
setwd("~/ShinyApps/giveDirectly/")
source("global.R")
theQuestion <- "Describe the biggest difference in your daily life."
excludeWords <- theDefaultExclusionWords
noNumbers <- T
noQuestions <- T
max = 10
questionNumber <- match(theQuestion, theQuestions)

corpusQ <- getCorpusQ(getQuestions(data, questionNumber))
corpusD <- trimCorpus(corpusQ, noNumbers, noQuestions, excludeWords)
corpusDF <- createCorpusDF(corpusD)

theTitle <- as.character(theQuestions[questionNumber])
		if (is.numeric(data[,questionNumber]))
			hist(data[,questionNumber],main="",xlab="",
						col=brewer.pal(8, "Dark2"))
		else {
			if (doWordCloud)
			wordcloud(corpusDF[questionNumber, ],scale=c(5,0.5),
                   max.words=max,colors=brewer.pal(8, "Dark2"))
        	else{
        	p <- ggplot(subset(wf, freq>max), aes(reorder(word, freq), freq),fill=freq) +geom_bar(stat="identity") +theme(axis.text.x=element_text(angle=45,hjust=1)) +scale_fill_brewer(palette="Dark2") +  coord_flip() 
        		p
        		}
	

library(fpc)
library(cluster)

c <- corpusD[3]
dtm <- DocumentTermMatrix(c)
tdm <- TermDocumentMatrix(c)
#dtmss <- removeSparseTerms(dtm, .090)
freq <- colSums(as.matrix(dtm))
library(ggplot2)   
wf <- data.frame(word=names(freq), freq=freq)  
qplot(word, data=subset(wf,freq>5), geom="bar",weight=freq,fill=freq) 
p <- ggplot(subset(wf, freq>5), aes(word, freq))    
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p+scale_fill_brewer()
p  



