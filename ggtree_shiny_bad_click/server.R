# Libraries
library(shiny)

shinyServer(function(input, output, session) {
  
  # Create convenience function for tree file upload
  otree <- reactive({
    input$nktree$datapath
  })
  
  # Create convenience function for tree object
  treeobj <- reactive({
    return(read.tree(file = otree()))
  })
  
  # Read tree file and provide preview plot
  output$tree <- renderPlot({
    if(is.null(input$nktree)) {
      return(NULL)
    } else {
      tmptree <- treeobj()
      plot(tmptree)
      nodelabels(tmptree$node.label)
    }
  })
  
  bslim <- eventReactive(input$updateplot, {
    input$bslimit
  })
  
  outplot <- eventReactive(input$updateplot, {
    mytree <- importTree(treefile = otree(), bsval = bslim())
    outtree <- basetree(mytree = mytree)
    return(outtree)
  })
  
  output$prettytree <- renderPlot({
    if(is.null(outplot())) {
      return(NULL)
    } else {
      plot(outplot())
    }
  })
  
  output$real_coords <- renderTable({
    if(is.null(outplot())) {
      return(NULL)
    } else {
      outplot()$data
    }
  })
  
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })
  
  ftype <- reactive({
    input$filetype
  })
  
  fname <- reactive({
    input$filename
  })
  
  output$dlfile <- downloadHandler(
    filename = function() { 
      paste(fname(), ".", ftype(), sep='') 
    },
    content = function(file) {
      if(ftype() == "pdf") {
        pdf(file = file, width = 16.67, height = 11.11) # width / height in inches
        plot(outplot())
        dev.off()
      }
    }
  )
})

