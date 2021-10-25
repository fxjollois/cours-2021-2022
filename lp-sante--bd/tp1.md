# Langage SQL

Dans ce TP, nous allons utilier la [base de données publique des médicaments](https://base-donnees-publique.medicaments.gouv.fr/). Dans la page Téléchargement (lien situé tout en bas du site), vous trouverez les liens vers un fichier explicatif (en PDF) et les fichiers de données (au format texte). 

## Librairie `RSQLite` sous `R`



L'utilisation conjointe de la librairie [`DBI`](https://dbi.r-dbi.org/) et de la librairie [`RSQLite`](https://cran.r-project.org/web/packages/RSQLite/vignettes/RSQLite.html) permet de se connecter à une base de données au format [`SQLite`](https://www.sqlite.org/index.html) dans `R`. Vous trouverez sur [cette page](https://db.rstudio.com/databases/sqlite/) un certain nombre d'informations utiles. Voici ce qu'il faut en retenir pour la réalisation de ce TP.

> L'ensemble des commandes vues ici sont réutilisables pour se connecter à un autre SGBD que `SQLite`, en utilisant d'autres drivers (comme [`ODBC`](https://db.rstudio.com/databases/oracle/) - connecteur universel).

| Fonction | Utilité | Paramètres et retour |
|-|-|-|
| **`dbConnect()`** | Création d'une base de données | Driver (ici : `RSQLite::SQLite()`) <br> Nom du fichier ou `":memory:"`<br> Renvoie un connecteur à garder dans une variable |
| **`dbDisconnect()`** | Déconnexion propre | |
| **`dbListTables()`** | Liste des tables | |
| **`dbExecute()`** | Exécution d'une requête autre que `SELECT` | Connecteur à la BD<br> Requête dans une chaîne de caractères<br> Renvoie un code d'erreur |
| **`dbGetQuery()`** | Exécution d'une requête `SELECT` | Connecteur à la BD<br> Requête dans une chaîne de caractères<br> Renvoie le résultat de la requête dans un data.frame |

## Demande

A partir du modèle de la base et des fichiers de données fournies, nous allons recréer la BD médicaments.

1. Télécharger les 9 fichiers de données
    - les placer idéalement dans un répertoire dédié.
2. Créer la base de données
3. Créer les tables et les renseigner (i.e. mettre les valeurs dedans)
    - les voies d'administration sont listées dans une seule variable, et séparées par des “;” (par exemple "cutanée;orale;sublinguale"). Il faut donc ici aussi faire une nouvelle table "VoieAdministration" et insérer les données correctement.
4. Créer le script d'importation des données
    - les taux et les prix sont dans au format chaîne de caractères (resp. "xx %" et "xx,xx") et donc à modifier avant importation. 
5. Répondez aux demandes suivantes :
    - Combien de médicaments sont dans la BD ?
    - Combien de génériques ?
    - Donner les différents types de génériques.
    - Lister les médicaments pour lesquelles il y a une *surveillance renforcée*
    - Donner les 10 médicaments ayant les présentations les plus onéreuses 
    - Quels sont les dix médicaments avec le plus de composants (Code CIS, Dénomination et nombre de composants) ?
    - Pour chaque type de générique, on veut savoir le nombre de médicaments associés, ainsi que leur taux de remboursement moyen et leur prix moyen.
    - Quelles sont les voies d’administration possibles ? Et combien de médicaments sont concernés pour chaque voie ?
    - Quels sont les médicaments dont le service médical rendu (ou SMR) est jugé insuffisant ? Indiquez leur taux de remboursement et leur prix, en les classant par prix décroissant.
    - On veut les informations suivantes dans une table à deux colonnes (statistique, valeur) :
        - Nombre de médicaments
        - Nombre de médicaments avec autorisation active
        - Nombre de médicaments avec surveillance renforcée
        - Taux moyen de remboursement (pour ceux avec autorisation active)
        - Prix moyen (idem que le taux)
        - Durée moyenne de leur mise sur le marché (en nombre de jours - idem que le taux)
    
