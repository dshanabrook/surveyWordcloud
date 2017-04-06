#questionAnalysis
#change these defaults for your application
#word cloud parameter defaults:
minCloud <- 1
maxCloud <- 30
defaultCloud <- 10

minFreq <- 1
maxFreq <- 30
defaultFreq <- 10

fluidPage(
  titlePanel(theWebPageTitle, windowTitle = theWebPageTitle),		

  sidebarLayout(
    sidebarPanel(
      selectInput("theQuestion", "Choose question: ", multiple=FALSE, theQuestions),
      textAreaInput("wordsToExclude", "Exclude these words: ", theDefaultExclusionWords,rows=4),

    checkboxInput("doWordCloud", "Plot Word Cloud?", value=T),
    
    conditionalPanel(condition= "input.doWordCloud == true",
    	  sliderInput("wdsCloud","Number of words in cloud:",
                  min = minCloud,  max = maxCloud,  value = defaultCloud)),
                  
     conditionalPanel(condition= "input.doWordCloud == false",
    	    sliderInput("wdsFreq","Minimum word count shown:",
                  min = minFreq,  max = maxFreq,  value = defaultFreq)),
    
    checkboxInput("noQuestions", "Remove question words from cloud?", value=T),
    checkboxInput("noNumbers", "Remove numbers?", value=T),
 	tags$div(class = "header", checked = NA,
               tags$a(href= theDataSource))),

    # Show Word Cloud
    mainPanel(	
      h3(textOutput("mainTitle")),
      plotOutput("plot")
    )))