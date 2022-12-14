; Papillion Practical
; Jugal Patel

; Initialization
globals [] ; initiallizes global variables
patches-own [elevation used?] ; initializes pacthes (patches have 'elevation') (patches == cells)
turtles-own [start-patch] ; initializes turtles (turtle have '') (turtles == agents)

to setup
  ca
  if card = "real" [
    file-open "ElevationData.txt"
    while [not file-at-end?]
    [
      let next-Y file-read
      let next-X file-read
      let next-elevation file-read
      ask patch next-X next-Y [set elevation next-elevation]
    ]
    let min-elevation min [elevation] of patches
    let max-elevation max [elevation] of patches
    file-close
  ask patches
  [
      set pcolor scale-color green elevation min-elevation max-elevation ; sets colour attribute to elevation variable (increased elevation = increased green-ness)
      set used? false ; set used variable (is cell used) as false
  ]
  reset-ticks
  ]

  if card = "simulated"[
  ask patches
  [
    let elev1 100 - distancexy 30 30 ; create elevation gradient w elevation 100 at 30, 30
    let elev2 50 - distancexy 120 100 ; create elevation gradient w elevation 50 at 120, 100

   ifelse elev1 > elev2
    [set elevation elev1] ; random 10 adds noise +/- 10 value to elevation attributes of cells
    [set elevation elev2] ; if elevation arrising from elev1 hill's gradient is greater than elev2 hill, use elev1 gradient, otherwise use elev2 gradient

   set pcolor scale-color green elevation 0 100 ; sets colour attribute to elevation variable (increased elevation = increased green-ness)

   set used? false ; set used variable (is cell used) as false
  ]
  reset-ticks
  ]

  crt 50
  [
    set shape "papillion" ; imported butterfly1 shape as papillion; potential for error when running on non local pc**
    set size 2
    setxy (125 + random 10) (125 + random 10)
    set start-patch patch-here
  ]
end ; creates one turtle agent with size 2 at loc 85, 95

; Iterative actions
to go
  ask turtles [move
    if trace? = true [pen-down]] ; associated with trace? swicth in interfce
  tick
  plot corridor-width
  if ticks >= 1000 [
    let final-corridor-width corridor-width
    output-print word "corridor width:" final-corridor-width
    export-plot "corridor-width" (word "corridor-output-for-q-" q ".csv")
    stop] ; simulation automatically halts at 1000th tick

end ; ascribes function of 'move' to turtle - performed at each tick / time step / iteration

; Dynamism in agents
to move
  if elevation >= [elevation] of max-one-of neighbors [elevation] [stop] ; asks movement to stop if current cell elevation is the max within it's neighbourhood
  set used? true ; sets used? variable to true (this cell has been used)
  ifelse random-float 1 < q
  [uphill elevation]
  [move-to one-of neighbors]
end ; move function is defined to move uphill if float is greater than q, else move to a neighbour cell

; Reporting
to-report corridor-width
  let patches-visited count patches with [used?]
  let mean-distance mean [distance start-patch] of turtles
  report patches-visited / mean-distance
end
@#$#@#$#@
GRAPHICS-WINDOW
415
10
994
590
-1
-1
3.81
1
10
1
1
1
0
0
0
1
0
149
0
149
1
1
1
ticks
30.0

BUTTON
71
44
134
77
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
152
45
215
78
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
68
90
240
123
q
q
0
1
0.28
0.01
1
NIL
HORIZONTAL

MONITOR
68
157
189
202
NIL
corridor-width
17
1
11

PLOT
70
203
270
353
corridor-width
ticks
mean-distance
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"pen-0" 1.0 0 -7500403 true "" ""

SWITCH
257
90
374
123
trace?
trace?
0
1
-1000

CHOOSER
247
36
385
81
card
card
"real" "simulated"
0

@#$#@#$#@
## Description ODD du mod??le de papillons
Ce fichier d??crit le mod??le de Pe'er et al. (2005). La description est tir??e de la section 3.4 de Railsback et Grimm (2012). Le fichier utilise le format de NetLogo.

## Purpose
Le mod??le fut cr???? pour explorer les questions de corridors virtuels. Sous quelles conditions le comportement d'ascension des papillons m??ne-t'il ?? l'??mergence de corridors virtuels, c'est-??-dire, de corridors ??troits emprunt??s par les papillons lors de leur ascension? Comment la variabilit?? dans le comportement des papillons affectera l'??mergence de corridors virtuels?

## Entit??s, variables d'??tat et ??chelles
Le mod??le comporte deux types d'entit??s: les papillons et les cellules carr??es. Les cellules forment une grille de 150 x 150 patches, et chaque cellule (ou patch) n'a qu'une seule variable d'??tat (ou patch-own): son ??l??vation. Les papillons ne sont caract??ris??s que par leur localisation, c'est-??-dire la cellule sur laquelles ils se trouvent. Ainsi, les localisation des papillons sont de type discr??tes: les coordonn??es x et y du centre de la cellule sur laquelle ils se trouvent. La taille des cellules et la dur??e d'une it??ration ne sont pas sp??cifi??es car le mod??le est g??n??rique, mais lorsque le vrai mod??le d'??l??vation est utilis??, chaque cellule correspond ?? 25 X 25 m<sup>2</sup>. Les simulations roulent pendant 1000 it??rations; la dur??e d'une it??ration n'est pas sp??cifi??e mais devrait repr??senter le temps requis pour qu'un papillons avance de 25 ?? 35 m??tres (la distance d'une cellule aux voisines).

## Processus
Il n'y a qu'un seul processus dans le mod??le: le mouvement des papillons. ?? chaque it??ration, chaque papillon bouge une fois. L'ordre dans lequel les papillons ex??cutent l'action n'est pas important puisque les interactions ne sont pas prises en compte.

## Concepts de conception
Le _principe de base_ de ce mod??le est le concept de corridors virtuels utilis??s par plusieurs individus alors qu'il n'y a rien de particuli??rement b??n??fique dans ceux-ci. Ce concept est rencontr?? lorsque des corridors _??mergent_ de deux parties du mod??le: le comportement adaptatif des papillons et le paysage dans lequel ils se  d??placent. Ce _comportement adaptatif_ est mod??lis?? via une simple r??gle empirique reproduisant le comportement observ?? chez des vrais papillons: se d??placer en altitude. Ce comportement est bas?? sur la compr??hension (non incluse dans le mod??le) que se d??placer en altitude m??nera ?? l'accouplement et, par le fait m??me, au succ??s dans la transmission de g??nes, objectif ultime de tout organisme. Puisque nous consid??rons l'ascension comme objectif premier des papillons, la notion d'_apprentissage_ n'est pas utilis??e dans le mod??le.

La _d??tection_ est importante dans ce mod??le: les papillons sont pr??sum??s aptes ?? identifier quelle cellule parmi son voisinage a la plus haute altitude, mais aucune information au dela du voisinage ne lui est accessible. (Les ??tudes terrain de Pe'er 2003 s'attardaient ?? conna??tre jusqu'?? quelle distance les papillons per??oivent les diff??rences d'??l??vation.)

Le mod??le n'inclut pas d'_interaction_ entre les papillons; dans ses ??tudes de terrain, Pe'er (2003) arriva ?? la conclusion que les papillons r??els interagissent (ils cessent parfois leur ascension pour aller ?? la rencontre d'autres papillons pendant un moment), mais d??cida que ce comportement n'??tait pas dans un mod??le de corridors virtuels.

La _stochasticit??_ est utilis??e pour repr??senter deux sources de variabilit?? dans les mouvements trop complexes pour ??tre repr??sent?? de fa??on m??caniste. Les vrais papillons ne se d??placent pas toujours directement vers le sommet, notamment ?? cause de 1) limites dans l'habilet?? des papillons ?? d??tecter le sommet le plus ??lev?? dans leur voisinage, et 2) facteurs autres que la topographier (p.ex. fleurs) influencant la direction et le mouvement. Cette variabilit?? est repr??sent??e en assumant que les papillons ne se d??placent pas vers le sommet ?? chaque it??ration; parfois, ils vont dans une direction al??atoire. Si un papillons se d??place vers le sommet ou al??atoire ?? un temps donn?? est fonction d'un param??tre _q_, ??tant la probabilit?? qu'un individu se d??place au sommet plut??t qu'al??atoirement.

Afin de permettre l'_observation_ de corridors virtuels, nous d??finiront une mesure sp??cifique de "largeur de corridor" repr??sentant la largeur de territoire du chemin emprunt?? par un papillon, de son point de d??part au sommet.

## Initialisation
La topographie du paysage (l'??l??vation de chaque patch) est initialis??e lorsque le mod??le d??marre. Deux types de paysages sont utilis??s dans diff??rentes versions du mod??le: (1) une topographie artificielle avec deux sommets, et (2) la topographie d'un site d'??tude, import??e d'un fichier contenant les valeurs d'??l??vation pour chaque cellule. Les papillons sont initialis??s en cr??ant 500 inidvidus et en d??finissant leur localisation d'origine au m??me endroit.

## Intrants
L'environnement est constant, alors le mod??le n'a aucun intrant

## Sous-mod??les
Le sous-mod??le de mouvement (ou proc??dure de mouvement) d??finit comment les papillons d??cident de se d??placer 1) en altitude ou 2) al??atoirement. Premi??rement, se d??placer en altitude est d??finit comme se d??placer vers la cellule voisine ayant la plus haute valeur d'??l??vation; si deux cellules ont la m??me ??l??vation, une sera s??lectionn??e al??atoirement. "Se d??placer al??atoirement" est d??fini comme se d??placer sur une des cellules voisines, avec une probabilit?? ??gale pour chacune. Les cellules "voisines" sont les 8 cellules entourant la patch sur laquelle se retrouve un papillon. La d??cision de se d??placer en altitude ou al??atoirement est contr??l??e par le param??tre _q_, qui varie de 0.0 ?? 1.0 (_q_ est une variable globale: tous les papillons utilisent la m??me valeur). ?? chaque it??ration, chaque papillon "pige" un nombre al??atoire provenant d'une distribution uniforme entre 0.0 et 1.0. Si ce nombre est inf??rieur ?? _q_, le papillon ira vers un sommet, sinon, il bougera de fa??on al??atoire.

## R??F??RENCES
Pe???er, G., Saltz, D. & Frank, K. 2005. Virtual corridors for conservation management. _Conservation Biology_, 19, 1997???2003.

Pe???er, G. 2003. Spatial and behavioral determinants of butterfly movement patterns in topographically complex landscapes. Ph.D. thesis, Ben-Gurion University of the Negev.

Railsback, S. & Grimm, V. 2012. _Agent-based and individual-based modeling: A practical introduction_. Princeton University Press, Princeton, NJ.

###_Exercice traduit par Jonathan Gaudreau, 2014. Universit?? de Montr??al._
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

papillion
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
