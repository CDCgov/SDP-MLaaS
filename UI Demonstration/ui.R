library(shiny)

shinyUI(fluidPage(
  shinyjs::useShinyjs(),
  titlePanel("App Title Here"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("userData", label = "Upload a data set:", multiple = FALSE),
      selectInput(
        "model",
        "Choose your model:",
        c(
          "---" = "noSelection",
          "Nausea Model" = "NauseaModel",
          "Flu Model" = "FluModel",
          "Asthma Model" = "AsthmaModel",
          "Opioid Model" = "OpioidModel",
          "Poison Model" = "PoisonModel"
        )
      ),
      actionButton("runButton", "Run Model"),
      br(),
      br(),
      h3("Plot Controls"),
      
      radioButtons(
        "timeWindow",
        label = "Time Window:",
        choices = list("By Week" = 1, "By Month" = 2),
        inline = TRUE
      ),
      
      radioButtons(
        "scoresOrCounts",
        label = "Data Display:",
        choices = list("Prediction Count" = 2, "Prediction Percentage" = 3, "Score Statistics" = 1),
        inline = FALSE
      ),

      splitLayout(
      dateInput("startDate", "Start Date:"),
      dateInput("endDate", "End Date:")),
      
      radioButtons(
        "plotType",
        label = "Select Plot Type:",
        choices = list("Boxplot" = 1, "Violin" = 2, "Scatterplot" = 3),
        inline = FALSE
      ),
      actionButton("plotButton", "Generate Plot"),
      actionButton("resetButton", "Reset Parameters")
 
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Run Results", fluidRow(plotOutput("finalPlot", hover = "plot_hover")),
                 verbatimTextOutput("info"))
  )))))