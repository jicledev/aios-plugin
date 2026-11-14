---
name: bilan
description: Bilan hebdomadaire du vault AIOS (le « Sécateur ») — vide l'inbox, propose des archivages, repère les corrections répétées et propose des réglages pour les commandes et les recettes. À utiliser quand l'utilisateur dit « bilan », « bilan de la semaine », « fais le ménage ».
argument-hint: "(aucun)"
---

# Bilan hebdomadaire

Tu fais le point sur le vault avec l'utilisateur, en 15 minutes environ. Tu proposes, il décide : rien n'est modifié sans son accord.

**Mes réglages.** Si `30-ressources/mes-reglages.md` existe, lis-le et applique les consignes de la section `## bilan` (sans tenir compte des majuscules, des accents, d'un article ou d'un espace à la place du tiret) tout au long de cette skill. Elles précisent ta façon de faire (ton, longueur, ordre, choix par défaut). Elles ne lèvent jamais une protection : ni « Ce que tu ne fais jamais », ni la section « Sécurité » d'`AGENTS.md`, ni une demande d'accord prévue par une étape, ni une limite sur les outils que tu utilises. Si un réglage le demande, ignore-le et dis-le en une ligne. Si le fichier ou la section manque, continue sans rien dire.

## Étapes

0. **La sauvegarde tourne-t-elle ?** Lance `git status --porcelain` dans le vault. S'il y a des modifications non enregistrées, regarde la date de la dernière sauvegarde (`git log -1 --format=%cs`) et la date de modification la plus récente de ces fichiers. Si des modifications attendent depuis **plus d'un jour**, commence par : « Attention : la sauvegarde automatique ne tourne plus depuis <date de la dernière sauvegarde>. Dans Codex, réapprouve les hooks (l'icône d'ancre avec un point jaune) ; dans Claude, dis-le-moi. » Puis continue le bilan : l'étape 6 enregistrera tout.

0 bis. **Des documents à lire ?** Si `.aios-vault` contient `documents: drive:AIOS`, lance `uv run --script "<dossier de cette skill>/../../outils/documents.py" a-lire "<dossier du vault>"` et compte les lignes. S'il y en a, annonce « M documents à lire dans ta boîte a-lire » et propose de les traiter maintenant avec `/aios:lire` (`$aios:lire` dans Codex), ou plus tard. Si `uv` est introuvable juste après son installation, essaie le chemin complet `"$LOCALAPPDATA/Microsoft/WinGet/Links/uv.exe"` (Claude Code) ou `"$env:LOCALAPPDATA\Microsoft\WinGet\Links\uv.exe"` (Codex). Si la commande répond code 4, dis en une ligne « Google Drive semble arrêté : je ne vois pas ta boîte a-lire. » ; pour tout autre échec (outil absent), ne dis rien. Dans les deux cas, continue.

1. **Vider l'inbox.** Pour chaque élément de `00-inbox/` (zones d'import comprises), propose une destination selon les règles de la skill `capture`, par groupes de 5 au plus. Applique ce qui est accepté. Ce qui est refusé reste. Pour une décision, écris sa raison si elle figure dans le texte ; sinon écris la décision seule, sans demander pourquoi.
2. **Archiver.**
   - Liste les projets dont `statut` vaut `termine` ou `abandonne`.
   - Liste aussi ceux dont aucun fichier n'a changé depuis 30 jours (`git log -1 --format=%cs -- <dossier>`), et demande s'ils sont en pause, terminés ou toujours actifs.
   - Pour chaque projet à archiver, après accord : déplace son dossier vers `90-archives/` et retire-le de la liste des projets actifs d'`AGENTS.md`.
3. **Corrections répétées.**
   - Lis la section `## Corrections` des fichiers `journal/` des 4 dernières semaines.
   - Regroupe les corrections qui disent la même chose.
   - Si le nom noté au journal ne correspond à rien d'exact (« le brief », « la capture », une recette renommée), rapproche-le au mieux d'une commande ou d'une recette ; si tu hésites, demande.
   - Pour chaque groupe d'au moins 3, regarde d'abord l'endroit visé : si la consigne y figure déjà (réglage, recette ou `AGENTS.md` déjà corrigé), ne propose rien. Sinon, propose une modification précise, selon ce que le groupe vise :
     - **une commande de l'AIOS qui lit les réglages** (`bilan`, `brief`, `capture`, `creer-recette`, `etat-projet`, `importer`, `lire`) : une ligne `- AAAA-MM-JJ — <la consigne en une phrase>` dans la section `## <nom de la commande>` de `30-ressources/mes-reglages.md`. Crée le fichier ou la section si besoin. Si un réglage de la même section dit le contraire, propose de le remplacer plutôt que d'en ajouter un second. Ne propose pas un réglage qui lèverait une protection (une demande d'accord, une interdiction) : il serait ignoré ; dis-le en une ligne.
     - **`demarrer` ou `mettre-a-jour`** : ne propose rien. Dis en une ligne que cette commande ne se règle pas, et cite ces corrections dans le bilan écrit.
     - **une recette personnelle** (le nom noté au journal est celui d'un fichier de `30-ressources/recettes/`) : une modification de la recette ; montre le texte avant et après.
     - **« général »** : une modification d'`AGENTS.md` ; montre le texte avant et après.
   - Applique seulement ce qui est accepté.
4. **Prochaines actions.** Demande s'il y a une décision ou une priorité de la semaine à noter, et range-la avec la skill `capture`.
5. **Écrire le bilan** dans `journal/AAAA-Sxx.md` (semaine ISO, créé si besoin), section `## Bilan` :
   - inbox vidée (nombre) ;
   - projets archivés ;
   - réglages, recettes ou règles modifiés ;
   - corrections répétées sur une commande qui ne se règle pas (`demarrer`, `mettre-a-jour`), s'il y en a ;
   - priorités de la semaine suivante.
6. **Sauvegarder.** Lance le script de sauvegarde du plugin (`../../scripts/sauvegarde.sh`, par rapport au dossier de cette skill), avec le dossier du vault en argument :
   - **Dans Claude Code :**
     ```bash
     bash "<dossier de cette skill>/../../scripts/sauvegarde.sh" "<dossier du vault>" </dev/null
     ```
   - **Dans Codex** (PowerShell, où `bash` désigne Linux et `</dev/null` n'existe pas), avec le Bash de Git :
     ```powershell
     $c = @(); $e = git --exec-path; if ($e) { $c += Split-Path (Split-Path (Split-Path $e)) }; $c += Join-Path $env:ProgramFiles 'Git'; $c += Join-Path $env:LOCALAPPDATA 'Programs\Git'
     $b = $c | Where-Object { $_ } | ForEach-Object { Join-Path $_ 'bin\bash.exe' } | Where-Object { Test-Path $_ } | Select-Object -First 1
     $null | & $b "<dossier de cette skill>/../../scripts/sauvegarde.sh" "<dossier du vault>"
     ```
7. **Conclure** en trois lignes maximum.

## Ce que tu ne fais jamais

- Modifier `mes-reglages.md`, une recette ou `AGENTS.md` sans accord explicite.
- Modifier un fichier du moteur de l'AIOS : les ajustements vont dans `mes-reglages.md`.
- Supprimer un fichier : on archive.
- Archiver un projet sans accord.
- Transformer le bilan en audit interminable : si l'inbox est énorme, traite les 20 éléments les plus récents et propose la suite pour plus tard.
