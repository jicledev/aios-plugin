# Règles d'AGENTS.md — ce qui a changé, version par version

Ce fichier est lu par la commande `demarrer` quand elle est relancée sur un vault déjà installé. Il lui permet de proposer les règles qui manquent à l'`AGENTS.md` du vault, sans deviner.

- **Règles ajoutées** : à proposer si le vault ne les a pas. Leur texte exact est dans `template/AGENTS.md`.
- **Phrases remplacées** : une phrase du vault identique à un « Ancien » peut être remplacée par le « Nouveau ». Toute autre phrase qui diffère du template appartient à l'utilisateur : on n'y touche pas.

Les versions sont listées de la plus récente à la plus ancienne.

## 0.8.0

**Règles ajoutées**
- Aucune.

**Phrases remplacées**
- Ancien : `**Rien n'est envoyé, publié, programmé ou supprimé à l'extérieur sans ma validation explicite**, à chaque fois. Les brouillons sont libres.`
  Nouveau : `**Rien n'est envoyé, publié, programmé, supprimé ou modifié à l'extérieur sans ma validation explicite**, à chaque fois. Créer un brouillon ou une nouvelle page reste libre.`
  Note : le garde-fou retient désormais aussi les modifications d'une donnée existante hors du vault.

## 0.7.0

**Règles ajoutées**
- Section « Sources de vérité », en tête de liste : la puce « **Cherche d'abord, réponds ensuite.** ». Elle fait chercher dans le vault avant de répondre à une question sur un projet, un prix, une date ou une décision.
- Nouvelle section « Fin de session », à la fin du fichier. Elle fait proposer, quand la conversation se termine, de ranger les décisions et les actions qui ne sont pas encore dans le vault.

**Phrases remplacées**
- Ancien : `Pour lister les projets, lire les en-têtes des `10-projets/*/README.md` (pas d'index tenu à la main).`
  Nouveau : `La liste ci-dessous est un raccourci : en cas de doute, les en-têtes des `10-projets/*/README.md` font foi.`
  Note : à proposer seulement si le vault a encore la liste « Projets actifs ».

## 0.6.0

**Règles ajoutées**
- Nouvelle section « Mes recettes », entre « Règles de rangement » et « Conventions » : sa phrase d'introduction. Elle fait lancer une recette personnelle par sa phrase. Les lignes de recettes, elles, appartiennent à l'utilisateur.

**Phrases remplacées**
- Ancien : ``| `30-ressources/` | Réutilisable : `ma-voix.md`, `templates/`, `references/`. |``
  Nouveau : ``| `30-ressources/` | Réutilisable : `ma-voix.md`, `mes-reglages.md`, `recettes/`, `templates/`, `references/`. |``
- Ancien : `<skill concernée ou "général">`
  Nouveau : `<skill ou recette concernée, ou "général">`
- Ancien : `Le bilan hebdomadaire s'en sert pour améliorer les skills et ce fichier.`
  Nouveau : `Le bilan hebdomadaire s'en sert pour améliorer mes réglages, mes recettes et ce fichier.`

## 0.5.0

**Règles ajoutées**
- Tableau « Où trouver quoi » : la ligne « Google Drive › `AIOS/` » (les documents déposés et les originaux, hors du vault).
- Section « Sources de vérité » : la puce « **Documents** » (les originaux vivent dans Google Drive, leurs fiches de lecture dans le vault).

**Phrases remplacées**
- Aucune.

## 0.4.0

**Règles ajoutées**
- Aucune.

**Phrases remplacées**
- Ancien : `- Tout ce que Claude lit est envoyé au fournisseur du modèle : les informations très sensibles restent dans `prive-local/` (non sauvegardé) ou hors du vault.`
  Nouveau : `- Tout ce que l'IA lit (Claude, Codex…) est envoyé au fournisseur du modèle : les informations très sensibles restent dans `prive-local/` (non sauvegardé) ou hors du vault.`
