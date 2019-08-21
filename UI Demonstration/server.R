library(shiny)
library(shinyjs)
library(ggplot2)
library(readr)
library(tidyr)
library(dplyr)
library(purrr)
library(keras)
library(yardstick)
library(forcats)
library(reshape2)
library(lubridate)
library(ss)

shinyServer(function(input, output, session) {
  v <- reactiveValues(hasModelRun = FALSE, plotType = NULL, 
                      timeWindow = NULL, scoresOrCounts = 2, originalDF = NULL, df = NULL, predsWeek = NULL, predsMonth = NULL)
  
  observe({
    if (v$hasModelRun == FALSE) {
      shinyjs::disable("plotButton")
      shinyjs::disable("resetButton")
    } else {
      shinyjs::enable("plotButton")
      shinyjs::enable("resetButton")
    }
  })
  
  observeEvent(input$scoresOrCounts, {
    toggleState("plotType", input$scoresOrCounts == 1)
  })
  
  observeEvent(input$resetButton, {
    updateDateInput(session, "startDate", value = min(v$originalDF$dates), min = min(v$originalDF$dates), max = max(v$originalDF$dates))
    updateDateInput(session, "endDate", value = max(v$originalDF$dates), min = min(v$originalDF$dates), max = max(v$originalDF$dates))
    
    updateRadioButtons(session, "timeWindow", choices = list("By Week" = 1, "By Month" = 2), inline = TRUE)
    updateRadioButtons(session, "scoresOrCounts", choices = list("Score Statistics" = 1, "Prediction Count" = 2, "Prediction Percentage" = 3), inline = FALSE)
    updateRadioButtons(session, "plotType", choices = list("Boxplot" = 1, "Violin" = 2, "Scatterplot" = 3), inline = FALSE)
  })
  
  observeEvent(input$plotButton, {
    v$plotType <- input$plotType
    v$timeWindow <- input$timeWindow
    v$scoresOrCounts <- input$scoresOrCounts
    
    v$df <- subset(v$originalDF, v$originalDF$date >= input$startDate & v$originalDF$date <= input$endDate)
    v$predsMonth <- v$df %>%
      group_by(month) %>%
      summarise(countTrue = sum(predictions == 1), percentage = sum((predictions == 1) /n())) %>%
      mutate(monthName = month.abb[month])
    
    v$predsWeek <- v$df %>%
      group_by(week) %>%
      summarise(countTrue = sum(predictions == 1), percentage = sum((predictions == 1) /n()), weekName = min(date))
  })
  
  observeEvent(input$runButton, {
  v$hasModelRun <- FALSE
  
  #moved here/data insert
  inFile <- input$userData
  
  if(is.null(inFile)){
    return(NULL)}
  else{ rawdata <- read.csv(inFile$datapath)
  data <- rawdata[,1]
  date1 <- as.data.frame(rawdata[,2])
  data <-process(data)
}

  #use an if-then statement to code logic for which model should run
  #input$model is the parameter from the UI that controls the model choice
  
  if (input$model == "NauseaModel") {
    
      yhat_keras_class_vec <- predict_classes(object = model, x = as.matrix(data)) %>%
        as.vector()
    
      yhat_keras_prob_vec  <- predict_proba(object = model, x = as.matrix(data)) %>%
        as.vector()

      predictions <- cbind(yhat_keras_class_vec,yhat_keras_prob_vec)
      print(predictions)
    }
  
  
  if (input$model == "FluModel") {
yhat_keras_class_vec <- predict_classes(object = model1, x = as.matrix(data)) %>%
        as.vector()
      
      yhat_keras_prob_vec  <- predict_proba(object = model1, x = as.matrix(data)) %>%
        as.vector()
      
      predictions <- cbind(yhat_keras_class_vec,yhat_keras_prob_vec)
      print(predictions)
  }
  
  if (input$model == "AsthmaModel") {
      
      yhat_keras_class_vec <- predict_classes(object = model2, x = as.matrix(data)) %>%
        as.vector()
      
      yhat_keras_prob_vec  <- predict_proba(object = model2, x = as.matrix(data)) %>%
        as.vector()
      
      predictions <- cbind(yhat_keras_class_vec,yhat_keras_prob_vec)
      print(predictions)
  }
  
  if (input$model == "OpioidModel") {
      
      yhat_keras_class_vec <- predict_classes(object = model3, x = as.matrix(data)) %>%
        as.vector()
      
      yhat_keras_prob_vec  <- predict_proba(object = model3, x = as.matrix(data)) %>%
        as.vector()
      
      predictions <- cbind(yhat_keras_class_vec,yhat_keras_prob_vec)
      print(predictions)
  }
  
  if (input$model == "PoisonModel") {
      
      yhat_keras_class_vec <- predict_classes(object = model4, x = as.matrix(data)) %>%
        as.vector()
      
      yhat_keras_prob_vec  <- predict_proba(object = model4, x = as.matrix(data)) %>%
        as.vector()
      
      predictions <- cbind(yhat_keras_class_vec,yhat_keras_prob_vec)
      print(predictions)
  }
  #where inFile was

  
  #the predictions/results need to be fed into the initialDF dataframe below
  #the resulting data frame should have three columns: prediction, score, and date
  test <-cbind(predictions, date1)
  test <- as.data.frame(test)
  colnames(test)[3] <- "date"
  colnames(test)[1] <- "predictions"
  colnames(test)[2] <- "scores"
  
  test$date <- mdy(test$date)
  
  test <- test %>%
    mutate(month = month(test$date)) %>%
    mutate(week = week(test$date))
  initialDF <- test
  
  v$originalDF <- initialDF
  v$df <- initialDF

  v$predsMonth <- v$df %>%
    group_by(month) %>%
    summarise(countTrue = sum(predictions == 1), percentage = sum((predictions == 1) /n())) %>%
    mutate(monthName = month.abb[month])

  v$predsWeek <- v$df %>%
    group_by(week) %>%
    summarise(countTrue = sum(predictions == 1), percentage = sum((predictions == 1) /n()), weekName = min(date))

  updateDateInput(session, "startDate", value = min(v$df$date), min = min(v$df$date), max = max(v$df$date))
  updateDateInput(session, "endDate", value = max(v$df$date), min = min(v$df$date), max = max(v$df$date))
  
  v$hasModelRun <- TRUE
  v$plotType <- input$plotType
  v$timeWindow <- input$timeWindow
  v$scoresOrCounts <- input$scoresOrCounts
  })
  
  output$finalPlot <- renderPlot({
    if (v$hasModelRun == FALSE) return()

    if (v$timeWindow == 1) {
      timeWindow <- v$df$week
      timeLabel <- "Week"
      barChartData <- v$predsWeek
      barChartTime <- v$predsWeek$weekName
    } else {
      timeWindow <- v$df$month
      timeLabel <- "Month"
      barChartData <- v$predsMonth
      barChartTime <- v$predsMonth$monthName
    }

    if (v$plotType == 1 && v$scoresOrCounts == 1) {
      boxplot(scores~timeWindow,data=v$df, main=paste("Score Statistics by", timeLabel),
                                               xlab=timeLabel, ylab="Scores")
      
    } else if (v$plotType == 2 && v$scoresOrCounts == 1) {
        ggplot(v$df,aes(x=factor(timeWindow),y=scores)) + geom_violin(trim=FALSE) +
          ggtitle(paste("Score Statistics by", timeLabel)) + xlab(timeLabel) + ylab("Scores") +
          theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
          geom_boxplot(width=0.1)
  
    } else if (v$plotType == 3 && v$scoresOrCounts == 1) {
        testData = data.frame(timeWindow, v$df$scores)
        print(testData)

        plot(testData, pch = 20, col='dark green', main=paste("Scores and 70/90/95/99th Percentiles by", timeLabel),
                                                        xlab=timeLabel, ylab="Scores")
        Q75 = aggregate(testData$v.df.scores, list(testData$timeWindow), quantile, 0.75)
        Q90 = aggregate(testData$v.df.scores, list(testData$timeWindow), quantile, 0.90)
        Q95 = aggregate(testData$v.df.scores, list(testData$timeWindow), quantile, 0.95)
        Q99 = aggregate(testData$v.df.scores, list(testData$timeWindow), quantile, 0.99)
      
        lines(Q75, col="red")
        lines(Q90, col="green")
        lines(Q95, col="blue")
        lines(Q99, col="yellow")
        
        legend("right", 
               legend = c("70th %", "90th %", "95th %", "99th %"), 
               col = c("red", "green", "blue", "yellow"), 
               pch = c(19), 
               bty = "o", 
               pt.cex = 2, 
               cex = 1.2, 
               text.col = "black", 
               horiz = F)
        
    } else if (v$scoresOrCounts == 2) {
        ggplot(barChartData, aes(x = barChartTime, y = countTrue)) +
          geom_bar(stat = "identity") +
          ggtitle(paste("Prediction Counts by", timeLabel)) + xlab(timeLabel) + ylab("Count") +
          theme(plot.title = element_text(hjust = 0.5, face = "bold"))
      
    } else {
        ggplot(barChartData, aes(x = barChartTime, y = percentage)) +
          geom_bar(stat = "identity") +
          ggtitle(paste("Positive Predictions (%) by", timeLabel)) + xlab(timeLabel) + ylab("Percentage") +
          theme(plot.title = element_text(hjust = 0.5, face = "bold"))
    }
  })
})