ovrednoti <- function(kombinacija) {
  # Funkcija za medsebojno primerjavo različnih kombinacij kart. Gre za funkcijo, ki iz izbranih 7 kart izbere in 
  # ovrednoti najboljšo možno kombinacijo. Celoštevilski del služi primerjavi različnih kombinacij, decimalni del
  # pa za medsebojno primerjavo istih kombinacij (npr. par trojk je slabši od para štiric).
  
  # Legenda:
  #   najvišja karta -> 0
  #   en par -> 1
  #   dva para -> 2
  #   tris -> 3
  #   lestvica -> 4
  #   barva -> 5
  #   full house -> 6
  #   poker -> 7
  #   barvna lestvica -> 8
  
  # Dodatni komentar: Kraljeva lestvica je najvišja barvna lestvica, zato posebna obravnava ni potrebna.
  
  
  
  
  
  ###################################################################################################################
  # Kombinacijo najprej spremenimo v neko tabelo, saj nam to precej olajša njeno obravnavo.                         #
  ###################################################################################################################

  kombinacija <- separate(as.data.frame(kombinacija), kombinacija, c("vrednost", "barva"), sep = " ")
  
  
  
  
  ###################################################################################################################
  # Nato vse črke spremenimo v ustrezne vrednosti, da jih lahko med seboj primerjamo.                               #
  ###################################################################################################################
  
  kombinacija$vrednost <- gsub("J", "11", kombinacija$vrednost)
  kombinacija$vrednost <- gsub("Q", "12", kombinacija$vrednost)
  kombinacija$vrednost <- gsub("K", "13", kombinacija$vrednost)
  kombinacija$vrednost <- gsub("A", "14", kombinacija$vrednost)
  kombinacija$vrednost <- as.numeric(kombinacija$vrednost)
  
  kombinacija <- kombinacija[order(kombinacija$vrednost), ] # kombinacijo uredimo za lažje pregledovanje
  
  
  
  
  
  ###################################################################################################################
  # Obravnavamo vse možne kombinacije in poiščemo najboljšo.                                                        #
  ###################################################################################################################
  
  # Zapišimo nek vektor, ki si shranjuje dosežene vrednosti. To potrebujemo zaradi lestvice in pa barve, saj njuni
  # obravnavanji ne nastopita glede na vrednost zaradi enostavnejšega zapisa. Če je dosežen kateri od ostalih
  # primerov, vrednost lahko vrnemo takoj, saj so vse ostale možnosti lahko zgolj manjše.
  barve_lestvice <- c()
  
  skupaj_barve <- count(kombinacija$barva)
  skupaj_vrednosti <- count(kombinacija$vrednost)

  
  # 1. Lestvica -> najprej si ogledamo to, saj bomo ta kriterij potrebovali tudi v točki 2.
  razlike <- diff(kombinacija$vrednost)
  
  dolzina <- 1
  izbrani_ind <- c() # indeksi kart, ki sestavljajo lestvico
  for (j in 1:length(razlike)) {
    if (razlike[j] == 0) {
      # Če se ne premaknemo navzgor, morebitno pojavitev indeksa odstranimo, sicer se nam bo pri naslednjem
      # premiku karta 2x ponovila.
      izbrani_ind <- izbrani_ind[izbrani_ind != j]
    }
    if (razlike[j] == 1) {
      # Če je razlika 1, se v lestvici pomaknemo navzgor.
      dolzina <- dolzina + 1
      izbrani_ind <- append(izbrani_ind, c(j, j+1))
    }
    if (razlike[j] >= 2) {
      # Če je razlika večja od 2, pa bodisi začnemo znova (če lestvica ni bila dosežena) bodisi z izvajanjem
      # zaključimo, saj imamo v kombinaciji 7 kart lahko le eno neprekrivajočo se lestvico.
      if (dolzina < 5) {
        dolzina <- 1
        izbrani_ind <- c()
      } else {
        break
      }
    }
  }

  izbrani_ind <- unique(izbrani_ind) # nekatere karte se ponavljajo, česar seveda ne želimo
  
  if (length(izbrani_ind) >= 5) {
    # torej se nam v kombinaciji lestvica res pojavi
    izbrane <- kombinacija[izbrani_ind, ]
    izbrane <- tail(izbrane, n=5) # če lestvica obsega več kot 5 kart, vzamemo največje
    barve_lestvice <- append(barve_lestvice, 4 + sum(izbrane$vrednost)/100)
  }
  
  
  
  # 2. Barva ali barvna lestvica
  if (max(skupaj_barve$freq) >= 5) {
    if (dolzina >= 5) { 
      # pogoj za lestvico
      izbrane <- kombinacija[izbrani_ind, ]
      izbrane <- tail(izbrane, n=5) # če lestvica obsega več kot 5 kart, vzamemo največje
      return(8 + sum(izbrane$vrednost)/100)
      
    } else {
      # sicer gre le za barvo
      izbrana_barva <- skupaj_barve$x[which.max(skupaj_barve$freq)]
      izbrane <- kombinacija[kombinacija$barva == izbrana_barva, ]
      izbrane <- tail(izbrane, n=5) # če je slučajno več kot 5 kart iste barve, vzamemo največje
      barve_lestvice <- append(barve_lestvice, 5 + sum(izbrane$vrednost)/100)
    }
  }
  
  
  
  # 3. Poker oz. 4 enake 
  if (max(skupaj_vrednosti$freq) == 4) {
    # Lahko se pojavijo največ 4 karte z enako vrednostjo, poleg tega lahko nastopi le ena taka kombinacija.
    izbrana_vrednost <- skupaj_vrednosti$x[which.max(skupaj_vrednosti$freq)]
    return(7 + 4*izbrana_vrednost/100) # v tem primeru lahko uporabimo dejansko vrednost
  }
  
  
  
  # 4. Full house
  if ((3 %in% skupaj_vrednosti$freq) && (2 %in% skupaj_vrednosti$freq)) {
    # Če se v kombinaciji pojavita tako par kot tris, gre za full house
    vrednost_tris <- (skupaj_vrednosti[skupaj_vrednosti$freq == 3, ])[1, 1] # ta se ob pogoju lahko pojavi le enkrat
    vrednost_par <- skupaj_vrednosti[skupaj_vrednosti$freq == 2, ]
    vrednost_par <- max(vrednost_par$x) # ta se lahko pojavi dvakrat, zato izberemo večjo možnost
    return(6 + (3*vrednost_tris + 2*vrednost_par)/100)
  }
  
  
  
  # 5. Lestvica in barva
  # Na tem mestu lahko uporabimo že prej izračunani vrednost, saj so vse nadalje lahko zgolj manjše. Če se v
  # kombinaciji ne pojavi ne lestvica in ne barva, z iskanjem vrednosti nadaljujemo.
  if (length(barve_lestvice) > 0) {
    # Če vrednosti obstajajo, izberemo največjo.
    return(max(barve_lestvice))
  }
  
  
  
  # 6. Tris
  if (3 %in% skupaj_vrednosti$freq) {
    vrednost_tris <- skupaj_vrednosti[skupaj_vrednosti$freq == 3, ] # tokrat bi lahko imeli tudi 2 različna trisa
    vrednost_tris <- max(vrednost_tris$x)
    return(3 + 3*vrednost_tris/100)
  }
  
  
  
  # 7. Dva para
  if (nrow(skupaj_vrednosti[skupaj_vrednosti$freq == 2, ]) >= 2) {
    # Seveda se lahko pojavijo tudi trije pari. V tem primeru nas zanimata močnejša dva.
    pari <- skupaj_vrednosti[skupaj_vrednosti$freq == 2, ]
    if (nrow(pari) > 2) {
      # Če so pari trije, se najmanjšega znebimo.
      pari <- skupaj_vrednosti[skupaj_vrednosti$x != min(skupaj_vrednosti$x), ]
    }
    return(2 + 2*sum(pari$x)/100)
  }
  
  
  
  # 8. En par
  if (2 %in% skupaj_vrednosti$freq) {
    # Edina možnost, da pridemo do tega pogoja je, da se pojavi natanko 1 par.
    vrednost <- skupaj_vrednosti[skupaj_vrednosti$freq == 2, ][1, 1]
    return(1 + 2*vrednost/100)
  }
  
  
  
  # 9. Najvišja karta
  # Če smo prišli do konca, se med kartami ne pojavi nobena kombinacija, zato nas zanima le vrednost najmočnejše
  # karte.
  return(0 + max(kombinacija$vrednost)/100)
}






# Par primerov uporabe funkcije:
test <- karte[c(1, 4, 22, 8, 5, 43, 52)]
test1 <- karte[1:7]
test2 <- karte[c(3, 4, 33, 47, 22, 10, 51)]

ovrednoti(test)
ovrednoti(test1)
ovrednoti(test2)



