# Option — sauvegarde en ligne (GitHub)

**Ce que ça apporte.** Une copie de ton vault en ligne, dans un espace privé : si ton ordinateur tombe en panne, rien n'est perdu. La sauvegarde locale, elle, tourne déjà à chaque réponse.

**Temps.** Deux minutes si GitHub est déjà connecté sur cet ordinateur.

Les chemins sont donnés par rapport au dossier de la skill `demarrer`. Le vault est le dossier courant.

**Règle des lignes de `.aios-vault`.** Quand tu écris une décision (`oui`, `non`, `fait`, `aucun`, `drive:AIOS`), elle remplace l'ancienne ligne de la même option, et tu retires sa ligne `-plus-tard` s'il y en a une. Une ligne `-plus-tard` remplace elle aussi l'ancienne ligne de report.

## Étapes

1. **Déjà en place ?** Lance `git remote get-url origin` dans le vault. Si la commande répond, la sauvegarde en ligne existe : écris `github: oui` dans `.aios-vault`, sans toucher aux autres lignes, dis-le en une ligne et arrête-toi là.
2. Propose une sauvegarde en ligne sur GitHub, dans un dépôt **privé**. Seulement après un « oui » explicite, vérifie `gh auth status` :
   - **GitHub est connecté** :
     ```bash
     gh repo create <nom-choisi> --private --source . --remote origin --push
     ```
     Puis écris `github: oui` dans `.aios-vault`, sans toucher aux autres lignes, et retire la ligne `github-plus-tard:` s'il y en a une.
   - **`gh` est absent ou pas connecté** : ne fais taper aucune commande à l'utilisateur, et ne l'envoie pas dans un terminal. Dis-lui : « La sauvegarde en ligne demande une connexion à GitHub qu'on fera plus tard, avec de l'aide si besoin. En attendant, la sauvegarde locale continue : chaque modification est enregistrée sur ton ordinateur. » L'option est reportée : écris `github-plus-tard: AAAA-MM-JJ` (date du jour) dans `.aios-vault`, sans toucher aux autres lignes.
3. **Si c'est non**, écris `github: non` dans `.aios-vault`, sans toucher aux autres lignes. Dis que la sauvegarde locale continue, et qu'il suffit de dire « sauvegarde en ligne » pour y revenir.
4. **Si c'est « plus tard »**, écris `github-plus-tard: AAAA-MM-JJ` (date du jour), sans toucher aux autres lignes.

## Ce que tu ne fais jamais

- Créer un dépôt **public**, ou créer un dépôt / pousser sans accord explicite.
- Modifier la configuration Git globale de l'utilisateur.
