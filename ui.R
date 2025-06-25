library(shiny)
library(ggplot2)
library(bslib)

# Ensure UTF-8 encoding for proper rendering of µ
#Sys.setlocale("LC_ALL", "en_US.UTF-8")

# Define UI
ui <- fluidPage(
  # Include external CSS file
  tags$link(rel = "stylesheet", href = "styles.css"),
  
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
      navset_card_pill( 
        nav_panel("Biomarkers", "Iron-related biomarkers are critical for assessing iron metabolism, diagnosing conditions like anemia or hemochromatosis, and monitoring treatment. Based on clinical relevance and their use in medical practice, the most important biomarkers related to iron are listed below, with a focus on their role in evaluating iron status."), 
        nav_panel(
          "Biomarkers Explained",
          markdown("
    **Iron metabolism** is critical for *health assessment* and diagnosing conditions like _anemia_ or _hemochromatosis_.

    - **Serum Iron**: Measures *circulating iron* in the blood, indicating immediate availability.
    - **Ferritin**: Reflects _iron stores_, the most reliable marker for reserves.
    - **Transferrin Saturation (TSAT)**: Shows the *percentage* of transferrin saturated with iron.
    - **TIBC**: Indicates the blood’s _capacity to bind iron_.
  ")
        )
        ), 
      id = "tab" 
    
    
      
      
    ),
    mainPanel(
      plotOutput("rangePlot"),
      
      
      #plotOutput("histPlot")
    )
  )
)


# Run the app
#shinyApp(ui = ui, server = server)