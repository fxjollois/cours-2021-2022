/*global console,d3,Set */
/*eslint no-console: "off" */

// Etape 1 : renommage de la page
d3.select("head").append("title").html("Test d3js");

// Etape 2 : ajout d'un bouton radio avec le choix de la taille du TOP
var choix_taille = d3.select("#top").append("form").attr("class", "choix")
    .append("fieldset");
choix_taille.append("legend").html("Choisir une taille");
choix_taille
    .selectAll("input")
    .data([3, 5, 10, 20])
    .enter()
    .append("label")
    .text(function(d) {return d;})
    .insert("input")
    .attr("type", "radio")
    .attr("name", "taille")
    .attr("value", function(d) {return d;})
    .property("checked", function(d) {return d == 5;})
    .on("change", function() { console.log(this.value) });

// Etape 3 : ajout de choix dans une lliste d'année (mais vide pour le moment)
var choix_annee = d3.select("#top").append("form").attr("class", "choix")
    .append("fieldset");
choix_annee.append("legend").html("Choisir une année");
choix_annee.append("select").attr("name", "annee").attr("id", "choix_annee")
    .selectAll("option")
    .data([1234, 2345, 3456]) // pour essai
    .enter()
    .append("option")
    .attr("value", function(d) {return d;})
    .html(function(d) {return d;});

// Etape 4 : créer le tableau vide qui contiendra le TOP
d3.select("#top").append("table")
    .append("thead")
    .append("tr")
    .selectAll("th")
    .data(["Pays", "Rang", "Documents", "Citations"])
    .enter()
    .append("th")
    .html(function(d) {return d;});
d3.select("#top").select("table")
    .append("tbody")
    .attr("id", "table_top");

var generateCell = function(d) {
    return "<td class='" + (isNaN(parseInt(d)) ? "texte" : "nombre") + "'>" + d + "</td>";
}
var generateRow = function(d) {
    return generateCell(d.Country) + generateCell(d.Rank) + generateCell(d.Documents) + generateCell(d.Citations);
}

// Etape 5 : récupérer les données
d3.csv(
    "https://fxjollois.github.io/donnees/scimagojr/scimagojr.csv",
    function (d) {
        if (d.Country === "France" & d.Year === "1996") {
            console.log(d)
        }
        return {
            Year: parseInt(d.Year),
            Rank: parseInt(d.Rank),
            Country: d.Country,
            Region: d.Region,
            Documents: parseInt(d.Documents),
            Citations: parseInt(d.Citations),
            Hindex: parseInt(d["H index"])
        }
    })
    .then(function(data) {
        console.log(data[0]);
        // Etape 6 : mettre à jour le choix des années
        d3.select("#choix_annee").selectAll("option").remove();
        d3.select("#choix_annee").selectAll("option")
            .data(Array.from(new Set(data.map(function(d) {return d.Year;}))))
            .enter()
            .append("option")
            .attr("value", function(d) {return d;})
            .html(function(d) {return d;});
    
        // Etape 7 : remplir le tableau
        var data_annee = d3.filter(data, function(d) {return d.Year == d3.select("#choix_annee").node().value;});
        d3.select("#table_top").selectAll("tr")
            .data(data_annee)
            .enter()
            .append("tr")
            .style("display", function(d) {
                return d.Rank > parseInt(d3.select('input[name="taille"]:checked').node().value) ? "none" : "table-row";
            })
            .html(function(d) { return generateRow(d); })
    
        // Etape 8 : gérer le changement de taille
        choix_taille.on("change", function() { 
            d3.select("#table_top").selectAll("tr")
                .style("display", function(d) { 
                    return d.Rank > parseInt(d3.select('input[name="taille"]:checked').node().value) ? "none" : "table-row";
                })
        })
    
        // Etape 9 : gérer le changement d'année
        choix_annee.on("change", function() {
            data_annee = d3.filter(data, function(d) { return d.Year == d3.select("#choix_annee").node().value});
            d3.select("#table_top").html("")
                .selectAll("tr")
                .data(data_annee)
                .enter()
                .append("tr")
                .style("visibility", function(d, i) { 
                    return (i+1) > parseInt(d3.select('input[name="taille"]:checked').node().value) ? "hidden" : "visible";
                })
                .html(function(d) { return generateRow(d); })
        })
    })



