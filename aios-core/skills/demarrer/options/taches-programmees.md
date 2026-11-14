# Option — tâches programmées : rappel du bilan et brief du matin

**Ce que ça apporte.** Le **rappel du bilan** te fait signe une fois par semaine pour faire le point. Le **brief du matin** t'écrit chaque matin tes priorités du jour, tes rendez-vous et tes projets en retard, sans rien demander.

**Temps.** Deux minutes pour le rappel, trois pour le brief.

Les chemins sont donnés par rapport au dossier de la skill `demarrer`. Le vault est le dossier courant.

**Règle des lignes de `.aios-vault`.** Quand tu écris une décision (`oui`, `non`, `fait`, `aucun`, `drive:AIOS`), elle remplace l'ancienne ligne de la même option, et tu retires sa ligne `-plus-tard` s'il y en a une. Une ligne `-plus-tard` remplace elle aussi l'ancienne ligne de report.

## Quelle partie faire

- **Le rappel seul** (au premier jour de `demarrer`, ou quand l'utilisateur dit « active le rappel du bilan ») : ne fais que la partie « Rappel du bilan », avec la « Mécanique commune ». Ne parle pas du brief.
- **Le brief** (proposé au bilan, ou quand l'utilisateur dit « active le brief ») : ne fais que la partie « Brief du matin », avec la « Mécanique commune ». Si la ligne `rappel:` est absente de `.aios-vault` et que la tâche de rappel n'existe pas, propose aussi le rappel, par sa question. Jamais si la ligne vaut `rappel: non`.
- **« Changer l'heure de mon brief »**, ou une simple relance de `demarrer` sur un vault où `brief: oui` ou `rappel: oui` : ne fais que « À chaque relance ».

## Mécanique commune

- **Les tâches existent-elles déjà dans cette app ?**
  - **Dans Claude Code :** cherche l'outil `create_scheduled_task` (serveur `scheduled-tasks`) parmi les outils de la session ; il faut parfois le charger. S'il n'existe pas, dis : « Les rappels automatiques demandent l'app de bureau Claude. Tu peux lancer `/aios:brief` à la main quand tu veux. » Pour le rappel seul, la fin devient : « Tu peux lancer `/aios:bilan` quand tu veux. » (`$aios:bilan` dans Codex), sans parler du brief. L'option est reportée : écris `brief-plus-tard: AAAA-MM-JJ` (ou `rappel-plus-tard: AAAA-MM-JJ` pour le rappel seul), date du jour, dans `.aios-vault`, sans toucher aux autres lignes, puis arrête-toi là pour cette option. Sinon, appelle `list_scheduled_tasks` et cherche `aios-brief-du-matin` et `aios-rappel-bilan`.
  - **Dans Codex :** regarde dans la vue des tâches programmées (ou avec l'outil de liste des tâches de l'app, s'il existe) si des tâches « Brief du matin » et « Rappel du bilan » existent pour ce projet.
  - **Si la tâche demandée existe** : fais « À chaque relance » pour elle, écris sa ligne (`brief: oui` ou `rappel: oui`) si elle manque, et ne crée jamais un doublon.
- **Une seule app** : si la tâche demandée n'existe pas ici, demande « Utilises-tu aussi l'autre app (Claude ou Codex), avec un brief déjà programmé là-bas ? » (pour le rappel seul : « …avec un rappel déjà programmé là-bas ? », sans parler du brief). Indice, pour le brief : si la première ligne de `brief.md` date d'aujourd'hui ou d'hier, un brief tourne déjà ailleurs ; mentionne-le. Si oui, ne programme rien ici : dis que le brief reste là où il est, et que `/aios:brief` (ou `$aios:brief`) reste utilisable à la main. Écris alors la ligne de la tâche concernée dans `.aios-vault` (`brief: oui`, ou `rappel: oui` pour le rappel seul : elle est en place), sans toucher aux autres lignes, et arrête-toi là. La règle vaut aussi pour le rappel : une tâche ne se programme jamais dans les deux apps à la fois.
- Pose les questions d'horaires une à la fois, en donnant à chaque fois la valeur par défaut. Si l'utilisateur ne sait pas ou dit « comme tu veux », prends la valeur par défaut. Répète ensuite les horaires retenus en une phrase et attends sa confirmation.
- **Dans Claude Code :** traduis les horaires en expression cron, en heure locale : `<minute> <heure> * * <jours>`, avec les jours de 0 (dimanche) à 6 (samedi). Exemples : 8 h du lundi au vendredi = `0 8 * * 1-5` (par défaut pour le brief) ; 7 h 45 tous les jours = `45 7 * * *` ; dimanche 18 h = `0 18 * * 0` (par défaut pour le rappel). Crée la tâche manquante avec `create_scheduled_task`, en remplaçant `<chemin du vault>` par le chemin absolu du dossier courant. Explique : les tâches ne tournent que quand l'app de bureau Claude est ouverte. Si l'ordinateur était éteint à l'heure prévue, elles partent au prochain lancement. Elles apparaissent dans la barre latérale, section des tâches programmées.
- **Dans Codex :** crée, avec l'outil de tâches programmées de l'app (ou en guidant l'utilisateur dans la vue des tâches programmées si tu ne peux pas le faire), une tâche **récurrente sur ce projet** (le vault), à l'horaire choisi, en heure locale. Si l'app te demande de confirmer la création, explique à l'utilisateur qu'il doit la valider. Explique : les tâches ne tournent que quand l'app est ouverte et l'ordinateur allumé. Elles ne peuvent rien envoyer, supprimer ni modifier : le garde-fou les bloque.

## Rappel du bilan

- Si l'utilisateur vient de répondre à cette question (étape 7 de `demarrer`), ne la repose pas. Sinon, demande : « Veux-tu un rappel pour faire ton bilan de la semaine ? (le dimanche à 18 h par défaut) » Si c'est non, écris `rappel: non` dans `.aios-vault`, sans toucher aux autres lignes, et arrête-toi là.
- Après un « oui » : « À quel moment veux-tu le rappel du bilan ? (le dimanche à 18 h par défaut) »
- **Consigne du rappel et documents.** Si Drive est réglé (`documents: drive:AIOS`), remplace dans la consigne du rappel ci-dessous la phrase « compte les fichiers de `00-inbox/` (…), puis affiche uniquement : « C'est l'heure de ton bilan de la semaine (N éléments dans l'inbox). » » par : « compte les fichiers de `00-inbox/` (sous-dossiers compris, sans les fichiers cachés), puis ceux du dossier `<dossier a-lire>` (sans les fichiers cachés ni `desktop.ini`), puis affiche uniquement : « C'est l'heure de ton bilan de la semaine (N éléments dans l'inbox, M documents à lire). » », où `<dossier a-lire>` est le chemin absolu de `AIOS/a-lire` affiché par la commande `dossier` de l'option documents (`documents.md`), suivi de `\a-lire`. Fais de même dans Codex.
- **Dans Claude Code**, la tâche : `taskId: aios-rappel-bilan`, `title: Rappel du bilan`, `description: Rappel du bilan hebdomadaire du vault AIOS (<jour et heure>)`, où `<jour et heure>` est le moment choisi (par exemple « dimanche 18 h »), `cronExpression` : celle du rappel, `prompt` : « Tu es dans le vault AIOS `<chemin du vault>`. Si le dossier courant n'est pas ce vault, dis-le et arrête-toi. Sinon, compte les fichiers de `00-inbox/` (sous-dossiers compris, sans les fichiers cachés), puis affiche uniquement : « C'est l'heure de ton bilan de la semaine (N éléments dans l'inbox). Tape `/aios:bilan` quand tu veux. » Ne modifie rien. »
- **Dans Codex**, la tâche « Rappel du bilan » : consigne « Tu es dans le vault AIOS `<chemin du vault>`. Si le dossier courant n'est pas ce vault, dis-le et arrête-toi. Sinon, compte les fichiers de `00-inbox/` (sous-dossiers compris, sans les fichiers cachés), puis affiche uniquement : « C'est l'heure de ton bilan de la semaine (N éléments dans l'inbox). Tape `$aios:bilan` quand tu veux. » Ne modifie rien. »
- Une fois la tâche créée, écris `rappel: oui` dans `.aios-vault`, sans toucher aux autres lignes, et retire la ligne `rappel-plus-tard:` s'il y en a une.

## Brief du matin

- Demande : « Veux-tu recevoir un brief du matin (tes priorités, tes rendez-vous, tes projets en retard) ? » Si c'est non, écris `brief: non` dans `.aios-vault`, sans toucher aux autres lignes, dis qu'il suffit de dire « active le brief » pour y revenir, et arrête-toi là. Si c'est « plus tard », écris `brief-plus-tard: AAAA-MM-JJ` (date du jour).
- Après un « oui », les questions d'horaires :
  - « À quelle heure veux-tu ton brief ? (8 h par défaut) »
  - « Quels jours ? (du lundi au vendredi par défaut) »
- **Dans Claude Code**, la tâche : `taskId: aios-brief-du-matin`, `title: Brief du matin`, `description: Brief du matin du vault AIOS`, `cronExpression` : celle du brief, `prompt` : « Tu es dans le vault AIOS `<chemin du vault>`. Si le dossier courant n'est pas ce vault, dis-le et arrête-toi. Sinon, lance `/aios:brief`. »
- **Dans Codex**, la tâche « Brief du matin » : consigne « Tu es dans le vault AIOS `<chemin du vault>`. Si le dossier courant n'est pas ce vault, dis-le et arrête-toi. Sinon, lance `$aios:brief`. »
- Fais ensuite les autorisations de « À chaque relance ».
- Une fois la tâche créée, écris `brief: oui` dans `.aios-vault`, sans toucher aux autres lignes, et retire la ligne `brief-plus-tard:` s'il y en a une.

## À chaque relance

- **Cherche d'abord les tâches**, comme au premier point de la « Mécanique commune », sans rien écrire dans `.aios-vault`.
- **Horaires.** Si les tâches existent : donne leurs horaires actuels en clair (par exemple « brief du lundi au vendredi à 8 h 30, rappel le dimanche à 18 h ») et demande si l'utilisateur veut les changer. S'il veut changer, pose les questions d'horaires pour la tâche concernée et modifie-la (dans Claude Code, avec `update_scheduled_task`, son `cronExpression` seulement ; le garde-fou demandera son accord, c'est normal). Ne crée jamais un doublon.
- **Autorisations** (dans Claude Code, pour le brief, seulement si la tâche du brief existe), à faire dès que les tâches existent, même si les tâches existent déjà (un agenda a pu être branché depuis). Pour que le brief n'attende pas d'autorisation, ajoute au tableau `permissions.allow` de `.claude/settings.json` du vault, sans retirer ce qui y est déjà, **uniquement** :
  - `Edit(./brief.md)`, l'écriture du fichier du brief ;
  - les outils de **lecture** de l'agenda présents dans la session : ceux d'un connecteur d'agenda dont le nom commence par `list_`, `get_` ou `search_` (par exemple `mcp__<serveur>__list_events`). Jamais un outil qui crée, modifie, supprime ou répond.

## Ce que tu ne fais jamais

- Programmer le brief ou le rappel dans les deux apps à la fois.
- Créer une tâche en double.
- Écrire dans la configuration globale de Codex (dans le dossier personnel de l'utilisateur).
