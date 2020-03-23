# Najprej sestavimo seznam oz. tabelo vseh kart. Vsaka karta bo predstavljena kot par, kjer prva komponenta pove njeno 
# vrednost, druga pa barvo.

vrednosti <- c()
for (i in 2:10) {
  vrednosti[[i-1]] <- as.character(i)
}
vrednosti <- c(vrednosti, c("J", "Q", "K", "A"))

barve <- c("kriz", "pik", "srce", "karo")

kupcek <- expand.grid(vrednosti, barve)
colnames(kupcek) <- c("vrednost", "barva")










# Za lažji zapis shiny-ja
karte <- paste(kupcek$vrednost, kupcek$barva)



