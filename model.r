###########################################################################################################################
# Najprej sestavimo seznam oz. tabelo vseh kart. Vsaka karta bo predstavljena kot par, kjer prva komponenta pove njeno    #
# vrednost, druga pa barvo.                                                                                               #
###########################################################################################################################
vrednosti <- c()
for (i in 2:10) {
  vrednosti[[i-1]] <- as.character(i)
}
vrednosti <- c(vrednosti, c("J", "Q", "K", "A"))

barve <- c("kriz", "pik", "srce", "karo")

kupcek <- expand.grid(vrednosti, barve)
colnames(kupcek) <- c("vrednost", "barva")










###########################################################################################################################
# Združena tabela za bolj pregledno izbiranje kart v shiny aplikaciji. Zaradi lažje kasnejše uporabe bodo tudi vse        #
# funkcije kot argumente prejemale karte v naslednji obliki.                                                              #
###########################################################################################################################

karte <- paste(kupcek$vrednost, kupcek$barva)










###########################################################################################################################
# Zapis modela, ki na podlagi velikega števila iteracij izračuna verjetnost zmage igralčeve kombinacije kart.             #
###########################################################################################################################

model <- function (igr_karte, flop, turn, river, nasprotniki, updateProgress = NULL) {
  
  #########################################################################################################################
  # Najprej si ogledamo možnosti, da uporabnik ni pravilno izbral potrebnih kart. Poleg tega si označimo, če so bile flop #
  # turn in river že izbrane ali ne. Ta podatek bomo namreč potrebovali pri naključnem generiranju neizbranih kart.       #
  #########################################################################################################################
  
  if (length(igr_karte) < 2) {
    # uporabnik ni ustrezno izbral svojih kart
    return(list(NULL, "Prosim izberite karte, ki jih imate v roki."))
  }
  
  if (length(flop) == 1 || length(flop) == 2) {
    # uporabnik ni ustrezno izbral flop kart
    return(list(NULL, "Prosim izberite ustrezno število flop kart."))
  }
  
  flop_stevec <- FALSE
  turn_stevec <- FALSE
  river_stevec <- FALSE
  
  if (length(flop) == 0) {
    flop_stevec <- TRUE
    flop <- "/ / /" # To potrebujemo zgolj za zapis v datoteko -> sicer se npr. "2 kriz 2 pik" pojavi tudi v "2 kriz 2 pik 4 srce Q srce K kriz"
  }
  if (length(turn) == 0) {
    turn_stevec <- TRUE
    turn <- "/"
  }
  if (length(river) == 0) {
    # River karta še ni bila odprta, zato bomo izbrali naključno
    river_stevec <- TRUE
    river <- "/"
  }
  
  
  
  
  #########################################################################################################################
  # Najprej si ogledamo, če smo za dano kombinacijo že kdaj izračunali verjetnost.                                        #
  #########################################################################################################################
  
  # Vrstni red flop, turn in river kart pri izračunu ni pomemben. Ker sta pri istih kartah igralca verjetnosti za neki permutaciji
  # teh kart verjetnosti enaki, jih bomo v zapisu uredili, s čimer se tega problema znebimo.
  
  # Uredimo tudi karti, ki jim ima igralec v roki
  parametri <- paste(c(sort(igr_karte), sort(c(flop, turn, river)), nasprotniki), collapse = " ")
  
  ze_izracunane <- read.csv(file.path("www", "ze_izracunane.csv"), head = TRUE, sep=";", stringsAsFactors = FALSE)
  if (parametri %in% ze_izracunane$parametri) {
    # Iskana verjetnost smo enkrat že izračunali
    verjetnosti <- (ze_izracunane[ze_izracunane$parametri == parametri, ])$verjetnosti
    verjetnosti <- strsplit(verjetnosti, split = " ")
    verjetnosti <- as.numeric(unlist(verjetnosti))
    
    nacin <- c("Visoka karta", "Par", "Dva para", "Tris", "Lestvica", "Barva", "Full House", "Poker", "Barvna lestvica", "Royal flush")
    tabela_verjetnosti <- cbind(nacin, verjetnosti[2:11])
    colnames(tabela_verjetnosti) <- c("Način zmage", "Verjetnost (v %)")
    return (list(tabela_verjetnosti, paste0(sprintf("Verjetnost vaše zmage je enaka %s", verjetnosti[1]), "%.")))
  }
  
  
  
  
  #########################################################################################################################
  # Sicer za neko dovolj veliko število iteracij naključno zgeneriramo neznane karte in "odigramo" eno igro. Na koncu si  #
  # ogledamo v koliko igrah je opazovan igralec zmagal glede na število iteracij in to vzamemo za iskano verjetnost.      #
  #########################################################################################################################
  
  st_iteracij <- 5000
  st_zmag <- 0
  
  zm_visokaKarta <- 0 # števec zmag z visoko karto
  zm_par <- 0 # števec zmag s parom
  zm_2para <- 0 # števec zmag z dvema praoma
  zm_tris <- 0 # števec zmag s trisom
  zm_lestvica <- 0 # števec zmag z lestvico
  zm_barva <- 0 # števec zmag z barvo
  zm_fullHouse <- 0 # števec zmag s full housom
  zm_poker <- 0 # števec zmag s pokrom
  zm_barvnaLestvica <- 0 # števec zmag z barvno lestvico
  zm_kraljevaLestvica <- 0 # števec zmag s kraljevo lestvico
  
  for (i in 1:st_iteracij) {
    
    #######################################################################################################################
    # Najprej moramo naključno izbrati vse karte, ki niso določene. Zaenkrat to obsega flop, turn in river karte, če niso #
    # bile določene.                                                                                                      #
    #######################################################################################################################
  
    nove_karte <- karte[karte != igr_karte[1]]
    nove_karte <- nove_karte[nove_karte != igr_karte[2]]
  
    if (flop_stevec) {
      # Flop karte še niso bile odprte, zato izberemo naključne
      flop <- sample(nove_karte, 3)
    }
    nove_karte <- nove_karte[nove_karte != flop[1]]
    nove_karte <- nove_karte[nove_karte != flop[2]]
    nove_karte <- nove_karte[nove_karte != flop[3]]
  
    if (turn_stevec) {
      # Turn karta še ni bila odprta, zato izberemo naključno
      turn <- sample(nove_karte, 1)
    }
    nove_karte <- nove_karte[nove_karte != turn]
  
    if (river_stevec) {
      # River karta še ni bila odprta, zato izberemo naključno
      river <- sample(nove_karte, 1)
    }
    nove_karte <- nove_karte[nove_karte != river]
  
  
  
  
    #######################################################################################################################
    # Sestavimo seznam kombinacij, v katerega bomo zapisali vseh 7 kart za vsakega igralca, iz katerih bo iskal najboljšo #
    # kombinacijo. Za nasprotnike moramo najprej naključno zgenerirati karte, ki jih dobijo v roko. V tem seznamu bo prvo #
    # mesto vselej pripadalo opazovanemu igralcu.                                                                         #
    #######################################################################################################################
  
    kombinacije <- list()
    kombinacije[[1]] <- c(igr_karte, flop, turn, river)
  
    for (j in 2:(nasprotniki+1)) {
      nakljucne <- sample(nove_karte, 2)
      nove_karte <- nove_karte[nove_karte != nakljucne[1]]
      nove_karte <- nove_karte[nove_karte != nakljucne[2]]
      kombinacije[[j]] <- c(nakljucne, flop, turn, river)
    }
  
  
    
  
    #######################################################################################################################
    # S pomočjo seznama kombinacij sestavimo vektor vrednosti, ki za vsakega igralca pove največjo vrednost, ki jo doseže #
    # s svojimi kartami. Nato si ogledamo, če je imel opazovani igralec srečo, tj. ali je v igri zmagal ali ne, in v      #
    # primeru zmage še s katero kombinacijo je zmagal.                                                                    #
    #######################################################################################################################
    
    vrednosti <- c()
    for (k in 1:length(kombinacije)) {
      vrednosti[[k]] <- ovrednoti(as.vector(kombinacije[[k]]))
    }
    
    
    if (which.max(vrednosti) == 1) {
      st_zmag <- st_zmag + 1
      
      
      # Preverimo še, s kakšno kombinacijo smo zmagali.
      vrednost <- vrednosti[1]
      
      if (vrednost < 1) {
        # Zmagamo z visoko karto
        zm_visokaKarta <- zm_visokaKarta + 1
      }
      if (vrednost >= 1 && vrednost < 2) {
        # Zmagamo s parom
        zm_par <- zm_par + 1
      }
      if (vrednost >= 2 && vrednost < 3) {
        # Zmagamo z dvema paroma
        zm_2para <- zm_2para + 1
      }
      if (vrednost >= 3 && vrednost < 4) {
        # Zmagamo s setom
        zm_tris <- zm_tris + 1
      }
      if (vrednost >= 4 && vrednost < 5) {
        # Zmagamo z lestvico
        zm_lestvica <- zm_lestvica + 1
      }
      if (vrednost >= 5 && vrednost < 6) {
        # Zmagamo z barvo
        zm_barva <- zm_barva + 1
      }
      if (vrednost >= 6 && vrednost < 7) {
        # Zmagamo s full housom
        zm_fullHouse <- zm_fullHouse + 1
      }
      if (vrednost >= 7 && vrednost < 8) {
        # Zmagamo s pokrom
        zm_poker <- zm_poker + 1
      }
      if (vrednost >= 8 && vrednost < 8.6) {
        # Zmagamo z barvno lestvico
        zm_barvnaLestvica <- zm_barvnaLestvica + 1
      }
      if (vrednost == 8.6) {
        # Zmagamo s kraljevo lestvico
        zm_kraljevaLestvica <- zm_kraljevaLestvica + 1
      }
    }
    
    
    # Če funkciji v argument podamo tudi funkcijo za spremljanje napredka, moramo podati še kaj se bo sproti izpisovalo
    if (is.function(updateProgress)) {
      if (i %% 100 == 0 || i == 1) {
        # Trenutno verjetnost posodabljamo na vsakih 100 iteracij
        tekst <- paste0(paste("Trenutna verjetnost:", round(100*st_zmag/i, 2)), "%")
      }
      updateProgress(detail = tekst)
    }
  }
  
  
  # Izračunamo iskane verjetnosti
  verjetnosti <- round(100*(c(st_zmag, zm_visokaKarta, zm_par, zm_2para, zm_tris, zm_lestvica, zm_barva, zm_fullHouse, zm_poker, 
                              zm_barvnaLestvica, zm_kraljevaLestvica))/st_iteracij, 2)
  
  
  
  # Specifične verjetnosti zapišemo v tabelo
  nacin <- c("Visoka karta", "Par", "Dva para", "Tris", "Lestvica", "Barva", "Full House", "Poker", "Barvna lestvica", "Royal flush")
  tabela_verjetnosti <- cbind(nacin, verjetnosti[2:11])
  colnames(tabela_verjetnosti) <- c("Način zmage", "Verjetnost (v %)")
  
  
  
  # Pred koncem novo pridobljene podatke še zapišemo v datoteko
  nova_vrstica <- data.frame("parametri" = parametri, "verjetnosti" = paste(verjetnosti, collapse = " "))
  write.table(nova_vrstica, file.path("www", "ze_izracunane.csv"), row.names = FALSE, append = TRUE, sep = ";", col.names = FALSE)
  
  return(list(tabela_verjetnosti, paste0(sprintf("Verjetnost vaše zmage je enaka %s", verjetnosti[1]), "%.")))
}






# Par primerov uporabe funkcije:
# model(karte[c(8, 44)], NULL, NULL, NULL, 3)
# model(karte[c(48, 35)], karte[c(24, 36, 5)], karte[12], NULL, 3)
# model(karte[c(52, 51)], karte[c(48, 50, 49)], NULL, NULL, 2)

