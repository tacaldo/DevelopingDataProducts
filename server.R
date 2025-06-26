# Define server logic
server <- function(input, output, session) {
  # Render content for the "Range" tab
  output$range_content <- renderUI({
    switch(
      input$iron_property,
      "serum_iron" = tagList(
        h4("Serum Iron Range"),
        p("Normal Range:"),
        tags$ul(
          tags$li("Men: 65–176 mcg/dL"),
          tags$li("Women: 50–170 mcg/dL"),
          tags$li("Children: 50–120 mcg/dL (age-dependent)")
        ),
        p("Note: Serum iron varies diurnally and with diet. Ferritin is more reliable for iron status.")
        ),
      "ferritin" = tagList(
        h4("Ferritin Range"),
        p("Normal Range:"),
        tags$ul(
          tags$li("Men: 30–400 ng/mL"),
          tags$li("Women: 15–150 ng/mL"),
          tags$li("Children: 7–140 ng/mL (age-dependent)")
        ),
        p("Iron Deficiency: <30 ng/mL (healthy); <100 ng/mL (inflammation).")
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
    tagList(
      h3("Nutritional Guidance Tab"),
      p("This is the server-rendered content for the Nutritional Guidance tab.")
    )
  })
  
  # Render content for the "C" tab
  output$c_content <- renderUI({
    tagList(
      h3("C Tab"),
      p("This is the server-rendered content for the C tab.")
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
      "Enter Biomarker Value:",
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
  marker <- reactive({
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
