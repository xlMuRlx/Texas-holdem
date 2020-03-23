library(shiny)



ui <- fixedPage(
  headerPanel("Izračun verjetnosti - Texas hold 'em"),
  
  sidebarPanel(
    selectizeInput('karte_igr', 'Izberi svoji karti', karte, multiple = TRUE,
                options = list(maxItems = 2)),
    
    conditionalPanel(
      # Spremeni pogoj -> izbira 1 igralčeve karte ni dovolj, da se flop odpre
      condition = ("input.karte_igr != ''"),
      selectizeInput('karte_flop', 'Izberi flop karte', karte, multiple = TRUE,
                   options = list(maxItems = 3)),
    ),
    
    conditionalPanel(
      # Spremeni pogoj -> izbira 1 ali 2 flop kart ni dovolj, da se turn odpre
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
    
    actionButton(inputId = "konec", label = "Izračunaj!")
  ),
  
  
  
  mainPanel(

    fluidRow(
      h4("Moje karte"),
      uiOutput("karta1"),
      uiOutput("karta2")
    ),
    
    fluidRow(
      h4("Flop"),
      uiOutput("flop1"),
      uiOutput("flop2"),
      uiOutput("flop3")
    ),
    
    fluidRow(
      h4("Turn"),
      uiOutput("turn")
    ),
    
    fluidRow(
      h4("River"),
      uiOutput("river")
    )
  )
  
)




