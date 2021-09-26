# Exercices autour des lois et du calcul de probabilités

## Loi uniforme continue

### Exercice 1

**X** est une v.a. de loi uniforme sur l'intervalle *I*. Déterminer pour chaque intervalle ci-dessous la fonction de densité et calculer *P(4 &le; X &le; 5)*.

1. *I = [4; 6]*
2. *I = [0; 5]*

### Exercice 2

**X** est une v.a. de loi uniforme sur *[-3;3]*.

1. Calculer *P(X < 1)*, et *P(X &ge; 0.5)*
1. Donner l'espérance de **X**

### Exercice 3
Antoine doit venir voir Jean entre 14h45 et 16h30. Quelle est la probabilité qu'il arrive pendant la réunion de Jean qui a lieu entre 15h30 et 16h00 ?


## Lois discrètes

### Outil de calcul des probabilités d'une loi binomiale

<script>
function binom(n, p){
	if (p < 0 || p > n){
		return 0;
	}
	if (p > n / 2){
		return binom(n, n - p);
	}
	else {
		var c = 1;
		for (var k = 1; k <= p; k++){
			c = c * (n + 1 - k) / k;
		}
		return c;
	}
}

function f(N, p, K){
	return(binom(N, K) * Math.pow(p, K) * Math.pow(1-p, N-K));
}

function F(N, p, K){
	var somme = 0;
	for (var i = 0; i <= K; i++){
		somme += f(N, p, i);
	}
	return(somme);
}

function arrondi(x, d){
	var e, res;
  if (x < 0.0001) {
    res = "inférieur à 0.0001"
  } else {
    e = Math.pow(10, d);
    res = Math.round(e * x) / e;
  }
	return(res);
}


function maj(){
	N = parseInt(document.getElementById('entN').value);
	N = Math.max(N,1);
	N = Math.min(N,1000);
	document.getElementById('entN').value = N;
	document.getElementById('nbN').innerHTML = N;
	p = parseFloat(document.getElementById('entp').value);
	p = Math.max(p,0);
	p = Math.min(p,1);
	document.getElementById('entp').value = p;
	K = parseInt(document.getElementById('entK').value);
	K = Math.max(K,0);
	K = Math.min(K,N);
	document.getElementById('entK').value = K;
	document.getElementById("Pegal").innerHTML = arrondi(f(N,p,K), 4);
	document.getElementById("Pinf").innerHTML = arrondi(F(N,p,K), 4);
}
</script>

<table>
  <tr><th>Paramètre</th><th>Valeur</th><th>Limites</th></tr>
  <tr><td>N</td><td><input id="entN" value=25  onChange="maj();"></td><td>entre 1 et 1000</td></tr>
  <tr><td>p</td><td><input id="entp" value=0.4 onChange="maj();"></td><td>entre 0 et 1</td></tr>
  <tr><td>K</td><td><input id="entK" value=0   onChange="maj();"></td><td>entre 0 et <span id="nbN">25</span></td></tr>
</table>

<table>
  <tr><th>Proba</th><th>Valeur</th></tr>
  <tr><td>P(X = K)</td><td id="Pegal">--</td></tr>
  <tr><td>P(X &le; K)</td><td id="Pinf">--</td></tr>
</table>

### Pile ou face à répétition
On joue à pile ou face, 4 fois de suite. Et on note les résultats (dans l'ordre).

1. Déterminer la loi de probabilité 
2. Calculer les probabilités des 2 évènements suivants :
  - *A* : il y a strictement plus de piles que de faces
  - *B* : le premier lancer est pile

### De l'utilité des probabilités dans les choix stratégiques d'un étudiant

Un test comporte 10 questions, avec chacune 4 choix possibles et une seule réponse juste.

1. Combien y a t'il de grilles de réponses possibles ?
2. Quelle est la probabilité de répondre au hasard 6 fois correctement ?

### Concerts

Supposons un enseignant **J** ayant un groupe de rock et se produit à un concert **C** dans un bar à Cherbourg durant le mois d'octobre. On considère qu'un.e étudiant.e **E** a une probabilité de sortir le soir égale à *.5*, et a une probabilité de *.5* d'aller dans le bar où se produit le groupe.

1. Que puis-je dire de la variable aléatoire modélisant qu'un étudiant **E** voit un concert **C** ? Quelle est la probabilité de l'évènement *A* : **E** vient à **C** ?
1. Maintenant, on se demande combien d'étudiants parmi les 85 de la promo viendront à un concert. Comment modéliser ce processus ? Quelle est la probabilité qu'au moins 10 étudiants viennent ?
1. Enfin, l'enseignant se produit au final 3 fois dans le mois. On cherche donc à savoir quelle est la probabilité qu'un étudiant **E** voient les trois concerts **C1**, **C2** et **C3**. Comment puis-je faire ?
  - Quelle est la probabilité qu'un étudiant vienne à aucun concert ? à un seul concert ? à deux ? au trois ?
  - Sachant qu'un étudiant qui vient aux trois concerts aura la note maximale (donc 20), celui qui vient à 2 aura 15, à un seul 10, et 0 pour ceux qui ne viennent pas, comment puis-je estimer la moyenne de la promotion ?

> N'hésitez pas à contacter l'enseignant **J** pour plus de renseignements sur les concerts &#128521;
