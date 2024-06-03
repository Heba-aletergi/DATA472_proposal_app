#______________________ HELPER FUNCTION ________________________________________

hist_x <- function(input) {
  x <- faithful$waiting
  bins <- seq(min(x), max(x), length.out = input$bins + 1)
  
  ret <- list("x"= x, "bins"= bins)
  return(ret)
}

server <- function(input, output, session){
  # Read data from .CSV
  
  
  # Call when chaged Select Input (select_make)
  observeEvent(input$select_make, {
    # Read select Input value 
    selected <- as.numeric(input$select_make)
    output$distPlot <- renderPlot({
      hist_param <- hist_x(input)
      hist(hist_param$x, breaks = selected, col = "#007bc2", border = "white",
           xlab = "Waiting time to next eruption (in mins)",
           main = "Histogram of waiting times")
    })
  })
  # Call when change sliderInput (bins)
  observeEvent(input$bins, {
    output$distPlot <- renderPlot({
      hist_param <- hist_x(input)
      hist(hist_param$x, breaks = hist_param$bins, col = "#007bc2", border = "white",
           xlab = "Waiting time to next eruption (in mins)",
           main = "Histogram of waiting times")
    })
  })
}