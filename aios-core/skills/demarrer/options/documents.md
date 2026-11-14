# Option — les documents

**Ce que ça apporte.** Tu déposes des PDF, des fichiers Word ou des images, que `/aios:lire` (`$aios:lire`) transforme en fiches de lecture rangées dans ton vault. Les originaux restent dans ton Google Drive, où tu peux en déposer depuis ton téléphone.

**Temps.** Cinq minutes, avec l'installation d'un petit outil gratuit que Windows te demandera d'autoriser.

Les chemins sont donnés par rapport au dossier de la skill `demarrer` (`<dossier de cette skill>` désigne ce dossier). Le vault est le dossier courant.

**Règle des lignes de `.aios-vault`.** Quand tu écris une décision (`oui`, `non`, `fait`, `aucun`, `drive:AIOS`), elle remplace l'ancienne ligne de la même option, et tu retires sa ligne `-plus-tard` s'il y en a une. Une ligne `-plus-tard` remplace elle aussi l'ancienne ligne de report.

Pour **activer** l'option, fais « À chaque relance », puis « Le réglage ». À une simple relance de `demarrer` sur un vault où les documents sont déjà réglés, ne fais que « À chaque relance ».

## À chaque relance

1. **L'outil `uv`, à chaque relance.** Lance `uv --version`, même si les documents sont déjà réglés. S'il manque, annonce : « Pour lire tes documents, j'installe un petit outil gratuit (uv), qui fait tourner les programmes de lecture de l'AIOS. Windows va te demander de l'autoriser. » Puis lance :
   ```
   winget install --id astral-sh.uv -e
   ```
   et vérifie avec `uv --version`. Juste après l'installation, la commande reste souvent introuvable dans la session en cours : essaie alors le chemin complet `"$env:LOCALAPPDATA\Microsoft\WinGet\Links\uv.exe" --version` dans Codex, ou `"$LOCALAPPDATA/Microsoft/WinGet/Links/uv.exe" --version` dans Claude Code (puis `.local\bin\uv.exe` dans le dossier personnel), et utilise ce chemin complet à la place de `uv` dans la suite de cette option. Le chemin `WinGet\Links\uv.exe` n'est utile que jusqu'au prochain redémarrage de l'app.
   **En cas d'échec**, dis-le simplement : « Je n'ai pas pu installer l'outil de lecture. La lecture des PDF et des images marchera quand même dans Claude, mais pas celle des fichiers Word ni la boîte a-lire. Dis « active les documents » plus tard pour réessayer. » L'option est reportée, seulement si la ligne `documents:` est absente : écris alors `documents-plus-tard: AAAA-MM-JJ` (date du jour) dans `.aios-vault`, sans toucher aux autres lignes. Si les documents étaient déjà réglés, ne change rien à `.aios-vault`. Arrête-toi là pour cette option : les points suivants demandent l'outil.
2. **Autorisation (dans Claude Code)**, même si la ligne `documents:` existe déjà (vault créé dans Codex, par exemple) : ajoute `Bash(uv run --script *documents.py*)` au tableau `permissions.allow` de `.claude/settings.json` du vault s'il n'y est pas, sans retirer ce qui y est déjà. Ainsi la lecture des documents ne demande pas une autorisation à chaque fichier.

## Le réglage

3. **Le réglage, seulement si la ligne `documents:` est absente de `.aios-vault`**, ou si l'utilisateur vient de demander d'activer les documents alors qu'elle vaut `aucun` ou une valeur illisible (sinon il a déjà été fait : passe au point 6). Lance :
   ```
   uv run --script "<dossier de cette skill>/../../outils/documents.py" racine-drive
   ```
   - **Trouvé** (la commande affiche un chemin) : demande « Je vois ton Google Drive. On y range tes documents (les originaux), avec une boîte `a-lire` où tu peux déposer des fichiers depuis ton téléphone ? »
   - **Introuvable** (code 4) : explique que sans Google Drive pour ordinateur, l'AIOS gardera seulement les fiches de lecture, pas les fichiers d'origine.
4. **Après un « oui »** :
   - écris la ligne `documents: drive:AIOS` dans `.aios-vault` (sans toucher aux autres lignes ; elle remplace une ligne `documents: aucun`), et retire la ligne `documents-plus-tard:` s'il y en a une ;
   - lance `uv run --script "<dossier de cette skill>/../../outils/documents.py" dossier "<dossier courant>"`, qui crée `AIOS/a-lire/` et `AIOS/documents/` dans Drive ;
   - explique en deux phrases : « Depuis ton téléphone ou ton navigateur, enregistre un document dans le dossier `AIOS/a-lire` de ton Google Drive. Ensuite, dis-moi « traite mes documents » : j'en fais une fiche et je range l'original dans `AIOS/documents`. »
5. **Refus, ou Drive introuvable** : écris la ligne `documents: aucun` dans `.aios-vault`, sans toucher aux autres lignes. `/aios:lire` (`$aios:lire`) marchera quand même avec un fichier donné directement. Pour changer d'avis plus tard (Drive installé entre-temps), il suffit de dire « active les documents » : propose-le si l'utilisateur en parle.
   **Si c'est « plus tard »**, écris `documents-plus-tard: AAAA-MM-JJ` (date du jour), sans toucher aux autres lignes, et n'écris pas de ligne `documents:`.
6. **Le rappel du bilan.** Si la tâche « Rappel du bilan » existe déjà (`aios-rappel-bilan` dans Claude Code, avec `list_scheduled_tasks`), que Drive est réglé et que sa consigne ne parle pas encore de documents à lire, propose : « Je mets à jour ton rappel du dimanche pour qu'il compte aussi tes documents à lire ? » Après accord, dans Claude Code, modifie seulement son `prompt` avec `update_scheduled_task`, en reprenant la consigne du rappel donnée dans `taches-programmees.md` (le garde-fou demandera ton accord, c'est normal). Dans Codex, guide l'utilisateur pour modifier la consigne dans la vue des tâches programmées. Sans accord, n'y touche pas.
