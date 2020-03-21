library(shiny)

ui <- fluidPage(
  headerPanel("Izračun verjetnosti - Texas hold 'em"),
  sidebarPanel(
    selectizeInput('karte_igr', 'Izberi svoji karti', karte, multiple = TRUE,
                selected = 1, options = list(maxItems = 2)),
    
    conditionalPanel(
      condition = "input.karte_igr != ''",
      selectizeInput('karte_flop', 'Izberi flop karte', karte, multiple = TRUE,
                   selected = 1, options = list(maxItems = 3)),
    ),
    
    conditionalPanel(
      condition = "input.karte_flop != ''",
      selectizeInput('karte_turn', 'Izberi turn karto', karte, multiple = TRUE,
                     selected = 1, options = list(maxItems = 1)),
    ),
    
    conditionalPanel(
      condition = "input.karte_turn != ''",
      selectizeInput('karte_river', 'Izberi river karto', karte, multiple = TRUE,
                     selected = 1, options = list(maxItems = 1)),
    ),
    
    sliderInput('nasprotniki', 'Izberi število nasprotnikov', 1, 9, 1),
    
    actionButton(inputId = "konec", label = "Naredi izračun!"),
  ),
  mainPanel(
    imageOutput("karte_igr1"),
  )
)


server <- function(input, output) {
  output$karte_igr1 <- renderImage({
    pot <- system.file(sprintf('Slike/%s.jpg', input$karte_igr[1]), package='imager')
    slika <- load.image(pot)
    plot(slika)
  }, deleteFile = FALSE)
}


shinyApp(ui = ui, server = server)