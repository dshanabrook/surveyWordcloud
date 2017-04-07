Survey questions word cloud analysis using R Shiny

Survey questions are notoriously difficult to summarize.  Using word clouds, especially when the output is easily adjusted, is a possible solution.  This R shiny code takes a single .csv file of survey questions (columns) and answers (rows), and presents each question with a wordcloud of the answers.

global.R - inialization pararmeters are set here, data, titles, etc.

dataFile.csv - string, location (file name) of input data 
		first row - survey questions
		following rows - survey replies, one row per survey
		
theWebPageTitle - string, Title of web page
theDefaultExclusionWords - string of words not to be included in the word clouds.  This can be added to dynamically.  words should not be seperated by spaces, only ","
theDataSourceInput - string, reference only, this is the source of the survey data.

Implemented Example with givedirectly.com data:
https://bravo.shinyapps.io/givedirectly/


