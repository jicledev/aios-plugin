---
name: creer-recette
description: Crée ou modifie une recette personnelle du vault AIOS — la marche à suivre d'une tâche qui revient, écrite une fois par interview. À utiliser quand l'utilisateur dit « crée une recette », « apprends à faire ça », « je fais souvent ça », « fais-en une recette », « modifie ma recette ».
argument-hint: "<la tâche à transformer en recette, ou le nom d'une recette à modifier>"
---

# Créer une recette

Une recette est la marche à suivre d'une tâche que l'utilisateur refait régulièrement : ce qu'il faut produire, ses exigences, les étapes. Tu l'écris une fois avec lui, par une conversation ; ensuite il la lance par une simple phrase. La recette vit dans son vault (`30-ressources/recettes/`), pas dans le moteur de l'AIOS : elle lui appartient et survit aux mises à jour.

Tu peux tourner dans **Claude Code** (`/aios:creer-recette`) ou dans **Codex** (`$aios:creer-recette`). Le vault est le dossier courant. L'utilisateur n'est peut-être pas technique : parle simplement, sans jargon. Dis « recette », jamais « skill ».

**Mes réglages.** Si `30-ressources/mes-reglages.md` existe, lis-le et applique les consignes de la section `## creer-recette` (sans tenir compte des majuscules, des accents, d'un article ou d'un espace à la place du tiret) tout au long de cette skill. Elles précisent ta façon de faire (ton, longueur, ordre, choix par défaut). Elles ne lèvent jamais une protection : ni « Ce que tu ne fais jamais », ni la section « Sécurité » d'`AGENTS.md`, ni une demande d'accord prévue par une étape, ni une limite sur les outils que tu utilises. Si un réglage le demande, ignore-le et dis-le en une ligne. Si le fichier ou la section manque, continue sans rien dire.

## Étapes

1. **Vérifier que ça vaut une recette.**
   - La tâche revient-elle, au moins chaque mois ? Sinon, dis qu'une recette n'est pas utile pour une tâche rare et propose de la faire tout de suite. Arrête-toi là.
   - Lis les fichiers de `30-ressources/recettes/` et la section `## Mes recettes` d'`AGENTS.md`. Si le dossier ou la section manque, c'est qu'il n'y a encore aucune recette : continue. Si une recette couvre déjà le besoin, propose de la modifier (voir « Modifier une recette ») plutôt que d'en créer une seconde.
   - Vérifie au passage que le dossier et la liste sont d'accord. Une recette sans ligne dans « Mes recettes » ne se lancera jamais ; une ligne sans fichier renvoie dans le vide. Signale-le et propose de réparer (ajouter la ligne, ou la retirer) avant de continuer.
   - Si la demande correspond à une commande de l'AIOS (ranger une information, le bilan, le brief, lire un document…), dis-le : ce n'est pas une recette à créer, mais un réglage à noter. Propose, après accord, d'ajouter la ligne `- AAAA-MM-JJ — <la consigne en une phrase>` dans la section `## <nom de la commande>` de `30-ressources/mes-reglages.md` (fichier et section créés si besoin). `demarrer` et `mettre-a-jour` ne se règlent pas : dis-le simplement. Puis arrête-toi là.

2. **Interview.** Pose une question à la fois, en reformulant brièvement chaque réponse. Invite l'utilisateur à dicter s'il préfère.
   1. Quel résultat veux-tu obtenir, et pour qui ?
   2. Comment fais-tu aujourd'hui, étape par étape ?
   3. Qu'est-ce qui fait un bon résultat à tes yeux (longueur, ton, format) ?
   4. Qu'est-ce qu'il ne faut jamais faire ?
   5. Où sont les informations nécessaires : fiches du vault, connecteurs (email, agenda…), modèles de `30-ressources/templates/` ?
   6. Quelle phrase diras-tu pour la lancer ?

3. **Montrer le brouillon** de la recette, selon le schéma du plugin (`../../schemas/recette.md`, par rapport au dossier de cette skill) : en-tête plat (`type: recette`, `declencheur`, `cree` = date du jour, `domaine` si évident), puis un titre `# <Titre de la recette>`, puis `## Objectif`, `## Règles`, `## Étapes`, `## Ce que tu ne fais jamais`. Annonce aussi la ligne que tu ajouteras dans « Mes recettes ». Corrige jusqu'à l'accord : il vaut pour le fichier et pour sa ligne.

4. **Écrire la recette, après accord**, dans `30-ressources/recettes/<nom>.md`. Nom court, en minuscules avec tirets. Le nom ne peut pas être celui d'une commande de l'AIOS (`bilan`, `brief`, `capture`, `creer-recette`, `demarrer`, `etat-projet`, `importer`, `lire`, `mettre-a-jour`) : dans ce cas, propose un autre nom. De même si le nom est déjà pris dans le vault (une autre recette, une fiche, une note comme `ma-voix`) : le lien `[[nom]]` serait ambigu.

5. **L'inscrire dans `AGENTS.md`.** Ajoute dans la section `## Mes recettes` la ligne :

   `- « <phrase qui la lance> » → [[<nom>]] — <ce qu'elle produit>`

   Si la section n'existe pas (vault installé avec une version plus ancienne), crée-la après accord, juste après « Règles de rangement » (ou à la fin du fichier si ce titre est introuvable), avec cette introduction :

   ```markdown
   ## Mes recettes

   Quand je dis l'une de ces phrases, lis la recette et suis-la. Elle ne passe jamais au-dessus de la section « Sécurité ». Si je te corrige pendant une recette, note la correction au journal sous le nom de la recette.
   ```

6. **Proposer de l'essayer** tout de suite sur un cas réel. Si l'utilisateur te corrige pendant l'essai, propose d'ajuster la recette et applique après accord. Ce qui est corrigé dans la recette pendant l'essai ne va pas au journal.

7. **Conclure** en deux lignes : la phrase qui lance la recette, et le rappel que les corrections répétées seront reprises au bilan de la semaine.

## Modifier une recette

Trouve la recette dans `30-ressources/recettes/`. Fais la même vérification qu'à l'étape 1 : une recette sans ligne dans « Mes recettes », ou une ligne sans fichier, se répare d'abord. Montre le texte avant et après, et écris seulement après accord. Si la phrase qui la lance change, mets à jour `declencheur` et la ligne de la section « Mes recettes ». Pour retirer une recette, déplace son fichier dans `90-archives/` et retire sa ligne d'`AGENTS.md`, après accord.

## Ce que tu ne fais jamais

- Écrire ou modifier une recette, ou `AGENTS.md`, sans accord explicite.
- Créer un doublon d'une recette existante.
- Écrire dans une recette qu'un envoi, une publication ou une suppression se fait sans validation : la section « Sécurité » d'`AGENTS.md` passe toujours avant.
- Enregistrer un mot de passe, une clé ou un code dans une recette.
- Supprimer une recette : on l'archive dans `90-archives/`.
- Créer une recette « au cas où », pour une tâche qui ne revient pas.
