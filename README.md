# Texas hold 'em poker

Texas hold 'em je ena izmed najbolj popularnih različic igre poker. Na začetku vsak igralec prejme dve karti, nato pa se skupne karte odpirajo v treh fazah. V prvi fazi se na igralni mizi odprejo tri karte, ki jih imenujemo tudi "the flop", sledita ji še dve nadaljni, v katerih se odpre po ena karta, ang. "the turn" in "the river". Cilj vsakega igralca je poiskati čim boljšo kombinacijo petih kart iz vseh, ki jih ima na voljo, tj. dveh svojih in petih skupnih. Pred prvim odpiranjem skupnih kart in po vsaki opravljeni fazi se igralci odločajo o svojih stavah, pri čemer imajo na voljo metode: izenači (ang. call), višaj (ang. raise), odstopi (ang. fold) in check. Na koncu zmaga igralec z najboljšo kombinacijo izmed vseh, ki so še v igri.

Sam bom v projektu obravnaval le verjetnosti zmage igralca glede na karte, ki so mu na voljo. Gre torej za obravnavo, da bo z do sedaj zbranimi kartami igralec na koncu imel izmed vseh najboljšo kombinacijo kart. Zaradi tega program nikakor ne bo obravnaval stavnih metod igralca, saj je namenjen zgolj pomoči igralcu pri uresničevanju svoje igralne strategije.




## Kombinacije in njihove verjetnosti

Temelj zgoraj vpisane igre vsekakor predstavljajo verjetnosti, da pridemo do neke želene kombinacije kart. Seveda so pravila igre zastavljena na način, da je najmočnejša kombinacija najmanj verjetna. Tako se npr. royal flush, pojavi zgolj z verjetnostjo 0.000154%, medtem ko do najpogostojstejše kombinacije, enega para, pridemo približno z verjetnostjo 42.3%. 

Izračun teh verjetnosti torej predstavljajo temelj mojega programa. Seveda moramo upoštevati tudi spreminjajoče se dejavnike, kot so število nasprotnikov in pa že odprte karte. Po vsaki fazi odpiranja kart se namreč zaradi na novo pridobljenih podatkov iskane verjetnosti lahko drastično spremenijo.




## Model

Glavna funkcija mojega programa je funckcija `ovrednoti`, ki dani kombinaciji sedmih kart določi neko numerično vrednost, s pomočjo katere lahko kombinacije med seboj primerjamo. Ta vrednost je sestavljena iz dveh delov, pri čemer nam celoštevilski del pove vrednost dosežene kombinacije, decimalni del pa vsoto upoštevanih kart, kar potrebujemo za medsebojno primerjavo enakih kombinacij.

Preostanek programa temelji na ideji Monte Carlo metod. Zaradi prevelikega števila možnih kombinacij je namreč obravnava vseh nemogoča, zato v resnici računamo približke iskanih verjetnosti. Za izbrane parametre tako program generira neko dovolj veliko število možnih scenarijev in opazuje v koliko od njih igralec zmaga. Za iskano verjetnost tako vzamemo kar razmerje, pridobljeno s pomočjo obravnave teh scenarijev.




## Navodila za uporabnika

<!--- Dodaj nahajanje programa, opis map, nahajanje knjižnic, ... --->

Uporabnik v uporabniški konzoli izbere naslednje parametre, na podlagi katerih se izračuna iskana verjetnost:
* 2 karti, ki jih ima v roki
* 3 karte, ki se pojavijo v flop-u (izbira je neobvezna)
* 1 turn karta (izbira je neobvezna)
* 1 river karta (izbira je neobvezna)
* število nasprotnikov.

Po njihovi izbiri klikne na gumb *Izračunaj*, ki program požene in izpiše končno verjetnost.
