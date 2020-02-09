library(shiny)
library(ggplot2)
shinyUI(fluidPage(
  titlePanel("Predict consumption vs weight and kind of transmission"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sliderwt", "Introduce here the weight of the car in units of 1000 lbs.", 1.5, 5, value = 3.25,step=0.05),
      sliderInput("slideram", "Introduce here the kind of transmission (0=automatic, 1=manual)", 0, 1, value=0,step=1),
      checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
      checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
      checkboxInput("showModel3", "Show/Hide Model 3", value = TRUE),
      checkboxInput("showModel4", "Show/Hide Model 4", value = TRUE),
      submitButton("Submit")
    ),
    mainPanel(
      plotOutput("plot1"),
      h3("Legend"),
      h4("Horizontal solid lines: Model 1 (salmon for automatic and Turkish blue for manual transmission)"),
      h4("Dashed line: Model 2"),
      h4("Dotted lines: Model 3 (salmon for automatic and Turkish blue for manual transmission)"),
      h4("Orange curve: Model 4"),
      h4("Points: Data from mtcars (salmon for automatic and Turkish blue for manual transmission)"),
      h4("Squares: Predictions from the different models for the input values of the side panel (green - model 1; black - model 2; magenta - model 3; orange - model 4"),
      h3("Predicted Consumption from Model 1 (consumption ~ transmission):"),
      textOutput("pred1"),
      h3("Predicted Consumption from Model 2 (consumption ~ transmission + weight):"),
      textOutput("pred2"),
      h3("Predicted Consumption from Model 3 (consumption ~ transmission + weight + transmission*weight):"),
      textOutput("pred3"),
      h3("Predicted Consumption from Model 4 (consumption ~ weight^2):"),
      textOutput("pred4")
    )
  )
))