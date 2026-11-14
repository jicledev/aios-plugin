---
name: mettre-a-jour
description: Met à jour le moteur AIOS (le plugin) vers la dernière version publiée, sans toucher au vault. À utiliser quand l'utilisateur dit « mets à jour l'AIOS », « mise à jour de l'AIOS », « installe la nouvelle version de l'AIOS ».
argument-hint: "(aucun)"
---

# Mettre à jour l'AIOS

Tu mets à jour le moteur de l'AIOS : les commandes, le garde-fou et la sauvegarde. Le vault de l'utilisateur (ses notes, son `AGENTS.md`, ses fiches) n'est pas concerné. L'utilisateur n'est peut-être pas technique : parle simplement, sans jargon (pas de « plugin », « marketplace » ou « CLI », sauf s'il les emploie). Dis plutôt « le moteur de l'AIOS ».

Tu peux tourner dans **Claude Code** ou dans **Codex** (l'app ChatGPT). Tu es dans Codex si la variable d'environnement `CODEX_SHELL` vaut `1` ou si tes outils viennent de Codex. Suis la partie qui correspond.

## Étapes

1. **Annoncer.** Dis en une phrase ce que tu vas faire.

### Dans Claude Code

Préviens que tu vas peut-être demander une ou deux autorisations pour lancer des commandes.

2. **Choisir la voie.** Lance `claude --version`.
   - **Voie 1 : la commande répond.** Lance successivement :
     ```bash
     claude plugin marketplace update aios-marketplace
     ```
     ```bash
     claude plugin update aios@aios-marketplace
     ```
   - **Voie 2 : la commande est introuvable.** Demande à l'utilisateur de taper lui-même `/plugin` dans la zone de message. Guide-le étape par étape : onglet des sources de plugins, `aios-marketplace`, mise à jour, puis le plugin `aios`, mise à jour. Une étape à la fois, et attends sa réponse avant la suivante.

3. **Lire le résultat.**
   - Si la sortie indique que le plugin est déjà à la dernière version (`already at the latest version`), dis : « L'AIOS est déjà à jour (version X). » et arrête-toi là.
   - Si la mise à jour a réussi, dis : « L'AIOS est passé de la version X à la version Y. »
   - En cas d'erreur, explique-la en une phrase simple, dis ce que l'utilisateur peut faire (réessayer plus tard, vérifier sa connexion), puis arrête-toi.

4. **Activer la nouvelle version.** La nouvelle version ne sert qu'après un rechargement. Demande à l'utilisateur de taper lui-même `/reload-plugins` dans la zone de message, car tu ne peux pas le faire à sa place. S'il préfère, il peut aussi fermer cette session et en ouvrir une nouvelle sur le même dossier.

### Dans Codex

L'app n'a pas de commande pour cela : tu guides l'utilisateur, une étape à la fois, en attendant sa réponse avant la suivante.

2. **Mettre à jour.** « Ouvre l'onglet Plugins de l'app, puis le plugin **aios**. S'il propose une mise à jour, lance-la ; sinon, désinstalle-le puis réinstalle-le depuis la même source. » Demande-lui la version affichée après coup. Si elle n'a pas changé, dis : « L'AIOS est déjà à jour (version X). » et arrête-toi là.

3. **Réapprouver les protections.** « Une icône d'ancre avec un point jaune apparaît en bas de la zone de message : clique dessus et réapprouve les deux hooks de l'AIOS. » Explique pourquoi en une phrase : sans cette approbation, la sauvegarde automatique et le garde-fou ne tournent plus, sans aucun message.

4. **Activer la nouvelle version.** « Ouvre une nouvelle conversation sur ce dossier : la nouvelle version ne sert qu'à partir de là. »

### Dans les deux cas

5. **Nouveautés du vault.** Rappelle que la mise à jour ne modifie jamais son vault. Si la version a changé, propose de relancer `/aios:demarrer` (ou `$aios:demarrer` dans Codex) une fois la nouvelle version activée : il reconnaîtra le vault, n'ajoutera que ce qui manque (par exemple le réglage des documents) et demandera son accord à chaque fois.

## Ce que tu ne fais jamais

- Modifier le contenu du vault (fichiers, `AGENTS.md`, `.claude/settings.json`).
- Installer ou mettre à jour depuis une autre source que `aios-marketplace`.
- Désinstaller le plugin ou retirer une source de plugins.
- Toucher à d'autres plugins que `aios`.
