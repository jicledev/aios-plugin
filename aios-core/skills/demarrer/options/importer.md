# Option — importer du contenu existant

**Ce que ça apporte.** Tes notes, tes fichiers texte ou tes pages Notion entrent dans le vault, puis sont rangés avec toi, par petits lots. Rien n'est modifié à la source.

**Temps.** Quelques minutes pour faire entrer le contenu ; le rangement peut se poursuivre aux bilans suivants.

Les chemins sont donnés par rapport au dossier de la skill `demarrer`. Le vault est le dossier courant.

**Règle des lignes de `.aios-vault`.** Quand tu écris une décision (`oui`, `non`, `fait`, `aucun`, `drive:AIOS`), elle remplace l'ancienne ligne de la même option, et tu retires sa ligne `-plus-tard` s'il y en a une. Une ligne `-plus-tard` remplace elle aussi l'ancienne ligne de report.

## Étapes

1. Demande : « As-tu du contenu existant à importer (notes, documents, pages Notion) ? » Si l'utilisateur vient de dire oui à cette proposition (au bilan, par exemple), ne repose pas la question : passe au point 2.
2. **Si oui**, enchaîne sur la skill `importer` (`/aios:importer` dans Claude Code, `$aios:importer` dans Codex). À la fin, écris la ligne `import: fait` dans `.aios-vault`, sans toucher aux autres lignes, et retire la ligne `import-plus-tard:` s'il y en a une.
3. **Si non**, écris la ligne `import: non` dans `.aios-vault`, sans toucher aux autres lignes. Dis que l'import reste possible à tout moment : il suffit de dire « importe mes notes ».
4. **Si c'est « plus tard »**, écris la ligne `import-plus-tard: AAAA-MM-JJ` (date du jour), sans toucher aux autres lignes.
