library(dplyr)
library(ggplot2)
library(plotly)

#______________________ HELPER FUNCTION ________________________________________

hist_x <- function(input) {
  x <- faithful$waiting
  bins <- seq(min(x), max(x), length.out = input$bins + 1)
  
  ret <- list("x"= x, "bins"= bins)
  return(ret)
}

# Main Dashboard -----------------------------
main_dashboard <- function(output, data) {
  
  # Value box ---------------------------------------
  count_petrol <- filter(data, MOTIVE_POWER == 'PETROL')
  count_diesel <- filter(data, MOTIVE_POWER == 'DIESEL')
  
  output$box_val1 <- renderValueBox({ 
    valueBox(formatC(nrow(data), format="d", big.mark=','),"Total Car Reg", icon = icon("stats",lib='glyphicon'),color = "green")  
  })
  output$box_val2 <- renderValueBox({ 
    valueBox(
      formatC(nrow(count_petrol), format="d", big.mark=','),"Total Petrol Car", icon = icon("line-chart"),color = "purple")  
  })
  output$box_val3 <- renderValueBox({
    valueBox(
      formatC(nrow(count_diesel), format="d", big.mark=','),"Total Diesel Car", icon = icon("menu-hamburger",lib='glyphicon'),color = "yellow")  
  })
  
  # Top 5 Brand Plot ----------------------------------
  make_freq <- sort(table(data$MAKE), decreasing = TRUE)
  make_top <- head(make_freq,5)
  make_freq_df <- as.data.frame(make_top)
  colnames(make_freq_df) <- c("MAKE", "Count")
  
  output$main_plot1 <- renderPlotly({
    plot_ly(make_freq_df, x = ~MAKE, y = ~Count, type = 'bar', name = '') %>%
      layout(title = "Bar Chart",
           xaxis = list(title = "Brand"),
           yaxis = list(title = "Brand Count"))       
  })
  
  
  # Distribution of body Type pie chart ---------------------
  body_type <- head(table(data$BODY_TYPE))
  body_type_df <- as.data.frame(body_type)
  colnames(body_type_df) <- c("Character", "Frequency")
  
  output$pieChart <- renderPlotly({
    plot_ly(body_type_df, labels = ~Character, values = ~Frequency, type = 'pie') %>%
      layout(title = "")
  })
  
  y_ <- "IMPORT_STATUS"
 
  output$MD_top5_txt <- renderText({
    paste("You chose", c)
  })
}

# General Statistics Page --------------------
general_stat <- function(output, data) {
  
  # Calculate min and max values for each column
  summary_stats <- apply(data[, -1], 2, function(x) c(min = min(x), max = max(x)))
  
  output$DataTable <- DT::renderDataTable({
    DT::datatable(data[,c("MAKE","BODY_TYPE","ORIGINAL_COUNTRY","TLA","MOTIVE_POWER","IMPORT_STATUS","VEHICLE_YEAR")], filter = "top", 
          options = list(pageLength = 10)
      )
  })
}

#______________________ SERVER FUNCTION ________________________________________

server <- function(input, output, session){
  # Read data from .CSV
  data <- read.csv("VehicleYear-2023.csv")
  make <- data[0:2,c("MAKE")]
  
  # MAin Dashboard
  main_dashboard(output, data)
  
  # General Statistics Page
  general_stat(output,data)
  
  
  # Fill SelectInput (select_make) with dataset value
  observe({
    updateSelectInput(session, "select_make",
                      choices = unique(data$MAKE),
                      selected = "Select Vehicle")
  })
  
  # Reactive with widget (textOutput)  
  output$R_btn_val <- renderText({
    paste("You chose", input$radio_feat_1)
  })
  
  # Reactive with widget ()
  output$radioGroup  <- renderUI({
    radioButtons("radio_feat_1", "Select an option", 
                 choices = unique(data$MAKE),
                 selected = "opt2")
  })
  
  # Call when SelectInput(select_make) chaged 
  observeEvent(input$select_make, {
    selected <- as.numeric(input$select_make)  # Read select Input value and convert it to numeric to use it for histogram
    output$distPlot <- renderPlot({
      hist_param <- hist_x(input)
      hist(hist_param$x, breaks = selected, col = "#007bc2", border = "white",
           xlab = "Waiting time to next eruption (in mins)",
           main = "Histogram of waiting times")
    })
  })
  # Call when sliderInput(bins) chaged.
  observeEvent(input$bins, {
    output$distPlot <- renderPlot({
      hist_param <- hist_x(input)
      hist(hist_param$x, breaks = hist_param$bins, col = "#007bc2", border = "white",
           xlab = "Waiting time to next eruption (in mins)",
           main = "Histogram of waiting times")
    })
  })
}