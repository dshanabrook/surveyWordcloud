	
shinyServer(function(input, output, session) {
	output$value <- renderText({ input$wordsToExclude })
	excludeWords <- reactive(removeSpaces(input$wordsToExclude))
	questionNumber <- reactive(match(input$theQuestion, theQuestions))
	
	corpusQ <- reactive(getCorpusQ(getQuestions(data,questionNumber())))
	corpusD <- reactive(trimCorpus(corpusQ(), input$noNumbers, input$noQuestions, excludeWords()))
	corpusDF <- reactive(createCorpusDF(corpusD()))
	
	output$mainTitle <- renderText({
         paste(questionNumber(), ": ", as.character(theQuestions[questionNumber()]))
    })

	output$plot <- renderPlot({
		if (is.numeric(data[,questionNumber()]))
			hist(data[,questionNumber()],main="",xlab="",
						col=brewer.pal(8, "Dark2"))
		else
			wordcloud(corpusDF()[questionNumber(), ],scale=c(5,0.5),
                   max.words=input$max,colors=brewer.pal(8, "Dark2"))
	})
})
