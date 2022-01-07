# Shiny - évaluation

## A FAIRE

Vous devez améliorer le tableau de bord, en réalisant les éléments suivants :

- Intégrer le choix du pays pour la `valueBox` indiquant le volume total de documents produits
- La progression est en fait le pourcentage de la valeur de 2020 par rapport à celle de 1996. Modifier le code pour avoir le delta entre cette valeur et 100%
    - par exemple : 169% deviendra +69%, et 85% deviendra -15%
    - modifier les couleurs en fonction de la valeur (vert si > 0 et orange sinon)
- Modifier la `valueBox` pour afficher une couleur en fonction de la production totale de documents :
    - si inférieur à 1000 : rouge
    - entre 1000 et 100000 : bleu clair
    - supérieur strictement à 100000 : vert
- Ajouter un TOP 20 pour une année choisie par l'utilisateur, dans la seconde partie (vide pour le moment)
- Ajouter un graphique d'évolution en base 100 avec le choix des pays (cf `checkboxGroupInput`), dans la troisième partie (vide aussi)
    - le code ci-dessous vous permet de calculer les valeurs en base 100 en 1996 pour chaque pays et chaque année
        ```
prod %>%
  select(Country, Year, Documents) %>%
  pivot_wider(names_from = Year, values_from = Documents, names_prefix = "Year") %>%
  mutate(across(starts_with("Year"), ~ .x / Year1996 * 100))
        ```
