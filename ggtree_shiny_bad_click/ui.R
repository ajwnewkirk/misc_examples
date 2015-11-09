library(shiny)

shinyUI(
  navbarPage("ggtree",
             tabPanel("Use ggtree", 
                      tags$head(
                        tags$style(HTML("
                                        .shiny-output-error-validation {
                                        color: red;
                                        }
                                        "))
                        ),
                      
                      # Getting started section
                      fluidRow(
                        hr(),
                        HTML("<h3><strong>&nbsp;&nbsp;Getting Started</strong></h3>"),
                        hr()
                      ),
                        
                      fluidRow(
                        column(4, 
                               h4('Newick Tree'),
                               fileInput(inputId = 'nktree', 
                                         label = 'Select a Newick-formatted tree file.')
                        ),
                        column(8,
                               plotOutput('tree')
                        )
                      ),
                      
                      # Decorate your tree section  
                      fluidRow(
                        hr(),
                        HTML("<h3><strong>&nbsp;&nbsp;View Your ggTree</strong></h3>"),
                        hr(),
                        column(3, 
                               h4("Basic Setup"),
                               sliderInput(inputId = "bslimit", 
                                           label = "Lowest bootstrap value to display", 
                                           min = 0,
                                           max = 100,
                                           value = 70)
                        )
                      ),
                      
                      fluidRow(
                        column(12,
                               actionButton(inputId = "updateplot",
                                            label = "Plot")
                        )
                      ),
                      
                      fluidRow(
                        column(6, 
                              plotOutput('prettytree',
                                         width = 1200,
                                         height = 800,
                                         click = "plot_click"),
                              verbatimTextOutput("info")
                        ),
                        column(6,
                               tableOutput("real_coords")
                        )
                      ),
                      
                      fluidRow(
                        column(12, 
                               h4("Save Your Image"),
                               textInput(inputId = "filename",
                                         label = "Enter the File Name."),
                               selectInput(inputId = "filetype",
                                           label = "Choose an image format.",
                                           choices = c("pdf")),
                               downloadButton(outputId = "dlfile",
                                              label = "Download Image"),
                               br(),
                               br()
                        )
                      )
              ),
             navbarMenu("Help",
                        tabPanel("Basics",
                                 HTML("<hr>
                                      <h3><strong>A Phylogenetic Tree Markup Tool Using ggtree and Shiny</strong></h3>
                                      <hr>
                                      <p>This is a minimal example of an unexplained issue where plots produced with ggtree and displayed in a Shiny webpage do not return the expected coordinates when clicking on the plot. To observe the behavior, upload the example.tree Newick tree file included in the repo to the app and click the 'Plot' button. Click on the parent node for C and D and observe the x and y coordinates returned by Shiny below the plot. In my tests Shiny consistantly returned x = 0.4 and y = 0.68, while the expected coordinates from ggtree (see both tree axes and table) are 0.04 and 9.5. Resolving this conflict is desirable because it will allow users to click to select nodes, which may then be passed to other functions for applying ggtree markup tools (e.g. hilight()).</p>
                                      ")),
                        tabPanel("About",
                                 HTML("<hr>
                                      <h3><strong>A Phylogenetic Tree Markup Tool Using ggtree and Shiny</strong></h3>
                                      <hr>
                                      <div>Developer: A. Jo Williams-Newkirk</div>
                                      <div>Contact: Twitter @ajwnewkirk
                                      <div>Version: 0.1</div>
                                      <div>Release Date: November 2015</div>
                                      <div>Written in R using the Shiny web application framework.</div>"))
                                 )
             )
)
