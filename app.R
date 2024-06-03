library(shiny)
library(shinydashboard)
library(bslib)

# USER INTERFACE FUCNTION 
source("ui.R")

# SERVER FUNCTION 
source("server.R")

shinyApp(ui = ui, server = server)