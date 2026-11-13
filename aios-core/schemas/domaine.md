# Schéma — fiche domaine

Fichier : `20-domaines/<nom-du-domaine>/README.md`. Un domaine est une responsabilité permanente (une « casquette ») : il n'a pas de fin.

En-tête YAML **plat** :

| Champ | Obligatoire | Valeurs |
|---|---|---|
| `type` | oui | `domaine` |
| `statut` | oui | `actif` \| `dormant` |

Corps libre. Sections conseillées : `## Périmètre`, `## Règles`, `## Contacts clés`, `## Projets liés` (en `[[liens]]`).

## Exemple

```markdown
---
type: domaine
statut: actif
---
# Contenu

## Périmètre
Newsletter hebdomadaire, posts LinkedIn, vidéos YouTube.

## Règles
- Newsletter envoyée le mardi.
- Toujours relire avec [[ma-voix]].

## Projets liés
- [[lancement-formation]]
```
