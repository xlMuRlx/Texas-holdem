# Texas hold 'em poker

Texas hold 'em je ena izmed najbolj popularnih različic igre poker. Na začetku vsak igralec prejme dve karti, nato pa se skupne karte odpirajo v treh fazah. V prvi fazi se na igralni mizi odprejo tri karte, ki jih imenujemo tudi "flop", sledita ji še dve nadaljni, v katerih se odpre po ena karta, ang. "turn" in "river". Cilj vsakega igralca je poiskati čim boljšo kombinacijo petih kart iz vseh, ki jih ima na voljo, tj. dveh svojih in petih skupnih. Pred prvim odpiranjem skupnih kart in po vsaki opravljeni fazi se igralci odločajo o svojih stavah, pri čemer imajo na voljo metode: izenači (ang. call), višaj (ang. raise), odstopi (ang. fold) in check. Na koncu zmaga igralec z najboljšo kombinacijo izmed vseh, ki so še v igri.

Sam bom v projektu obravnaval le verjetnosti zmage igralca glede na karte, ki so mu na voljo. Gre torej za obravnavo, da bo z do sedaj zbranimi kartami igralec na koncu imel izmed vseh najboljšo kombinacijo kart. Zaradi tega program nikakor ne bo obravnaval stavnih metod igralca, saj je namenjen zgolj pomoči igralcu pri uresničevanju svoje igralne strategije.




## Navodila za uporabnika

Glavni program se nahaja v datoteki ui.R. Po zagonu te datoteke se pred njim pojavi uporabniška konzola, v kateri uporabnik nato izbere naslednje parametre, na podlagi katerih se izračuna iskana verjetnost:
* 2 karti, ki jih ima v roki
* 3 karte, ki se pojavijo v flop-u (izbira je neobvezna)
* 1 turn karta (izbira je neobvezna)
* 1 river karta (izbira je neobvezna)
* število nasprotnikov.

Po njihovi izbiri klikne na gumb *Izračunaj!*, ki program požene in izpiše končno verjetnost.




## Kombinacije in njihove verjetnosti

Temelj zgoraj vpisane igre vsekakor predstavljajo verjetnosti, da pridemo do neke želene kombinacije kart. Seveda so pravila igre zastavljena na način, da je najmočnejša kombinacija najmanj verjetna. Tako se npr. royal flush, pojavi zgolj z verjetnostjo 0.000154%, medtem ko do najpogostojstejše kombinacije, enega para, pridemo približno z verjetnostjo 42.3%. 

Izračun teh verjetnosti torej predstavljajo temelj mojega programa. Seveda moramo upoštevati tudi spreminjajoče se dejavnike, kot so število nasprotnikov in pa že odprte karte. Po vsaki fazi odpiranja kart se namreč zaradi na novo pridobljenih podatkov iskane verjetnosti lahko drastično spremenijo.




## Model

Temeljna funkcija mojega programa je funckcija `ovrednoti`, ki dani kombinaciji sedmih kart določi neko numerično vrednost, s pomočjo katere lahko kombinacije med seboj primerjamo. Pri tem je pomembno omeniti, da se vselej seveda upošteva zgolj 5 kart, ki sestavljajo najboljšo kombinacijo. Vrednost je sestavljena iz dveh delov, pri čemer nam celoštevilski del pove vrednost dosežene kombinacije, decimalni del pa vsoto upoštevanih kart, kar potrebujemo za medsebojno primerjavo enakih kombinacij. Vrednosti kombinacije so bile določene v skladu z njihovo močjo, in sicer:
* visoka karta: 0 (npr. A:clubs:, J:diamonds:, 10:spades:, 5:clubs:, 2:hearts: ima vrednost 0,42)
* en par: 1 (npr. 10:hearts:, 10:clubs:, 9:hearts:, 4:diamonds:, 2:diamonds: ima vrednost 1,35)
* dva para: 2 (npr. A:spades:, A:clubs:, J:diamonds:, J:clubs:, 7:spades: ima vrednost 2,57)
* tris oz. set: 3 (npr. 8:clubs:, 8:spades:, 8:diamonds:, K:clubs:, 4:hearts: ima vrednost 3,41)
* lestvica: 4 (npr. Q:clubs:, J:diamonds:, 10:hearts:, 9:spades:, 8:diamonds: ima vrednost 4,50)
* barva: 5 (npr. A:spades:, J:spades:, 8:spades:, 5:spades:, 2:spades: ima vrednost 5,40)
* full house: 6 (npr. J:klubs:, J:hearts:, J:spades:, 8:diamonds:, 8:hearts: ima vrednost 6,49)
* poker: 7 (npr. Q:clubs:, Q:hearts:, Q:diamonds:, Q:spades:, 4:diamonds: ima vrednost 7,52)
* barvna lestvica: 8 (npr. 9:clubs:, 8:clubs:, 7:clubs:, 6:clubs:, 5:clubs: ima vrednost 8,35)
Pri tem je pomembno omeniti še dejstvo, da se običajno posebej obravnava še kraljevo lestvico. Ker pa v programu decimalni del predstavlja vsoto uporabljenih kart, smo z njim že upoštevali, da gre zgolj za najvišjo barvno lestvico, zato ni potrebno definirati še enega razreda (npr. A:hearts:, K:hearts:, Q:hearts:, J:hearts:, 10:hearts: ima vrednost 8,60).

Preostanek programa temelji na ideji Monte Carlo metod in se nahaja v datoteki model.R, kjer je definirana tudi glavna funkcija za izračunavanje `model`. Zaradi prevelikega števila možnih kombinacij je namreč obravnava vseh nemogoča, zato v resnici računamo približke iskanih verjetnosti. Za izbrane parametre tako program generira neko dovolj veliko število možnih scenarijev in opazuje v koliko od njih igralec zmaga. Za iskano verjetnost tako vzamemo kar razmerje, pridobljeno s pomočjo obravnave teh scenarijev.
