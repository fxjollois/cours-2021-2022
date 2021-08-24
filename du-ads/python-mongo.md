# Python et MongoDB

Dans ce document, nous utilisons le package [`pymongo`](https://docs.mongodb.com/drivers/pymongo/), permettant la connection à une base de données [MongoDB](https://www.mongodb.com/fr). Il fait suite à [l'introduction à MongoDB](mongo.html)

Le but de ce document est donc de montré les exemples d'utilisation des différentes commandes permettant la récupération de données sur le serveur.

## Exemples sur `restaurants`

Ici, nous allons nous connecter sur le serveur local, et travailler sur une base des restaurants New-Yorkais. Merci de suivre la procédure sur [cette page](../infos-mongo) pour importer les données si besoin.

```python
import pymongo
client = pymongo.MongoClient()
db = client.test
```

Le premier document est présenté ci-dessous. La base contient les informations de plus de 25000 restaurants new-yorkais (base de test fournie par [Mongo](https://docs.mongodb.com/getting-started/shell/import-data/)).

```json
{
        "_id" : ObjectId("58ac16d1a251358ee4ee87de"),
        "address" : {
                "building" : "469",
                "coord" : [
                        -73.961704,
                        40.662942
                ],
                "street" : "Flatbush Avenue",
                "zipcode" : "11225"
        },
        "borough" : "Brooklyn",
        "cuisine" : "Hamburgers",
        "grades" : [
                {
                        "date" : ISODate("2014-12-30T00:00:00Z"),
                        "grade" : "A",
                        "score" : 8
                },
                {
                        "date" : ISODate("2014-07-01T00:00:00Z"),
                        "grade" : "B",
                        "score" : 23
                },
                {
                        "date" : ISODate("2013-04-30T00:00:00Z"),
                        "grade" : "A",
                        "score" : 12
                },
                {
                        "date" : ISODate("2012-05-08T00:00:00Z"),
                        "grade" : "A",
                        "score" : 12
                }
        ],
        "name" : "Wendy'S",
        "restaurant_id" : "30112340"
}
```

### Document dans `python`

Les données `JSON` sont similaires à un dictionnaire `python`. Pour récupérer le premier document, nous utilisons la fonction `find()` de l'objet créé `m`.

```python
d = db.restaurants.find(limit = 1)
d
class(d)
```

Les objets `address` et `grades` sont particuliers, comme on peut le voir dans le `JSON`. Le premier est une liste, et le deuxième est un tableau. Voila leur classe en `R`.

```python
class(d$address)
d$address
class(d$grades)
d$grades
```

### Dénombrement

Comme indiqué, on utilise la fonction `count()` pour dénombrer les documents :

- Tous les restaurants

```python
db.restaurants.count()
```

- Restaurants de *Brooklyn*

```python
db.restaurants.count(query = '{ "borough": "Brooklyn" }')
```

- Restaurants de *Brooklyn* proposant de la cuisine française

```python
db.restaurants.count(query = '{ "borough": "Brooklyn", "cuisine": "French" }')
```

- Restaurants de *Brooklyn* proposant de la cuisine française ou italienne

```python
db.restaurants.count(query = '{ "borough": "Brooklyn", "cuisine": { "$in": ["French", "Italian"]} }')
```

- Idem mais écrit plus lisiblement

```python
db.restaurants.count(
  query = '{ 
    "borough": "Brooklyn", 
    "cuisine": { "$in": ["French", "Italian"]}
  }'
)
```

- Restaurants situés sur *Franklin Street*
    - Notez l'accès au champs `street` du champs `address`

```python
db.restaurants.count(
  query = '{ 
    "address.street": "Franklin Street"
  }'
)
```


- Restaurants ayant eu un score de 0

```python
db.restaurants.count(
  query = '{ 
    "grades.score": 0
  }'
)
```

- Restaurants ayant eu un score inférieur à 5

```python
db.restaurants.count(
  query = '{ 
    "grades.score": { "$lte": 5 }
  }'
)
```


### Valeurs distinctes

On peut aussi voir la liste des valeurs distinctes d'un attribut, avec la fonction `distinct()`.

- Quartier (`borough`), pour tous les restaurants

```python
db.restaurants.distinct(key = "borough")
```

- Cuisine pour les restaurants de *Brooklyn*

```python
db.restaurants.distinct(
  key = "cuisine",
  query = '{ "borough": "Brooklyn" }'
)
```

- Grade des restaurants de *Brooklyn*

```python
db.restaurants.distinct(
  key = "grades.grade",
  query = '{ "borough": "Brooklyn" }'
)
```

### Restriction et Projection

La fonction `find()` de l'objet `m` permet donc de réaliser les *restrictions* et *projections*.

- Restaurants *Shake Shack* (uniquement les attributs `"street"` et `"borough"`)

```python
db.restaurants.find(query = '{ "name": "Shake Shack" }', 
       fields = '{ "address.street": 1, "borough": 1 }')
```

- Idem sans l'identifiant interne

```python
db.restaurants.find(query = '{ "name": "Shake Shack" }', 
       fields = '{ "_id": 0, "address.street": 1, "borough": 1 }')
```

- 10 premiers restaurants du quartier *Queens*, avec une note A et un score supérieur à 50 (on affiche le nom et la rue du restaurant
    - Remarquez l'affichage des scores dans `R`.

```python
db.restaurants.find(query = '{"borough": "Queens", "grades.score": { "$gte":  50}}',
       fields = '{"_id": 0, "name": 1, "grades.score": 1, "address.street": 1}',
       limit = 10)
```

- Restaurants *Shake Shack* dans différents quartiers (*Queens* et *Brooklyn*)

```python
db.restaurants.find(query = '{"name": "Shake Shack", "borough": {"$in": ["Queens", "Brooklyn"]}}', 
       fields = '{"_id": 0, "address.street": 1, "borough": 1}')
```

- Restaurants du Queens ayant une note supérieure à 50, mais trié par ordre décroissant de noms de rue, et ordre croissant de noms de restaurants

```python
db.restaurants.find(query = '{"borough": "Queens", "grades.score": { "$gt":  50}}',
       fields = '{"_id": 0, "name": 1, "address.street": 1}',
       sort = '{"address.street": -1, "name": 1}')
```

### Agrégat

Ils sont réalisés avec la fonction `aggregate()`, qui permet de faire beaucoup plus.

- Limite aux 5 premiers restaurants

```python
db.restaurants.aggregate(pipeline = '[
    {"$limit": 10 }
]')
```

- Idem avec tri sur le nom du restaurant

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$sort": { "name": 1 }}
]')
```

- Idem en se restreignant à *Brooklyn*
    - Notez que nous obtenons uniquement 5 restaurants au final
    
```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$sort": { "name": 1 }},
    { "$match": { "borough": "Brooklyn" }}
]')
```

- Mêmes opérations mais avec la restriction en amont de la limite
    - Nous avons ici les 10 premiers restaurants de *Brooklyn* donc

```python
db.restaurants.aggregate(pipeline = '[
    { "$match": { "borough": "Brooklyn" }},
    { "$limit": 10 },
    { "$sort": { "name": 1 }}
]')
```

- Séparation des 5 premiers restaurants sur la base des évaluations (`grades`)
    - Chaque ligne correspond maintenant a une évaluation pour un restaurant

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$unwind": "$grades" }
]')
```

- Idem précédemment, en se restreignant à celle ayant eu *B*

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$unwind": "$grades" },
    { "$match": { "grades.grade": "B" }}
]')
```

- Si on inverse les opérations `$unwind` et `$match`, le résultat est clairement différent

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$match": { "grades.grade": "B" }},
    { "$unwind": "$grades" }
]')
```

- On souhaite ici ne garder que le nom et le quartier des 10 premiers restaurants
    - Notez l'ordre (alphabétique) des variables, et pas celui de la déclaration
    
```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1 } }
]')
```

- Ici, on supprime l'adresse et les évaluations 

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$project": { "address": 0, "grades": 0 } }
]')
```

- En plus du nom et du quartier, on récupère l'adresse mais dans un nouveau champs 

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1 , "street": "$address.street"} }
]')
```

- On ajoute le nombre de visites pour chaque restaurant (donc la taille du tableau `grades`)

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1, "nb_grades": { "$size": "$grades" } } }
]')
```

- On trie ce résultat par nombre de visites, et on affiche les 10 premiers
    - Notez qu'il y a des restaurants sans visite donc (pour lesquels `grades` est préent mais égal à `NULL`)
    - Dans l'idéal, ces restaurants ne devraient pas avoir de champs `grades`

```python
db.restaurants.aggregate(pipeline = '[
    { "$project": { "name": 1, "borough": 1, "nb_grades": { "$size": "$grades" } } },
    { "$sort": { "nb_grades": 1 }},
    { "$limit": 10 }
]')
```

- On ne garde maintenant que le premier élément du tableau `grades` (indicé 0)

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$project": { "name": 1, "borough": 1, "grade": { "$arrayElemAt": [ "$grades", 0 ]} } }
]')
```

- On peut aussi faire des opérations sur les chaînes, tel que la mise en majuscule du nom

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$project": { "nom": { "$toUpper": "$name" }, "borough": 1 } }
]')
```

- On peut aussi vouloir ajouter un champs, comme ici le nombre d'évaluations

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$addFields": { "nb_grades": { "$size": "$grades" } } }
]')
```

- On extrait ici les trois premières lettres du quartier

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$project": { 
        "nom": { "$toUpper": "$name" }, 
        "quartier": { "$substr": [ "$borough", 0, 3 ] } 
    } }
]')
```

- On fait de même, mais on met en majuscule et on note *BRX* pour le *Bronx*
    - on garde le quartier d'origine pour vérification ici

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$addFields": { "quartier": { "$toUpper": { "$substr": [ "$borough", 0, 3 ] } } }},
    { "$project": { 
        "nom": { "$toUpper": "$name" }, 
        "quartier": { "$cond": { "if": { "$eq": ["$borough", "Bronx"] }, "then": "BRX", "else": "$quartier" } },
        "borough": 1
    } }
]')
```

- On calcule ici le nombre total de restaurants

```python
db.restaurants.aggregate(pipeline = '[
    {"$group": {"_id": "Total", "NbRestos": {"$sum": 1}}}
]')
```

- On fait de même, mais par quartier

```python
db.restaurants.aggregate(pipeline = '[
    {"$group": {"_id": "$borough", "NbRestos": {"$sum": 1}}}
]')
```

- Pour faire le calcul des notes moyennes des restaurants du *Queens*, on exécute le code suivant

```python
db.restaurants.aggregate('[
    { "$match": { "borough": "Queens" }},
    { "$unwind": "$grades" },
    { "$group": { "_id": "null", "score": { "$avg": "$grades.score" }}}
]')
```

-  Il est bien évidemment possible de faire ce calcul par quartier et de les trier selon les notes obtenues (dans l'ordre décroissant)

```python
db.restaurants.aggregate('[
    { "$unwind": "$grades" },
    { "$group": { "_id": "$borough", "score": { "$avg": "$grades.score" }}},
    { "$sort": { "score": -1 }}
]')
```

- On peut aussi faire un regroupement par quartier et par rue (en ne prenant que la première évaluation - qui est la dernière en date a priori), pour afficher les 10 rues où on mange le plus sainement
    - Notez que le premier `$match` permet de supprimer les restaurants sans évaluations (ce qui engendrerait des moyennes = `NA`)

```python
db.restaurants.aggregate(pipeline = '[
    { "$project": { 
        "borough": 1, "street": "$address.street", 
        "eval": { "$arrayElemAt": [ "$grades", 0 ]} 
    } },
    { "$match": { "eval": { "$exists": true } } },
    { "$match": { "eval.score": { "$gte": 0 } } },
    { "$group": { 
        "_id": { "quartier": "$borough", "rue": "$street" }, 
        "score": { "$avg": "$eval.score" }
    }},
    { "$sort": { "score": 1 }},
    { "$limit": 10 }
]')
```

- Pour comprendre la différence entre `$addToSet` et `$push`, on les applique sur les grades obtenus pour les 10 premiers restaurants
    - `$addToSet` : valeurs distinctes
    - `$push` : toutes les valeurs présentes

```python
db.restaurants.aggregate(pipeline = '[
    { "$limit": 10 },
    { "$unwind": "$grades" },
    { "$group": { 
        "_id": "$name", 
        "avec_addToSet": { "$addToSet": "$grades.grade" },
        "avec_push": { "$push": "$grades.grade" }
    }}
]')
```

### Itération

Il est possible de définir un curseur (de même type que PL/SQL par exemple), qui va itérer sur la liste de résultats (celle-ci sera stocké sur le serveur). Cela permet de récupérer les documents un par un, ce qui est judicieux en cas de gros volume. De plus, ceux-ci sont récupérés au format `list` pure, ce qui peut simplifier la manipulation en cas de données fortement imbriquées.

- Affichage particulier des 10 premiers restaurants du *Queens* ayant un score supérieur à 50

```python
cursor = db.restaurants.iterate(
  query = '{"borough": "Queens", "grades.score": { "$gte":  50}}',
  fields = '{"_id": 0, "name": 1, "address.street": 1}',
  sort = '{"address.street": -1, "name": 1}',
  limit = 10)
while(!is.null(doc <- cursor$one())){
  cat(sprintf("%s (%s)\n", doc$name, doc$`address`$`street`))
}
```

Plutôt que d'avoir les documents un par un, il est ausi possible de les avoir par paquets avec la fonction `batch(n)` (ainsi que `page(n)` et `json(n)` qui diffèrent sur le type de ce qui est retourné) sur le curseur (`n` étant donc le nombre de documents renvoyés)

- Vue des différences entre les 3 opérateurs

```python
cursor = db.restaurants.iterate(limit = 15)
cursor$batch(5)
cursor$page(5)
cursor$json(5)
```

- Calcul d'une moyenne par itération en `batch`

```python
cursor = db.restaurants.iterate()
fin = FALSE
n_batch = 5
somme = 0
nombre = 0
liste = NULL
while (!fin) {
  #cat("\n\n--------------\n\n")
  doc = cursor$batch(n_batch)
  if (length(doc) > 0 ) {
    scores = unlist(lapply(doc, function (d) {
      res = lapply(d$grades, function (g) {
        return (g$score)
      })
      return (res)
    }))
    #print(scores)
    nombre = nombre + length(scores)
    somme = somme + sum(scores)
    #liste = c(liste, scores)
  }
  if (length(doc) < n_batch) {
    fin = TRUE
  }
}
cat("Résultat du calcul :", round(somme/nombre, 5), "\n")
```

- Si on voulait la faire dans `R` en important les données
    - Notez que le code est beaucoup plus simple
    - **MAIS** beaucoup plus gourmand en espace disque en local et en blocage réseau (pour tout récupérer d'un coup)

```
df = db.restaurants.find()
mean(Reduce(rbind, df$grades)$score, na.rm = T)
```

## A faire


### Rendu

Envoyez votre fichier (script `R` ou markdown `Rmd` - avec votre nom dans le nom du fichier) par mail à **francois-xavier.jollois@u-paris.fr**.

### Restaurants 

1. Lister tous les restaurants de la chaîne "Bareburger" (rue, quartier)
1. Lister les trois chaînes de restaurant les plus présentes
1. Donner les 10 styles de cuisine les plus présents dans la collection
1. Lister les 10 restaurants les moins bien notés (note moyenne la plus haute)
1. Lister par quartier le nombre de restaurants, le score moyen et le pourcentage moyen d'évaluation A

#### Questions complémentaires

Nécessitent une recherche sur la toile pour compléter ce qu’on a déjà vu dans ce TP.

1. Lister les restaurants (nom et rue uniquement) situés sur une rue ayant le terme “Union” dans le nom
1. Lister les restaurants ayant eu une visite le 1er février 2014
1. Lister les restaurants situés entre les longitudes -74.2 et -74.1 et les lattitudes 40.1 et 40.2


### AirBnB

Nous allons travailler sur des données AirBnB. Celles-ci sont stockées sur le serveur Mongo dans la collection `listingsAndReviews` de la base `sample_airbnb`.

> [Aide sur les données](https://docs.atlas.mongodb.com/sample-data/sample-airbnb)

1. Créer la connexion à la collection dans R
1. Donner le nombre de logements
1. Lister les informations du logement "10545725" (cf _id)
1. Lister les différentes types de logements possibles cf (room_type)
1. Donner le nombre de logements par type
1. Représenter graphiquement la distribution des prix 
1. Croiser numériquement et graphiquement le type et le prix (price)
1. Représenter la distribution du nombre d'avis (cf reviews - à calculer)
1. Croiser graphiquement le nombre d'avis et le prix, en ajoutant l'information du type de logement


