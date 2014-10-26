library(shiny)
library(extrafont)
data(Loblolly)
require(stats); require(graphics)

shinyServer(
        
        function(input, output) {
                
                # create the reactive function 
                selectseed <- reactive({
                        as.numeric(input$seed)
                        
                })
                
                # create the summary table for the whole dataset
                output$sum <- renderPrint({
                        summary(Loblolly)
                        
                })
                
                # output the structure table for the whole dataset
                output$str <- renderPrint({
                        str(Loblolly)
                        
                })
                
                # fit a nonlinear regression model for the selected seed level
                output$nlm <- renderPrint({
                        nls(height ~ SSasymp(age, Asym, R0, lrc), 
                            data = Loblolly, subset = Seed == selectseed())
                        
                })
                
                # plot the selected seed level data and fitted nonlinear curve
                output$myplot <- renderPlot({
                        plot(height ~ age, data = Loblolly, subset = Seed == selectseed(),
                             xlab = "Tree age (yr)", las = 1,
                             ylab = "Tree height (ft)",
                             bty="l", col="red", pch=19, cex = age/5,
                             main = c("Loblolly Data and Fitted Curve", selectseed()), 
                             col.main="forestgreen", cex.main = 1.25)
                        fm1 <- nls(height ~ SSasymp(age, Asym, R0, lrc),
                                   data = Loblolly, subset = Seed == selectseed())
                        age <- seq(0, 30, length.out = 101)
                        lines(age, predict(fm1, list(age = age)), col = "blue", lty = 4, lwd = 2)
                        
                })
                
                # downloadHandler contains 2 arguments as functions, namely filename, content
                output$down <- downloadHandler(
                        filename =  function() {
                                paste("Loblolly", input$dl, sep=".")
                        },
                        # content is a function with argument file. content writes the plot to the device
                        content = function(file) {
                                if(input$dl == "png")
                                        png(file) # open the png device
                                else
                                        pdf(file) # open the pdf device
                                plot(height ~ age, data = Loblolly, subset = Seed == selectseed(), 
                                     xlab = "Tree age (yr)", las = 1, 
                                     ylab = "Tree height (ft)", 
                                     bty="l", col="red", pch=19, cex = age/5,
                                     main = c("Loblolly Data and Fitted Curve", selectseed()), 
                                     col.main = "forestgreen", cex.main = 1.25)
                                fm1 <- nls(height ~ SSasymp(age, Asym, R0, lrc),
                                           data = Loblolly, subset = Seed == selectseed())
                                age <- seq(0, 30, length.out = 101)
                                lines(age, predict(fm1, list(age = age)), col = "blue", lty = 4, lwd = 2)
                                dev.off()  # turn the device off
                                
                        }) 
                
        }
)
