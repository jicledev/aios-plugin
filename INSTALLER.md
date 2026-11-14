# Installer l'AIOS — procédure pour l'assistant

Ce document s'adresse à l'assistant IA (Claude Code ou Codex) à qui l'utilisateur a demandé d'installer l'AIOS. Si tu es un humain, lis plutôt le [README](README.md).

Tu installes l'AIOS pour une personne qui n'est peut-être pas technique. Règles de conduite pendant toute la procédure :

- Parle simplement, en français, sans jargon : pas de « plugin », « marketplace », « CLI », « repo » ni « commit ». Dis « le moteur de l'AIOS » et « ton vault » (le dossier où vivra ta mémoire).
- Avant chaque commande qui demandera une autorisation, dis en une phrase ce que tu vas faire et pourquoi, pour que l'utilisateur sache quoi accepter.
- En cas d'erreur, explique-la en une phrase et dis ce que l'utilisateur peut faire. Ne relance pas indéfiniment la même commande.
- Une étape à la fois. Quand c'est à l'utilisateur d'agir (taper quelque chose, redémarrer), donne-lui le texte exact à taper et attends sa réponse.
- Tu n'installes rien d'autre que ce qui est décrit ici, et tu ne modifies pas les réglages de l'ordinateur.

## Avant de commencer

1. **Présente l'AIOS** en deux phrases : « L'AIOS transforme ce dossier en mémoire pour ton assistant (Claude ou Codex) : qui tu es, tes projets, tes règles. Rien n'est envoyé, publié, supprimé ou modifié sans ton accord, et tout est sauvegardé automatiquement. »

2. **Examine le dossier de la session** (le dossier courant).
   - **Il contient un fichier `.aios-vault`** : l'AIOS est déjà installé ici. Dis-le. Si tu es Codex, va directement à la section « Codex » (elle traite ce cas) ; sinon, passe à la section « Mettre à jour l'AIOS ».
   - **Il est vide** (ou ne contient que des fichiers cachés de configuration) : continue.
   - **Il contient d'autres fichiers** : dis ce que tu vois en une phrase, puis explique que l'AIOS a besoin d'un dossier dédié et ne transforme pas un dossier déjà utilisé. Propose à l'utilisateur de créer un dossier vide, par exemple `AIOS` dans ses Documents, d'ouvrir une nouvelle session (Claude Code) ou conversation (Codex) sur ce dossier, puis de recoller la même phrase. Arrête-toi là.

3. **Vérifie Git** (aussi dans Codex, avant sa section), l'outil qui sert à la sauvegarde et au garde-fou. Lance `git --version`.
   - **La commande répond** : continue.
   - **Elle échoue** : explique que l'AIOS a besoin d'un petit outil gratuit, Git for Windows. L'utilisateur l'installe depuis https://git-scm.com/download/win en gardant les options par défaut, ferme complètement son app (Claude ou ChatGPT/Codex), la rouvre sur ce dossier et recolle la même phrase. Arrête-toi là.


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
   Explique ce qui va suivre : quelques questions sur lui, ses activités et ses projets, puis Claude prépare le vault. Compter une dizaine de minutes : le premier jour, l'AIOS n'installe que l'essentiel.

## Mettre à jour l'AIOS

- **Le moteur est installé**, c'est-à-dire que la commande `/aios:mettre-a-jour` existe dans cette session : demande à l'utilisateur de taper `/aios:mettre-a-jour`, ou de dire « mets à jour l'AIOS ».
- **Le dossier est un vault mais le moteur n'est pas installé** sur cet ordinateur (nouvel ordinateur, réinstallation) : suis la section « Claude Code » ci-dessus. À l'étape 5, `/aios:demarrer` reconnaîtra le vault existant et n'ajoutera que ce qui manque.

## Codex

Si tu es Codex (l'app ChatGPT « Powered by Codex »), suis cette section à la place de « Claude Code ». L'app n'a pas de commande pour installer un plugin : c'est l'utilisateur qui clique, et tu le guides **une étape à la fois**, en attendant sa réponse avant la suivante. Les commandes de l'AIOS s'écrivent `$aios:…` dans Codex.

1. **Ajoute la source.** « Ouvre l'onglet **Plugins** de l'app, ajoute une source de plugins (marketplace) et saisis : `jicledev/aios-plugin`. »
2. **Installe le moteur.** « Le plugin **aios** apparaît, avec ses recettes : clique sur **Installer le plug-in**. » S'il est déjà installé, passe à l'étape suivante.
3. **Approuve les protections.** « L'app te demande d'approuver deux hooks de l'AIOS (ou une icône d'ancre avec un point jaune apparaît en bas de la zone de message) : approuve-les. » Explique en une phrase : ce sont le garde-fou (rien n'est envoyé ni supprimé sans toi) et la sauvegarde automatique ; sans cette approbation, ils ne tournent pas.
4. **Ouvre une nouvelle conversation** sur ce dossier (le projet du vault) : le moteur ne sert qu'à partir de là.
5. **Lance l'installation du vault.** Dans cette nouvelle conversation, l'utilisateur tape `$aios:demarrer`. Explique ce qui va suivre : quelques questions, puis le vault est prêt (une dizaine de minutes).

**Le dossier contient déjà `.aios-vault`** (vault installé avec Claude, ouvert pour la première fois dans Codex) : fais seulement les étapes 1 à 4, puis `$aios:demarrer`, qui reconnaîtra le vault et n'ajoutera que la partie Codex (les protections). Rien de son contenu ne change.

**Une limite à annoncer honnêtement** : dans Codex, le garde-fou ne peut pas demander l'accord de l'utilisateur, il bloque donc toute action sensible (envoyer, publier, supprimer, modifier ce qui existe), même confirmée. Codex peut préparer des brouillons ; l'envoi se fait dans l'app concernée ou depuis Claude.

**Après chaque mise à jour** du moteur dans Codex, l'icône d'ancre jaune revient : il faut réapprouver les hooks, sinon la sauvegarde et le garde-fou s'arrêtent sans prévenir.
