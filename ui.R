#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(queuecomputer)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Queue Simulator (M/M/K)"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("inter", 
                   "interarrivals/arrivals",
                   c("interarrivals", "arrivals")),
       sliderInput("arrivals",
                   "rate of interarrivals/arrivals",
                   min = 1,
                   max = 20,
                   value = 5, 
                   step = 0.1),
       sliderInput("service",
                   "rate of service",
                   min = 1,
                   max = 20,
                   value = 5,
                   step = 0.1),
       sliderInput("servers",
                   "number of servers",
                   min = 1,
                   max = 10,
                   value = 1),
       sliderInput("n", 
                    "Logarithm of number of customers",
                   min = 1, 
                   max = 5,
                   value = 2,
                   step = 0.25)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("hist_departures"), 
       plotOutput("hist_waiting"),
       plotOutput("arrivalwaiting"),
       plotOutput("queuelengthplot")
    )
  )
))
