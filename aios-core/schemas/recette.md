# Schéma — recette personnelle

Fichier : `30-ressources/recettes/<nom>.md`. Une recette est la marche à suivre d'une tâche qui revient, écrite une fois : ce qu'il faut produire, les règles à respecter, les étapes. Elle se lance par sa phrase, listée dans la section « Mes recettes » d'`AGENTS.md`.

En-tête YAML **plat** :

| Champ | Obligatoire | Valeurs |
|---|---|---|
| `type` | oui | `recette` |
| `declencheur` | oui | la phrase qui lance la recette, entre guillemets si besoin |
| `cree` | oui | date `AAAA-MM-JJ` |
| `domaine` | non | nom d'un dossier de `20-domaines/` |

Corps, dans cet ordre : un titre `# <Titre de la recette>`, puis `## Objectif` (le résultat attendu, en deux lignes), `## Règles` (exigences de qualité, priorités), `## Étapes` (numérotées), `## Ce que tu ne fais jamais`.

Une recette ne passe jamais au-dessus de la section « Sécurité » d'`AGENTS.md` : rien n'est envoyé, publié, supprimé ou modifié sans validation.

**Noms réservés.** Une recette ne peut pas porter le nom d'une commande de l'AIOS : `bilan`, `brief`, `capture`, `creer-recette`, `demarrer`, `etat-projet`, `importer`, `lire`, `mettre-a-jour`.

## Exemple

```markdown
---
type: recette
declencheur: "fais le compte rendu du rendez-vous"
cree: 2026-11-14
domaine: clients
---
# Compte rendu d'un rendez-vous client

## Objectif
Un compte rendu d'une page, prêt à relire, que je peux envoyer au client le jour même.

## Règles
- Une page au plus, dans mon style : voir [[ma-voix]].
- Les décisions d'abord, les détails ensuite.
- Chaque action a un responsable et une date.

## Étapes
1. Demande-moi mes notes du rendez-vous, ou lis celles que je viens de coller.
2. Trouve la fiche du projet concerné dans `10-projets/` et lis son objectif et ses dernières décisions.
3. Rédige le compte rendu : contexte en deux lignes, décisions, actions, prochaine date.
4. Montre-moi le brouillon et corrige-le jusqu'à mon accord.
5. Range les décisions et les actions dans la fiche du projet.

## Ce que tu ne fais jamais
- Envoyer le compte rendu au client sans ma validation.
- Inventer une décision ou une date qui n'est pas dans mes notes.
```
