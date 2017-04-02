#questionAnalysis
#change these defaults for your application

fluidPage(
  titlePanel(theWebPageTitle, windowTitle = theWebPageTitle),		

  sidebarLayout(
    sidebarPanel(
      selectInput("theQuestion", "Choose question: ", multiple=FALSE, theQuestions),
      textAreaInput("wordsToExclude", "Exclude these words: ", theDefaultExclusionWords,rows=4),
  #    submitButton(text="Update", icon=NULL),
      hr(),
    sliderInput("max","Number of words in cloud:",
                  min = minWords,  max = maxWords,  value = defaultWords),
    checkboxInput("noQuestions", "Remove question words from cloud?", value=T),
    checkboxInput("noNumbers", "Remove numbers?", value=T),
 	tags$div(class = "header", checked = NA,
               tags$a(href= theDataSource))),

    # Show Word Cloud
    mainPanel(	
      h3(textOutput("mainTitle")),
      plotOutput("plot")
    )))