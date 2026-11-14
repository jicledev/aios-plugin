# Schéma — fiche projet

Fichier : `10-projets/<nom-du-projet>/README.md`. Un projet a une fin (date ou livrable).

L'en-tête YAML est **plat** (aucun objet imbriqué) pour rester lisible dans les « Propriétés » d'Obsidian. Il est le contrat lu par les skills et, plus tard, par l'application.

| Champ | Obligatoire | Valeurs |
|---|---|---|
| `type` | oui | `projet` |
| `statut` | oui | `idee` \| `actif` \| `en-pause` \| `termine` \| `abandonne` |
| `echeance` | non | date `AAAA-MM-JJ` |
| `domaine` | non | nom d'un dossier de `20-domaines/` |
| `code_repo` | non | URL du dépôt GitHub |
| `code_local` | non | chemin local du dépôt de code |
| `code_stack` | non | liste, ex. `[react-native, supabase]` |
| `notion` | non | URL Notion, si le projet utilise Notion |

Corps : sections `## Objectif`, `## Prochaines actions`, `## Décisions` (une ligne datée par décision, avec sa raison quand elle est connue : `- AAAA-MM-JJ — <décision> — parce que <raison>`), `## Notes`.

## Exemple

```markdown
---
type: projet
statut: actif
echeance: 2027-03-01
domaine: produits
code_repo: https://github.com/exemple/mon-app
code_local: C:\Users\exemple\Projets\mon-app
code_stack: [react-native, supabase]
---
# Lancement de mon app

## Objectif
Publier la v1 sur les stores avant mars.

## Prochaines actions
- [ ] Finir l'écran d'inscription
- [ ] Préparer la page de vente

## Décisions
- 2026-11-13 — Lancement d'abord sur Android uniquement — parce que le budget ne couvre qu'une plateforme.

## Notes
Lié à [[produits]].
```
