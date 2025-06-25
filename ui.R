library(shiny)
library(ggplot2)
library(bslib)

# Ensure UTF-8 encoding for proper rendering of µ
#Sys.setlocale("LC_ALL", "en_US.UTF-8")

# Define UI
ui <- fluidPage(
  titlePanel("Blood Panel Metrics: Interpreting Iron Related Biomarkers"),
  sidebarLayout(
    sidebarPanel(
      selectInput("iron_property",
                  "Select Iron Biomarker:",
                  choices = list(
                    "Serum Iron (mcg/dL)" = "serum_iron",
                    "Ferritin (ng/mL)" = "ferritin",
                    "Transferrin Saturation (%)" = "transferrin_sat",
                    "Total Iron-Binding Capacity (mcg/dL)" = "tibc"
                  )),
      br(),
      uiOutput("dynamic_slider"), # Dynamic slider placeholder
      tags$style(HTML("
        select, option {
          font-family: 'Arial', sans-serif;
          font-size: 14px;
        }
      ")),
      br(),
      br(),
      layout_columns( 
        card( 
          card_header("Card 1 header"),
          p("Card 1 body"),
        ), 
      ) 
      
      
    ),
    mainPanel(
      plotOutput("rangePlot"),
      
      
      #plotOutput("histPlot")
    )
  )
)


# Run the app
#shinyApp(ui = ui, server = server)