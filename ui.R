library(shiny)
library(shinydashboard)
library(bslib)
library(plotly)


# USER INTERFACE FUCNTION 

ui <- function(request) {
#----------------------------- MUNU BAR SIDE -----------------------------------
  sidebar <- dashboardSidebar(disable = FALSE,
    sidebarMenu(id="tabs",
            #menuItem("Main Dashboard", tabName="plot", icon=icon("line-chart")),
            menuItem("Main Dashboard", tabName = "main", icon=icon("line-chart"), selected=TRUE),
            menuItem("General Statistics", tabName = "data_table", icon=icon("table")),
            menuItem("Single Vehicle Features",
                     menuSubItem("Model VS Vehicle Year", tabName = "s_model_year", icon = icon("angle-right")),
                     menuSubItem("global.R", tabName = "hhh", icon = icon("angle-right"))
            ),
            menuItem("Two Vehicles",
                     menuSubItem("global.R", tabName = "tt", icon = icon("angle-right")),
                     menuSubItem("ui.R", tabName = "ui", icon = icon("angle-right")),
                     menuSubItem("server.R", tabName = "server", icon = icon("angle-right")),
                     menuSubItem("structure", tabName = "structure", icon = icon("angle-right"))
            )
    ),
    hr(),
    conditionalPanel("input.tabs == 'plot'",
                     fluidRow(
                     )
    )
  )
#----------------------------- MAIN CONTENT ------------------------------------
body <- dashboardBody(
    tabItems(
      # Page (General Statistics)
      tabItem(tabName = "data_table",
              fluidRow(
                box(width = 12),
                box(status = "primary", background = NULL, width = 12,
                    DT::dataTableOutput("DataTable"))
                ),
              fluidRow(
                
              )
      ),
      # Page (Main Dashboard) ---------------------------------------
      tabItem(tabName = "main",
              fluidRow(
                valueBoxOutput("box_val1"),
                valueBoxOutput("box_val2"),
                valueBoxOutput("box_val3")
              ),
              fluidRow(
                box(
                  title = "Top 5 brand Reg"
                  ,status = "primary"
                  ,solidHeader = FALSE 
                  ,collapsible = TRUE 
                  ,plotlyOutput("main_plot1", height = "300px")
                  #textOutput("MD_top5_txt")
                ),
                box(
                  title = "Data Distribution by Body Type"
                  ,status = "primary"
                  ,solidHeader = FALSE 
                  ,collapsible = TRUE 
                  ,plotlyOutput("pieChart", height = "300px")
                )
              )
      ),
      # Page (Single Vehicle --> Model vs VehicleYear) -----------------------
      tabItem(tabName = "s_model_year",
              # Filter Panel ------------------------------
              card(
                layout_columns(
                  box(status = "primary", width = 11,
                    selectInput("select_make", label = h4("SELECT VEHICLE BRAND"), 
                                choices = list("5" = 5, "10" = 10, "15" = 15), 
                                selected = 1,selectize = FALSE),
                    
                  ),
                  box(status = "primary", width = 11,
                    #"VEHICLE_YEAR"  ,  "TLA" , "ORIGINAL_COUNTRY" , "MOTIVE_POWER" , "IMPORT_STATUS" , "FIRST_NZ_REGISTRATION_YEAR" , 
                    radioButtons("radio_feat_1", label = h4("SELECT FEATURE 1"),
                                 choices = list("MOTIVE_POWER", "IMPORT_STATUS", "FIRST_NZ_REGISTRATION_YEAR"),
                                 selected = 1)
                  ),
                  box(status = "primary", width = 11,
                    radioButtons("radio_feat_2", label = h4("SELECT FEATURE 2"),
                                 choices = list("VEHICLE_YEAR", "TLA", "ORIGINAL_COUNTRY"),
                                 selected = 1),
                    sliderInput(inputId = "bins", label = "Number of bins:",
                                min = 1, max = 50, value = 30),
                    textOutput("R_btn_val")
                  )
                ),
                br(),
              ),
              # Chart Panel ------------------------------
              card(
                box(width = NULL, status = "primary", solidHeader = FALSE, title="Table",
                    plotOutput(outputId = "distPlot")
                )
              )
      ),  # END Page (Single Vehicle --> Model vs VehicleYear
      tabItem(tabName = "ui",
              box( width = NULL, status = "primary", solidHeader = TRUE, title="ui.R",
                   tags$p("UI Page")  
              )
      ),
      tabItem(tabName = "server",
              box( width = NULL, status = "primary", solidHeader = TRUE, title="server.R",
              )
      )
    )
  )
  dashboardPage(
    dashboardHeader(title = "Heba Aleterji"),
    sidebar,
    body
  )
}