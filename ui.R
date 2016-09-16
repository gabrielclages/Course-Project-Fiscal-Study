
library(shiny)
library(markdown)

shinyUI(navbarPage("Brazilian Artificial Accounts Study",
                   tabPanel("Data Table",
                            # Sidebar
                            sidebarLayout(
                              sidebarPanel(
                                helpText("Select your data preferences:"),
                                sliderInput('Year', 'Year',  min=1994, max=2015, value=c(1994,2015), step=1),
                                checkboxGroupInput('President', 'President', c("Itamar"="Itamar", "FHC"="FHC", "Lula"="Lula", "Dilma"="Dilma"), selected = c("Itamar","FHC","Lula","Dilma")),
                                checkboxGroupInput('Fiscal_deficit', 'Balance of Government:', c("Surplus"=0, "Deficit"=1), selected = c(0,1))
                              ),mainPanel(dataTableOutput('table'))
                            )
                   ),
                   tabPanel("Graph",
                            
                            mainPanel(
                              dygraphOutput("dygraph"))),
                   tabPanel("About",
                                mainPanel(includeMarkdown("about.md"))
                            )
))