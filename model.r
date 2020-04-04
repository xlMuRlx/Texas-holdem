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

model <- function (igr_karte, flop, turn, river, nasprotniki) {
  
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
  
  parametri <- paste(c(igr_karte, flop, turn, river, nasprotniki), collapse = " ")
  
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
  
    for (i in 2:nasprotniki) {
      nakljucne <- sample(nove_karte, 2)
      nove_karte <- nove_karte[nove_karte != nakljucne[1]]
      nove_karte <- nove_karte[nove_karte != nakljucne[2]]
      kombinacije[[i]] <- c(nakljucne, flop, turn, river)
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
  }
  
  verjetnost <- round(100*st_zmag/st_iteracij, 2)
  
  nova_vrstica <- data.frame("parametri" = parametri, "verjetnost" = verjetnost)
  
  write.table(nova_vrstica,"www\\ze_izracunane.csv", row.names = FALSE, append = TRUE, sep = ",", col.names = FALSE)
  return(paste0(sprintf("Verjetnost vaše zmage je enaka %s", verjetnost), "%."))
}







# Par primerov uporabe funkcije:
model(karte[c(1, 3)], NULL, NULL, NULL, 2)
model(karte[c(1, 3)], karte[c(2, 4, 5)], karte[52], karte[31], 3)
model(karte[c(13, 12)], karte[c(11, 10, 9)], NULL, NULL, 2)

