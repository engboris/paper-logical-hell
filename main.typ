#import "@preview/arkheion:0.1.0": arkheion, arkheion-appendices
#import "@preview/prooftrees:0.1.0"

#show: arkheion.with(
  title: "Descente dans l'enfer logique",
  authors: (
    (name: "Boris Eng",
     email: "https://engboris.fr",
     affiliation: "ReFL, OCamlPro"),
  ),
  abstract: [
  Dans cet article, j'illustre comment il est possible de partir d'intuitions naturelles sur le raisonnement pour ensuite descendre, en utilisant les dernières recherches en informatique théorique, à des niveaux de compréhension où toute intuition est évacuée au profit d'une connectique du sens. J'illustre mon propos en partant de l'évidence "si A est vrai, alors A est vrai".
  ],
  date: "27/10/2024",
)
#set cite(style: "chicago-author-date")
#show link: underline
#show heading.where(level: 3): it => it.body

#let interp(x) = $bracket.l.double #x bracket.r.double$

= Du langage naturel au langage formel

Posons une assertion quelconque que l'on appellera $A$. Cette assertion est soit vraie soit fausse. Si je dis que si $A$ est vrai alors $A$ doit nécessairement être vrai, cela devrait sonner comme une évidence qui ne mériterait même pas d'être formulée. "C'est logique, c'est comme ça" dira t-on.

Pour donner plus de crédit à l'assertion, on pourrait vouloir la mathématiser avec un jeu de symboles. Posons un ensemble de symboles ${A, B, C, ...}$. Au lieu de dire "si ... alors ..." je pourrais écrire $=>$ pour obtenir $A => A$ que l'on qualifie de _formule logique_.

= Sémantique de vérité

Tout cela n'est qu'une concaténation de symboles. Je dois définir le sens du symbole $=>$. Je représente les valeurs de vérité avec $1$ pour vrai et $0$ pour faux et la valeur de vérité de $A$ par $sigma(A)$. La valeur de vérité $sigma(A => B)$ de $A => B$ est définie de telle sorte que $sigma(A => B)$ (c'est-à-dire que $A => B$ est logiquement valide) lorsque l'erreur logique d'avoir $sigma(A) = 1$ et $sigma(B) = 0$ donne $sigma(A => B) = 0$ (le vrai ne peut pas impliquer le faux) et dans tous les autres cas $sigma(A => B) = 1$. En particulier, cela a pour conséquence que $sigma(A => A) = 1$.

= Théorie de la démonstration

Nous savons que $A => A$ est _vrai_ et nous l'avons obtenu par un petit calcul de valeur de vérité. Mais pourquoi est-ce valide ? Il faut le _prouver_ avec une _preuve_ de la même manière que l'on essaie de prouver l'innocence d'une personne devant un juge. La théorie de la démonstration nous propose de construire des preuves par empilage de _règles logiques_ dans un système de règles défini à l'avance qui reflète le raisonnement.

Ces systèmes logiques, bien qu'ils possèdent de nombreuses règles pour divers symboles logiques, si l'on s'intéresse purement et simplement au cas de notre assertion $A => A$, nous avons les règles suivantes :

#grid(
  columns: (1fr, 1fr),
  rows: (auto, auto),
  align: center,
  gutter: 3pt,
  [
    #prooftrees.tree(
      prooftrees.axi[(hypothèses)],
      prooftrees.uni[$A tack.r A$ (conclusion)]
    )
  ],
  [
    #prooftrees.tree(
    prooftrees.axi[$Gamma, A tack.r B$],
    prooftrees.uni[$Gamma tack.r A => B$]
    )
  ],
)

où $tack.r$ sépare l'espace des hypothèses et des conclusions dans une assertion en tant qu'étape du raisonnement. La règle de gauche nous dit que $A$ se trouve dans l'espace des hypothèses et dans l'espace des conclusions alors la preuve est validée. La règle de droite, lue de bas en haut, nous dit que si l'on souhaite prouver $A => B$, il faut placer $A$ dans l'espace des hypothèses puis prouver $B$.

Par application de ces règles, nous pouvons construire cette preuve de $A => A$ :

#prooftrees.tree(
  prooftrees.axi[],
  prooftrees.uni[$A tack.r A$],
  prooftrees.uni[$tack.r A => A$]
)

= Correspondance de Curry-Howard

Mais de quel droit peut-on invoquer les règles logiques que nous invoquons ? La correspondance de Curry-Howard en informatique théorique nous dit qu'il y a une correspondance formelle entre les preuves mathématiques (comme notre preuve de $A => A$) et la notion de _type_ en programmation fonctionnelle. La programmation fonctionnelle est un paradigme de programmation permettant le calcul par composition d'expressions "fonctionnelles" prenant une entrée et produisant une sortie. Les types sont des étiquettes permettant de contraindre le comportement des programmes.

En particulier, il se trouve que l'implication $A => B$ correspond au type des fonctions $A -> B$ prenant une entrée de type $A$ et produisant un résultat de type $B$ en sortie. Il en ressort que les preuves sont des programmes. Mais il ne s'agit pas de n'importe quel système logique et de n'importe quel langage fonctionnel : il s'agit de la déduction naturelle pour la logique minimale implicative et du $lambda$-calcul simplement typé.

Notre assertion $A => A$ devient maintenant le type $A -> A$ et notre preuve précédente devient l'expression fonctionnelle $lambda x^A.x$ qui est une _fonction identité_ prenant une entrée $x$ de type $A$ et la retournant (elle ne fait rien d'autre que rendre ce qui lui est donné en entrée).

= Logique linéaire

La logique linéaire nous apprend que l'implication $A => B$ peut-être décomposée en sous-connecteurs pour devenir $!A multimap B$ exhibant le fait implicite que $A$ peut être utilisé un nombre illimité de fois dans le raisonnement pour prouver $B$ (la vérité n'est pas consommable). L'implication $multimap$ est une implication _linéaire_ qui utilise une unique fois son entrée (les assertions deviennent des entités consommables et qui doivent être consommées sans laisser de restes).

Nous sommes dans un cadre où nous pourrions imaginer une preuve qui duplique son argument $A$ un certain nombre de fois pour ensuite les effacer mais nous allons plutôt changer légèrement de cap et nous intéresser à la justification plus simple de l'implication linéaire $A multimap A$.

= Théorie des réseaux de preuve

Nous pourrions en rester aux preuves précédentes en les appliquant à la logique linéaire qui a le mérite de donner plus de détails sur le pourquoi des choses. Cependant, Jean-Yves Girard, en analysant les preuves de la logique linéaire, est arrivé à une nouvelle représentation des preuves plus canonique qui se défait de l'ordre d'application des règles (jugé non pertinent) et arrive à des preuves ressemblant à des graphes reliant des formules. Ces nouvelles preuves s'appellent des _réseaux de preuve_.

Dans ce nouveau paradigme, la preuve de $A multimap A$ devient un simple câble reliant deux occurrences de $A$ vues comme conclusions et notées $A(0)$ et $A(1)$, que l'on pourrait dessiner comme ceci :

#prooftrees.tree(
  prooftrees.axi[ax],
  prooftrees.uni[$A(0) quad quad A(1)$],
)

Que reste t-il si on oublie nos présupposés sur la notion de formule et de preuve à ce stade ? Nous obtenons simplement un graphe connectant des points dans l'espace. Mais qu'est-ce qui fait que ce graphe a un sens logique ou qu'il est logiquement correct ?

Girard définit un _critère de correction_ pour déterminer quels sont les graphes corrects qui sera ensuite simplifié par Danos et Regnier. Les graphes doivent passer un certain nombre de tests définis. Pour être correct il faut donc :
- avoir une certaine "circuiterie" déterminée par ces tests;
- avoir des points distincts;
- se placer dans un système qui identifie des points comme étant des _occurrences_ d'une même formule.

Ces points exhibent ce qui est implicite dans les évidences, en particulier le fait qu'elles se placent dans un système sans pour autant être totalement relatives étant donné qu'elles ont une structure spécifique.

Comme on a perdu la notion d'occurrence, en réalité, nous n'avons pas une preuve de $A multimap A$ (inatteignable seulement par la morphologie des preuves) mais une preuve de quelque chose comme $A multimap A'$ ou $A(0) multimap A(1)$ qui est plutôt une fonction de _copie_ (qualifié de _fax_ par Girard) qui copie son entrée qu'une fonction identité comme pour la correspondance de Curry-Howard.

= Géométrie de l'interaction

Dans son programme de géométrie de l'interaction, Girard a cherché à comprendre ce qui caractérisait mathématiquement la théorie des réseaux de preuve. Il y a diverses manières de voir mathématiquement les réseaux de preuve : comme des permutations ou partitions sur des ensembles d'entiers naturels, comme des graphes interactifs, comme des isométries partielles, etc.

En particulier, il est possible de se placer dans un espace d'objets qui permet de représenter et d'internaliser les tests de critère de correction qui étant précedemment donnés par une évaluation externe.

Une partition d'un ensemble d'entiers est une manière de séparer l'ensemble en plusieurs groupes. Par exemple ${{1,2}, {3}}$ et ${{1}, {2, 3}}$ sont des partitions de ${1, 2, 3}$. On peut représenter notre preuve de $A multimap A$ par la partition ${{1, 2}}$ et aussi l'unique test de critère de correction correspondant par la partition ${{1}, {2}}$. Passer le test consiste à relier les entiers identiques et à obtenir une structure connexe (tout est connecté) et sans cycle. On obtient donc une matérialisation de notre preuve mais aussi ce qui fait que notre preuve est correcte puis on connecte les deux comme on branche deux câbles électriques.

= Syntaxe transcendantale

Ce cadre est trop limité. On peut aller plus loin en se plaçant dans un cadre plus puissant, plus permissif et plus expressif qui est celui de l'unification de termes et en particulier du principe de résolution qui est notamment utilisé en programmation logique.

L'idée est de former des agents indépendants pouvant se connecter et interagir par destruction du port connecté et propagation d'information, de la même manière que l'on ferait interagir des molécules ensemble dans une "grosse soupe d'interconnexions".

Notre preuve de $A multimap A$ devient l'expression $[+1, +2]$ et son test $[-1]+[-2]$. Les symboles de polarité opposée peuvent se connecter ensemble. Lorsque que $[+1, +2]$ interagit avec $[-1]$, on obtient $[+2]$ qui peut à son tour interagir avec $[-2]$ pour laisser $[]$ indiquant que tout s'est bien connecté. Dans le cas de dépendances circulaires, on aurait eu une interaction infinie. On a donc réifié la notion de correction en des phénomènes de calcul : le passage des tests est un test morphologique certifiant et l'échec devient un résultat erroné ou un calcul bloqué dans une boucle infinie.

Dans la syntaxe transcendantale, on peut dire que l'on a atteint une forme de _connectique du sens_. Cependant, il faut reconstruire tout l'écosystème de nos présupposés systémiques. Que signifie la notion d'occurrence dans ce monde où tout est unique et localisé dans l'espace, comme dans la mémoire d'un ordinateur finalement ?

Cela nous amène notamment à nous questionner sur le sens de l'égalité logique. En calcul des prédicats (aussi appelée logique du premier ordre), l'égalité est un simple prédicat comme d'autres et non un concept fondamental. Donc un élément d'une catégorie à part et arbitraire. En logique du second ordre, nous avons la définition nous disons que deux termes sont égaux lorsque qu'aucune propriété ne peut les distinguer. Cependant, il se trouve que cet "espace des propriétés" est toujours choisi de sorte à ce que deux occurrences d'une même entité soient considérées égales. Sauf que lorsqu'on écrit $a = a$, comme dit Girard, l'un est à gauche et l'autre à droite. Dans notre paradigme de syntaxe transcendantale, elles auraient donc deux adresses différentes. En informatique, on parlerait d'inégalité physique pour dire que deux éléments ne sont pas à la même adresse dans la mémoire. Peut-on dire que c'est une propriété invalide ? Ce qui reste à faire c'est décrire toute cette connectique du _système_ qui nous dit que nous considérons un espace des propriétés et pas un autre, certaines règles et pas d'autres. En d'autres termes, rendre explicite nos présupposés, même dans les évidences les plus banales, celles dont on ne doute plus parce que cela serait absurde autrement.
