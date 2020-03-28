library(shiny)



server <- function(input, output, session) {
  
  ################################################################
  # Posodabljanje preostlih kart, ki so še na voljo              #
  ################################################################
  
  # 1. Posodobitev za flop
  observe({
    ostanek <- karte[karte != input$karte_igr[1]]
    ostanek <- ostanek[ostanek != input$karte_igr[2]]
    
    updateSelectInput(session, "karte_flop",
                      label = paste("Izberi flop karte"),
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
                      label = paste("Izberi turn karto"),
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
                      label = paste("Izberi river karto"),
                      choices = ostanek,
    )
  })
  
  
  
  ################################################################
  # Zapis za grafični prikaz izbranih kart                       #
  ################################################################
  
  # 1. Prikaz para igralčevih kart
  output$karta1 <- renderUI({
    if(is.null(input$karte_igr[1])) {
      pot <- "zaprta.jpg"
      img(src=pot, height="22%", width="22%", align="left")
    } else {
      pot <- paste0(input$karte_igr[1],".jpg")
      img(src=pot, height="22%", width="22%", align="left")
    }
  })
  
  output$karta2 <- renderUI({
    if(is.null(input$karte_igr[2])) {
      pot <- "zaprta.jpg"
      img(src=pot, height="22%", width="22%", align="left")
    } else {
      if (is.na(input$karte_igr[2])) {
        pot <- "zaprta.jpg"
        img(src=pot, height="22%", width="22%", align="left")
      } else {
        pot <- paste0(input$karte_igr[2],".jpg")
        img(src=pot, height="22%", width="22%", align="left")
      }
    }
  })
  
  
  # 2. Prikaz flop kart
  output$flop1 <- renderUI({
    if(is.null(input$karte_flop[1])) {
      pot <- "zaprta.jpg"
      img(src=pot, height="22%", width="22%", align="left")
    } else {
      pot <- paste0(input$karte_flop[1],".jpg")
      img(src=pot, height="22%", width="22%", align="left")
    }
  })
  
  output$flop2 <- renderUI({
    if(is.null(input$karte_flop[2])) {
      pot <- "zaprta.jpg"
      img(src=pot, height="22%", width="22%", align="left")
    } else {
      if (is.na(input$karte_flop[2])) {
        pot <- "zaprta.jpg"
        img(src=pot, height="22%", width="22%", align="left")
      } else {
        pot <- paste0(input$karte_flop[2],".jpg")
        img(src=pot, height="22%", width="22%", align="left")
      }
    }
  })
  
  output$flop3 <- renderUI({
    if(is.null(input$karte_flop[3])) {
      pot <- "zaprta.jpg"
      img(src=pot, height="22%", width="22%", align="left")
    } else {
      if (is.na(input$karte_flop[3])) {
        pot <- "zaprta.jpg"
        img(src=pot, height="22%", width="22%", align="left")
      } else {
        pot <- paste0(input$karte_flop[3],".jpg")
        img(src=pot, height="22%", width="22%", align="left")
      }
    }
  })
  
  
  # 3. Prikaz turn in river karte
  
  output$turn <- renderUI({
    if(is.null(input$karte_turn)) {
      pot <- "zaprta.jpg"
      img(src=pot, height="22%", width="22%", align="left")
    } else {
      pot <- paste0(input$karte_turn,".jpg")
      img(src=pot, height="22%", width="22%", align="left")
    }
  })
  
  output$river <- renderUI({
    if(is.null(input$karte_river)) {
      pot <- "zaprta.jpg"
      img(src=pot, height="22%", width="22%", align="left")
    } else {
      pot <- paste0(input$karte_river,".jpg")
      img(src=pot, height="22%", width="22%", align="left")
    }
  })
}



