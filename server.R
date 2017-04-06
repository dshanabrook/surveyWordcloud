	
shinyServer(function(input, output, session) {
	output$value <- renderText({ input$wordsToExclude })
	excludeWords <- reactive(removeSpaces(input$wordsToExclude))
	questionNumber <- reactive(match(input$theQuestion, theQuestions))
	
	corpusQ <- reactive(getCorpusQ(getQuestions(data,questionNumber())))
	corpusD <- reactive(trimCorpus(corpusQ(), input$noNumbers, input$noQuestions, excludeWords()))
	corpusDF <- reactive(createCorpusDF(corpusD()))
	wf <- reactive(frequencies(corpusD(), questionNumber()))
	
	output$mainTitle <- renderText({
         paste(questionNumber(), ": ", as.character(theQuestions[questionNumber()]))
    })

	output$plot <- renderPlot({
		if (is.numeric(data[,questionNumber()]))
			hist(data[,questionNumber()],main="",xlab="",
						col=brewer.pal(8, "Dark2"))
		else {
			if (input$doWordCloud)
			wordcloud(corpusDF()[questionNumber(), ],scale=c(5,0.5),
                   max.words=input$wdsCloud,colors=brewer.pal(8, "Dark2"))
        	else {	
        	p <- ggplot(subset(wf(), freq>input$wdsFreq), aes(reorder(word, freq), freq)) +geom_bar(stat="identity") +theme(axis.text.x=element_text(angle=45,hjust=2)) +scale_fill_brewer(palette="Dark2") + coord_flip() + xlab("Word")
        	print(p)
       		 }
       		 }
	})
})
