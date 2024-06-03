# USER INTERFACE FUCNTION 

ui <- function(request) {
  sidebar <- dashboardSidebar(
    hr(),
    sidebarMenu(id="tabs",
                menuItem("Main Dashboard", tabName="plot", icon=icon("line-chart")),
                menuItem("General Statistics", tabName = "global", icon=icon("table"), selected=TRUE),
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
  # 
  body <- dashboardBody(
    tabItems(
      # Page ( General Statistics) -------------------------------------------
      tabItem(tabName = "global",
              box(width = NULL, status = "primary", solidHeader = FALSE, title="Table",
                  
              )
      ),
      # Page (Single Vehicle --> Model vs VehicleYear) -----------------------
      tabItem(tabName = "s_model_year",
              # Filter Panel ------------------------------
              card(
                layout_columns(
                  card(
                    selectInput("select_make", label = h3("Select Vehicle Brand"), 
                                choices = list("5" = 5, "10" = 10, "15" = 15), 
                                selected = 1,selectize = FALSE),
                    
                  ),
                  card(
                    sliderInput(inputId = "bins", label = "Number of bins:",
                                min = 1, max = 50, value = 30)
                  ),
                  card(
                    verbatimTextOutput("select_make")  # Display selected option for(select_make)
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