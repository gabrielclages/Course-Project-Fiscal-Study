
library(shiny)
library(datasets)
library(dplyr)
library(RCurl)

x <- getURL("https://raw.githubusercontent.com/gabrielclages/ShinyApp_Fiscal_Study/master/Dataset_Fiscal_Study.csv")
dataset <- read.csv(text = x, sep = ";", nrows=260)
myts <- ts(dataset$Balance, start=c(1994, 1), end=c(2015, 8), frequency=12)
dataset$Balance <- format(dataset$Balance,justify = "right", big.mark=',', scientific=FALSE)

# Define server logic
shinyServer(function(input, output) {
  output$table <- renderDataTable({
    Year_seq <- seq(from = input$Year[1], to = input$Year[2], by = 1)
    data <- transmute(dataset, President = President, Date = Date, Month = Month, Year = Year,
                      Balance = Balance, Fiscal_Deficit = Fiscal_deficit, Presidential_election = Presidential_election)
    data <- filter(data, President %in% input$President, Fiscal_Deficit %in% input$Fiscal_deficit,  
                   Year %in% Year_seq)
    data

  }, options = list(lengthMenu = c(5, 15, 30), pageLength = 30))
  
  
  output$dygraph <- renderDygraph({
    dygraph(myts, main="Balance of Government") %>% 
      dySeries(label="Balance in (BRL)") %>%
      dyAxis("y", label = "Balance in (BRL)") %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE) %>%
      dyShading(from = min(myts), to = 0, axis = "y", color = "#FFE6E6") %>%
      dyEvent("1995-1-1", "FHC", labelLoc = "bottom") %>%
      dyEvent("2003-1-1", "LULA", labelLoc = "bottom")%>%
      dyEvent("2011-1-1", "DILMA", labelLoc = "bottom") %>%
      dyAnnotation("2014-10-1", text = "A", tooltip = "New Election") %>%
      dyRangeSelector()
  })
  
})
