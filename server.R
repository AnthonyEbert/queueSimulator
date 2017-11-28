#YEAR: 2017
#COPYRIGHT HOLDER: Anthony Ebert

library(shiny)
library(queuecomputer)
library(ggplot2)

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
    ggplot(queue_lengths_computed()) + aes(x = times, y = queuelength) + geom_step() + 
      ggtitle("Queue length plot") + xlab("Time") + ylab("Queue length")
  })
  
})


















