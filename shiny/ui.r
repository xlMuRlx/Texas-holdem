library(shiny)



ui <- fixedPage(
  headerPanel("Izračun verjetnosti - Texas hold 'em"),
  sidebarPanel(
    selectizeInput('karte_igr', 'Izberi svoji karti', karte, multiple = TRUE,
                options = list(maxItems = 2)),
    
    conditionalPanel(
      condition = "input.karte_igr != ''",
      selectizeInput('karte_flop', 'Izberi flop karte', karte, multiple = TRUE,
                   options = list(maxItems = 3)),
    ),
    
    conditionalPanel(
      condition = "input.karte_flop != ''",
      selectizeInput('karte_turn', 'Izberi turn karto', karte, multiple = TRUE,
                     options = list(maxItems = 1)),
    ),
    
    conditionalPanel(
      condition = "input.karte_turn != ''",
      selectizeInput('karte_river', 'Izberi river karto', karte, multiple = TRUE,
                     options = list(maxItems = 1)),
    ),
    
    sliderInput('nasprotniki', 'Izberi število nasprotnikov', 1, 9, 1),
    
    actionButton(inputId = "konec", label = "Izračunaj!"),
  ),
  
  
  mainPanel(
    uiOutput("karta1"),
    uiOutput("karta2"),
    
    uiOutput("flop1"),
    uiOutput("flop2"),
    uiOutput("flop3"),
    
    uiOutput("turn"),
    
    uiOutput("river"),
  ),
)




