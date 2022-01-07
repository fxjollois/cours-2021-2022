# Shiny

Le package [`shiny`](https://shiny.rstudio.com/) permet de développer très facilement des applications web à partir de `R`. Grâce à cette librairie, et d'autres librairies `R`, comme [`ggplot2`](http://ggplot2.tidyverse.org/) et [`shinydashboard`](https://rstudio.github.io/shinydashboard/), il est ainsi possible de générer des tableaux de bord, introduisant même des méthodes statistiques approfondies si besoin.

**Note** : installer les trois packages suivant dès maintenant : `shiny`, `shinydashboard` et `tidyverse` (dans lequel est inclus `ggplot2` entre autres).

## Quelques notions

Une application quelle qu'elle soit fait intervenir des notions importantes à comprendre pour la suite :

- **Développeur** : créateur(s) de l'application (vous en l'occurence dans la suite)
- **Utilisateur** : personnes accédant à l'application et intéragissant avec elle
- **Interface** (*UI* pour *User Interface*) : ensemble des éléments visibles par l'utilisateur, comprenant
    - **Entrées** (*inputs*) : boutons, listes de sélections, zone de saisie,... que les utilisateurs pourront modifier
    - **Sorties** (*outputs*) : éléments générés automatiquement par l'application, directement ou à partir des choix faits par l'utilisateur (cf *entrées*)
- **Exécution** : calcul des éléments de *sorties* à partir des éléments d'*entrées*, tout ceci étant fait par le **serveur** (*server*)

## Exécution d'une application

Pour exécuter une application `shiny`, il est nécessaire que celle-ci soit stockée dans un répertoire dédié, avec deux possibilités :

- tout le code nécessaire dans un seul fichier nommée **`app.R`** (nom obligatoire) - option prise dans ce document
- la partie *UI* dans le fichier **`ui.R`** et la partie *server* dans le fichier **`server.R`**

## Structure d'un dashboard

Nous allons utiliser le package `shinydashboard`, qui permet de créer des tableaux de bords (ou *dashboard* en anglais), à l'aide de la librairie `shiny`. L'idée de cette librairie est de proposer une organisation basée sur [Admin LTE](https://adminlte.io/themes/AdminLTE/index2.html), avec des outils prêts à être utiliser.

### Squelette

Nous allons commencer par créer le squelette du tableau de bord. Ainsi, nous allons utiliser la fonction `dashboardPage()`, qui prend au minimum trois arguments :

- l'en-tête, créée avec la fonction `dashboardHeader()`
- la partie gauche (pour les interactions a priori), créée avec la fonction `dashboardSidebar()`
- la partie droite (principale), créée avec la fonction `dashboardBody()`

Elle peut aussi prendre deux autres paramètres optionnels :

- le titre (donné dans `title`) dans la navigateur
- l'habillage ou couleur principale (avec le paramètre `skin`, pouvant prendre les valeurs `"blue"`, `"black"`, `"purple"`, `"green"`, `"red"` ou `"yellow"`)

Voici donc le contenu initial de notre nouvelle application (à mettre dans un nouveau répertoire donc, et dans un fichier `app.R`).

```r
library(shiny)
library(shinydashboard)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(),
    title = "Titre dans le navigateur",
    skin = "red"
  ),
  server = function(input, output) {
  }
)
```

Une fois sauvegardé dans **R Studio**, vous devez voir apparaître en haut à droite du code source, une flèche verte avec le texte  `Run App`, qui vous permettra d'exécuter l'application. 

On voit un bandeau rouge en haut, couleur déterminée par l'option `skin = "red"` (voir l'aide de `dashboardPage()` pour la liste des couleurs).

Le titre donné dans le paramètre `title` est visible lorsqu'on regarde l'application dans le navigateur (en cliquant sur `Open in Browser`), c'est celui de l'onglet du navigateur.

Ensuite, la zone en dessous est découpé en deux zones : 

- une à fond noire : ce sera la zone de *contrôle*, qui peut être masquer en cliquant sur l'icône dans la barre du haut ;
- une à fond gris : ce sera la zone *principale*, dans laquelle nous mettrons les informations, tableaux et graphiques.

### En-tête

Dans la partie en-tête, déclarée avec la fonction `dashboardHeader()`, nous allons écrire d'une part le titre qui apparaîtra en haut à gauche de l'application, ainsi que les différents items qui vont appraître dans la barre de menu en haut.

Pour ajouter un titre au tableau de bord, il suffit de donner une valeur au paramètre `title` de la fonction `dashboardHeader()`. Commençons par lui donner un titre (et modifier celui de la page).

```
library(shiny)
library(shinydashboard)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title = "Dashboard sur la Production scientifique",
      titleWidth = 300
    ),
    dashboardSidebar(),
    dashboardBody(),
    title = "Production scientifique",
    skin = "red"
  ),
  server = function(input, output) {
  }
)
```

Il est possible d'ajouter d'autres éléments dans la barre de menu, que nous ne verrons pas ici.

### Partie principale

En plus des `outputs` classiques que l'on peut avoir, il est possible de déclarer des *boîtes* pouvant inclure du contenu. En exécutant le code suivant, vous verrez le rendu des boîtes disponibles dans le package `shinydashboard`.

```
library(shiny)
library(shinydashboard)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
      box(
        title = "Evolution de la production scientifique",
        footer = "Nombre de documents scientifiques par année",
        status = "info",
        solidHeader = TRUE,
        width = 8,
        "graphique à prévoir ici"
      ),
      infoBox(
        title = "Progression",
        value = "+ ??%",
        subtitle = "Entre 1996 et 2020",
        icon = icon("chart-line"),
        fill = TRUE,
        color = "light-blue",
        width = 4
      ),
      valueBox(
        value = "??",
        subtitle = "Nombre de documents scientifiques produits sur la periode 1996-2020",
        icon = icon("newspaper"),
        color = "green",
        width = 4
      ),
      tabBox(
        title = "Informations",
        width = 4,
        tabPanel(title = "Titre 1", "contenu 1"),
        tabPanel(title = "Titre 2", "contenu 2")
      )
    ),
    title = "Production scientifique",
    skin = "red"
  ),
  server = function(input, output) {
  }
)
```

##### `box()` 

La fonction `box()` permet de déclarer une boîte, dans laquelle nous allons pouvoir intégrer des éléments de type `input` ou `output`. On pourra ensuite positionner ces boîtes librement avec des fonctions telles que `fluidRow()` et `column()`.

Elle peut prendre différents paramètres permettant de personnaliser l'affichage :

- `footer` : texte en pied de la boîte
- `status` : statut de la boîte, définissant un aspect type (regarder l'aide de `validStatuses` pour plus d'infos)
- `solidHeader` : pour dire si le titre a une couleur de fond ou non
- `width` : largeur de la boîte (entre 1 et 12),
- ...

##### `infoBox()`

Ce type de boîte permet de donner une information particulière, courte. En plus du titre, nous pouvons bien évidemment mettre une valeur. On peut aussi personnaliser ces boîtes en changeant l'icône, le remplissage ou non et la couleur.

##### `valueBox()`

C'est un autre type de boîte pour donner une information courte. Nous pouvons la personnaliser, avec une icône et une couleur spécifiques.

##### `tabBox()`

On peut avoir un système d'onglets dans une `box()` grâce à cette fonction. Celle-ci prend en premier paramètre le titre qui s'affichera en haut à droite par défaut. Un autre paramètre possible est la largeur. Ici, nous définissons une largeur de 4, pour que le `tabBox()` se mette à la suite des deux autres boîtes (tester l'application en commentant cette ligne). Ensuite, chaque onglet est définie avec la fonction `tabPanel()`. Celle-ci prend en paramètre le titre et une suite d'éléments.

#### Remarque

Les boîtes sont placées automatiquement, en fonction de leur hauteur et leur largeur pour minimiser l'espace utilisé. Elles vont bouger quand on va ajouter les éléments dans l'*UI*.


### Partie complémentaire

La fonction `dashboardSidebar()` va nous permetter de déterminer le contenu de la partie gauche (par défaut) du tableau de bord, dédiée principalement aux différents choix que pourra faire l'utilisateur.

Mais il est aussi possible de donner la possibilité d'avoir plusieurs *écrans* (ou page, regroupant un ensemble de graphiques et/ou boîtes) dans le tableau de bords. Pour cela, nous allons définir un menu (avec plusieurs items) dans la partie `sidebar` et définir le contenu de chaque item de ce menu dans le `body`.

Le menu se déclare avec la fonction `sidebarMenu()`, et les items du menu par des `menuItem()`. On doit définir le texte à afficher et l'identifiant de l'item. On peut y ajouter des icônes pour personnaliser le menu. On peut aussi insérer un lien si on le souhaite.

En exécutant le code qui suit, vous verrez comment avoir deux pages, un lien vers le [site](http://www.scimagojr.com/) d'où proviennent les données et un lien vers la liste des icônes disponibles (sur le site [*Font awesome*](http://fontawesome.io/icons/)).

```
library(shiny)
library(shinydashboard)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title = "Dashboard sur la Production scientifique",
      titleWidth = 300
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Vue globale", tabName = "tab_global", icon = icon("list-ol")),
        menuItem("Par année", tabName = "tab_annee", icon = icon("calendar")),
        menuItem("Base 100", tabName = "tab_base100", icon = icon("percent")),
        menuItem("Données", icon = icon("database"), href = "http://www.scimagojr.com/"),
        menuItem("Liste des icônes", icon = icon("font-awesome"), href = "http://fontawesome.io/icons/")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          "tab_global",
          box(
            title = "Evolution de la production scientifique",
            footer = "Nombre de documents scientifiques par année",
            status = "info",
            solidHeader = TRUE,
            width = 8,
            "graphique à prévoir ici"
          ),
          infoBox(
            title = "Progression",
            value = "+ ??%",
            subtitle = "Entre 1996 et 2020",
            icon = icon("chart-line"),
            fill = TRUE,
            color = "light-blue",
            width = 4
          ),
          valueBox(
            value = "??",
            subtitle = "Nombre de documents scientifiques produits sur la periode 1996-2020",
            icon = icon("newspaper"),
            color = "green",
            width = 4
          ),
          tabBox(
            title = "Informations",
            width = 4,
            tabPanel(title = "Titre 1", "contenu 1"),
            tabPanel(title = "Titre 2", "contenu 2")
          )
        ),
        tabItem(
          "tab_annee",
          "Vide pour le moment"
        ),
        tabItem(
          "tab_base100",
          "Vide aussi"
        )
      )
    ),
    title = "Production scientifique",
    skin = "red"
  ),
  server = function(input, output) {
  }
)
```

Maintenant, nous avons l'essentiel de notre interface. Nous allons pouvoir nous concentrer sur les tableaux et graphiques à produire.


## Eléments calculés

Nous allons maintenant regarder comment afficher les différents éléments que nous devons présenter dans le tableau de bord.

### Graphique

Pour ajouter un graphique calculé par **R**, il est nécessaire de définir deux éléments :

- dans l'**UI** : un objet nommé `plotOutput("nom_graphique")` indiquant où, dans l'interface, s'affichera le graphique ;
- dans le **serveur** : on affectera le retour de la fonction `renderPlot()` à l'objet `nom_graphique`.

Pour notre exemple, voici le code, qui permet d'afficher l'évolution pour toutes les villes.

```
library(shiny)
library(shinydashboard)
library(tidyverse)

prod = read.csv("https://fxjollois.github.io/donnees/scimagojr/scimagojr.csv")

prod_global = prod %>%
  group_by(Year) %>%
  summarise(Documents = sum(Documents))

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title = "Dashboard sur la Production scientifique",
      titleWidth = 300
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Vue globale", tabName = "tab_global", icon = icon("list-ol")),
        menuItem("Par année", tabName = "tab_annee", icon = icon("calendar")),
        menuItem("Base 100", tabName = "tab_base100", icon = icon("percent")),
        menuItem("Données", icon = icon("database"), href = "http://www.scimagojr.com/"),
        menuItem("Liste des icônes", icon = icon("font-awesome"), href = "http://fontawesome.io/icons/")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          "tab_global",
          box(
            title = "Evolution de la production scientifique",
            footer = "Nombre de documents scientifiques par année",
            status = "info",
            solidHeader = TRUE,
            width = 8,
            plotOutput("evolution")
          ),
          infoBox(
            title = "Progression",
            value = "+ ??%",
            subtitle = "Entre 1996 et 2020",
            icon = icon("chart-line"),
            fill = TRUE,
            color = "light-blue",
            width = 4
          ),
          valueBox(
            value = "??",
            subtitle = "Nombre de documents scientifiques produits sur la periode 1996-2020",
            icon = icon("newspaper"),
            color = "green",
            width = 4
          ),
          tabBox(
            title = "Informations",
            width = 4,
            tabPanel(title = "Titre 1", "contenu 1"),
            tabPanel(title = "Titre 2", "contenu 2")
          )
        ),
        tabItem(
          "tab_annee",
          "Vide pour le moment"
        ),
        tabItem(
          "tab_base100",
          "Vide aussi"
        )
      )
    ),
    title = "Production scientifique",
    skin = "red"
  ),
  server = function(input, output) {
    output$evolution <- renderPlot({
      ggplot(prod_global, aes(Year, Documents)) +
        geom_line() +
        theme_minimal() +
        labs(x = "", y = "Nombre de documents")
    })
  }
)
```

Vous remarquerez que nous avons ajouter la librairie `tidyverse` (contenant en particulier `dplyr` et `ggplot2`) au début de notre code. Nous calculons l'évolution globale au démarrage de l'application, car ce calcul ne dépend pas des actions de l'utilisateur. Et dans la fonction `renderPlot()`, nous créons uniquement le graphique voulu.

### Texte

Nous allons ici indiquer les valeurs pour la progression (dans l'`infoBox`) et le volume totale (dans la `valueBox`) pour toutes les villes. Pour cela, nous devons aussi définir deux éléments :

- dans l'**UI** : un objet nommé `textOutput("nom")` indiquant où, dans l'interface, s'affichera le texte ;
- dans le **serveur** : on affectera le retour de la fonction `renderText()` à l'objet `nom`.

Ainsi, nous obtenons le code suivant.

```
library(shiny)
library(shinydashboard)
library(tidyverse)

prod = read.csv("https://fxjollois.github.io/donnees/scimagojr/scimagojr.csv")

prod_global = prod %>%
  group_by(Year) %>%
  summarise(Documents = sum(Documents))

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title = "Dashboard sur la Production scientifique",
      titleWidth = 300
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Vue globale", tabName = "tab_global", icon = icon("list-ol")),
        menuItem("Par année", tabName = "tab_annee", icon = icon("calendar")),
        menuItem("Base 100", tabName = "tab_base100", icon = icon("percent")),
        menuItem("Données", icon = icon("database"), href = "http://www.scimagojr.com/"),
        menuItem("Liste des icônes", icon = icon("font-awesome"), href = "http://fontawesome.io/icons/")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          "tab_global",
          box(
            title = "Evolution de la production scientifique",
            footer = "Nombre de documents scientifiques par année",
            status = "info",
            solidHeader = TRUE,
            width = 8,
            plotOutput("evolution")
          ),
          infoBox(
            title = "Progression",
            value = textOutput("progression"),
            subtitle = "Entre 1996 et 2020",
            icon = icon("chart-line"),
            fill = TRUE,
            color = "light-blue",
            width = 4
          ),
          valueBox(
            value = textOutput("volume"),
            subtitle = "Nombre de documents scientifiques produits sur la periode 1996-2020",
            icon = icon("newspaper"),
            color = "green",
            width = 4
          ),
          tabBox(
            title = "Informations",
            width = 4,
            tabPanel(title = "Titre 1", "contenu 1"),
            tabPanel(title = "Titre 2", "contenu 2")
          )
        ),
        tabItem(
          "tab_annee",
          "Vide pour le moment"
        ),
        tabItem(
          "tab_base100",
          "Vide aussi"
        )
      )
    ),
    title = "Production scientifique",
    skin = "red"
  ),
  server = function(input, output) {
    output$evolution <- renderPlot({
      ggplot(prod_global, aes(Year, Documents)) +
        geom_line() +
        theme_minimal() +
        labs(x = "", y = "Nombre de documents")
    })
    output$progression <- renderText({
      paste(round(tail(prod_global$Documents, 1) / head(prod_global$Documents, 1) * 100), "%")
    })
    output$volume <- renderText({
      round(sum(prod_global$Documents, na.rm = T), 1)
    })
  }
)
```

### Tableau

Maintenant, nous allons ajouter des tableaux calculés directement : le TOP 10 des pays sur la production et le TOP 10 des pays sur l'évolution. Encore une fois, nous allons définir deux éléments :

- dans l'**UI** : un objet nommé `tableOutput("nom")` indiquant où, dans l'interface, s'affichera le tableau ;
- dans le **serveur** : on affectera le retour de la fonction `renderTable()` à l'objet `nom`.

Le code deviendra donc le suivant.

```
library(shiny)
library(shinydashboard)
library(tidyverse)

prod = read.csv("https://fxjollois.github.io/donnees/scimagojr/scimagojr.csv")

prod_global = prod %>%
  group_by(Year) %>%
  summarise(Documents = sum(Documents))

top10_prod = prod %>%
  group_by(Country) %>%
  summarise(Documents = sum(Documents)) %>%
  arrange(desc(Documents)) %>%
  head(10)

top10_evol = prod %>%
  filter(Year %in% c(1996, 2020)) %>%
  select(Country, Year, Documents) %>%
  pivot_wider(names_from = Year, values_from = Documents, names_prefix = "Year") %>%
  mutate(Evolution = 100 * (Year2020 / Year1996 - 1)) %>%
  arrange(desc(Evolution)) %>%
  head(10)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title = "Dashboard sur la Production scientifique",
      titleWidth = 300
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Vue globale", tabName = "tab_global", icon = icon("list-ol")),
        menuItem("Par année", tabName = "tab_annee", icon = icon("calendar")),
        menuItem("Base 100", tabName = "tab_base100", icon = icon("percent")),
        menuItem("Données", icon = icon("database"), href = "http://www.scimagojr.com/"),
        menuItem("Liste des icônes", icon = icon("font-awesome"), href = "http://fontawesome.io/icons/")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          "tab_global",
          box(
            title = "Evolution de la production scientifique",
            footer = "Nombre de documents scientifiques par année",
            status = "info",
            solidHeader = TRUE,
            width = 8,
            plotOutput("evolution")
          ),
          infoBox(
            title = "Progression",
            value = textOutput("progression"),
            subtitle = "Entre 1996 et 2020",
            icon = icon("chart-line"),
            fill = TRUE,
            color = "light-blue",
            width = 4
          ),
          valueBox(
            value = textOutput("volume"),
            subtitle = "Nombre de documents scientifiques produits sur la periode 1996-2020",
            icon = icon("newspaper"),
            color = "green",
            width = 4
          ),
          tabBox(
            title = "TOP 10",
            width = 4,
            tabPanel(title = "Production", tableOutput("top_prod")),
            tabPanel(title = "Evolution", tableOutput("top_evol"))
          )
        ),
        tabItem(
          "tab_annee",
          "Vide pour le moment"
        ),
        tabItem(
          "tab_base100",
          "Vide aussi"
        )
      )
    ),
    title = "Production scientifique",
    skin = "red"
  ),
  server = function(input, output) {
    output$evolution <- renderPlot({
      ggplot(prod_global, aes(Year, Documents)) +
        geom_line() +
        theme_minimal() +
        labs(x = "", y = "Nombre de documents")
    })
    output$progression <- renderText({
      paste(round(tail(prod_global$Documents, 1) / head(prod_global$Documents, 1) * 100), "%")
    })
    output$volume <- renderText({
      round(sum(prod_global$Documents, na.rm = T), 1)
    })
    output$top_prod <- renderTable({
      top10_prod
    })
    output$top_evol <- renderTable({
      top10_evol
    })
  }
)
```


## Interaction avec l'utilisateur

Notre *dashboard* est malheureusement dit *statique* pour le moment, car l'utilisateur ne peut pas interagir avec, ce qui est souvent demandé. Par exemple, sur ce cas, il serait intéressant de pouvoir choisir un pays, pour ne voir que les informations de celui-ci (évolution, progression, ...).

Pour cela, nous allons introduire la notions d'**inputs** (ou **entrées**). Nous allons ajouter un élément dans l'*UI* : un `selectInput()`, qui correspond à une liste de choix. Dans cette fonction, nous devrons déterminer le nom de la variable créée (qui nous permettra de connaître le choix de l'utilisateur), le label à afficher et la liste de choix. Pour cette dernière, nous allons prendre la liste des pays en ajoutant le choix "Tous les pays". Pour utiliser cette variable créer, dans le *server*, nous la récupérons avec le nom donné, dans l'objet `input` (cf code ci-dessous).

Nous allons utiliser ce choix à deux moments pour le moment :

- pour la création du graphique ;
- pour le calcul du taux de progression.


```
library(shiny)
library(shinydashboard)
library(tidyverse)

prod = read.csv("https://fxjollois.github.io/donnees/scimagojr/scimagojr.csv")

prod_global = prod %>%
  group_by(Year) %>%
  summarise(Documents = sum(Documents))

top10_prod = prod %>%
  group_by(Country) %>%
  summarise(Documents = sum(Documents)) %>%
  arrange(desc(Documents)) %>%
  head(10)

top10_evol = prod %>%
  filter(Year %in% c(1996, 2020)) %>%
  select(Country, Year, Documents) %>%
  pivot_wider(names_from = Year, values_from = Documents, names_prefix = "Year") %>%
  mutate(Evolution = 100 * (Year2020 / Year1996 - 1)) %>%
  arrange(desc(Evolution)) %>%
  head(10)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title = "Dashboard sur la Production scientifique",
      titleWidth = 300
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Vue globale", tabName = "tab_global", icon = icon("list-ol")),
        menuItem("Par année", tabName = "tab_annee", icon = icon("calendar")),
        menuItem("Base 100", tabName = "tab_base100", icon = icon("percent")),
        menuItem("Données", icon = icon("database"), href = "http://www.scimagojr.com/"),
        menuItem("Liste des icônes", icon = icon("font-awesome"), href = "http://fontawesome.io/icons/")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          "tab_global",
          box(
            title = "Evolution de la production scientifique",
            footer = "Nombre de documents scientifiques par année",
            status = "info",
            solidHeader = TRUE,
            width = 8,
            plotOutput("evolution")
          ),
          box(
            width = 4,
            selectInput("pays", "Pays choisis", 
                        choices = c("Tous les pays", sort(unique(prod$Country))))
          ),
          infoBox(
            title = "Progression",
            value = textOutput("progression"),
            subtitle = "Entre 1996 et 2020",
            icon = icon("chart-line"),
            fill = TRUE,
            color = "light-blue",
            width = 4
          ),
          valueBox(
            value = textOutput("volume"),
            subtitle = "Nombre de documents scientifiques produits sur la periode 1996-2020",
            icon = icon("newspaper"),
            color = "green",
            width = 4
          ),
          tabBox(
            title = "TOP 10",
            width = 4,
            tabPanel(title = "Production", tableOutput("top_prod")),
            tabPanel(title = "Evolution", tableOutput("top_evol"))
          )
        ),
        tabItem(
          "tab_annee",
          "Vide pour le moment"
        ),
        tabItem(
          "tab_base100",
          "Vide aussi"
        )
      )
    ),
    title = "Production scientifique",
    skin = "red"
  ),
  server = function(input, output) {
    output$evolution <- renderPlot({
      if (input$pays == "Tous les pays") {
        df = prod_global
      } else {
        df = prod %>%
          filter(Country == input$pays) %>%
          group_by(Year) %>%
          summarise(Documents = sum(Documents))
      }
      ggplot(df, aes(Year, Documents)) +
        geom_line() +
        theme_minimal() +
        labs(x = "", y = "Nombre de documents")
    })
    output$progression <- renderText({
      if (input$pays == "Tous les pays") {
        df = prod_global
      } else {
        df = prod %>%
          filter(Country == input$pays) %>%
          group_by(Year) %>%
          summarise(Documents = sum(Documents))
      }
      paste(round(tail(df$Documents, 1) / head(df$Documents, 1) * 100), "%")
    })
    output$volume <- renderText({
      round(sum(prod_global$Documents, na.rm = T), 1)
    })
    output$top_prod <- renderTable({
      top10_prod
    })
    output$top_evol <- renderTable({
      top10_evol
    })
  }
)
```


## Variable réactive

Dans le code ci-dessus, il y a deux fois le test sur le choix du pays, pour avoir le tableau d'évolution qui nous sert à la fois pour le graphique et pour la progression. L'idéal serait de faire une fonction permettant de calculer ce tableau, directement après le choix d'un pays par l'utilisateur. Pour cela, nous devons utiliser la fonction `reactive()`, tel que ci-dessous.

```
library(shiny)
library(shinydashboard)
library(tidyverse)

prod = read.csv("https://fxjollois.github.io/donnees/scimagojr/scimagojr.csv")

prod_global = prod %>%
  group_by(Year) %>%
  summarise(Documents = sum(Documents))

top10_prod = prod %>%
  group_by(Country) %>%
  summarise(Documents = sum(Documents)) %>%
  arrange(desc(Documents)) %>%
  head(10)

top10_evol = prod %>%
  filter(Year %in% c(1996, 2020)) %>%
  select(Country, Year, Documents) %>%
  pivot_wider(names_from = Year, values_from = Documents, names_prefix = "Year") %>%
  mutate(Evolution = 100 * (Year2020 / Year1996 - 1)) %>%
  arrange(desc(Evolution)) %>%
  head(10)

shinyApp(
  ui = dashboardPage(
    dashboardHeader(
      title = "Dashboard sur la Production scientifique",
      titleWidth = 300
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Vue globale", tabName = "tab_global", icon = icon("list-ol")),
        menuItem("Par année", tabName = "tab_annee", icon = icon("calendar")),
        menuItem("Base 100", tabName = "tab_base100", icon = icon("percent")),
        menuItem("Données", icon = icon("database"), href = "http://www.scimagojr.com/"),
        menuItem("Liste des icônes", icon = icon("font-awesome"), href = "http://fontawesome.io/icons/")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          "tab_global",
          box(
            title = "Evolution de la production scientifique",
            footer = "Nombre de documents scientifiques par année",
            status = "info",
            solidHeader = TRUE,
            width = 8,
            plotOutput("evolution")
          ),
          box(
            width = 4,
            selectInput("pays", "Pays choisis", 
                        choices = c("Tous les pays", sort(unique(prod$Country))))
          ),
          infoBox(
            title = "Progression",
            value = textOutput("progression"),
            subtitle = "Entre 1996 et 2020",
            icon = icon("chart-line"),
            fill = TRUE,
            color = "light-blue",
            width = 4
          ),
          valueBox(
            value = textOutput("volume"),
            subtitle = "Nombre de documents scientifiques produits sur la periode 1996-2020",
            icon = icon("newspaper"),
            color = "green",
            width = 4
          ),
          tabBox(
            title = "TOP 10",
            width = 4,
            tabPanel(title = "Production", tableOutput("top_prod")),
            tabPanel(title = "Evolution", tableOutput("top_evol"))
          )
        ),
        tabItem(
          "tab_annee",
          "Vide pour le moment"
        ),
        tabItem(
          "tab_base100",
          "Vide aussi"
        )
      )
    ),
    title = "Production scientifique",
    skin = "red"
  ),
  server = function(input, output) {
    donnees = reactive({
      if (input$pays == "Tous les pays") {
        df = prod_global
      } else {
        df = prod %>%
          filter(Country == input$pays) %>%
          group_by(Year) %>%
          summarise(Documents = sum(Documents))
      }
      df
    })
    
    output$evolution <- renderPlot({
      ggplot(donnees(), aes(Year, Documents)) +
        geom_line() +
        theme_minimal() +
        labs(x = "", y = "Nombre de documents")
    })
    output$progression <- renderText({
      df = donnees()
      paste(round(tail(df$Documents, 1) / head(df$Documents, 1) * 100), "%")
    })
    output$volume <- renderText({
      round(sum(prod_global$Documents, na.rm = T), 1)
    })
    output$top_prod <- renderTable({
      top10_prod
    })
    output$top_evol <- renderTable({
      top10_evol
    })
  }
)
```


