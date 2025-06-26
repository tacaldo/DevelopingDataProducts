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
                    "TSAT (%)" = "transferrin_sat",
                    "TIBC (mcg/dL)" = "tibc"
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
      navset_card_pill(
        nav_panel("Biomarkers",
                  markdown("
                           *<i>Iron-related biomarkers are critical for assessing iron metabolism, diagnosing conditions like anemia or hemochromatosis, and monitoring treatment.</i>*
                           
                           While many more iron-related biomarkers exist, the primary focus of the app is...
                           
                           
                           
                           
                           
                           
                           ")
                  ), 
        nav_panel(
          "Descriptions",
          markdown("
    - **Serum Iron**: Measures *circulating iron* in the blood, indicating immediate availability.
    - **Ferritin**: Reflects _iron stores_, the most reliable marker for reserves.
    - **Transferrin Saturation (TSAT)**: Shows the *percentage* of transferrin saturated with iron.
    - **TIBC**: Indicates the blood’s _capacity to bind iron_.
  ")
        ),
        
        
      id = "tab" 

        
        ),
      br(),
      br(),
      
      layout_columns( 
        card( 
          card_header(markdown("*Important Notice*")),
          markdown("*This content is provided for educational purposes only and is not intended as a substitute for professional medical advice, diagnosis, or treatment. Always consult a qualified healthcare provider with any questions regarding a medical condition or before making changes to your diet, supplementation, or treatment plan.*"),
        ), 

      )       
      
      
    
    
      
      
    ),
    mainPanel(
      plotOutput("rangePlot"),
      
      navset_tab( 
        nav_panel("Range", uiOutput("range_content")),
        nav_panel("Nutritional Guidance", uiOutput("nutritional_content")), 
        nav_panel("C", "Page C content"),
        id = "tab2" 
    
      ),
      br(),
      br(),
      
      
      
      
      
      #plotOutput("histPlot")
    )
  )
)


# Run the app
#shinyApp(ui = ui, server = server)