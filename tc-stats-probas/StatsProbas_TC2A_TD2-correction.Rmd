---
title: "Lois de probabilité et estimation"
author: "FX Jollois"
date: "TC - 2ème année - 2021/2022"
output:
  beamer_presentation:
    theme: "Madrid"
    colortheme: "seahorse"
    fonttheme: "structurebold"
header-includes:
- \usepackage{booktabs}
- \usepackage{longtable}
- \usepackage{array}
- \usepackage{multirow}
- \usepackage{wrapfig}
- \usepackage{float}
- \usepackage{colortbl}
- \usepackage{pdflscape}
- \usepackage{tabu}
- \usepackage{threeparttable}
- \usepackage{threeparttablex}
- \usepackage[normalem]{ulem}
- \usepackage{makecell}
- \usepackage{xcolor}
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, warning = FALSE, message = FALSE)
library(tidyverse)
library(knitr)
library(kableExtra)
set.seed(1234)
```

## Exercices

### Plus grand nombre tiré
On joue à un jeu avec deux dés (non pipés), pendant lequel on note le plus grand chiffre obtenu. Quelle est la loi de la variable aléatoire  ?

::: alert
### Solution

$P(X= 1) = \frac{1}{36}$...
:::

## Exercices - Loi uniforme continue

### Exercice 1
$X$ est une v.a. de loi uniforme sur l'intervalle $I$. Déterminer pour chaque intervalle ci-dessous la fonction de densité et calculer $P(4 \le X \le 5)$.

1. $I = [4; 6]$
2. $I = [0; 5]$

::: alert
### Solution pour $I = [4; 6]$
- $f(x) = \frac{1}{b - a} = \frac{1}{6 - 4} = \frac{1}{2} = .5$
- $P(4 \le X \le 5) = P(X \le 5) - P(X \le 4) = F(5) - F(4) = \frac{x - a}{b - a} - 0 = \frac{5 - 4}{6 - 4} = .5$ 
:::

::: alert
### Solution pour $I = [0; 5]$
- $f(x) = \frac{1}{b - a} = \frac{1}{5 - 0} = \frac{1}{5} = .2$
- $P(4 \le X \le 5) = P(X \le 5) - P(X \le 4) = F(5) - F(4) = 1 - \frac{4 - 0}{5 - 0} = 0.8$ 
:::

## Exercices - Loi uniforme continue

### Exercice 2
$X$ est une v.a. de loi uniforme sur $[-3;3]$.

1. Calculer $P(X < 1)$, et $P(X \ge 0.5)$
1. Donner l'espérance de $X$

::: alert
### Solution 
- $P(X \le 1) = F(A) = \frac{1 - (-3)}{3 - (-3)} = \frac{4}{6} = .333\ldots$
- $P(X \ge .5) = 1 - P(X \le .5) = 1 - \frac{.5 - (-3)}{3 - (-3)} = 1 - \frac{3.5}{6} = 0.416666\ldots$
- $E(X) = \frac{a + b}{2} = \frac{-3 + 3}{2} = 0$
:::
 
## Exercices - Loi uniforme continue

### Exercice 3
Antoine doit venir voir Jean entre 14h45 et 16h30. Quelle est la probabilité qu'il arrive pendant la réunion de Jean qui a lieu entre 15h30 et 16h00 ?

::: alert
### Solution
$X$ l'heure d'arrivée d'Antoine suit une v.a. de loi uniforme sur $[14.75;16.5]$. On va chercher $P(15.5 \le X \le 16)$

\begin{equation*}
\begin{split}
  P(15.5 \le X \le 16) &= P(X \le 16) - P(X \le 15.5) \\
                       &= \frac{16 - 14.75}{16.5 - 14.75} - \frac{15.5 - 14.75}{16.5 - 14.75}\\
                       &= \frac{1.25}{1.75} - \frac{0.75}{1.75}\\
                       &= ~0.286
\end{split}
\end{equation*}
:::

## Exercice

Réussite à un examen de $n$ étudiants

Suivi de la réussite de $n$ étudiants tous les ans depuis 20 ans

