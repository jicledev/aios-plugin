# Installer l'AIOS — procédure pour l'assistant

Ce document s'adresse à l'assistant IA (Claude Code, et plus tard d'autres) à qui l'utilisateur a demandé d'installer l'AIOS. Si tu es un humain, lis plutôt le [README](README.md).

Tu installes l'AIOS pour une personne qui n'est peut-être pas technique. Règles de conduite pendant toute la procédure :

- Parle simplement, en français, sans jargon : pas de « plugin », « marketplace », « CLI », « repo » ni « commit ». Dis « le moteur de l'AIOS » et « ton vault » (le dossier où vivra ta mémoire).
- Avant chaque commande qui demandera une autorisation, dis en une phrase ce que tu vas faire et pourquoi, pour que l'utilisateur sache quoi accepter.
- En cas d'erreur, explique-la en une phrase et dis ce que l'utilisateur peut faire. Ne relance pas indéfiniment la même commande.
- Une étape à la fois. Quand c'est à l'utilisateur d'agir (taper quelque chose, redémarrer), donne-lui le texte exact à taper et attends sa réponse.
- Tu n'installes rien d'autre que ce qui est décrit ici, et tu ne modifies pas les réglages de l'ordinateur.

## Avant de commencer

1. **Présente l'AIOS** en deux phrases : « L'AIOS transforme ce dossier en mémoire pour Claude : qui tu es, tes projets, tes règles. Rien n'est envoyé, publié ou supprimé sans ton accord, et tout est sauvegardé automatiquement. »

2. **Examine le dossier de la session** (le dossier courant).
   - **Il contient un fichier `.aios-vault`** : l'AIOS est déjà installé ici. Dis-le, puis passe à la section « Mettre à jour l'AIOS ».
   - **Il est vide** (ou ne contient que des fichiers cachés de configuration) : continue.
   - **Il contient d'autres fichiers** : dis ce que tu vois en une phrase, puis explique que l'AIOS a besoin d'un dossier dédié et ne transforme pas un dossier déjà utilisé. Propose à l'utilisateur de créer un dossier vide, par exemple `AIOS` dans ses Documents, d'ouvrir une nouvelle session Claude Code sur ce dossier, puis de recoller la même phrase. Arrête-toi là.

3. **Vérifie Git**, l'outil qui sert à la sauvegarde et au garde-fou. Lance `git --version`.
   - **La commande répond** : continue.
   - **Elle échoue** : explique que l'AIOS a besoin d'un petit outil gratuit, Git for Windows. L'utilisateur l'installe depuis https://git-scm.com/download/win en gardant les options par défaut, ferme complètement Claude Code, le rouvre sur ce dossier et recolle la même phrase. Arrête-toi là.

## Claude Code

1. **Choisis la voie.** Lance `claude --version`.

2. **Voie 1 : la commande répond.** Annonce que tu vas ajouter la source de l'AIOS puis installer le moteur, puis lance successivement :
   ```bash
   claude plugin marketplace add jicledev/aios-plugin
   ```
   ```bash
   claude plugin install aios@aios-marketplace
   ```
   Ces deux réponses ne sont pas des erreurs, c'est le cas d'une réinstallation ou d'un second vault :
   - **la source est déjà déclarée** : lance `claude plugin marketplace update aios-marketplace` à la place, puis passe à l'installation ;
   - **l'AIOS est déjà installé** : lance `claude plugin update aios@aios-marketplace` pour prendre la dernière version, puis continue.

3. **Voie 2 : la commande est introuvable.** C'est l'utilisateur qui tape les commandes, dans la zone de message de Claude Code. Donne-les une par une et attends son retour après chacune :
   ```
   /plugin marketplace add jicledev/aios-plugin
   ```
   ```
   /plugin install aios@aios-marketplace
   ```
   Si l'une des deux répond que c'est déjà fait (source déjà déclarée, AIOS déjà installé), ce n'est pas une erreur : continue. Le moteur sera mis à jour plus tard avec « mets à jour l'AIOS ».
   Si l'app de bureau ne reconnaît pas `/plugin`, guide-le dans le menu : bouton **+** à côté de la zone de message, **Plugins**, puis ajoute la source `jicledev/aios-plugin` et installe **aios**.

4. **Active le moteur.** Il ne sert qu'après un rechargement, et tu ne peux pas le lancer toi-même. Demande à l'utilisateur de taper :
   ```
   /reload-plugins
   ```
   S'il préfère, il peut aussi fermer la session et en rouvrir une nouvelle sur le même dossier.

5. **Lance l'installation du vault.** Une fois le rechargement fait, demande à l'utilisateur de taper :
   ```
   /aios:demarrer
   ```
   Explique ce qui va suivre : quelques questions sur lui, ses activités et ses projets, puis Claude prépare le vault. Compter 15 à 20 minutes.

## Mettre à jour l'AIOS

- **Le moteur est installé**, c'est-à-dire que la commande `/aios:mettre-a-jour` existe dans cette session : demande à l'utilisateur de taper `/aios:mettre-a-jour`, ou de dire « mets à jour l'AIOS ».
- **Le dossier est un vault mais le moteur n'est pas installé** sur cet ordinateur (nouvel ordinateur, réinstallation) : suis la section « Claude Code » ci-dessus. À l'étape 5, `/aios:demarrer` reconnaîtra le vault existant et n'ajoutera que ce qui manque.

## Codex

Pas encore pris en charge.
