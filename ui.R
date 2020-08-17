#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("COVID-19 Evolution in Cameroon"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            p("Upload the dataset on the Github repository and click on the button View data!!!"),
            fileInput("file", "Upload the file", multiple = F),
            checkboxInput(inputId = "header", label = "Header", value = T),
            radioButtons(inputId = "sep", label = "Separator",
                         choices = c(Semicolon = ";", Comma = ",",Spase = " "),
                         selected = ";"),
            actionButton("doTable", "View Data"),
            p("Choose a date to plot the evolution of the COVID-19 and click on the button Plot!!!"),
            dateInput("date1", "Choise a date: ", value = "2020-03-06", 
                      min = "2020-03-06", max = "2020-04-10",
                      format = "dd/mm/yyyy"),
            actionButton("doPlot", "Plot!!!")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h4("View the last 7 days of the data set"),
            tableOutput("View"),
            h4("The evolution of COVID-19 in Cameroon"),
            plotOutput("distPlot")
        )
    )
))
