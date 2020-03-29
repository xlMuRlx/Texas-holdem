ui <- dashboardPage(
  dashboardHeader(title="Texas hold 'em"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("DOMOV", tabName = "domov", icon = icon("home")),
      menuItem("IGRALNA MIZA", tabName = "miza", icon = icon("coins"))
    )
  ),
  
  
  
  dashboardBody(
    tabItems(
      
      tabItem(tabName = "domov",
        h1("Izračun verjetnosti"),
        fluidRow(
          box(collapsible = FALSE,
              title = "Izbor kart", width = 4, status = "primary", solidHeader = TRUE,
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
                               options = list(maxItems = 1))
              )
          ),
          
          box(collapsible = FALSE,
              title = "Število nasprotnikov", width = 4, status = "primary", solidHeader = TRUE,
              sliderInput('nasprotniki', 'Izberi število nasprotnikov', 1, 9, 1),
              actionButton(inputId = "konec", label = "Izračunaj!")
          ),
          
          box(collapsible = FALSE,
              title = "Iskana verjetnost", width = 4, status = "primary", solidHeader = TRUE,
              textOutput("rezultat")
          )
        )
      ),

      tabItem(tabName = "miza",
        h1("Igralna miza"),

        fluidRow(width = 12,
          uiOutput("karta1"),
          uiOutput("karta2"),
          
          column(width=1),
          
          uiOutput("flop1"),
          uiOutput("flop2"),
          uiOutput("flop3"),
          
          column(width=1),
          
          uiOutput("turn"),
          
          column(width=1),
          
          uiOutput("river")
        )
      )
    )
  )
)



