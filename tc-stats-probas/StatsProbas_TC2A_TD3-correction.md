# Exercices autour des lois et du calcul de probabilités - *correction*

## Loi uniforme continue

### Exercice 1

**X** est une v.a. de loi uniforme sur l'intervalle *I*. Déterminer pour chaque intervalle ci-dessous la fonction de densité et calculer *P(4 &le; X &le; 5)*.

1. *I = [4; 6]*
2. *I = [0; 5]*

#### Solution

Pour rappel, *P(X &le; x) = F(x) = (x - a) / (b - a)*

1. Avec *I = [4; 6]*, *P(4 &le; X &le; 5) = P(X &le; 5) = (5 - 4) / (6 - 5) = .5*
1. Avec *I = [0; 5]*, *P(4 &le; X &le; 5) = P(X &ge; 4) = 1 - P(X &le; 4) = 1 - (4 - 0) / (5 - 0) = .2*

### Exercice 2

**X** est une v.a. de loi uniforme sur *[-3;3]*.

1. Calculer *P(X < 1)*, et *P(X &ge; 0.5)*
1. Donner l'espérance de **X**

#### Solution

1. Calcul :
    - *P(X < 1) = (1 - (-3)) / (3 - (-3)) = 4 / 6 = .66666....*
    - *P(X &ge; 0.5) = 1 - P(X &le; 0.5) = 1 - (.5 - (-3)) / (3 - (-3)) = 1 - 3.5 / 6 = 2.5 / 6 = 0.41666...*
1. Espérance : *E(X) = (a + b) / 2 = (-3 + 3) / 2 = 0*


### Exercice 3

Antoine doit venir voir Jean entre 14h45 et 16h30. Quelle est la probabilité qu'il arrive pendant la réunion de Jean qui a lieu entre 15h30 et 16h00 ?

#### Solution

On considère donc **X** la v.a. de loi uniforme continue sur l'intervale *[14.75; 16.5]*. Et on calcul *P(15.30 &le; X &le; 16)*.

- *P(15.30 &le; X &le; 16) = P(X &le; 16) - P(X &le; 15.30)*
- *P(15.30 &le; X &le; 16) = (16 - 14.75) / (16.5 - 14.75) - (15.30 - 14.75) / (16.5 - 14.75)*
- *P(15.30 &le; X &le; 16) = 1.25 / 1.75 - .75 / 1.75*
- *P(15.30 &le; X &le; 16) = .5 / 1.75 = 0.2857...*




## Lois discrètes

### Pile ou face à répétition
On joue à pile ou face, 4 fois de suite. Et on note les résultats (dans l'ordre).

1. Déterminer la loi de probabilité 
2. Calculer les probabilités des 2 évènements suivants :
  - *A* : il y a strictement plus de piles que de faces
  - *B* : le premier lancer est pile

#### Solution

1. Loi discrète à 16 issues (l'ordre a du sens a priori) équi-probable (avec *1* : pile et *2* : face)
    - *&Omega; = {1111, 1112, 1121, 1122, 1211, 1212, 1221, 1222, 2111, 2112, 2121, 2122, 2211, 2212, 2221, 2222}*
    - *P(&omega;) = 1/16*
1. Calcul
    - *P(A) = P(1111) + P(1112) + P(1121) + P(1211) + P(2111) = 5 /16 = .3125*
    - *P(B) = .5*

### De l'utilité des probabilités dans les choix stratégiques d'un étudiant

Un test comporte 10 questions, avec chacune 4 choix possibles et une seule réponse juste.

1. Combien y a t'il de grilles de réponses possibles ?
2. Quelle est la probabilité de répondre au hasard 6 fois correctement ? et d'avoir au moins 6 réponses correctes ?

#### Solution

1. On a 4<sup>10</sup> = 1048576 grilles possibles
1. On a dix tirages aléatoires d'une loi de Bernouilli avec *p=.25* &mdash;> **X** &sim; *B(10, .25)*
    - *P(X = 6) = 0.016222*
    - *P(X &ge; 6) = 1 - P(X &le; 5) = 1 - 0.9802723 = 0.01972771*

### Concerts

Supposons un enseignant **J** ayant un groupe de rock et se produit à un concert **C** dans un bar à Cherbourg durant le mois d'octobre. On considère qu'un.e étudiant.e **E** a une probabilité de sortir le soir égale à *.5*, et a une probabilité de *.5* d'aller dans le bar où se produit le groupe.

1. Que puis-je dire de la variable aléatoire modélisant qu'un étudiant **E** voit un concert **C** ? Quelle est la probabilité de l'évènement *A* : **E** vient à **C** ?
1. Maintenant, on se demande combien d'étudiants parmi les 85 de la promo viendront à un concert. Comment modéliser ce processus ? Quelle est la probabilité que moins 10 étudiants viennent ? qu'au moins 20 ? au moins 50 ?
1. Enfin, l'enseignant se produit au final 3 fois dans le mois. On cherche donc à savoir quelle est la probabilité qu'un étudiant **E** voient les trois concerts **C1**, **C2** et **C3**. Comment puis-je faire ?
  - Quelle est la probabilité qu'un étudiant vienne à aucun concert ? à un seul concert ? à deux ? au trois ?
  - Sachant qu'un étudiant qui vient aux trois concerts aura la note maximale (donc 20), celui qui vient à 2 aura 15, à un seul 10, et 0 pour ceux qui ne viennent pas, comment puis-je estimer la moyenne de la promotion ?

#### Solution

1. **X** suit une loi de Bernouilli *p = .25*
    - *P(E à C) = P(Bon bar &cap; Sortie) = .5 &times; .5 = .25*
1. **Y** suit une loi Binomiale &sim; *B(84, .25)*
    - *P(Y &le; 10) = 0.0024*
    - *P(Y &ge; 20) = 1 - P(Y &le; 19) = 1 - 0.3597 = 0.6403*
    - *P(Y &ge; 50) = 1 - P(Y &le; 49) = 1 - 1 = 0*
1. **Z** suit une loi Binomiale &sim; *B(3, .25)*
    - Calcul des probabilités
        - *P(Z = 0) = 0.4219*
        - *P(Z = 1) = 0.4219*
        - *P(Z = 2) = 0.1406*
        - *P(Z = 3) = 0.0156*
    - On peut estimer *N<sub>note</sub> = 84 &times; P(Z = note)*
        - *E(Z') = (1 / 84) &times; &sum;<sub>note</sub> note &times; 84 &times; P(Z = note)*
        - *E(Z') = 6.64*


### Guichet de poste

Dans une poste d’un petit village, on remarque qu’entre 10 heures et 11 heures, la probabilité pour que deux personnes entrent durant la même minute est considérée comme nulle et que l’arrivée des personnes est indépendante de la minute considérée. On a observé que la probabilité pour qu’une personne se présente entre la minute *m* et la minute *m+1* est : *p = 0.1*. On veut calculer la probabilité pour que *n* personnes se
présentent au guichet entre 10h et 11h.

1. Définir une variable aléatoire adaptée. Combien de personnes peut on espérer dans l'heure considérée ?
1. Donner les probabilités qu'aucune personne ne vienne ? qu'une seule personne ? que 6 personnes viennent ?
2. Quelle est la probabilité pour qu'au moins 10 personnes se présentent au guichet entre 10h et 11h ?

#### Solution

1. Une variable aléatoire adaptée à ce problème est le nombre X de personnes se présentant au guichet entre 10h et 11h. Compte tenu des hypothèses, on partage l’heure en 60 minutes. Alors X suit une loi de Poisson de paramètre *&lambda; = 60×0.1 = 6*. 
1. On peut alors calculer les probabilités demandées : 
    - P(X = 0) = 6
1.  Calculons maintenant la probabilité pour que au moins 10 personnes se présentent au guichet entre 10h et 11h :
    - 
    
### Centenaire

Si dans une population une personne sur cent est centenaire, quelle est la probabilité de trouver au moins une personne centenaire parmi 100 personnes choisies au hasard ? Et parmi 200 personnes ?

#### Solution

Poisson (1 / 100)
