# Introduction à MongoDB - *évaluation*


## Rendu

Envoyez votre fichier (notebook `ipynb` - avec votre nom dans le nom du fichier) par mail à **francois-xavier.jollois@u-paris.fr**.

2 parties :

1. Suite du travail sur les restaurants
1. Données AirBnB

## Restaurants 

1. Lister tous les restaurants de la chaîne "Bareburger" (rue, quartier)
1. Lister les trois chaînes de restaurant les plus présentes
1. Donner les 10 styles de cuisine les plus présents dans la collection
1. Lister les 10 restaurants les moins bien notés (note moyenne la plus haute)
1. Lister par quartier le nombre de restaurants, le score moyen et le pourcentage moyen d'évaluation A

### Questions complémentaires

Nécessitent une recherche sur la toile pour compléter ce qu’on a déjà vu dans ce TP.

1. Lister les restaurants (nom et rue uniquement) situés sur une rue ayant le terme “Union” dans le nom
1. Lister les restaurants ayant eu une visite le 1er février 2014
1. Lister les restaurants situés entre les longitudes -74.2 et -74.1 et les lattitudes 40.1 et 40.2

## AirBnB

Nous allons travailler sur des données AirBnB. Celles-ci sont stockées sur le serveur Mongo dans la collection `listingsAndReviews` de la base `sample_airbnb`.

> [Aide sur les données](https://docs.atlas.mongodb.com/sample-data/sample-airbnb)

Une fois créée la connexion à la collection dans Python, répondre aux questions suivantes :

1. Lister les différentes types de logements possibles cf (`room_type`)
1. Lister les différents équipements possibles cf (`amenities`)
1. Donner le nombre de logements
1. Donner le nombre de logements de type "Entire home/apt"
1. Donner le nombre de logements proposant la "TV" et le "Wifi (cf `amenities`) 
1. Donner le nombre de logements n'ayant eu aucun avis
1. Lister les informations du logement "10545725" (cf _id)
1. Lister le nom, la rue et le pays des logements dont le prix est supérieur à 10000
1. Donner le nombre de logements par type
1. Donner le nombre de logements par pays
1. On veut représenter graphiquement la distribution des prix, il nous faut donc récupérer uniquement les tarifs 
    - Un tarif apparraissant plusieurs fois dans la base doit être présent plusieurs fois dans cette liste
1. Calculer pour chaque type de logements (`room_type`) le prix (`price`)
1. On veut représenter la distribution du nombre d'avis. Il faut donc calculer pour chaque logement le nombre d'avis qu'il a eu (cf `reviews`)
1. Compter le nombre de logement pour chaque équipement possible
1. On souhaite connaître les 10 utilisateurs ayant fait le plus de commentaires

