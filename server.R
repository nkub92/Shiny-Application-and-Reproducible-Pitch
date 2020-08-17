#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
suppressMessages(library(lubridate))
library(ggplot2)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
        # Uploading data 
    
        df_upload <- reactive({
            
            infile <- input$file
            if (is.null(infile)) return(NULL)
            df <- read.csv(infile$datapath, header = input$header, sep = input$sep)
            return(df)
        })
        
        # Table outcome
        
        viewTable <- eventReactive(input$doTable, {
            dataset <- df_upload()
            names(dataset) <- c("dates","confirmed","death", "recovered", "Population")
            dataset
        })
        
        output$View <- renderTable({
            
            tail(viewTable(), n = 7)
        })
        
        # Generating the plot
        
        viewPlot <- eventReactive(input$doPlot, {
            
            dataset <- df_upload()
            names(dataset) <- c("dates","confirmed","death", "recovered", "Population")
            dataset$dates <- as.Date(dataset$dates, "%d/%m/%y")
            
            # selecting data up still the input date from ui.R
            date1 <- as.Date(input$date1, "%d/%m/%y")
            dataset <- dataset[dataset$dates <= date1,]
            
            # transforming the data set
            df <- dataset %>%
                dplyr::select(dates, confirmed, death, recovered) %>%
                gather(key = "variable", value = "values", -dates)
            # draw the histogram with the specified number of bins
            ggplot(df, aes(x = dates, y = values)) + 
                geom_line(aes(color = variable)) + 
                scale_color_manual(values = c("blue", "red", "green"))
            
        })
        
        output$distPlot <- renderPlot({
            
            viewPlot()

        })
    
})
