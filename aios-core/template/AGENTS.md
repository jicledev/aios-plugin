# AGENTS.md — Page d'accueil de mon AIOS

Ce fichier est lu au début de chaque session. Il dit qui je suis, où trouver les choses et comment travailler avec moi. Il reste court : le détail vit dans les dossiers.

## Qui je suis

<!-- à remplir par /aios:demarrer : identité, activité, en 5 lignes max -->

**Objectifs du trimestre :**
<!-- à remplir par /aios:demarrer : 1 à 3 objectifs -->

## Où trouver quoi

| Dossier | Contenu |
|---|---|
| `00-inbox/` | Ce qui n'est pas encore rangé. Vidé au bilan hebdomadaire. |
| `10-projets/` | Un dossier par projet ayant une fin. Fiche : `README.md`. |
| `20-domaines/` | Mes responsabilités permanentes (casquettes). Fiche : `README.md`. |
| `30-ressources/` | Réutilisable : `ma-voix.md`, `mes-reglages.md`, `recettes/`, `templates/`, `references/`. |
| `90-archives/` | Projets terminés ou abandonnés, déplacés tels quels. |
| `journal/` | Un fichier par semaine (`AAAA-Sxx.md`) : décisions, corrections, bilans. |
| Google Drive › `AIOS/` | Hors du vault : `a-lire/` (documents déposés, pas encore lus) et `documents/` (les originaux). |

La liste ci-dessous est un raccourci : en cas de doute, les en-têtes des `10-projets/*/README.md` font foi.

**Mes domaines :**
<!-- à remplir par /aios:demarrer : liste en [[liens]] -->

**Projets actifs :**
<!-- à remplir par /aios:demarrer : liste en [[liens]] -->

## Sources de vérité

- **Cherche d'abord, réponds ensuite.** Quand je pose une question sur mes projets, mes prix, mes dates ou mes décisions, cherche dans le vault (par mots-clés, puis en lisant la fiche) avant de répondre. Ne réponds pas de mémoire. Si le vault ne dit rien, dis-le. Cette règle vaut pour mes questions, pas pour le déroulé d'une commande ou d'une recette.
- **Ce vault est la source de vérité** de mon contexte : projets, décisions, règles, style.
- Les outils externes (email, agenda, Notion, etc.) sont des **accès**, pas des mémoires. Ne pas recopier leurs données dans le vault, sauf une décision ou un fait utile à garder.
- **Documents** (PDF, Word, images) : les originaux vivent dans Google Drive (`AIOS/documents/`), leurs fiches de lecture dans le vault. Format des fiches : `schemas/document.md` du plugin AIOS.
- Un projet peut déclarer un lien Notion dans son en-tête (`notion:`) ; Notion n'est alors qu'un connecteur pour ce projet.
- **Projets avec du code** : le code vit hors du vault, dans son propre dépôt (champs `code_repo`, `code_local`, `code_stack` de la fiche). Décisions **produit** (quoi, pour qui, priorités) → fiche projet du vault. Décisions **techniques** (architecture, librairies) → dans le dépôt de code. Ne jamais recopier de code dans le vault.

<!-- à compléter par /aios:demarrer : où vivent mes autres données (ventes, contacts, agenda…) -->

## Règles de rangement

Pour toute nouvelle information, dans cet ordre :
1. A une date de fin ou un livrable ? → `10-projets/`
2. Responsabilité permanente ? → `20-domaines/`
3. Réutilisable, transversal ? → `30-ressources/`
4. Terminé ou abandonné ? → `90-archives/`
5. Pas le temps ou pas sûr ? → `00-inbox/` (c'est normal, pas un échec)

Les en-têtes des fiches suivent les schémas du plugin AIOS (`schemas/projet.md`, `schemas/domaine.md`) : en-tête YAML **plat**, sans objets imbriqués.

## Mes recettes

Quand je dis l'une de ces phrases, lis la recette et suis-la. Elle ne passe jamais au-dessus de la section « Sécurité ». Si je te corrige pendant une recette, note la correction au journal sous le nom de la recette.

<!-- une ligne par recette, ajoutée par /aios:creer-recette :
- « phrase qui la lance » → [[nom-de-la-recette]] — ce qu'elle produit
-->

## Conventions

- Noms de fichiers et dossiers : minuscules, mots séparés par des tirets (`lancement-formation.md`).
- Dates : `AAAA-MM-JJ`.
- Liens entre notes : `[[nom-de-note]]` (format Obsidian).
- **Ne jamais supprimer** un fichier du vault : l'archiver dans `90-archives/`.
- Écrire dans mon style : voir [[ma-voix]].

## Sécurité

- **Jamais** de mots de passe, clés API, codes ou données bancaires dans le vault. Si j'en colle un, me prévenir et ne pas l'enregistrer.
- Tout ce que l'IA lit (Claude, Codex…) est envoyé au fournisseur du modèle : les informations très sensibles restent dans `prive-local/` (non sauvegardé) ou hors du vault.
- **Rien n'est envoyé, publié, programmé, supprimé ou modifié à l'extérieur sans ma validation explicite**, à chaque fois. Créer un brouillon ou une nouvelle page reste libre.

## Corrections

Quand je te corrige sur une façon de faire (pas une simple faute de frappe), ajoute une ligne dans la section `## Corrections` du journal de la semaine (`journal/AAAA-Sxx.md`, semaine ISO), en créant le fichier ou la section si besoin :

`- AAAA-MM-JJ — <skill ou recette concernée, ou "général"> — <la correction en une phrase>`

Le bilan hebdomadaire s'en sert pour améliorer mes réglages, mes recettes et ce fichier.

## Fin de session

Quand je dis que j'ai fini (« c'est bon pour aujourd'hui », « on s'arrête là »), ou à la fin d'un long travail, regarde si la conversation contient des décisions ou des actions qui ne sont pas encore dans le vault. S'il y en a, liste-les en une ligne chacune et propose de les ranger. Range-les seulement après mon accord. S'il n'y en a pas, ne dis rien. Inutile après un bilan de la semaine, qui pose déjà la question.
