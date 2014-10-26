library(shiny)

# define UI for application
shinyUI(fluidPage(
        # header or title panel 
        titlePanel(title = h4("Growth of Loblolly Pine Trees", align="center")),
        
        sidebarLayout(
                # sidebar panel
                sidebarPanel(
                        selectInput("seed", "Select the seed", 
                                    choices = c(sort(levels(Loblolly$Seed))), selected = 301),
                        radioButtons(inputId = "dl", label = "Select the file type", 
                                     choices = list("png", "pdf"))
                        
                ),
                
                # main panel
                mainPanel(
                        tabsetPanel(type="tab", 
                                    tabPanel("Summary", verbatimTextOutput("sum")),
                                    tabPanel("Structure", verbatimTextOutput("str")),
                                    tabPanel("Model", verbatimTextOutput("nlm")),
                                    tabPanel("Plot", plotOutput("myplot"),
                                             downloadButton(outputId = "down", 
                                                            label = "Download the plot"))
                                    
                        )
                        
                )
                
        )
)  
)