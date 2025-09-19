# Course Style Package

> Template Typst pour documents pedagogiques

## Description

Le package `course-style` est un template Typst concu pour creer des documents pedagogiques elegants et structures. Il offre un ensemble complet de fonctionnalites pour les enseignants et formateurs souhaitant produire des supports de cours professionnels.

## Installation

### 1. Creer la structure de dossiers

Creez le dossier suivant dans votre repertoire de packages Typst :

```
C:\Users\[votre-nom]\AppData\Local\typst\packages\local\course-style\0.0.1
```

### 2. Copier les fichiers

- Placez le fichier `style.typ` dans ce dossier
- Placez le fichier `typst.toml` dans ce dossier
- Ajoutez votre logo `logo.png` au meme niveau que `style.typ`

### 3. Structure finale

```
C:\Users\[votre-nom]\AppData\Local\typst\packages\local\course-style\0.0.1
├── typst.toml
├── style.typ
└── logo.png
```

## Utilisation de base

```typst
#import "@local/course-style:0.0.1": *

#show: doc => COURSE(
  class: "Seconde",
  level: "SNT",
  duration: "2h",
  title: "Mon cours",
  doc
)

= Titre principal
== Section
=== Sous-section

#definition_box(title: "Variables")[
  Une variable stocke une valeur en memoire.
]

#example_box[
  Voici un exemple concret d'utilisation.
]
```

## Fonctionnalites principales

### En-tete automatique
- Logo personnalisable
- Informations de classe et duree
- Numerotation automatique des pages

### Encadres pedagogiques
- Definitions
- Exemples
- Informations
- Avertissements
- Syntheses

### Systeme de corrections
- Lignes a completer
- Trous dans le texte
- Blocs de reponse
- Mode correction activable/desactivable

### Tableaux vides
- Generation automatique
- Styles personnalisables
- Lignes alternees

### Encadres gentle-clues
- Objectifs
- Conseils
- Erreurs
- Succes
- Memos

## Documentation complete

**Pour voir tous les exemples et la documentation detaillee, consultez le fichier PDF genere a partir de `Demo_Course_Style.typ`.**

Ce fichier contient :
- Tous les exemples visuels des fonctionnalites
- La syntaxe complete pour chaque element
- Des cas d'usage concrets
- Les parametres de configuration disponibles


---

> **Astuce** : Compilez le fichier `Demo_Course_Style.typ` en PDF pour avoir un apercu complet de toutes les fonctionnalites disponibles avec des exemples visuels.