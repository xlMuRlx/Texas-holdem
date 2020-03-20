# Najprej sestavimo seznam oz. tabelo vseh kart. Vsaka karta bo predstavljena kot par, kjer prva komponenta pove njeno vrednost, druga pa barvo.

vrednosti <- c()
for (i in 2:10) {
  vrednosti[[i-1]] <- as.character(i)
}
vrednosti <- c(vrednosti, c("J", "Q", "K", "A"))

barve <- c("kriz", "pik", "srce", "karo")

kupcek <- expand.grid(vrednosti, barve)
colnames(kupcek) <- c("vrednost", "barva")






# Potrebujemo neko funkcijo za medsebojno primerjavo različnih kombinacij kart. Gre za funkcijo, ki iz izbranih 7 kart izbere in ovrednoti naboljšo možno kombinacijo.

ovrednoti <- function(kombinacija) {
  kombinacija$vrednost[kombinacija$vrednost == "J"] <- 11
  kombinacija$vrednost[kombinacija$vrednost == "Q"] <- 12
  kombinacija$vrednost[kombinacija$vrednost == "K"] <- 13
  kombinacija$vrednost[kombinacija$vrednost == "A"] <- 14
  kombinacija$vrednost <- as.numeric(kombinacija$vrednost)
  
  kombinacija <- kombinacija[order(-kombinacija$vrednost), ]
  
}





# Za lažji zapis shiny-ja
karte <- paste(kupcek$vrednost, kupcek$barva)








