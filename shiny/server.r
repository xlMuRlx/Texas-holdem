server <- function(input, output, session) {
  
  ################################################################
  # Posodabljanje preostlih kart, ki so še na voljo              #
  ################################################################
  
  # 1. Posodobitev za flop
  observe({
    ostanek <- karte[karte != input$karte_igr[1]]
    ostanek <- ostanek[ostanek != input$karte_igr[2]]
    
    updateSelectInput(session, "karte_flop",
                      label = paste("Izberite flop karte"),
                      choices = ostanek,
    )
  })
  
  
  # 2. Posodobitev za turn
  observe({
    ostanek <- karte[karte != input$karte_igr[1]]
    ostanek <- ostanek[ostanek != input$karte_igr[2]]
    ostanek <- ostanek[ostanek != input$karte_flop[1]]
    ostanek <- ostanek[ostanek != input$karte_flop[2]]
    ostanek <- ostanek[ostanek != input$karte_flop[3]]
    
    updateSelectInput(session, "karte_turn",
                      label = paste("Izberite turn karto"),
                      choices = ostanek,
    )
  })
    
  
  # 3. Posodobitev za river
  observe({
    ostanek <- karte[karte != input$karte_igr[1]]
    ostanek <- ostanek[ostanek != input$karte_igr[2]]
    ostanek <- ostanek[ostanek != input$karte_flop[1]]
    ostanek <- ostanek[ostanek != input$karte_flop[2]]
    ostanek <- ostanek[ostanek != input$karte_flop[3]]
    ostanek <- ostanek[ostanek != input$karte_turn]
      
    updateSelectInput(session, "karte_river",
                      label = paste("Izberite river karto"),
                      choices = ostanek,
    )
  })
  
  
  
  ################################################################
  # Zapis za grafični prikaz izbranih kart                       #
  ################################################################
  
  # 1. Prikaz para igralčevih kart
  output$karta1 <- renderUI({
    if(length(input$karte_igr) < 1) {
      pot <- "zaprta.png"
      img(src=pot, height="15%", width="15%", align="left")
    } else {
      pot <- paste0(input$karte_igr[1],".png")
      img(src=pot, height="15%", width="15%", align="left")
    }
  })
  
  output$karta2 <- renderUI({
    if(length(input$karte_igr) < 2) {
      pot <- "zaprta.png"
      img(src=pot, height="15%", width="15%", align="left")
    } else {
      pot <- paste0(input$karte_igr[2],".png")
      img(src=pot, height="15%", width="15%", align="left")
    }
  })
  
  
  # 2. Prikaz flop kart
  output$flop1 <- renderUI({
    if(length(input$karte_flop) < 1) {
      pot <- "zaprta.png"
      img(src=pot, height="15%", width="15%", align="left")
    } else {
      pot <- paste0(input$karte_flop[1],".png")
      img(src=pot, height="15%", width="15%", align="left")
    }
  })
  
  output$flop2 <- renderUI({
    if(length(input$karte_flop) < 2) {
      pot <- "zaprta.png"
      img(src=pot, height="15%", width="15%", align="left")
    } else {
      pot <- paste0(input$karte_flop[2],".png")
      img(src=pot, height="15%", width="15%", align="left")
    }
  })
  
  output$flop3 <- renderUI({
    if(length(input$karte_flop) < 3) {
      pot <- "zaprta.png"
      img(src=pot, height="15%", width="15%", align="left")
    } else {
      pot <- paste0(input$karte_flop[3],".png")
      img(src=pot, height="15%", width="15%", align="left")
    }
  })
  
  
  # 3. Prikaz turn in river karte
  
  output$turn <- renderUI({
    if(length(input$karte_turn) < 1) {
      pot <- "zaprta.png"
      img(src=pot, height="15%", width="15%", align="left")
    } else {
      pot <- paste0(input$karte_turn,".png")
      img(src=pot, height="15%", width="15%", align="left")
    }
  })
  
  output$river <- renderUI({
    if(length(input$karte_river) < 1) {
      pot <- "zaprta.png"
      img(src=pot, height="15%", width="15%", align="left")
    } else {
      pot <- paste0(input$karte_river,".png")
      img(src=pot, height="15%", width="15%", align="left")
    }
  })
  
  
  
  ################################################################
  # Zapis izvajanja dejanskega modela                            #
  ################################################################
  
  besedilo <- eventReactive(input$konec, {
    model(input$karte_igr, input$karte_flop, input$karte_turn, input$karte_river, input$nasprotniki)
  })
  
  output$rezultat <- renderText({
    besedilo()
  })
  
  
}



