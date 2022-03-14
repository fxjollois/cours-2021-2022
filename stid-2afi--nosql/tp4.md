# TP4 : Connexion Python et MongoDB

Le but de ce TP est de voir l'utilisation des commandes MongoDB dans Python.

## Accès à MongoDB dans Python

Nous allons utiliser le module `pymongo`. Pour l'utiliser (après l'avoir installée), on l'importe classiquement comme ci-dessous.

```python
import pymongo
```

### Connexion vers la collection

La première opération est de créer une connexion entre Python et MongoDB en utilisant la fonction `MongoClient()`. Celle-ci prend en paramètre une adresse de serveur. Si elle n'y est pas, elle se connecte en local.

```python
URI = 'mongodb+srv://user:user@cluster0.ougec.mongodb.net/test'
client = pymongo.MongoClient(URI) # enlever le paramètre URI si connexion locale
```

On peut liste l'ensemble des bases de données du serveur en utilisant le code suivant :

```python
for db in client.list_databases():
    print(db["name"] + "(" + db["sizeOnDisk"] + " octets)")
```

Pour accéder à la base de données `test`, nous pouvons simplement créer un objet `db` comme suit :

```python
db = client.test
```

Par le biais de l'objet ainsi créé (`db`) et en ajoutant le nom de la collection, on a accès aux différentes fonctions que l'on a vu dans Mongo (précisemment `countDocuments()`, `distinct()`, `find()` et `aggregate()`). 

Pour lister les connexions, on utilise un code similaire à précédemment.

```python
for coll in db.list_collections():
    print(coll["name"])
```


### Document dans `python`

Les données `JSON` sont similaires à un dictionnaire `python`. Pour récupérer le premier document, nous utilisons la fonction `find()`.

```python
d = db.restaurants.find(limit = 1)
d
```

L'objet retourné est un **curseur**, et non le résultat. Nous avons celui-ci lorsque nous utilisons `d` dans une commande telle qu'une transformation en `list` par exemple. Une fois le résultat retourné (un seul élément ici), le curseur ne renvoie plus rien.

```python
list(d)
```

### Dénombrement

Il existe la fonction `count_documents()` qui compte directement le nombre de document. Pour information, la fonction `estimated_document_count()`  pour estimer le nombre de documents, à utiliser de préférence en cas de multiples serveurs et de données massives. Dans le cas où l'on veut compter les documents qui respectent une certaine condition, nous utilisons le paramètre obligatoire `filter`. Notez que les noms des champs sont entre quotes.

- Tous les restaurants (l'une ou l'autre donne le même résultat)

```python
db.restaurants.count_documents({})
db.restaurants.estimated_document_count()
```

- Restaurants de *Brooklyn*

```python
db.restaurants.count_documents({ "borough": "Brooklyn" })
```

- Restaurants de *Brooklyn* proposant de la cuisine française

```python
db.restaurants.count_documents({ "borough": "Brooklyn", "cuisine": "French" })
```

- Restaurants de *Brooklyn* proposant de la cuisine française ou italienne

```python
db.restaurants.count_documents({ "borough": "Brooklyn", "cuisine": { "$in": ["French", "Italian"]} })
```

- Idem mais écrit plus lisiblement

```python
db.restaurants.count_documents({ 
    "borough": "Brooklyn", 
    "cuisine": { "$in": ["French", "Italian"]} 
})
```

- Restaurants situés sur *Franklin Street*
    - Notez l'accès au champs `street` du champs `address`

```python
db.restaurants.count_documents(
  { 
    "address.street": "Franklin Street"
  }
)
```


- Restaurants ayant eu un score de 0

```python
db.restaurants.count_documents(
  { 
    "grades.score": 0
  }
)
```

- Restaurants ayant eu un score inférieur à 5

```python
db.restaurants.count_documents(
  { 
    "grades.score": { "$lte": 5 }
  }
)
```

### Valeurs distinctes 

Il existe la même fonction `distinct()`, avec les mêmes possibilités. On peut ainsi vouloir les valeurs distinctes présentes dans un sous-ensemble de documents (respectant une contrainte particulière). Voici quelques exemples :

- Quartier (`borough`), pour tous les restaurants

```python
db.restaurants.distinct(key = "borough")
```

- Cuisine pour les restaurants de *Brooklyn*

```python
db.restaurants.distinct(
  key = "cuisine",
  query = { "borough": "Brooklyn" }
)
```

- Grade des restaurants de *Brooklyn*

```python
db.restaurants.distinct(
  key = "grades.grade",
  query = { "borough": "Brooklyn" }
)
```
### Récupération de données avec `find()` (restriction et projection)

Cette fonction permet donc de récupérer tout ou partie des documents, selon éventuellement un critère de restriction (dans le paramètre `query`) et un critère de projection (dans le paramètre `fields`). Pour n'avoir que le premier document, on utilise le paramètre `limit`. Pour le tri, on utilise le paramètre `sort`. 

Pour améliorer la lisibilité du résultat et l'utilisation ultérieure des données, on transforme celles-ci en `DataFrame` (du module `pandas`). Ce format, bien que souvent pratique, n'est pas forcément idéal pour certains champs complexes.

Voici quelques exemples :

- 5 premiers restaurants de la base 
    - Notez le contenu des colonnes `address` et `grades`.

```python
import pandas
pandas.DataFrame(db.restaurants.find(limit = 5))
```

- Restaurants *Shake Shack* (uniquement les attributs `"street"` et `"borough"`)

```python
c = db.restaurants.find({ "name": "Shake Shack" }, { "address.street": 1, "borough": 1 })
pandas.DataFrame(c)
```

- Idem sans l'identifiant interne

```python
c = db.restaurants.find(
    { "name": "Shake Shack" }, 
    { "_id": 0, "address.street": 1, "borough": 1 }
)
pandas.DataFrame(c)
```

- 10 premiers restaurants du quartier *Queens*, avec une note A et un score supérieur à 50 (on affiche le nom et la rue du restaurant

```python
c = db.restaurants.find(
    {"borough": "Queens", "grades.score": { "$gte":  50}},
    {"_id": 0, "name": 1, "grades.score": 1, "address.street": 1},
    limit = 10
)
pandas.DataFrame(c)
```

- Restaurants *Shake Shack* dans différents quartiers (*Queens* et *Brooklyn*)

```python
c = db.restaurants.find(
    {"name": "Shake Shack", "borough": {"$in": ["Queens", "Brooklyn"]}}, 
    {"_id": 0, "address.street": 1, "borough": 1}
)
pandas.DataFrame(c)
```

- Restaurants du Queens ayant une note supérieure à 50, mais trié par ordre décroissant de noms de rue, et ordre croissant de noms de restaurants

```python
c = db.restaurants.find(
    {"borough": "Queens", "grades.score": { "$gt":  50}},
    {"_id": 0, "name": 1, "address.street": 1},
    sort = (("address.street", -1), ("name", 1))
)
pandas.DataFrame(c)
```


### Agrégats

Bien évidemment, on peut faire des calculs d'agrégats, avec la fonction `aggregate()`, prenant en paramètre donc le pipeline (tableau composé d'une suite d'opérations), avec les opérateurs suivants :


| Fonction       | Opération |
|:-|:-|
| `$limit`       | restriction à un petit nombre de documents (très utiles pour tester son calcul) |
| `$sort`        | tri sur les documents |
| `$match`       | restriction sur les documents à utiliser |
| `$unwind`      | séparation d'un document en plusieurs sur la base d'un tableau |
| `$addFields`   | ajout d'un champs dans les documents |
| `$project`     | redéfinition des documents |
| `$group`       | regroupements et calculs d'aggégrats |
| `$sortByCount` | regroupement, calcul de dénombrement et tri déccroissant en une opération |
| `$lookup`      | jointure avec une autre collection |
| ...            | |

Voici encore quelques exemples :

- Limite aux 5 premiers restaurants

```python
c = db.restaurants.aggregate(
    [
        {"$limit": 10 }
    ]
)
pandas.DataFrame(c)
```

- Idem avec tri sur le nom du restaurant

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$sort": { "name": 1 }}
    ]
)
pandas.DataFrame(c)
```

- Idem en se restreignant à *Brooklyn*
    - Notez que nous obtenons uniquement 5 restaurants au final
    
```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$sort": { "name": 1 }},
        { "$match": { "borough": "Brooklyn" }}
    ]
)
pandas.DataFrame(c)
```

- Mêmes opérations mais avec la restriction en amont de la limite
    - Nous avons ici les 10 premiers restaurants de *Brooklyn* donc

```python
c = db.restaurants.aggregate(
    [
        { "$match": { "borough": "Brooklyn" }},
        { "$limit": 10 },
        { "$sort": { "name": 1 }}
    ]
)
pandas.DataFrame(c)
```

- Séparation des 5 premiers restaurants sur la base des évaluations (`grades`)
    - Chaque ligne correspond maintenant a une évaluation pour un restaurant

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 5 },
        { "$unwind": "$grades" }
    ]
)
pandas.DataFrame(c)
```

- Idem précédemment, en se restreignant à celles ayant eu *B*

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$unwind": "$grades" },
        { "$match": { "grades.grade": "B" }}
    ]
)
pandas.DataFrame(c)
```

- Si on inverse les opérations `$unwind` et `$match`, le résultat est clairement différent

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$match": { "grades.grade": "B" }},
        { "$unwind": "$grades" }
    ]
)
pandas.DataFrame(c)
```

- On souhaite ici ne garder que le nom et le quartier des 10 premiers restaurants
    - Notez l'ordre (alphabétique) des variables, et pas celui de la déclaration
    
```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$project": { "name": 1, "borough": 1 } }
    ]
)
pandas.DataFrame(c)
```

- Ici, on supprime l'adresse et les évaluations 

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$project": { "address": 0, "grades": 0 } }
    ]
)
pandas.DataFrame(c)
```

- En plus du nom et du quartier, on récupère l'adresse mais dans un nouveau champs 

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$project": { "name": 1, "borough": 1 , "street": "$address.street"} }
    ]
)
pandas.DataFrame(c)
```

- On ajoute le nombre de visites pour chaque restaurant (donc la taille du tableau `grades`)

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$project": { "name": 1, "borough": 1, "nb_grades": { "$size": "$grades" } } }
    ]
)
pandas.DataFrame(c)
```

- On trie ce résultat par nombre de visites, et on affiche les 10 premiers

```python
c = db.restaurants.aggregate(
    [
        { "$project": { "name": 1, "borough": 1, "nb_grades": { "$size": "$grades" } } },
        { "$sort": { "nb_grades": -1 }},
        { "$limit": 10 }
    ]
)
pandas.DataFrame(c)
```

- On ne garde maintenant que le premier élément du tableau `grades` (indicé 0)

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$project": { "name": 1, "borough": 1, "grade": { "$arrayElemAt": [ "$grades", 0 ]} } }
    ]
)
pandas.DataFrame(c)
```

- `$first` permet aussi de garder uniquement le premier élément du tableau `grades` de façon explicite (`$last` pour le dernier)

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$project": { "name": 1, "borough": 1, "grade": { "$first": "$grades" } } }
    ]
)
pandas.DataFrame(c)
```


- On peut aussi faire des opérations sur les chaînes, tel que la mise en majuscule du nom

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$project": { "nom": { "$toUpper": "$name" }, "borough": 1 } }
    ]
)
pandas.DataFrame(c)
```

- On peut aussi vouloir ajouter un champs, comme ici le nombre d'évaluations

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$addFields": { "nb_grades": { "$size": "$grades" } } }
    ]
)
pandas.DataFrame(c)
```

- On extrait ici les trois premières lettres du quartier

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$project": { 
            "nom": { "$toUpper": "$name" }, 
            "quartier": { "$substr": [ "$borough", 0, 3 ] } 
        } }
    ]
)
pandas.DataFrame(c)
```

- On fait de même, mais on met en majuscule et on note *BRX* pour le *Bronx*
    - on garde le quartier d'origine pour vérification ici

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$addFields": { "quartier": { "$toUpper": { "$substr": [ "$borough", 0, 3 ] } } }},
        { "$project": { 
            "nom": { "$toUpper": "$name" }, 
            "quartier": { "$cond": { 
                "if": { "$eq": ["$borough", "Bronx"] }, 
                "then": "BRX", 
                "else": "$quartier" 
            } },
            "borough": 1
        } }
    ]
)
pandas.DataFrame(c)
```

- On calcule ici le nombre total de restaurants

```python
c = db.restaurants.aggregate(
    [
        {"$group": {"_id": "Total", "NbRestos": {"$sum": 1}}}
    ]
)
pandas.DataFrame(c)
```

- On fait de même, mais par quartier

```python
c = db.restaurants.aggregate(
    [
        {"$group": {"_id": "$borough", "NbRestos": {"$sum": 1}}}
    ]
)
pandas.DataFrame(c)
```

- Une fois le dénombrement fait, on peut aussi trié le résultat

```python
c = db.restaurants.aggregate(
    [
        {"$group": {"_id": "$borough", "NbRestos": {"$sum": 1}}},
        {"$sort": { "NbRestos": -1}}
    ]
)
pandas.DataFrame(c)
```

- La même opération est réalisable directement avec `$sortByCount`

```python
c = db.restaurants.aggregate(
    [
        {"$sortByCount": "$borough"}
    ]
)
pandas.DataFrame(c)
```

- Pour faire le calcul des notes moyennes des restaurants du *Queens*, on exécute le code suivant

```python
c = db.restaurants.aggregate(
    [
        { "$match": { "borough": "Queens" }},
        { "$unwind": "$grades" },
        { "$group": { "_id": "null", "score": { "$avg": "$grades.score" }}}
    ]
)
pandas.DataFrame(c)
```

-  Il est bien évidemment possible de faire ce calcul par quartier et de les trier selon les notes obtenues (dans l'ordre décroissant)

```python
c = db.restaurants.aggregate(
    [
        { "$unwind": "$grades" },
        { "$group": { "_id": "$borough", "score": { "$avg": "$grades.score" }}},
        { "$sort": { "score": -1 }}
    ]
)
pandas.DataFrame(c)
```

- On peut aussi faire un regroupement par quartier et par rue (en ne prenant que la première évaluation - qui est la dernière en date a priori), pour afficher les 10 rues où on mange le plus sainement
    - Notez que le premier `$match` permet de supprimer les restaurants sans évaluations (ce qui engendrerait des moyennes = `NA`)

```python
c = db.restaurants.aggregate(
    [
        { "$project": {
            "borough": 1, "street": "$address.street", 
            "eval": { "$arrayElemAt": [ "$grades", 0 ]} 
        } },
        { "$match": { "eval": { "$exists": True } } },
        { "$group": { 
            "_id": { "quartier": "$borough", "rue": "$street" }, 
            "score": { "$avg": "$eval.score" }
        }},
        { "$sort": { "score": 1 }},
        { "$limit": 10 }
    ]
)
pandas.DataFrame(c)
```

- Pour comprendre la différence entre `$addToSet` et `$push`, on les applique sur les grades obtenus pour les 10 premiers restaurants
    - `$addToSet` : valeurs distinctes
    - `$push` : toutes les valeurs présentes

```python
c = db.restaurants.aggregate(
    [
        { "$limit": 10 },
        { "$unwind": "$grades" },
        { "$group": { 
            "_id": "$name", 
            "avec_addToSet": { "$addToSet": "$grades.grade" },
            "avec_push": { "$push": "$grades.grade" }
        }}
    ]
)
pandas.DataFrame(c)
```

## Gestion des variables spéciales dans le DataFrame

Une fois importées dans un `DataFrame`, les champs complexes (comme `address` et `grades`) sont des variables d'un type un peu particulier. 

```python
df = pandas.DataFrame(db.restaurants.find(limit = 10))
df
```

### Variables ayant des dictionnaires comme valeurs

Le champs `address` est une liste de dictionnaires, ayant chacun plusieurs champs (ici tous les mêmes).

- Nom du bâtiment et rue concaténés dans une nouvelle variable de `df`
    - utilisation de *list comprehension*

```python
df.assign(info = [e["building"] + ", " + e["street"] for e in df.address])
```

- Transformation de la liste en un `DataFrame`

```python
pandas.DataFrame([e for e in df.address])
```

- Idem en intégrant le résultat dans le `DataFrame`  original

```python
pandas.concat([df.drop("address", axis = 1), pandas.DataFrame([e for e in df.address])], axis = 1)
```


### Variables ayant des tableaux comme valeurs

Le champs `grades` est une liste de tableaux, ayant chacun potentiellement plusieurs valeurs (des dictionnaires de plus)

- Récupération d'un élément du tableau (premier ou dernier)

```python
df.assign(derniere = [e[0] for e in df.grades], premiere = [e[-1] for e in df.grades]).drop("grades", axis = 1)
```

- Transformation de la liste de tableaux en un seul `DataFrame`
    - `zip()` permet d'itérer sur plusieurs tableaux en même temps
    - `concat()` permet de concaténer les tableaux entre eux
    
```python
dfgrades = pandas.concat([pandas.DataFrame(g).assign(_id = i) for (i, g) in zip(df._id, df.grades)])
dfgrades
```

- Jointure entre les deux `DataFrames` avec `merge()`

```python
pandas.merge(df.drop("grades", axis = 1), dfgrades.reset_index())
```

## A faire - Données AirBnB

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



