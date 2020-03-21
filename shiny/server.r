library(shiny)



server <- function(input, output) {
  
  ################################################################
  # Zapis za grafični prikaz izbranih kart                       #
  ################################################################
  
  # 1. Prikaz para igralčevih kart
  output$karta1 <- renderUI({
    if(is.null(input$karte_igr[1]) == TRUE) {
      pot <- "zaprta.jpg"
      img(src=pot, height="25%", width="25%", align="left")
    } else {
      pot <- paste0(input$karte_igr[1],".jpg")
      img(src=pot, height="25%", width="25%", align="left")
    }
  })
  
  output$karta2 <- renderUI({
    if(is.null(input$karte_igr[2]) == TRUE) {
      pot <- "zaprta.jpg"
      img(src=pot, height="25%", width="25%", align="left")
    } else {
      if (is.na(input$karte_igr[2])) {
        pot <- "zaprta.jpg"
        img(src=pot, height="25%", width="25%", align="left")
      } else {
        pot <- paste0(input$karte_igr[2],".jpg")
        img(src=pot, height="25%", width="25%", align="left")
      }
    }
  })
  
  
  # 2. Prikaz flop kart
  output$flop1 <- renderUI({
    if(is.null(input$karte_flop[1]) == TRUE) {
      pot <- "zaprta.jpg"
      img(src=pot, height="25%", width="25%", align="left")
    } else {
      pot <- paste0(input$karte_flop[1],".jpg")
      img(src=pot, height="25%", width="25%", align="left")
    }
  })
  
  output$flop2 <- renderUI({
    if(is.null(input$karte_flop[2]) == TRUE) {
      pot <- "zaprta.jpg"
      img(src=pot, height="25%", width="25%", align="left")
    } else {
      if (is.na(input$karte_flop[2])) {
        pot <- "zaprta.jpg"
        img(src=pot, height="25%", width="25%", align="left")
      } else {
        pot <- paste0(input$karte_flop[2],".jpg")
        img(src=pot, height="25%", width="25%", align="left")
      }
    }
  })
  
  output$flop3 <- renderUI({
    if(is.null(input$karte_flop[3]) == TRUE) {
      pot <- "zaprta.jpg"
      img(src=pot, height="25%", width="25%", align="left")
    } else {
      if (is.na(input$karte_flop[3])) {
        pot <- "zaprta.jpg"
        img(src=pot, height="25%", width="25%", align="left")
      } else {
        pot <- paste0(input$karte_flop[3],".jpg")
        img(src=pot, height="25%", width="25%", align="left")
      }
    }
  })
  
  
  # 3. Prikaz turn in river karte
  
  output$turn <- renderUI({
    if(is.null(input$karte_turn) == TRUE) {
      pot <- "zaprta.jpg"
      img(src=pot, height="25%", width="25%", align="left")
    } else {
      pot <- paste0(input$karte_turn,".jpg")
      img(src=pot, height="25%", width="25%", align="left")
    }
  })
  
  output$river <- renderUI({
    if(is.null(input$karte_river) == TRUE) {
      pot <- "zaprta.jpg"
      img(src=pot, height="25%", width="25%", align="left")
    } else {
      pot <- paste0(input$karte_river,".jpg")
      img(src=pot, height="25%", width="25%", align="left")
    }
  })
}



