---
name: demarrer
description: Installe et personnalise un vault AIOS, puis active ses options à la demande. À utiliser au premier lancement dans un dossier vide, ou quand l'utilisateur dit « démarrer », « mettre à jour mon AGENTS.md », « refaire mon profil », « changer l'heure de mon brief », « active le brief », « je veux le brief du matin », « sauvegarde en ligne », « active les documents » ou « active le rappel du bilan ».
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

**Le premier jour, tu poses le socle, rien de plus.** Les options (importer du contenu existant, brief du matin, sauvegarde en ligne, documents) viennent ensuite : le bilan de la semaine en propose une à la fois, et l'utilisateur peut en demander une quand il veut. Si cette skill a été lancée pour activer une option dans un vault déjà installé, va directement à « À la demande ».

## Étapes

1. **Vérifier le dossier.**
   - Le vault est **toujours** le dossier de la session (le dossier courant). Les protections et la sauvegarde automatique ne fonctionnent que dans une session ouverte *dans* le vault.
   - Si l'utilisateur veut son vault ailleurs (il cite un autre dossier, ou le dossier courant est un projet de code, un dépôt existant, son dossier personnel…), ne pose rien. Explique simplement : « Pour que l'AIOS fonctionne, il faut rouvrir une session (Claude Code) ou une conversation (Codex) dans le dossier du vault, puis relancer `/aios:demarrer` (ou `$aios:demarrer` dans Codex). » Propose de créer le dossier vide s'il n'existe pas, puis arrête-toi là.
   - **Dans Codex**, vérifie aussi Git : lance `git --version`. S'il manque, explique que l'AIOS a besoin d'un petit outil gratuit, Git for Windows (https://git-scm.com/download/win, options par défaut), puis de fermer et rouvrir l'app et de relancer `$aios:demarrer`. Arrête-toi là.
   - Si le dossier courant contient déjà `.aios-vault`, c'est une mise à jour : l'étape 2 ajoutera seulement ce qui manque, l'étape 2 bis proposera les règles nouvelles d'`AGENTS.md`, puis à l'étape 3 ne demande que ce qui a changé. Un vault installé avec Claude et ouvert pour la première fois dans Codex (ou l'inverse) est aussi une mise à jour : seules les étapes 5, 7 et 8 ont du nouveau à proposer.
   - S'il est vide, continue.
   - S'il contient d'autres fichiers sans `.aios-vault`, dis ce que tu vois et demande confirmation avant de continuer (rien ne sera écrasé, mais le dossier deviendra un vault).

2. **Poser la structure.** Lance le script fourni par le plugin, situé à `../../scripts/poser-structure.sh` par rapport au dossier de cette skill :
   - **Dans Claude Code :**
     ```bash
     bash "<dossier de cette skill>/../../scripts/poser-structure.sh" "<dossier courant>"
     ```
   - **Dans Codex :** avec le Bash de Git, comme expliqué plus haut : `& $b "<dossier de cette skill>/../../scripts/poser-structure.sh" "<dossier courant>"`.

   Il ne remplace jamais un fichier existant. Résume en une phrase ce qui a été créé.

   Si `.aios-vault` n'existait pas avant cette étape (vault neuf), ajoute-lui aussitôt la ligne `installe: <version du moteur>` (version lue dans `../../.claude-plugin/plugin.json`, par rapport au dossier de cette skill), sans toucher aux autres lignes. Elle distingue un vault neuf d'un vault installé avant la version 0.9.0.

2 bis. **Mettre à niveau les règles**, seulement pour un vault déjà installé (le fichier `.aios-vault` existait avant l'étape 2). Les règles génériques d'`AGENTS.md` évoluent avec le moteur, mais l'`AGENTS.md` du vault n'est jamais réécrit d'office : tu proposes, l'utilisateur décide.
   1. Lis la ligne `regles:` de `.aios-vault` et la version du moteur (`../../.claude-plugin/plugin.json`, par rapport au dossier de cette skill). Si `regles:` vaut déjà la version du moteur, passe cette étape sans rien dire — sauf si l'utilisateur a demandé « mets à jour mon AGENTS.md » : fais-la alors quand même. Si la ligne manque, le vault date d'avant ce mécanisme : continue.
   2. Lis le journal des règles du moteur (`../../schemas/regles-agents.md`) : tout le fichier si la ligne `regles:` manque ou si l'utilisateur a demandé la mise à jour, sinon seulement les versions postérieures à sa valeur. Lis aussi le template (`../../template/AGENTS.md`) et l'`AGENTS.md` du vault.
   3. Relève ce qui manque au vault dans les sections génériques (« Où trouver quoi », « Sources de vérité », « Règles de rangement », « Mes recettes » pour sa phrase d'introduction, « Conventions », « Sécurité », « Corrections », « Fin de session ») :
      - une section ou une règle du template absente du vault (une règle que le vault contient sous une autre formulation n'est pas absente : ne la propose pas) ;
      - une phrase du vault identique à un « Ancien » du journal, à remplacer par son « Nouveau ».
      Toute autre phrase qui diffère du template est une règle que l'utilisateur a écrite ou réécrite : n'y touche pas. En cas de doute, montre les deux versions et demande. Le journal sert à reconnaître les phrases remplacées et à expliquer chaque règle ; c'est la comparaison avec le template qui dit ce qui manque. Une règle refusée peut donc être reproposée à la version suivante : c'est voulu.
   4. Ne touche jamais aux parties personnelles : « Qui je suis », les objectifs, « Mes domaines », « Projets actifs », les lignes de « Sources de vérité » propres à l'utilisateur, les lignes de recettes.
   5. S'il n'y a rien à proposer, dis-le en une ligne. Sinon, montre les changements groupés par section, texte avant et après, avec une phrase sur ce que chacun apporte. L'utilisateur accepte tout, une partie, ou rien. Applique seulement ce qui est accepté.
   6. Écris ou remplace la ligne `regles: <version du moteur>` dans `.aios-vault`, sans toucher aux autres lignes, que les changements aient été acceptés ou non. Dis que les règles refusées ne seront pas reproposées avant une prochaine version, et qu'il suffit de dire « mets à jour mon AGENTS.md » pour les revoir.

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
   - Pour un vault neuf, ajoute à `.aios-vault` la ligne `regles: <version du moteur>` (version lue dans `../../.claude-plugin/plugin.json`), sans toucher aux autres lignes : ses règles sont celles de cette version.

5. **Verrouiller les connecteurs.**
   - Parcours la liste des outils MCP (`mcp__…`) disponibles dans cette session. Retiens ceux que le garde-fou du plugin juge sensibles, avec la même règle que `../../scripts/garde.sh` (lis-le) : dans la partie du nom après le dernier `__`, découpée en mots (camelCase, `_`, `-`, `.`), un mot de `VERBES_SENSIBLES`, ou, à défaut, l'un des mots de `SOUS_CHAINES` collé à d'autres (ex. `sendemail`). S'y ajoutent les modifications : un mot de `VERBES_MODIFICATION`, sauf si le nom contient le mot `draft` ou `drafts` (un brouillon reste libre), si un mot de `VERBES_LECTURE` vient avant (c'est une lecture), ou si c'est un outil de l'app Claude elle-même (serveur `ccd_…`, par exemple `mcp__ccd_turn__update_plan`) : ceux-là n'entrent dans la liste que pour leurs verbes sensibles. S'y ajoute enfin la création d'un événement d'agenda : un mot de `VERBES_CREATION` dans un nom qui contient aussi un mot de `NOMS_AGENDA` (par exemple `create_event`), avec les mêmes exemptions de brouillon et de lecture.
   - **Dans Claude Code :**
     - Montre la liste à l'utilisateur, groupée par connecteur, et explique : « Pour ces actions — envoyer, publier, supprimer, modifier ce qui existe, créer un événement d'agenda — je te demanderai toujours ton accord, même en mode automatique. Le reste des créations (une page, un brouillon) est libre. »
     - Après accord, ajoute leurs noms exacts (`mcp__<serveur>__<outil>`) au tableau `permissions.ask` de `.claude/settings.json` du vault, sans retirer ce qui y est déjà.
     - Exception : dans le serveur `scheduled-tasks` (les tâches programmées de l'app de bureau), `create_scheduled_task` et les outils `list_…` ne sont pas sensibles. Ils créent ou listent des tâches sur cet ordinateur sans rien envoyer, et le garde-fou les laisse passer. Ne les ajoute pas à `permissions.ask`. Modifier, supprimer ou lancer une tâche existante reste sensible.
     - Si aucun connecteur n'est branché, dis-le : le garde-fou du plugin protégera les connecteurs ajoutés plus tard, et relancer `/aios:demarrer` complétera la liste.
   - **Dans Codex :**
     - **Vérifie d'abord que les protections tournent.** Lis `.git/aios-sauvegarde.log` : la sauvegarde y écrit une ligne datée à la fin de chacune de tes réponses, et le garde-fou est approuvé en même temps qu'elle. S'il n'existe pas ou n'a aucune ligne d'aujourd'hui, n'annonce aucune protection : demande à l'utilisateur de cliquer sur l'icône d'**ancre** avec un point jaune (en bas de la zone de message) et d'approuver les deux hooks de l'AIOS, puis d'ouvrir une nouvelle conversation et de relancer `$aios:demarrer`. Arrête-toi là.
     - N'écris aucun réglage. Codex ne sait pas demander ton accord pour ces actions : le garde-fou les bloque toutes, même si l'utilisateur confirme. Montre la liste groupée par connecteur et explique : « Dans Codex, ces actions sont bloquées par sécurité : je ne peux ni envoyer, ni publier, ni supprimer, ni modifier ce qui existe déjà, ni créer un événement d'agenda à ta place. Je peux en revanche créer une page, et préparer un brouillon ; tu l'envoies toi-même depuis l'app concernée (Gmail…), ou tu me le demandes depuis Claude. » Les connecteurs branchés plus tard sont bloqués de la même façon, sans rien à refaire.

6. **Sauvegarde.**
   - Si `git config user.name` ou `user.email` est vide dans le vault, demande un nom et un email (ou l'adresse « noreply » GitHub) et configure-les **localement** (`git config user.name …` sans `--global`).
   - Enregistre l'état actuel : `git add -A`, puis, seulement s'il y a des changements (`git diff --cached --quiet` échoue), `git commit -m "AIOS : installation du vault"` (ou `"AIOS : mise à jour du profil"` lors d'une relance).
   - La sauvegarde en ligne (GitHub) est une option : ne la propose pas ici.

7. **Rappel du bilan.** Pose une seule question : « Veux-tu un rappel pour faire ton bilan de la semaine ? (le dimanche à 18 h par défaut) ». C'est le bilan qui fait vivre l'AIOS et qui proposera les options : sans rappel, on l'oublie.
   - Si la ligne `rappel:` existe déjà dans `.aios-vault`, ne repose pas la question.
   - Pour un vault déjà installé qui n'a pas cette ligne, regarde d'abord si la tâche « Rappel du bilan » existe (dans Claude Code, `aios-rappel-bilan` dans `list_scheduled_tasks`) : si oui, écris `rappel: oui`, sans toucher aux autres lignes, et ne pose pas la question.
   - Après un « oui », lis `options/taches-programmees.md` (dans le dossier de cette skill) et ne fais que sa partie « Rappel du bilan », avec sa « Mécanique commune ». Il écrit la ligne `rappel: oui`.
   - Après un « non », écris `rappel: non` dans `.aios-vault`, sans toucher aux autres lignes.
   - Sans app de bureau (aucun outil de tâches programmées), le rappel est reporté : dis-le en une ligne et continue. Le socle se termine quand même.

8. **Options.** Ne propose aucune option le premier jour : c'est le bilan qui propose, une par semaine.
   - **Vault neuf** : rien à faire ici.
   - **Vault installé avant la version 0.9.0** (son `.aios-vault` n'a pas de ligne `installe:`) : écris `installe: avant-0.9.0`, puis les lignes manquantes d'après l'état réel, sans toucher aux autres lignes :
     - `brief: oui` si une tâche « Brief du matin » existe pour ce vault (dans Claude Code, `aios-brief-du-matin` dans `list_scheduled_tasks`) ;
     - `rappel: oui` si une tâche « Rappel du bilan » existe (`aios-rappel-bilan`) ;
     - `github: oui` si `git remote get-url origin` répond ;
     - `import: fait`, car la question lui a été posée à l'installation.
     Ne propose rien : là aussi, c'est le bilan qui propose.
   - **Vault déjà installé, relancé** (après l'état des lieux ci-dessus, s'il y en a eu un) : pour chaque option active (`brief: oui`, `rappel: oui`, `documents: drive:AIOS` dans `.aios-vault`), lis son fichier dans `options/` (`taches-programmees.md`, `documents.md`) et ne fais que sa section « À chaque relance ». Une option qui n'est pas active n'est pas lue.

9. **Conclure** en quatre lignes au plus :
   - ce qui est en place ;
   - les commandes utiles (`/aios:brief`, `/aios:capture`, `/aios:bilan`, `/aios:etat-projet`, `/aios:importer`, `/aios:lire`, `/aios:creer-recette` dans Claude Code ; `$aios:brief`, `$aios:capture`, `$aios:bilan`, `$aios:etat-projet`, `$aios:importer`, `$aios:lire`, `$aios:creer-recette` dans Codex) ;
   - pour un vault neuf, le premier rendez-vous : « Fais ton premier bilan dans une semaine : dis simplement « bilan ». » ;
   - pour un vault neuf, les options, en une ligne : « Plus tard, je te proposerai une à une : importer tes notes, un brief du matin, une sauvegarde en ligne, la lecture de tes documents. Tu peux en demander une quand tu veux. »
   Ajoute en une phrase que le dossier peut s'ouvrir dans Obsidian (« Ouvrir un dossier comme coffre ») pour lire et naviguer.

## À la demande

Quand l'utilisateur demande une option dans un vault déjà installé, ne refais pas le socle : lis le fichier de l'option dans `options/` (dans le dossier de cette skill) et suis-le.

| L'utilisateur dit | Fichier à suivre |
|---|---|
| « active le brief », « je veux le brief du matin » | `options/taches-programmees.md`, partie « Brief du matin » |
| « changer l'heure de mon brief » | `options/taches-programmees.md`, section « À chaque relance » |
| « active le rappel du bilan » | `options/taches-programmees.md`, partie « Rappel du bilan » |
| « sauvegarde en ligne » | `options/github.md` |
| « active les documents » | `options/documents.md` |
| « importe mes notes » | `options/importer.md` |

Une option déjà refusée (`brief: non`, `rappel: non`, `github: non`, `import: non`, `documents: aucun`) ou reportée (`…-plus-tard:`) s'active de la même façon : le fichier de l'option remplace sa ligne dans `.aios-vault`.

Si le dossier courant n'est pas un vault (pas de `.aios-vault`), commence par le socle.

## Ce que tu ne fais jamais

- Installer le vault dans un autre dossier que le dossier de la session.
- Écraser ou vider un fichier existant.
- Remplir `AGENTS.md` avec des suppositions que l'utilisateur n'a pas validées.
- Créer un dépôt **public**, ou créer un dépôt / pousser sans accord explicite.
- Modifier la configuration Git globale de l'utilisateur.
- Écrire dans la configuration globale de Codex (dans le dossier personnel de l'utilisateur).
- Programmer le brief dans les deux apps à la fois.
- Proposer une option le premier jour (import, brief, sauvegarde en ligne, documents) : c'est le bilan qui les propose, une par semaine.
- Lancer un script du plugin avec `bash` tout court dans Codex.
- Enregistrer un mot de passe, une clé ou un code dans le vault.
