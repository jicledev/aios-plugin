---
name: demarrer
description: Installe et personnalise un vault AIOS. À utiliser au premier lancement dans un dossier vide, ou quand l'utilisateur dit « démarrer », « mettre à jour mon AGENTS.md » ou « refaire mon profil ».
argument-hint: "(aucun)"
---

# Démarrer l'AIOS

Tu installes le vault AIOS de l'utilisateur dans le dossier courant, puis tu le personnalises par une conversation. L'utilisateur n'est peut-être pas technique : parle simplement, une question à la fois, sans jargon (pas de « YAML », « commit », « hook » sauf s'il les emploie).

## Étapes

1. **Vérifier le dossier.**
   - Le vault est **toujours** le dossier de la session (le dossier courant dans lequel Claude Code a été ouvert). Les protections et la sauvegarde automatique ne fonctionnent que dans une session ouverte *dans* le vault.
   - Si l'utilisateur veut son vault ailleurs (il cite un autre dossier, ou le dossier courant est un projet de code, un dépôt existant, son dossier personnel…), ne pose rien. Explique simplement : « Pour que l'AIOS fonctionne, il faut rouvrir une session Claude Code dans le dossier du vault, puis relancer `/aios:demarrer`. » Propose de créer le dossier vide s'il n'existe pas, puis arrête-toi là.
   - Si le dossier courant contient déjà `.aios-vault`, c'est une mise à jour : l'étape 2 ajoutera seulement ce qui manque, puis à l'étape 3 ne demande que ce qui a changé.
   - S'il est vide, continue.
   - S'il contient d'autres fichiers sans `.aios-vault`, dis ce que tu vois et demande confirmation avant de continuer (rien ne sera écrasé, mais le dossier deviendra un vault).

2. **Poser la structure.** Lance le script fourni par le plugin, situé à `../../scripts/poser-structure.sh` par rapport au dossier de cette skill :
   ```bash
   bash "<dossier de cette skill>/../../scripts/poser-structure.sh" "<dossier courant>"
   ```
   Il ne remplace jamais un fichier existant. Résume en une phrase ce qui a été créé.

3. **Interview.** Une question à la fois, en reformulant brièvement chaque réponse :
   1. Qui es-tu et quelle est ton activité ?
   2. Tes 1 à 3 objectifs pour ce trimestre ?
   3. Tes responsabilités permanentes (tes « casquettes ») ? → futurs domaines.
   4. Tes projets en cours, avec une échéance si elle existe ? Pour chacun : y a-t-il du code ? Si oui, l'adresse GitHub et le dossier local.
   5. Où vivent tes autres données (ventes, contacts, agenda, documents partagés) ?
   6. Comment écris-tu ? Demande 1 ou 2 textes que l'utilisateur aime, ou propose de le faire plus tard.

4. **Écrire le contexte, après validation.**
   - Montre le brouillon des sections personnelles d'`AGENTS.md` (les repères `<!-- à remplir par /aios:demarrer … -->`). Écris seulement après accord, en remplaçant les repères. Ne touche pas aux règles génériques.
   - Crée une fiche par domaine (`20-domaines/<nom>/README.md`) et par projet (`10-projets/<nom>/README.md`) selon les schémas du plugin (`../../schemas/domaine.md`, `../../schemas/projet.md`). En-têtes plats, noms en minuscules avec tirets. Pour un projet avec du code, remplis `code_repo`, `code_local`, `code_stack`.
   - Remplis `30-ressources/ma-voix.md` avec ce que tu as appris (ou laisse les repères si reporté).
   - Liste les domaines et projets en `[[liens]]` dans `AGENTS.md`.

5. **Contenu existant.** Demande : « As-tu du contenu existant à importer (notes, documents, pages Notion) ? » Si oui, enchaîne sur la skill `importer`.

6. **Verrouiller les connecteurs.**
   - Parcours la liste des outils MCP (`mcp__…`) disponibles dans cette session. Retiens ceux que le garde-fou du plugin juge sensibles, avec la même règle que `../../scripts/garde.sh` (lis-le) : dans la partie du nom après le dernier `__`, découpée en mots (camelCase, `_`, `-`, `.`), un mot de `VERBES_SENSIBLES`, ou, à défaut, l'un des mots de `SOUS_CHAINES` collé à d'autres (ex. `sendemail`).
   - Montre la liste à l'utilisateur, groupée par connecteur, et explique : « Pour ces actions, je te demanderai toujours ton accord, même en mode automatique. »
   - Après accord, ajoute leurs noms exacts (`mcp__<serveur>__<outil>`) au tableau `permissions.ask` de `.claude/settings.json` du vault, sans retirer ce qui y est déjà.
   - Exception : dans le serveur `scheduled-tasks` (les tâches programmées de l'app de bureau), `create_scheduled_task` et les outils `list_…` ne sont pas sensibles. Ils créent ou listent des tâches sur cet ordinateur sans rien envoyer, et le garde-fou les laisse passer. Ne les ajoute pas à `permissions.ask`. Modifier, supprimer ou lancer une tâche existante reste sensible.
   - Si aucun connecteur n'est branché, dis-le : le garde-fou du plugin protégera les connecteurs ajoutés plus tard, et relancer `/aios:demarrer` complétera la liste.

7. **Sauvegarde.**
   - Si `git config user.name` ou `user.email` est vide dans le vault, demande un nom et un email (ou l'adresse « noreply » GitHub) et configure-les **localement** (`git config user.name …` sans `--global`).
   - Enregistre l'état actuel : `git add -A`, puis, seulement s'il y a des changements (`git diff --cached --quiet` échoue), `git commit -m "AIOS : installation du vault"` (ou `"AIOS : mise à jour du profil"` lors d'une relance).
   - Propose une sauvegarde en ligne sur GitHub, dans un dépôt **privé**. Seulement après un « oui » explicite, vérifie `gh auth status` :
     - **GitHub est connecté** :
       ```bash
       gh repo create <nom-choisi> --private --source . --remote origin --push
       ```
     - **`gh` est absent ou pas connecté** : ne fais taper aucune commande à l'utilisateur, et ne l'envoie pas dans un terminal. Dis-lui : « La sauvegarde en ligne demande une connexion à GitHub qu'on fera plus tard, avec de l'aide si besoin. En attendant, la sauvegarde locale continue : chaque modification est enregistrée sur ton ordinateur. » Puis passe à l'étape suivante.

8. **Brief du matin et rappel du bilan.**
   - Cherche l'outil `create_scheduled_task` (serveur `scheduled-tasks`) parmi les outils de la session. Il faut parfois le charger. S'il n'existe pas, dis : « Les rappels automatiques demandent l'app de bureau Claude. Tu peux lancer `/aios:brief` à la main quand tu veux. » Puis passe à l'étape suivante.
   - Appelle `list_scheduled_tasks`. Si les tâches `aios-brief-du-matin` et `aios-rappel-bilan` existent déjà, dis-le, ne pose pas la question ci-dessous et va directement au point des autorisations. Ne crée jamais une tâche qui existe déjà.
   - Demande : « Veux-tu recevoir un brief chaque matin de semaine à 8 h (tes priorités, tes rendez-vous, tes projets en retard) et un rappel du bilan le dimanche à 18 h ? »
   - Seulement après un « oui » explicite, crée les tâches manquantes avec `create_scheduled_task`, en remplaçant `<chemin du vault>` par le chemin absolu du dossier courant :
     - `taskId: aios-brief-du-matin`, `title: Brief du matin`, `cronExpression: 0 8 * * 1-5`, `prompt` : « Tu es dans le vault AIOS `<chemin du vault>`. Si le dossier courant n'est pas ce vault, dis-le et arrête-toi. Sinon, lance `/aios:brief`. »
     - `taskId: aios-rappel-bilan`, `title: Rappel du bilan`, `cronExpression: 0 18 * * 0`, `prompt` : « Tu es dans le vault AIOS `<chemin du vault>`. Compte les fichiers de `00-inbox/` (sous-dossiers compris, sans les fichiers cachés), puis affiche uniquement : « C'est dimanche : ton bilan de la semaine t'attend (N éléments dans l'inbox). Tape `/aios:bilan` quand tu veux. » Ne modifie rien. »
   - **Autorisations**, à faire dès que les tâches existent, même si les tâches existent déjà (un agenda a pu être branché depuis). Pour que le brief de 8 h n'attende pas d'autorisation, ajoute au tableau `permissions.allow` de `.claude/settings.json` du vault, sans retirer ce qui y est déjà, **uniquement** :
     - `Edit(./brief.md)`, l'écriture du fichier du brief ;
     - les outils de **lecture** de l'agenda présents dans la session : ceux d'un connecteur d'agenda dont le nom commence par `list_`, `get_` ou `search_` (par exemple `mcp__<serveur>__list_events`). Jamais un outil qui crée, modifie, supprime ou répond.
   - Explique : les tâches ne tournent que quand l'app de bureau Claude est ouverte. Si l'ordinateur était éteint à l'heure prévue, elles partent au prochain lancement. Elles apparaissent dans la barre latérale, section des tâches programmées.

9. **Obsidian.** Explique que le dossier peut s'ouvrir dans Obsidian (« Ouvrir un dossier comme coffre ») pour lire et naviguer.

10. **Conclure** en trois lignes : ce qui est en place, les commandes utiles (`/aios:brief`, `/aios:capture`, `/aios:bilan`, `/aios:etat-projet`, `/aios:importer`), et le conseil de faire un `/aios:bilan` chaque semaine.

## Ce que tu ne fais jamais

- Installer le vault dans un autre dossier que le dossier de la session.
- Écraser ou vider un fichier existant.
- Remplir `AGENTS.md` avec des suppositions que l'utilisateur n'a pas validées.
- Créer un dépôt **public**, ou créer un dépôt / pousser sans accord explicite.
- Modifier la configuration Git globale de l'utilisateur.
- Enregistrer un mot de passe, une clé ou un code dans le vault.
