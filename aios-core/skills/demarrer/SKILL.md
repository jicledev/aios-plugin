---
name: demarrer
description: Installe et personnalise un vault AIOS. À utiliser au premier lancement dans un dossier vide, ou quand l'utilisateur dit « démarrer », « mettre à jour mon AGENTS.md », « refaire mon profil » ou « changer l'heure de mon brief ».
argument-hint: "(aucun)"
---

# Démarrer l'AIOS

Tu installes le vault AIOS de l'utilisateur dans le dossier courant, puis tu le personnalises par une conversation. L'utilisateur n'est peut-être pas technique : parle simplement, une question à la fois, sans jargon (pas de « YAML », « commit », « hook » sauf s'il les emploie).

Tu peux tourner dans **Claude Code** ou dans **Codex** (l'app ChatGPT). Tu es dans Codex si la variable d'environnement `CODEX_SHELL` vaut `1` ou si tes outils viennent de Codex. Sinon, tu es dans Claude Code. Les commandes s'écrivent `/aios:…` dans Claude Code et `$aios:…` dans Codex : donne toujours la forme qui correspond à l'outil de l'utilisateur.

**Lancer un script du plugin dans Codex.** Codex exécute les commandes avec PowerShell, où `bash` désigne Linux (WSL), pas le Bash de Git. Trouve d'abord le Bash de Git, puis lance le script avec lui :
```powershell
$c = @(); $e = git --exec-path; if ($e) { $c += Split-Path (Split-Path (Split-Path $e)) }; $c += Join-Path $env:ProgramFiles 'Git'; $c += Join-Path $env:LOCALAPPDATA 'Programs\Git'
$b = $c | Where-Object { $_ } | ForEach-Object { Join-Path $_ 'bin\bash.exe' } | Where-Object { Test-Path $_ } | Select-Object -First 1
& $b "<chemin du script>" "<arguments>"
```

## Étapes

1. **Vérifier le dossier.**
   - Le vault est **toujours** le dossier de la session (le dossier courant). Les protections et la sauvegarde automatique ne fonctionnent que dans une session ouverte *dans* le vault.
   - Si l'utilisateur veut son vault ailleurs (il cite un autre dossier, ou le dossier courant est un projet de code, un dépôt existant, son dossier personnel…), ne pose rien. Explique simplement : « Pour que l'AIOS fonctionne, il faut rouvrir une session (Claude Code) ou une conversation (Codex) dans le dossier du vault, puis relancer `/aios:demarrer` (ou `$aios:demarrer` dans Codex). » Propose de créer le dossier vide s'il n'existe pas, puis arrête-toi là.
   - **Dans Codex**, vérifie aussi Git : lance `git --version`. S'il manque, explique que l'AIOS a besoin d'un petit outil gratuit, Git for Windows (https://git-scm.com/download/win, options par défaut), puis de fermer et rouvrir l'app et de relancer `$aios:demarrer`. Arrête-toi là.
   - Si le dossier courant contient déjà `.aios-vault`, c'est une mise à jour : l'étape 2 ajoutera seulement ce qui manque, puis à l'étape 3 ne demande que ce qui a changé. Un vault installé avec Claude et ouvert pour la première fois dans Codex (ou l'inverse) est aussi une mise à jour : seules les étapes 6, 7 et 9 ont du nouveau à proposer. Après une mise à jour du moteur de l'AIOS, l'étape 6 (Documents) peut aussi être nouvelle.
   - S'il est vide, continue.
   - S'il contient d'autres fichiers sans `.aios-vault`, dis ce que tu vois et demande confirmation avant de continuer (rien ne sera écrasé, mais le dossier deviendra un vault).

2. **Poser la structure.** Lance le script fourni par le plugin, situé à `../../scripts/poser-structure.sh` par rapport au dossier de cette skill :
   - **Dans Claude Code :**
     ```bash
     bash "<dossier de cette skill>/../../scripts/poser-structure.sh" "<dossier courant>"
     ```
   - **Dans Codex :** avec le Bash de Git, comme expliqué plus haut : `& $b "<dossier de cette skill>/../../scripts/poser-structure.sh" "<dossier courant>"`.

   Il ne remplace jamais un fichier existant. Résume en une phrase ce qui a été créé.

3. **Interview.** Une question à la fois, en reformulant brièvement chaque réponse :
   1. Qui es-tu et quelle est ton activité ?
   2. Tes 1 à 3 objectifs pour ce trimestre ?
   3. Tes responsabilités permanentes (tes « casquettes ») ? → futurs domaines.
   4. Tes projets en cours, avec une échéance si elle existe ? Pour chacun : y a-t-il du code ? Si oui, l'adresse GitHub et le dossier local.
   5. Où vivent tes autres données (ventes, contacts, agenda, documents partagés) ?
   6. Comment écris-tu ? Demande 1 ou 2 textes que l'utilisateur aime, ou propose de le faire plus tard.

4. **Écrire le contexte, après validation.**
   - Montre le brouillon des sections personnelles d'`AGENTS.md` (les repères `<!-- à remplir … -->`). Écris seulement après accord, en remplaçant les repères. Ne touche pas aux règles génériques.
   - Crée une fiche par domaine (`20-domaines/<nom>/README.md`) et par projet (`10-projets/<nom>/README.md`) selon les schémas du plugin (`../../schemas/domaine.md`, `../../schemas/projet.md`). En-têtes plats, noms en minuscules avec tirets. Pour un projet avec du code, remplis `code_repo`, `code_local`, `code_stack`.
   - Remplis `30-ressources/ma-voix.md` avec ce que tu as appris (ou laisse les repères si reporté).
   - Liste les domaines et projets en `[[liens]]` dans `AGENTS.md`.

5. **Contenu existant.** Demande : « As-tu du contenu existant à importer (notes, documents, pages Notion) ? » Si oui, enchaîne sur la skill `importer`.

6. **Documents.** Cette étape permet à l'utilisateur de déposer des PDF, des fichiers Word ou des images, que `/aios:lire` (`$aios:lire`) transforme en fiches de lecture.
   1. **L'outil `uv`, à chaque relance.** Lance `uv --version`, même si les documents sont déjà réglés. S'il manque, annonce : « Pour lire tes documents, j'installe un petit outil gratuit (uv), qui fait tourner les programmes de lecture de l'AIOS. Windows va te demander de l'autoriser. » Puis lance :
      ```
      winget install --id astral-sh.uv -e
      ```
      et vérifie avec `uv --version`. Juste après l'installation, la commande reste souvent introuvable dans la session en cours : essaie alors le chemin complet `"$env:LOCALAPPDATA\Microsoft\WinGet\Links\uv.exe" --version` dans Codex, ou `"$LOCALAPPDATA/Microsoft/WinGet/Links/uv.exe" --version` dans Claude Code (puis `.local\bin\uv.exe` dans le dossier personnel), et utilise ce chemin complet à la place de `uv` dans la suite de cette étape. Le chemin `WinGet\Links\uv.exe` n'est utile que jusqu'au prochain redémarrage de l'app.
      **En cas d'échec**, dis-le simplement : « Je n'ai pas pu installer l'outil de lecture. La lecture des PDF et des images marchera quand même dans Claude, mais pas celle des fichiers Word ni la boîte a-lire. Relance `/aios:demarrer` (`$aios:demarrer`) plus tard pour réessayer. » N'écris rien dans `.aios-vault` et passe directement à l'étape 7 : les points suivants demandent l'outil.
   2. **Autorisation (dans Claude Code)**, même si la ligne `documents:` existe déjà (vault créé dans Codex, par exemple) : ajoute `Bash(uv run --script *documents.py*)` au tableau `permissions.allow` de `.claude/settings.json` du vault s'il n'y est pas, sans retirer ce qui y est déjà. Ainsi la lecture des documents ne demande pas une autorisation à chaque fichier.
   3. **Le réglage, seulement si la ligne `documents:` est absente de `.aios-vault`** (sinon il a déjà été fait : passe au point 6). Lance :
      ```
      uv run --script "<dossier de cette skill>/../../outils/documents.py" racine-drive
      ```
      - **Trouvé** (la commande affiche un chemin) : demande « Je vois ton Google Drive. On y range tes documents (les originaux), avec une boîte `a-lire` où tu peux déposer des fichiers depuis ton téléphone ? »
      - **Introuvable** (code 4) : explique que sans Google Drive pour ordinateur, l'AIOS gardera seulement les fiches de lecture, pas les fichiers d'origine.
   4. **Après un « oui »** :
      - ajoute la ligne `documents: drive:AIOS` à `.aios-vault` (sans toucher aux autres lignes) ;
      - lance `uv run --script "<dossier de cette skill>/../../outils/documents.py" dossier "<dossier courant>"`, qui crée `AIOS/a-lire/` et `AIOS/documents/` dans Drive ;
      - explique en deux phrases : « Depuis ton téléphone ou ton navigateur, enregistre un document dans le dossier `AIOS/a-lire` de ton Google Drive. Ensuite, dis-moi « traite mes documents » : j'en fais une fiche et je range l'original dans `AIOS/documents`. »
   5. **Refus, ou Drive introuvable** : ajoute la ligne `documents: aucun` à `.aios-vault`. `/aios:lire` marchera quand même avec un fichier donné directement. Pour changer d'avis plus tard (Drive installé entre-temps), il suffit de retirer cette ligne et de relancer `/aios:demarrer` : propose-le si l'utilisateur en parle.
   6. **Le rappel du bilan.** Si la tâche « Rappel du bilan » existe déjà (`aios-rappel-bilan` dans Claude Code, avec `list_scheduled_tasks`), que Drive est réglé et que sa consigne ne parle pas encore de documents à lire, propose : « Je mets à jour ton rappel du dimanche pour qu'il compte aussi tes documents à lire ? » Après accord, dans Claude Code, modifie seulement son `prompt` avec `update_scheduled_task`, en reprenant la consigne de l'étape 9 (le garde-fou demandera ton accord, c'est normal). Dans Codex, guide l'utilisateur pour modifier la consigne dans la vue des tâches programmées. Sans accord, n'y touche pas.

7. **Verrouiller les connecteurs.**
   - Parcours la liste des outils MCP (`mcp__…`) disponibles dans cette session. Retiens ceux que le garde-fou du plugin juge sensibles, avec la même règle que `../../scripts/garde.sh` (lis-le) : dans la partie du nom après le dernier `__`, découpée en mots (camelCase, `_`, `-`, `.`), un mot de `VERBES_SENSIBLES`, ou, à défaut, l'un des mots de `SOUS_CHAINES` collé à d'autres (ex. `sendemail`).
   - **Dans Claude Code :**
     - Montre la liste à l'utilisateur, groupée par connecteur, et explique : « Pour ces actions, je te demanderai toujours ton accord, même en mode automatique. »
     - Après accord, ajoute leurs noms exacts (`mcp__<serveur>__<outil>`) au tableau `permissions.ask` de `.claude/settings.json` du vault, sans retirer ce qui y est déjà.
     - Exception : dans le serveur `scheduled-tasks` (les tâches programmées de l'app de bureau), `create_scheduled_task` et les outils `list_…` ne sont pas sensibles. Ils créent ou listent des tâches sur cet ordinateur sans rien envoyer, et le garde-fou les laisse passer. Ne les ajoute pas à `permissions.ask`. Modifier, supprimer ou lancer une tâche existante reste sensible.
     - Si aucun connecteur n'est branché, dis-le : le garde-fou du plugin protégera les connecteurs ajoutés plus tard, et relancer `/aios:demarrer` complétera la liste.
   - **Dans Codex :**
     - **Vérifie d'abord que les protections tournent.** Lis `.git/aios-sauvegarde.log` : la sauvegarde y écrit une ligne datée à la fin de chacune de tes réponses, et le garde-fou est approuvé en même temps qu'elle. S'il n'existe pas ou n'a aucune ligne d'aujourd'hui, n'annonce aucune protection : demande à l'utilisateur de cliquer sur l'icône d'**ancre** avec un point jaune (en bas de la zone de message) et d'approuver les deux hooks de l'AIOS, puis d'ouvrir une nouvelle conversation et de relancer `$aios:demarrer`. Arrête-toi là.
     - N'écris aucun réglage. Codex ne sait pas demander ton accord pour ces actions : le garde-fou les bloque toutes, même si l'utilisateur confirme. Montre la liste groupée par connecteur et explique : « Dans Codex, ces actions sont bloquées par sécurité : je ne peux ni envoyer, ni publier, ni supprimer à ta place. Je peux en revanche préparer un brouillon ; tu l'envoies toi-même depuis l'app concernée (Gmail…), ou tu me le demandes depuis Claude. » Les connecteurs branchés plus tard sont bloqués de la même façon, sans rien à refaire.

8. **Sauvegarde.**
   - Si `git config user.name` ou `user.email` est vide dans le vault, demande un nom et un email (ou l'adresse « noreply » GitHub) et configure-les **localement** (`git config user.name …` sans `--global`).
   - Enregistre l'état actuel : `git add -A`, puis, seulement s'il y a des changements (`git diff --cached --quiet` échoue), `git commit -m "AIOS : installation du vault"` (ou `"AIOS : mise à jour du profil"` lors d'une relance).
   - Propose une sauvegarde en ligne sur GitHub, dans un dépôt **privé**. Seulement après un « oui » explicite, vérifie `gh auth status` :
     - **GitHub est connecté** :
       ```bash
       gh repo create <nom-choisi> --private --source . --remote origin --push
       ```
     - **`gh` est absent ou pas connecté** : ne fais taper aucune commande à l'utilisateur, et ne l'envoie pas dans un terminal. Dis-lui : « La sauvegarde en ligne demande une connexion à GitHub qu'on fera plus tard, avec de l'aide si besoin. En attendant, la sauvegarde locale continue : chaque modification est enregistrée sur ton ordinateur. » Puis passe à l'étape suivante.

9. **Brief du matin et rappel du bilan.**
   - **Les tâches existent-elles déjà dans cette app ?**
     - **Dans Claude Code :** cherche l'outil `create_scheduled_task` (serveur `scheduled-tasks`) parmi les outils de la session ; il faut parfois le charger. S'il n'existe pas, dis : « Les rappels automatiques demandent l'app de bureau Claude. Tu peux lancer `/aios:brief` à la main quand tu veux. » Puis passe à l'étape suivante. Sinon, appelle `list_scheduled_tasks` et cherche `aios-brief-du-matin` et `aios-rappel-bilan`.
     - **Dans Codex :** regarde dans la vue des tâches programmées (ou avec l'outil de liste des tâches de l'app, s'il existe) si des tâches « Brief du matin » et « Rappel du bilan » existent pour ce projet.
     - **Si elles existent** : donne leurs horaires actuels en clair (par exemple « brief du lundi au vendredi à 8 h 30, rappel le dimanche à 18 h ») et demande si l'utilisateur veut les changer. S'il veut changer, pose les questions d'horaires ci-dessous pour la tâche concernée et modifie-la (dans Claude Code, avec `update_scheduled_task`, son `cronExpression` seulement ; le garde-fou demandera son accord, c'est normal). Ne crée jamais un doublon. Puis va au point des autorisations.
   - **Une seule app** : si aucune tâche n'existe ici, demande « Utilises-tu aussi l'autre app (Claude ou Codex), avec un brief déjà programmé là-bas ? ». Indice : si la première ligne de `brief.md` date d'aujourd'hui ou d'hier, un brief tourne déjà ailleurs ; mentionne-le. Si oui, ne programme rien ici : dis que le brief reste là où il est, et que `/aios:brief` (ou `$aios:brief`) reste utilisable à la main. Passe à l'étape suivante.
   - Demande : « Veux-tu recevoir un brief du matin (tes priorités, tes rendez-vous, tes projets en retard) et un rappel pour faire ton bilan de la semaine ? » Si c'est non, passe à l'étape suivante.
   - Après un « oui », pose les questions d'horaires, une à la fois, en donnant à chaque fois la valeur par défaut :
     - « À quelle heure veux-tu ton brief ? (8 h par défaut) »
     - « Quels jours ? (du lundi au vendredi par défaut) »
     - « À quel moment veux-tu le rappel du bilan ? (le dimanche à 18 h par défaut) »
     - Si l'utilisateur ne sait pas ou dit « comme tu veux », prends la valeur par défaut. Répète ensuite les horaires retenus en une phrase et attends sa confirmation.
   - **Dans Claude Code :**
     - Traduis les horaires en expression cron, en heure locale : `<minute> <heure> * * <jours>`, avec les jours de 0 (dimanche) à 6 (samedi). Exemples : 8 h du lundi au vendredi = `0 8 * * 1-5` (par défaut pour le brief) ; 7 h 45 tous les jours = `45 7 * * *` ; dimanche 18 h = `0 18 * * 0` (par défaut pour le rappel).
     - **Consigne du rappel et documents.** Si Drive est réglé (`documents: drive:AIOS`), remplace dans la consigne du rappel ci-dessous la phrase « compte les fichiers de `00-inbox/` (…), puis affiche uniquement : « C'est l'heure de ton bilan de la semaine (N éléments dans l'inbox). » » par : « compte les fichiers de `00-inbox/` (sous-dossiers compris, sans les fichiers cachés), puis ceux du dossier `<dossier a-lire>` (sans les fichiers cachés ni `desktop.ini`), puis affiche uniquement : « C'est l'heure de ton bilan de la semaine (N éléments dans l'inbox, M documents à lire). » », où `<dossier a-lire>` est le chemin absolu de `AIOS/a-lire` affiché par la commande `dossier` de l'étape 6, suivi de `\a-lire`. Fais de même dans Codex.
     - Crée les tâches manquantes avec `create_scheduled_task`, en remplaçant `<chemin du vault>` par le chemin absolu du dossier courant et `<jour et heure>` par le moment choisi pour le rappel (par exemple « dimanche 18 h ») :
       - `taskId: aios-brief-du-matin`, `title: Brief du matin`, `description: Brief du matin du vault AIOS`, `cronExpression` : celle du brief, `prompt` : « Tu es dans le vault AIOS `<chemin du vault>`. Si le dossier courant n'est pas ce vault, dis-le et arrête-toi. Sinon, lance `/aios:brief`. »
       - `taskId: aios-rappel-bilan`, `title: Rappel du bilan`, `description: Rappel du bilan hebdomadaire du vault AIOS (<jour et heure>)`, `cronExpression` : celle du rappel, `prompt` : « Tu es dans le vault AIOS `<chemin du vault>`. Si le dossier courant n'est pas ce vault, dis-le et arrête-toi. Sinon, compte les fichiers de `00-inbox/` (sous-dossiers compris, sans les fichiers cachés), puis affiche uniquement : « C'est l'heure de ton bilan de la semaine (N éléments dans l'inbox). Tape `/aios:bilan` quand tu veux. » Ne modifie rien. »
     - **Autorisations**, à faire dès que les tâches existent, même si les tâches existent déjà (un agenda a pu être branché depuis). Pour que le brief n'attende pas d'autorisation, ajoute au tableau `permissions.allow` de `.claude/settings.json` du vault, sans retirer ce qui y est déjà, **uniquement** :
       - `Edit(./brief.md)`, l'écriture du fichier du brief ;
       - les outils de **lecture** de l'agenda présents dans la session : ceux d'un connecteur d'agenda dont le nom commence par `list_`, `get_` ou `search_` (par exemple `mcp__<serveur>__list_events`). Jamais un outil qui crée, modifie, supprime ou répond.
     - Explique : les tâches ne tournent que quand l'app de bureau Claude est ouverte. Si l'ordinateur était éteint à l'heure prévue, elles partent au prochain lancement. Elles apparaissent dans la barre latérale, section des tâches programmées.
   - **Dans Codex :**
     - Crée, avec l'outil de tâches programmées de l'app (ou en guidant l'utilisateur dans la vue des tâches programmées si tu ne peux pas le faire), deux tâches **récurrentes sur ce projet** (le vault), aux horaires choisis, en heure locale :
       - « Brief du matin » : consigne « Tu es dans le vault AIOS `<chemin du vault>`. Si le dossier courant n'est pas ce vault, dis-le et arrête-toi. Sinon, lance `$aios:brief`. »
       - « Rappel du bilan » : consigne « Tu es dans le vault AIOS `<chemin du vault>`. Si le dossier courant n'est pas ce vault, dis-le et arrête-toi. Sinon, compte les fichiers de `00-inbox/` (sous-dossiers compris, sans les fichiers cachés), puis affiche uniquement : « C'est l'heure de ton bilan de la semaine (N éléments dans l'inbox). Tape `$aios:bilan` quand tu veux. » Ne modifie rien. »
     - Si l'app te demande de confirmer la création, explique à l'utilisateur qu'il doit la valider.
     - Explique : les tâches ne tournent que quand l'app est ouverte et l'ordinateur allumé. Elles ne peuvent rien envoyer ni supprimer : le garde-fou les bloque.

10. **Obsidian.** Explique que le dossier peut s'ouvrir dans Obsidian (« Ouvrir un dossier comme coffre ») pour lire et naviguer.

11. **Conclure** en trois lignes : ce qui est en place, les commandes utiles (`/aios:brief`, `/aios:capture`, `/aios:bilan`, `/aios:etat-projet`, `/aios:importer`, `/aios:lire`, `/aios:creer-recette` dans Claude Code ; `$aios:brief`, `$aios:capture`, `$aios:bilan`, `$aios:etat-projet`, `$aios:importer`, `$aios:lire`, `$aios:creer-recette` dans Codex), et le conseil de faire un bilan chaque semaine.

## Ce que tu ne fais jamais

- Installer le vault dans un autre dossier que le dossier de la session.
- Écraser ou vider un fichier existant.
- Remplir `AGENTS.md` avec des suppositions que l'utilisateur n'a pas validées.
- Créer un dépôt **public**, ou créer un dépôt / pousser sans accord explicite.
- Modifier la configuration Git globale de l'utilisateur.
- Écrire dans la configuration globale de Codex (dans le dossier personnel de l'utilisateur).
- Programmer le brief dans les deux apps à la fois.
- Lancer un script du plugin avec `bash` tout court dans Codex.
- Enregistrer un mot de passe, une clé ou un code dans le vault.
