library(shiny)

ui <- fluidPage(
  headerPanel("Izračun verjetnosti - Texas hold 'em"),
  sidebarPanel(
    selectizeInput('karte_igr', 'Izberi svoje karte', karte, multiple = TRUE,
                selected = 1, options = list(maxItems = 2)),
    
    selectInput('flop', 'Flop karte so že odprte', c("NE", "DA")),
    conditionalPanel(
      condition = "input.flop == 'DA'",
      selectizeInput('karte_flop', 'Izberi flop karte', karte, multiple = TRUE,
                     selected = 1, options = list(maxItems = 3)),
    ),
    
    conditionalPanel(
      condition = "input.flop == 'DA'",
      selectInput('turn', 'Turn karta je že odprta', c("NE", "DA")),
      conditionalPanel(
        condition = "input.turn == 'DA'",
        selectInput('karte_turn', 'Izberi turn karto', karte),
      ),
      
      conditionalPanel(
        condition = "input.turn == 'DA'",
        selectInput('river', 'River karta je že odprta', c("NE", "DA")),
        conditionalPanel(
          condition = "input.river == 'DA'",
          selectInput('karte_river', 'Izberi river karto', karte),
        ),
      ),
    ),
    
    sliderInput('nasprotniki', 'Izberi število nasprotnikov', 1, 9, 1),
    
    actionButton(inputId = "konec", label = "Naredi izračun!"),
  ),
  mainPanel(
    
  )
)


server <- function(input, output) {
}


shinyApp(ui = ui, server = server)