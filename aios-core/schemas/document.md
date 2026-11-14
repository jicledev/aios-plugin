# Schéma — fiche de lecture d'un document

Fichier : `<dossier de destination>/<titre-court>.md`, par exemple `20-domaines/veille-techno/agents-patterns.md`. Une fiche résume un document (PDF, Word, image…) pour le retrouver et s'en servir sans relire l'original. L'original ne vit jamais dans le vault : il est dans Google Drive (`AIOS/documents/`), ou reste là où il était.

En-tête YAML **plat** :

| Champ | Obligatoire | Valeurs |
|---|---|---|
| `type` | oui | `document` |
| `format` | oui | `pdf` \| `word` \| `image` \| `autre` |
| `source` | non | URL ou provenance (« mail de X », « salon Y ») |
| `ajoute` | oui | date `AAAA-MM-JJ` |
| `original` | non | chemin relatif au dossier AIOS de Drive (ex. `documents/2026/agents-patterns.pdf`) ; absent s'il n'y a pas de Drive |
| `original_local` | non | chemin absolu d'origine, quand l'original n'est pas conservé dans Drive |
| `empreinte` | oui | empreinte SHA-256 du fichier, pour repérer les doublons |
| `projet` | non | nom d'un dossier de `10-projets/` |
| `domaine` | non | nom d'un dossier de `20-domaines/` |

Corps : `## Résumé` (quelques lignes), `## Idées clés` (liste), `## Notes` (libre, avec des `[[liens]]`), puis la ligne `Original : [<nom du fichier>](<lien file:///…>)`. Pour une image, le résumé décrit ce que montre le schéma : composants, flux, ce qu'il faut retenir.

## Exemple

```markdown
---
type: document
format: pdf
source: https://exemple.com/agents-patterns
ajoute: 2026-11-14
original: documents/2026/agents-patterns.pdf
empreinte: 3f2a…c91e
domaine: veille-techno
---
# Patterns d'architecture des agents

## Résumé
Panorama des façons d'organiser un système d'agents : orchestrateur, chaîne, équipe d'agents spécialisés.

## Idées clés
- Commencer par un seul agent avec de bons outils avant d'en ajouter d'autres.
- Un orchestrateur coûte cher en jetons : le réserver aux tâches vraiment parallèles.

## Notes
Utile pour [[lancement-app]].

Original : [agents-patterns.pdf](file:///G:/Mon%20Drive/AIOS/documents/2026/agents-patterns.pdf)
```
