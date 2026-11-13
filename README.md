# AIOS — ton système d'exploitation IA

L'AIOS transforme un simple dossier de ton ordinateur (ton **vault**) en mémoire, en règles et en recettes pour Claude. Tu n'as plus à réexpliquer ton contexte à chaque fois : Claude sait qui tu es, sur quoi tu travailles et comment tu aimes que les choses soient faites.

Ce que tu obtiens :
- un dossier bien rangé : inbox, projets, domaines, ressources, archives, journal ;
- des commandes en français : `/aios:capture` pour ranger une info, `/aios:bilan` pour faire le point de la semaine, `/aios:etat-projet` pour savoir où en est un projet, `/aios:importer` pour récupérer tes notes existantes ;
- un **brief du matin**, chaque jour de semaine à 8 h, avec tes priorités, tes rendez-vous et tes projets en retard (`/aios:brief` pour l'avoir à tout moment), et un rappel du bilan le dimanche ;
- un **garde-fou** : rien n'est envoyé, publié ou supprimé sans ton accord ;
- une **sauvegarde automatique** de ton vault.

## Ce qu'il te faut

- Un ordinateur Windows.
- Claude Code installé, et ton compte Claude connecté. L'app de bureau Claude suffit.

## Installer l'AIOS

1. **Crée un dossier vide** pour ton vault. Dans l'Explorateur Windows, va dans **Documents**, fais un clic droit, puis **Nouveau** et **Dossier**. Appelle-le `AIOS`.
2. **Ouvre l'app Claude** et va dans l'onglet **Code**.
3. **Ouvre une nouvelle session sur ce dossier** : au moment de choisir le dossier de travail, sélectionne `Documents\AIOS`.
4. **Copie cette phrase et colle-la** dans la zone de message, puis envoie-la :

   ```
   Installe l'AIOS en suivant https://github.com/jicledev/aios-plugin/blob/main/INSTALLER.md
   ```

5. **Laisse-toi guider.** Claude va te demander deux ou trois autorisations. Il te dit avant chacune à quoi elle sert : tu peux accepter.
6. **Si Claude te demande de taper quelque chose**, par exemple `/reload-plugins`, tape-le exactement comme indiqué.
7. **Réponds aux questions** de Claude sur toi, tes activités et tes projets. Compte 15 à 20 minutes. À la fin, ton vault est prêt.

> **Tu utilises Claude Code dans un terminal plutôt que dans l'app ?** Crée le dossier de la même façon, ouvre un terminal dans ce dossier, tape `claude`, puis colle la même phrase.

## Ce qui se passe pendant l'installation

Claude vérifie que le dossier est vide et que l'outil de sauvegarde (Git) est présent. Il installe ensuite le moteur de l'AIOS, te fait recharger la session, puis te pose ses questions. Il ne touche à rien en dehors de ce dossier.

## Mettre à jour l'AIOS

Ouvre une session sur ton vault et dis simplement à Claude : **« mets à jour l'AIOS »**. Ton contenu n'est jamais modifié par une mise à jour.

## Si ça bloque

- Décris le problème à Claude avec tes mots : il est là pour t'aider.
- Si Claude te dit qu'il manque **Git for Windows**, installe-le depuis https://git-scm.com/download/win en gardant les options par défaut. Ferme ensuite l'app Claude, rouvre-la sur ton dossier et recolle la phrase.
- Si ça ne va toujours pas, contacte la personne qui t'a envoyé ce lien.

## Obsidian (facultatif)

Ton vault peut aussi s'ouvrir dans Obsidian, une application gratuite pour lire et naviguer dans tes notes. Dans Obsidian, choisis « Ouvrir un dossier comme coffre » et sélectionne ton vault. Claude sert à produire, Obsidian à lire.
