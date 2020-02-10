library(shiny)
library(ggplot2)
shinyServer(function(input, output) {
  model1 <- lm(mpg ~ am, data = mtcars)
  model2 <- lm(mpg ~ wt + am, data = mtcars)
  model3 <- lm(mpg ~ wt + am + am*wt, data = mtcars)
  model4 <- lm(mpg ~ wt + I(wt^2), data = mtcars)
  
  model1pred <- reactive({
    amInput <- input$slideram
    predict(model1, newdata = data.frame(am = amInput))
  })
  
  model2pred <- reactive({
    wtInput <- input$sliderwt
    amInput <- input$slideram
    predict(model2, newdata = 
              data.frame(wt = wtInput,
                         am = amInput))
  })
  
  model3pred <- reactive({
    wtInput <- input$sliderwt
    amInput <- input$slideram
    predict(model3, newdata = 
              data.frame(wt = wtInput,
                         am = amInput))
  })
  
  model4pred <- reactive({
    wtInput <- input$sliderwt
    predict(model4, newdata = 
              data.frame(wt = wtInput))
  })
  
  
  output$plot1 <- renderPlot({
    wtInput <- input$sliderwt
    
    # plot(mtcars$wt, mtcars$mpg, xlab = "weight (1000 lbs.)", 
    #      ylab = "Consumption (MPG)", bty = "n", pch = 16,
    #      xlim = c(1,5), ylim = c(10, 35))
    
    gw <- ggplot(mtcars,aes(y=mpg,x=wt))
    gw <- gw + geom_point(size=4,aes(color=as.factor(am)))
    gw <- gw + xlab("wt (1000 lbs)")+ylab("mpg (Miles/gallon)")
    print(gw)
    
    if(input$showModel1){
      gw <- gw + geom_hline(yintercept = model1$coefficients[1],colour="salmon",size = 1)
      gw <- gw + geom_hline(yintercept = model1$coefficients[1]+model1$coefficients[2],color="#00BFC4",size = 1)

      gw <- gw + geom_point(aes(x=wtInput, y=model1pred()), colour="green",size=5,shape=15)
      print(gw)
    }
    if(input$showModel2){
      gw <- gw + geom_abline(intercept = summary(model2)$coefficients[1], slope = summary(model2)$coefficients[2],
                             color="black",size=1.5,linetype="dashed")
      
      gw <- gw + geom_point(aes(x=wtInput, y=model2pred()), colour="black",size=5,shape=15)
      print(gw)
    }
    if(input$showModel3){
      gw <- gw + geom_abline(intercept = summary(model3)$coefficients[1], slope = summary(model3)$coefficients[2],
                             color="salmon",size=1.5,linetype="dotted")
      gw <- gw + geom_abline(intercept = summary(model3)$coefficients[1]+summary(model3)$coefficients[3],
                             slope = summary(model3)$coefficients[2]+summary(model3)$coefficients[4], color="#00BFC4",size=1.5,linetype="dotted")
      
      gw <- gw + geom_point(aes(x=wtInput, y=model3pred()), colour="magenta",size=5,shape=15)
      print(gw)
    }
    
    if(input$showModel4){
      gw <- gw + stat_smooth(method = "lm", formula = y ~ x + I(x^2), size = 1.5,col="orange",se=FALSE,linetype="twodash")
      
      gw <- gw + geom_point(aes(x=wtInput, y=model4pred()), colour="orange",size=5,shape=15)
      print(gw)
    }

  })
  
  output$pred1 <- renderText({paste(as.character(model1pred()),"mpg",collapse = " ")
  })

  output$pred2 <- renderText({paste(as.character(model2pred()),"mpg",collapse = " ")
  })

  output$pred3 <- renderText({paste(as.character(model3pred()),"mpg",collapse = " ")
  })

  output$pred4 <- renderText({paste(as.character(model4pred()),"mpg",collapse = " ")
  })
})