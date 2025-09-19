#import "@local/course-style:0.0.1": *

#show: doc => COURSE(
  class: "Seconde",
  level: "SNT",
  duration: "1h30",
  title: "Documentation du package course-style:0.0.1",
  cell_fill_color: blue.lighten(90%),
  doc
)

= Documentation du package course-style:0.0.1
#outline(title: none, )
== Installation et configuration

=== Installation du package
1. *Créer la structure de dossiers* :
   Créez le dossier suivant dans votre répertoire de packages Typst :
   ```
  C:\Users\xxxx\AppData\Local\typst\packages\local\course-style\0.0.1
   ```

2. *Copier les fichiers* :
   - Placez le fichier `style.typ` dans ce dossier
   - Placez le fichier `typst.toml` dans ce dossier
   - Ajoutez votre logo `logo.png` *au même niveau* que `style.typ`

3. *Structure finale* :
   ```
  C:\Users\xxxx\AppData\Local\typst\packages\local\course-style\0.0.1
   ├── typst.toml
   ├── style.typ
   └── logo.png
   ```

=== Configuration du package (typst.toml)

Le fichier `typst.toml` doit contenir la configuration suivante :

```toml
[package]
name = "course-style"
version = "0.0.1"
entrypoint = "style.typ"
authors = ["CADI TAZI Tawfiq"]
license = "MIT"
description = "Template for educational documents and courses"
```

== Exemple d'arborescence de titres
=== Titre de niveau 3 (exemple)
==== Titre de niveau 4 (exemple)
===== Titre de niveau 5 (exemple de hiérarchie)
====== Titre de niveau 6 (structure complète)

Ce document présente toutes les fonctionnalités disponibles dans le module `course-style:0.0.1` pour créer des documents pédagogiques.

== Configuration de base

=== Import et utilisation

#grid(columns: (auto, 1fr), stroke: 0.5pt + gray, inset: 1em,
[
```typst
#import "@local/course-style:0.0.1": *

#show: doc => COURSE(
  class: "Seconde",
  level: "SNT",
  duration: "2h",
  title: "Mon cours",
  doc
)
```

],

[
- `class` : Classe concernée (défaut: "Seconde")
- `level` : Niveau/matière (défaut: "SNT")
- `duration` : Durée du cours (défaut: "2h")
- `title` : Titre du document (défaut: "Les données structurées")
- `academy` : Académie (défaut: "ACADÉMIE")
- `school` : Établissement (défaut: "Lycée XX")
- `logo_path` : Chemin du logo (défaut: "Tux.png")
- `logo_width` : Taille du logo (défaut: 1cm)
- `cell_fill_color` : Couleur des cellules signature (défaut: yellow)

])





== Encadrés personnalisés

=== Encadré générique

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #format_box(title: "Mon titre", color: blue)[
      ```typst
    #format_box(title: "Mon titre", color: blue)[Contenu de l'encadré]
    ```
    ]
  ],
  [
    #format_box(title: "Titre vert", color: green, breakable: true)[
      ```typst
    #format_box(title: "Titre vert", color: green, breakable: true)[Contenu cassable]
    ```
    ]
  ],
  [
    #definition_box(title: "Variables")[```typst
    #definition_box(title: "Variables")[Une variable stocke une valeur]
    ```]
  ],
  [
    #example_box[```typst
    #example_box[Voici un exemple concret d'utilisation]
    ```]
  ],
  [
    #info_box[```typst
    #info_box[Information importante à retenir]
    ```]
  ],
  [
    #warning_box[```typst
    #warning_box[Attention : risque d'erreur !]
    ```]
  ],
  grid.cell(colspan: 2)[
    #synthesis_box(title: "À retenir", color: orange)[```typst
    #synthesis_box(title: "À retenir", color: orange)[Points clés du chapitre]
    ```]
  ]
)



=== Tableaux vides

*Tableau par défaut (solide) :*
```typst
#empty_table(cols: 3, rows: 4)
```
#empty_table(cols: 3, rows: 4)

*Tableau en pointillés :*
```typst
#empty_table(cols: 4, rows: 3, solid: false)
```
#empty_table(cols: 4, rows: 3, solid: false)

*Tableau entièrement en pointillés (y compris en-tête) :*
```typst
#empty_table(cols: 4, rows: 3, solid: false, header_solid: false)
```
#empty_table(cols: 4, rows: 3, solid: false, header_solid: false)

*Tableau avec lignes alternées :*
```typst
#empty_table(cols: 5, rows: 4, striped: true)
```
#empty_table(cols: 5, rows: 4, striped: true)

*Tableau avec en-tête coloré :*
```typst
#empty_table(cols: 4, rows: 3, header_fill: true)
```
#empty_table(cols: 4, rows: 3, header_fill: true)

*Tableau complet (solide + rayé + en-tête coloré) :*
```typst
#empty_table(cols: 3, rows: 5, striped: true, header_fill: gray.darken(20%))
```
#empty_table(cols: 3, rows: 5, striped: true, header_fill: gray.darken(20%))

== Système de corrections

=== Lignes d'écriture

*Lignes complètes sans correction :*
```typst
#set_correction(false)
#full_lines(count: 2, correction: "Première réponse seulement")
```
#set_correction(false)
#full_lines(count: 2, spacing: 1em, correction: "Première réponse seulement")

*Lignes complètes avec correction :*
```typst
#set_correction(true)
#full_lines(count: 3, correction: "Première réponse seulement")
```
#set_correction(true)
#full_lines(count: 3, correction: "Première réponse seulement ")

*Ligne à compléter sans correction :*
```typst
#set_correction(false)
Nom : #lines()
```
#set_correction(false)
Nom : #lines()

*Ligne à compléter avec correction :*
```typst
#set_correction(true)
Nom : #lines(correction: "Jean Dupont")
```
#set_correction(true)
Nom : #lines(correction: "Jean Dupont")

*Réponse multi-lignes avec correction sur la première ligne :*
```typst
#set_correction(true)
Que pensez-vous ? #lines(count: 3, correction: "C'est très pratique pour les corrections")
```
#set_correction(true)
Que pensez-vous ? #lines(count: 3, correction: "C'est très pratique pour les corrections")

=== Configuration des corrections
```typst
#set_correction(true)   // Active les corrections
#set_correction(false)  // Masque les corrections
```

=== Trous à compléter
```typst
#set_correction(false)
#gap(width: 6cm)
```
#set_correction(false)
Voici un trou vide : #gap(width: 6cm)\

```typst
#set_correction(true)
#gap(width: 6cm, correction: "La réponse")
```
#set_correction(true)
Trou avec correction : #gap(width: 6cm, correction: "La réponse")

=== Blocs de réponse

*Bloc de réponse sans correction :*
```typst
#set_correction(false)
#response_block(height: 3cm, correction: "Réponse attendue dans ce bloc")
```
#set_correction(false)
Que remarquez-vous sur cette image ?
#response_block(height: 3cm)

*Bloc de réponse avec correction :*
```typst
#set_correction(true)
#response_block(height: 3cm, correction: "Réponse attendue dans ce bloc")
```
#set_correction(true)
Expliquez le concept de variable :
#response_block(height: 3cm, correction: "Une variable est un espace de stockage nommé qui contient une valeur")



*Bloc personnalisé (largeur, encadrement) :*
```typst
#set_correction(true)
#response_block(
  height: 2.5cm,
  width: 80%,
  inset: 1cm,
  stroke: (dash: "solid", thickness: 1pt),
  correction: "Réponse courte"
)
```
#set_correction(true)
Résumé en une phrase :
#response_block(
  height: 2.5cm,
  width: 80%,
  inset: 1cm,
  stroke: (dash: "solid", thickness: 1pt),
  correction: "Réponse courte et précise"
)

== Modules externes intégrés

=== gentle-clues : Encadrés pédagogiques

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #goal(title: "Objectif")[```typst
    #goal(title: "Objectif")[Comprendre les variables en Python]
    ```]
  ],
  [
    #info[```typst
    #info[Information générale sur le sujet]
    ```]
  ],
  [
    #warning[```typst
    #warning[Attention aux erreurs courantes !]
    ```]
  ],
  [
    #success[```typst
    #success[Bravo ! Exercice réussi]
    ```]
  ],
  [
    #error[```typst
    #error[Erreur détectée dans le code]
    ```]
  ],
  [
    #tip[```typst
    #tip[Astuce : utilisez Ctrl+S pour sauvegarder]
    ```]
  ],
  [
    #quotation[
    ```typst
    #quote[Citation importante d'un auteur]
    ```]
  ],
  [
    #memo[```typst
    #memo[Mémo à retenir absolument]
    ```]
  ],
  grid.cell(colspan: 2)[
    #task[```typst
    #task[Tâche à accomplir avant la prochaine séance]
    ```]
  ]
)

