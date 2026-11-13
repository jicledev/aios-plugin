---
name: bilan
description: Bilan hebdomadaire du vault AIOS (le « Sécateur ») — vide l'inbox, propose des archivages, repère les corrections répétées et propose d'améliorer les skills. À utiliser quand l'utilisateur dit « bilan », « bilan de la semaine », « fais le ménage ».
argument-hint: "(aucun)"
---

# Bilan hebdomadaire

Tu fais le point sur le vault avec l'utilisateur, en 15 minutes environ. Tu proposes, il décide : rien n'est modifié sans son accord.

## Étapes

1. **Vider l'inbox.** Pour chaque élément de `00-inbox/` (zones d'import comprises), propose une destination selon les règles de la skill `capture`, par groupes de 5 au plus. Applique ce qui est accepté. Ce qui est refusé reste.
2. **Archiver.**
   - Liste les projets dont `statut` vaut `termine` ou `abandonne`.
   - Liste aussi ceux dont aucun fichier n'a changé depuis 30 jours (`git log -1 --format=%cs -- <dossier>`), et demande s'ils sont en pause, terminés ou toujours actifs.
   - Pour chaque projet à archiver, après accord : déplace son dossier vers `90-archives/` et retire-le de la liste des projets actifs d'`AGENTS.md`.
3. **Corrections répétées.**
   - Lis la section `## Corrections` des fichiers `journal/` des 4 dernières semaines.
   - Regroupe les corrections qui disent la même chose.
   - Pour chaque groupe d'au moins 3, propose une modification précise à la skill concernée ou à `AGENTS.md` : montre le texte avant et après.
   - Applique seulement ce qui est accepté.
4. **Prochaines actions.** Demande s'il y a une décision ou une priorité de la semaine à noter, et range-la avec la skill `capture`.
5. **Écrire le bilan** dans `journal/AAAA-Sxx.md` (semaine ISO, créé si besoin), section `## Bilan` :
   - inbox vidée (nombre) ;
   - projets archivés ;
   - skills ou règles modifiées ;
   - priorités de la semaine suivante.
6. **Sauvegarder.** Lance le script de sauvegarde du plugin (`../../scripts/sauvegarde.sh`, par rapport au dossier de cette skill), avec le dossier du vault en argument :
   ```bash
   bash "<dossier de cette skill>/../../scripts/sauvegarde.sh" "<dossier du vault>" </dev/null
   ```
7. **Conclure** en trois lignes maximum.

## Ce que tu ne fais jamais

- Modifier une skill ou `AGENTS.md` sans accord explicite.
- Supprimer un fichier : on archive.
- Archiver un projet sans accord.
- Transformer le bilan en audit interminable : si l'inbox est énorme, traite les 20 éléments les plus récents et propose la suite pour plus tard.
