#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# test

library(shiny)
library(dplyr)
library(queuecomputer)
library(ggplot2)

queue_lengths <- function(arrivals, service = 0, departures, scales = NULL){
  
  queuedata <- data.frame(input = arrivals, output = departures - service + 1e-8) %>% tidyr::gather()
  
  queuedata$key <- as.factor(queuedata$key)
  
  state_df <- data.frame(
    key = as.factor(c("input", "output")),
    state = c(1, -1)
  )
  
  queuedata <- suppressMessages(left_join(queuedata, state_df))
  
  levels(queuedata$key) <- c("input", "output")
  
  queuedata <- queuedata %>% arrange(value, key) %>% mutate(
    QueueLength = cumsum(state),
    time = value
  )
  
  queuedata <- queuedata %>% select(key, time, QueueLength)
  
  return(queuedata)
  
}

reactive

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  arrivals <- reactive({
    switch(
      as.numeric(input$inter == "arrivals") + 1, 
      cumsum(rexp(10^input$n, input$arrivals)), 
      rexp(10^input$n, input$arrivals)
    )
    })
  service <- reactive({rexp(10^input$n, input$service)})
  
  departures <- reactive({queue(arrivals(), service(), input$servers)})
  
  waiting <- reactive({departures() - arrivals() - service()})
  
  queue_lengths_computed <- reactive({queue_lengths(arrivals(), service(), departures())})
   
  output$hist_departures <- renderPlot({
    hist(departures(), main = "Histogram of departure times")
  })
  
  output$hist_waiting <- renderPlot({
    hist(waiting(), main = "Histogram of waiting times")
  })
  
  output$arrivalwaiting <- renderPlot({
    qplot(arrivals(), waiting()) + ggtitle("Arrival and waiting time plot") + xlab("Arrival times") + ylab("Waiting times")
  })
  
  output$queuelengthplot <- renderPlot({
    ggplot(queue_lengths_computed()) + aes(x = time, y = QueueLength) + geom_step() + 
      ggtitle("Queue length plot") + xlab("Time") + ylab("Queue length")
  })
  
})


















