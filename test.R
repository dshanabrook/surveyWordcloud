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
if (is.numeric(data[, questionNumber])) {
	hist(data[, questionNumber], main = theQuestion, xlab = "", col = brewer.pal(8, 
		"Dark2"))
} else {
	wordcloud(corpusDF[questionNumber, ], scale = c(4, 0.5), max.words = max, 
		colors = brewer.pal(8, "Dark2"), main ="anything")
}
