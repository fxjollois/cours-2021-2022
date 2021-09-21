# TD2 : Compréhension des opérations usuelles en BD

## BD 1

### Schéma relationnel

On suppose qu'on a le modèle relationnel suivant :

- CLIENT(<u>NumClt</u>u>, Nom, Prenom, Adresse)
- TVA(<u>NumTx</u>, Valeur)
- PRODUIT(<u>NumPrd</u>, Designation, Type, PrixHT, QteStock, #NumTx)
- FACTURE(<u>NumFac</u>, #NumClt, Total)
- ACHAT(<u>#NumFac, #NumPrd</u>, Qte)

### Notation des opérations

On peut stocker le résultat de chaque opération dans une variable

- **Restriction** : Sélection (ou *filtrage*) des lignes d'une table vérifiant une condition
    - Clients dont le nom est `"Jollois"` : `RESTRICT(CLIENT, Nom = "Jollois")`
- **Projection** : Sélection de certaines colonnes de la table
    - Nom et prénom des clients : `PROJECT(CLIENT, Nom, Prenom)`
- **Calcul** : création d'une nouvelle colonne à partir d'autres colonnes de la table
    - Valeur (en € hors taxe) du stock pour chaque produit : `PROJECT(PRODUIT, Valeur = PrixHT * QteStock)`
- **Agrégat** : calcul d'une statistique soit sur l'ensemble d'une table, soit sur chaque regroupement de lignes selon un critère (une ou plusieurs colonnes)
    - Nombre de clients : `AGREGAT(Client, nb = COUNT(*))`
    - Nombre de produits par type : `AGREGAT(Produit | Type, nb = COUNT(*))`
- **Jointure** : regroupement d'informations entre deux tables
    - Récupération du taux de TVA pour chaque produit : `JOIN(PRODUIT, TVA)`

### Questions

1. Produits de moins de 10 euros HT strictement.
1. Numéro de produit, désignation et prix TTC de chaque produit.
1. Produits achetés (avec leur quantité) par le client 28
1. Clients (numéro, nom et prénom) ayant au moins
    1. 1 facture à leur nom,
    1. 5 factures à leur nom.
1. Récupération des informations concernant la facture 121 (en 3 demandes)
    - Nom, prénom et adresse du client,
    - Liste des produits achetés (prix HT et TTC, quantité, taux TVA),
    - Montant total de la facture.


## BD 2

### Schéma relationnel

- SERVICE(<u>NumSrv</u>, Denom)
- EMPLOYE(<u>NumEmp</u>, Nom, Prenom, Adresse, Selxe, Salaire, Prime, #NumSrv)
- PROJET(<u>NumPrj</u>, Libelle, #NumSrv)
- TRAVAIL(<u>#NumEmp, #NumPrj</u>, NbH)

### Questions

1. Liste des employés travaillant dans le service `"Statistiques"`.
2. Liste des employés ayant travaillés sur le projet `"SICLA"`.
3. Nom et prénom des employés avec le nombre de projets sur lesquels ils ont travaillés, et le nombre d'heures total travaillées.
4. Moyenne des salaires annuels pour chaque service (libellé + moyenne).
5. Libellé des projets pour lesquels l'employé `"Destin"` intervient.
6. Liste des employés (nom, prénom, service) ayant travaillés sur un projet qui n'était pas de leur service.
