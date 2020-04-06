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
    return("Prosim izberite karte, ki jih imate v roki.")
  }
  
  if (length(flop) == 1 || length(flop) == 2) {
    # uporabnik ni ustrezno izbral flop kart
    return("Prosim izberite ustrezno število flop kart.")
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
  
  ze_izracunane <- read.csv("www\\ze_izracunane.csv")
  if (parametri %in% ze_izracunane$parametri) {
    verjetnost <- (ze_izracunane[ze_izracunane$parametri == parametri, ])$verjetnost
    return (paste0(sprintf("Verjetnost vaše zmage je enaka %s", verjetnost), "%."))
  }
  
  
  
  
  #########################################################################################################################
  # Sicer za neko dovolj veliko število iteracij naključno zgeneriramo neznane karte in "odigramo" eno igro. Na koncu si  #
  # ogledamo v koliko igrah je opazovan igralec zmagal glede na število iteracij in to vzamemo za iskano verjetnost.      #
  #########################################################################################################################
  
  st_iteracij <- 5000
  st_zmag <- 0
  
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
  
    for (k in 2:nasprotniki) {
      nakljucne <- sample(nove_karte, 2)
      nove_karte <- nove_karte[nove_karte != nakljucne[1]]
      nove_karte <- nove_karte[nove_karte != nakljucne[2]]
      kombinacije[[k]] <- c(nakljucne, flop, turn, river)
    }
  
  
    
  
    #######################################################################################################################
    # S pomočjo seznama kombinacij sestavimo vektor vrednosti, ki za vsakega igralca pove največjo vrednost, ki jo doseže #
    # s svojimi kartami. Nato si ogledamo, če je imel opazoval igralec srečo, tj. ali je v igri zmagal, ali ne.           #
    #######################################################################################################################
    # Opomba: Pri obravnavi ovrednotenja kart enega igralca moramo karte preoblikovati v obliko, na kateri deluje funkcija
    #         ovrednoti.
    
    vrednosti <- c()
    for (j in 1:length(kombinacije)) {
      vrednosti[[j]] <- ovrednoti(kombinacije[[j]])
    }
    if (which.max(vrednosti) == 1) {
      st_zmag <- st_zmag + 1
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
  
  verjetnost <- round(100*st_zmag/st_iteracij, 2)
  
  nova_vrstica <- data.frame("parametri" = parametri, "verjetnost" = verjetnost)
  
  write.table(nova_vrstica, file.path("www", "ze_izracunane.csv"), row.names = FALSE, append = TRUE, sep = ",", col.names = FALSE)
  return(paste0(sprintf("Verjetnost vaše zmage je enaka %s", verjetnost), "%."))
}







# Par primerov uporabe funkcije:
# model(karte[c(7, 43)], NULL, NULL, NULL, 4)
# model(karte[c(48, 35)], karte[c(24, 36, 5)], karte[12], NULL, 3)
# model(karte[c(13, 12)], karte[c(11, 10, 9)], NULL, NULL, 2)

