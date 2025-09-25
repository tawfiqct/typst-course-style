# Course Style Package

> Template Typst pour documents pédagogiques 

## Description

Le package `course-style` est un template Typst conçu pour créer des documents pédagogiques élégants et structurés. 

## Architecture du système
Il utilise un système de **git worktrees** permettant de maintenir plusieurs versions simultanément (développement et versions figées) avec un **symlink** vers les packages locaux Typst pour un accès direct.

```
_typst_local_packages/
└─ course-style/
   ├─ 99.99.99/             # Dépôt git principal (développement actif)
   │  ├─ .git/             # Repository git complet
   │  ├─ style.typ         # Template en cours de développement
   │  ├─ typst.toml        # version = "99.99.99"
   │  ├─ logo.png          # Logo par défaut
   │  └─ Demo_Course_Style.typ # Démonstration
   ├─ 0.0.1/               # Worktree figé sur tag v0.0.1 (futur)
   │  ├─ .git → 99.99.99/.git/worktrees/0.0.1  # Référence worktree
   │  ├─ style.typ         # Version figée v0.0.1
   │  └─ typst.toml        # version = "0.0.1"
   └─ 0.0.2/               # Worktree figé sur tag v0.0.2 (futur)

%APPDATA%\Local\typst\packages\local\
└─ course-style → C:\...\\_typst_local_packages\course-style  # Symlink
```

## Installation et configuration

### 1. Créer le symlink

**Commande PowerShell (Administrateur requis) :**
```powershell
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\typst\packages\local\course-style" -Target "C:\votre\chemin\_typst_local_packages\course-style"
```

### Workflow de développement

#### Développement quotidien
1. Travailler directement dans `_typst_local_packages/course-style/99.99.99/`

#### Créer une version figée
```bash
cd 99.99.99/  # Dans le repo git principal
git tag v1.0.0 -m "Release v1.0.0: Description des changements"
git worktree add ../1.0.0 v1.0.0
```

#### Supprimer une version figée
```bash
cd 99.99.99/
git worktree remove ../1.0.0
```

### 2. Extension VSCode

Installer l'extension **Tinymist Typst** dans VSCode :
- L'extension installe automatiquement Typst (pas besoin d'installation manuelle)
- Compile et prévisualise les documents `.typ` directement dans VSCode


## Utilisation

### Imports selon le contexte

**Pour le développement (version courante) :**
```typst
#import "@local/course-style:99.99.99": *
```

**Pour les documents en production (versions figées) :**
```typst
#import "@local/course-style:1.0.0": *
```

### Exemple d'usage

```typst
#import "@local/course-style:99.99.99": *

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
  Une variable stocke une valeur en mémoire.
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
