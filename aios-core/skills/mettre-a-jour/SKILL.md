---
name: mettre-a-jour
description: Met à jour le moteur AIOS (le plugin) vers la dernière version publiée, sans toucher au vault. À utiliser quand l'utilisateur dit « mets à jour l'AIOS », « mise à jour de l'AIOS », « installe la nouvelle version de l'AIOS ».
argument-hint: "(aucun)"
---

# Mettre à jour l'AIOS

Tu mets à jour le moteur de l'AIOS : les commandes, le garde-fou et la sauvegarde. Le vault de l'utilisateur (ses notes, son `AGENTS.md`, ses fiches) n'est pas concerné. L'utilisateur n'est peut-être pas technique : parle simplement, sans jargon (pas de « plugin », « marketplace » ou « CLI », sauf s'il les emploie). Dis plutôt « le moteur de l'AIOS ».

## Étapes

1. **Annoncer.** Dis en une phrase ce que tu vas faire. Préviens que tu vas peut-être demander une ou deux autorisations pour lancer des commandes.

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

5. **Nouveautés du vault.** Rappelle que la mise à jour ne modifie jamais son vault. Si la nouvelle version apporte des nouveautés dans la structure du vault, `/aios:demarrer` les ajoutera, après son accord.

## Ce que tu ne fais jamais

- Modifier le contenu du vault (fichiers, `AGENTS.md`, `.claude/settings.json`).
- Installer ou mettre à jour depuis une autre source que `aios-marketplace`.
- Désinstaller le plugin ou retirer une source de plugins.
- Toucher à d'autres plugins que `aios`.
