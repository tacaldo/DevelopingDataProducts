# Define server logic
server <- function(input, output, session) {
  # Render content for the "Range" tab
  output$range_content <- renderUI({
    switch(
      input$iron_property,
      "serum_iron" = tagList(
        h3("Serum Iron Range"),
        p("Normal Range:"),
        tags$ul(
          tags$li("Men: 65–176 mcg/dL"),
          tags$li("Women: 50–170 mcg/dL"),
          tags$li("Children: 50–120 mcg/dL (age-dependent)")
        ),
        p("Note: Serum iron varies diurnally and with diet. Ferritin is more reliable for iron status.")
        ),
      "ferritin" = tagList(
        h3("Ferritin Range"),
        p("Normal Range:"),
        tags$ul(
          tags$li("Men: 30–400 ng/mL"),
          tags$li("Women: 15–150 ng/mL"),
          tags$li("Children: 7–140 ng/mL (age-dependent)")
        ),
        p("Iron Deficiency: <30 ng/mL (healthy); <100 ng/mL (inflammation).")
      ),
      "transferrin_sat" = tagList(
        h3("Transferrin Saturation (TSAT) Range"),
        p("Normal Range:"),
        tags$ul(
          tags$li("Men: 20–50%"),
          tags$li("Women: 15–45%"),
          tags$li("Children: 10–50% (age-dependent)")
        ),
        p("Iron Deficiency: <20%. Iron Overload: >50%."),
        p("Note: TSAT = (serum iron ÷ TIBC) × 100.")
      ),
      "tibc" = tagList(
        h3("Total Iron-Binding Capacity (TIBC) Range"),
        p("Normal Range:"),
        tags$ul(
          tags$li("Adults: 240–450 mcg/dL"),
          tags$li("Children: 100–400 mcg/dL (age-dependent)")
        ),
        p("Iron Deficiency: >400 mcg/dL. Iron Overload: <240 mcg/dL.")
      ),
      
      # Default case
      tagList(
        h3("Range Tab"),
        p(
          "This is the default server-rendered content for the Range tab."
        ),
        p(input$iron_property)
      )
    )
  })
  
  # Render content for the "Nutritional Guidance" tab
  output$nutritional_content <- renderUI({
    switch(input$iron_property,
           "serum_iron" = tagList(
             h3("Nutritional Guidance for Serum Iron"),
             p("To maintain healthy serum iron levels:"),
             tags$ul(
               tags$li("Eat heme iron foods (e.g., red meat, liver, fish) for better absorption."),
               tags$li("Pair non-heme iron (e.g., spinach, lentils) with vitamin C-rich foods (e.g., oranges)."),
               tags$li("Avoid tea, coffee, or dairy during iron-rich meals to reduce inhibitors."),
               tags$li("Consider oral iron supplements (e.g., ferrous sulfate) if deficient, taken on an empty stomach.")
             ),
             p("Consult a healthcare provider for monitoring and personalized advice.")
           ),
           "ferritin" = tagList(
             h3("Nutritional Guidance for Ferritin"),
             p("To boost iron stores:"),
             tags$ul(
               tags$li("Include high-bioavailability iron sources (e.g., meat, poultry, fish)."),
               tags$li("Supplement with oral iron for 4–6 months to reach ferritin >50 ng/mL."),
               tags$li("Monitor for side effects like nausea or constipation.")
             ),
             p("Consult a healthcare provider for monitoring.")
           ),
           "transferrin_sat" = tagList(
             h3("Nutritional Guidance for Transferrin Saturation"),
             p("To improve TSAT:"),
             tags$ul(
               tags$li("Address causes like blood loss or inflammation."),
               tags$li("Use intravenous iron if oral supplements are ineffective, especially in chronic conditions (e.g., CKD, IBD)."),
               tags$li("Increase dietary iron intake with heme sources or fortified foods.")
             ),
             p("Consult a healthcare provider for tailored treatment.")
           ),
           "tibc" = tagList(
             h3("Nutritional Guidance for TIBC"),
             p("To address abnormal TIBC:"),
             tags$ul(
               tags$li("High TIBC (>400 mcg/dL): Increase iron intake via diet (e.g., red meat, fortified cereals) or supplements."),
               tags$li("Low TIBC (<240 mcg/dL): Limit dietary iron and seek medical evaluation for possible iron overload (e.g., hemochromatosis)."),
               tags$li("Monitor with regular blood tests to assess iron status.")
             ),
             p("Consult a healthcare provider for personalized treatment.")
           ),
           # Default case
           tagList(
             h3("Nutritional Guidance"),
             p("Select an iron property to view specific nutritional recommendations.")
           )
    )
  })
  
  # Render content for the "C" tab
  output$instructions_content <- renderUI({
    tagList(
      h3("Instructions"),
      p("Check common iron related blood properties to get clinical ranges and nutritional guidance.."),
      tags$ul(
        tags$li("Choose iron biomarker from the drop down list [Select Iron Biomarker]."),
        tags$li("Set biomarker value using the slider [Set Biomarker Value]."),
      p(""),
      p("Note: The selections will update the range plot, and relevant tabs automatically.", class = "italic"),
      
        
      ),
    )
  })
  
  
  # Define ranges for each biomarker, i know
  ranges <- reactive({
    switch(
      input$iron_property,
      "serum_iron" = list(
        min = 0,
        max = 500,
        value = 100,
        step = 1,
        ranges = data.frame(
          xmin = c(0, 60, 170),
          xmax = c(60, 170, 500),
          ymin = c(-0.4, -0.4, -0.4),
          ymax = c(0.4, 0.4, 0.4),
          range = c("Low", "Normal", "High"),
          color = c("red", "yellow", "green")
        )
      ),
      "ferritin" = list(
        min = 0,
        max = 1000,
        value = 100,
        step = 1,
        ranges = data.frame(
          xmin = c(0, 30, 400),
          xmax = c(30, 400, 1000),
          ymin = c(-0.4, -0.4, -0.4),
          ymax = c(0.4, 0.4, 0.4),
          range = c("Low", "Normal", "High"),
          color = c("red", "yellow", "green")
        )
      ),
      "transferrin_sat" = list(
        min = 0,
        max = 100,
        value = 30,
        step = 0.1,
        ranges = data.frame(
          xmin = c(0, 20, 50),
          xmax = c(20, 50, 100),
          ymin = c(-0.4, -0.4, -0.4),
          ymax = c(0.4, 0.4, 0.4),
          range = c("Low", "Normal", "High"),
          color = c("red", "yellow", "green")
        )
      ),
      "tibc" = list(
        min = 0,
        max = 600,
        value = 300,
        step = 1,
        ranges = data.frame(
          xmin = c(0, 240, 450),
          xmax = c(240, 450, 600),
          ymin = c(-0.4, -0.4, -0.4),
          ymax = c(0.4, 0.4, 0.4),
          range = c("Low", "Normal", "High"),
          color = c("red", "yellow", "green")
        )
      )
    )
  })
  
  # Render dynamic slider
  output$dynamic_slider <- renderUI({
    req(input$iron_property) # Ensure iron_property is selected
    range_data <- ranges()
    sliderInput(
      "iron_value",
      "Set Biomarker Value:",
      min = range_data$min,
      max = range_data$max,
      value = range_data$value,
      step = range_data$step
    )
  })
  
  # Create data for the line
  data <- reactive({
    range_data <- ranges()
    x <- seq(0, range_data$max, length.out = 100)
    y <- rep(0, length(x))
    data.frame(x = x, y = y)
  })
  
  # Create marker data
  # marker <- reactive({
  #   data.frame(x = input$iron_value, y = 0)
  # })
  
  marker <- reactive({
    req(input$iron_value)  # Ensure input$iron_value is defined
    data.frame(x = input$iron_value, y = 0)
  })
  
  # Render line plot with ranges and marker
  output$rangePlot <- renderPlot({
    range_data <- ranges()
    ggplot() +
      geom_rect(
        data = range_data$ranges,
        aes(
          xmin = xmin,
          xmax = xmax,
          ymin = ymin,
          ymax = ymax,
          fill = range
        ),
        alpha = 0.3
      ) +
      geom_line(
        data = data(),
        aes(x = x, y = y),
        color = "black",
        size = 1
      ) +
      geom_point(
        data = marker(),
        aes(x = x, y = y),
        shape = 21,
        fill = "red",
        color = "black",
        size = 4
      ) +
      scale_fill_manual(
        values = range_data$ranges$color,
        labels = range_data$ranges$range,
        name = "Range"
      ) +
      theme_minimal() +
      labs(x = switch(
        input$iron_property,
        "serum_iron" = "Serum Iron (mcg/dL)",
        "ferritin" = "Ferritin (ng/mL)",
        "transferrin_sat" = "Transferrin Saturation (%)",
        "tibc" = "Total Iron-Binding Capacity (mcg/dL)"
      ), y = NULL, title = "Iron Biomarker Value in Clinical Ranges") +
      theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position = "none"
      ) +
      coord_cartesian(ylim = c(-.75, .75))
  })
  
}
