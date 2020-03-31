ui <- dashboardPage(
  dashboardHeader(title="Texas hold 'em"),
  
  dashboardSidebar(
    selectizeInput('karte_igr', 'Izberite svoji karti', karte, multiple = TRUE,
                   options = list(maxItems = 2)),
    
    conditionalPanel(
      # Spremeni pogoj -> izbira 1 igralčeve karte ni dovolj, da se flop odpre
      condition = "input.karte_igr != ''",
      selectizeInput('karte_flop', 'Izberite flop karte', karte, multiple = TRUE,
                     options = list(maxItems = 3)),
    ),
    
    conditionalPanel(
      # Spremeni pogoj -> izbira 1 ali 2 flop kart ni dovolj, da se turn odpre
      condition = "input.karte_flop != ''",
      selectizeInput('karte_turn', 'Izberite turn karto', karte, multiple = TRUE,
                     options = list(maxItems = 1)),
    ),
    
    conditionalPanel(
      condition = "input.karte_turn != ''",
      selectizeInput('karte_river', 'Izberite river karto', karte, multiple = TRUE,
                     options = list(maxItems = 1)),
    ),
    
    sliderInput('nasprotniki', 'Izberi število nasprotnikov', 1, 9, 1),
    
    actionButton(inputId = "konec", label = "Izračunaj!")
  ),
  
  
  
  dashboardBody(
    includeCSS("www/custom.css"),
    fluidRow(
      box(
        title = "Vaša roka",width = 5, solidHeader = TRUE,
        uiOutput("karta1"),
        uiOutput("karta2")
      ),
    ),
    
    fluidRow(
      box(
        title = "Igralna miza",width = 12, background = "olive", solidHeader = TRUE,
        uiOutput("flop1"),
        uiOutput("flop2"),
        uiOutput("flop3"),
        
        column(width=1),
        
        uiOutput("turn"),
        
        column(width=1),
        
        uiOutput("river")
      ),
    ),
    
   
   h1("Iskana verjetnost"),
   textOutput("rezultat")
  )
)




