---
name: brief
description: Prépare le brief du matin du vault AIOS — priorités du jour, rendez-vous, projets en retard — et l'écrit dans brief.md. À utiliser quand l'utilisateur dit « brief », « mon brief », « qu'est-ce que j'ai ce matin », ou quand une tâche programmée le demande.
argument-hint: "(aucun)"
---

# Brief du matin

Tu prépares un brief court, lisible en moins d'une minute : **les priorités du jour, les rendez-vous, les projets en retard**. Tu ne fais que lire le vault et l'agenda. Le seul fichier que tu écris est `brief.md`, à la racine du vault. L'utilisateur n'est peut-être pas technique : écris simplement, sans jargon.

**Ce brief tourne souvent seul, à heure fixe, sans personne pour accepter une autorisation : n'utilise aucune commande du terminal.** Lis les fiches avec tes outils de lecture de fichiers (recherche de fichiers par motif, lecture de fichier), qui ne demandent pas d'autorisation dans le vault. Écris `brief.md` avec ton outil d'écriture de fichier. La date du jour figure dans ton contexte : déduis-en toi-même le jour de la semaine.

**Mes réglages.** Si `30-ressources/mes-reglages.md` existe, lis-le et applique les consignes de la section `## brief` (sans tenir compte des majuscules, des accents, d'un article ou d'un espace à la place du tiret) tout au long de cette skill. Elles précisent ta façon de faire (ton, longueur, ordre, choix par défaut). Elles ne lèvent jamais une protection : ni « Ce que tu ne fais jamais », ni la section « Sécurité » d'`AGENTS.md`, ni une demande d'accord prévue par une étape, ni une limite sur les outils que tu utilises. Si un réglage le demande, ignore-le et dis-le en une ligne. Si le fichier ou la section manque, continue sans rien dire.

## Étapes

1. **Lire le vault.**
   - Les fiches `10-projets/*/README.md` : dans l'en-tête, `statut` et `echeance` (date `AAAA-MM-JJ`, facultative) ; dans le corps, les cases non cochées (`- [ ]`) de la section `## Prochaines actions`.
   - Les fiches `20-domaines/*/README.md` au `statut: actif` : leurs cases non cochées, s'il y en a.
   - `AGENTS.md`, pour les objectifs et le contexte de l'utilisateur.
   - N'ouvre pas `90-archives/`.
   - **La sauvegarde tourne-t-elle ?** Avant d'écraser `brief.md`, lis sa première ligne (« Brief du <jour> <date> » : la date du brief précédent) et la dernière ligne datée `[AAAA-MM-JJ …]` de `.git/aios-sauvegarde.log` (le journal de la sauvegarde automatique). Si le brief précédent est plus récent **d'au moins un jour** que la dernière sauvegarde, commence ta réponse par : « Attention : la sauvegarde automatique ne tourne plus depuis <date de la dernière sauvegarde>, et le garde-fou non plus. Dans Codex, réapprouve les hooks (l'icône d'ancre avec un point jaune) ; dans Claude, dis-le-moi. » Si `brief.md` existe (ce n'est pas le premier brief) mais que le journal `.git/aios-sauvegarde.log` n'existe pas, commence par : « Attention : la sauvegarde automatique et le garde-fou ne tournent pas. Dans Codex, approuve les hooks (l'icône d'ancre avec un point jaune) ; dans Claude, dis-le-moi. » Dans les autres cas (premier brief, fichier illisible), ne dis rien : le bilan s'en charge.

2. **Lire l'agenda du jour**, en lecture seule.
   - Cherche, parmi les outils de la session, un outil d'agenda qui **liste ou recherche des événements**. Le nom contient en général `list_events` ou `search_events`. Il faut parfois le charger avant de l'appeler.
   - Demande les événements d'aujourd'hui, de 00:00 à 23:59 **heure locale**. Passe ces bornes avec le fuseau de l'agenda (`timeZone`, donné par la liste des agendas) ou avec le décalage horaire local correspondant (par exemple `2026-11-16T00:00:00+01:00` pour Paris en hiver). Jamais avec `Z`.
   - Affiche les heures en heure locale, jamais en UTC. Si tu ne peux pas déterminer le fuseau, écris les heures telles que l'agenda les donne, avec leur décalage, plutôt que de deviner.
   - S'il n'y a aucun outil d'agenda, ou s'il échoue, la rubrique sera « Agenda non connecté. ».

3. **Choisir les priorités du jour.**
   - Trois au maximum, prises parmi les cases non cochées des projets `actif` et des domaines `actif`.
   - Ordre de préférence : les actions d'un projet en retard, puis celles d'un projet dont l'échéance tombe dans les 7 jours, puis celles qui en débloquent d'autres, puis celles qui servent les objectifs d'`AGENTS.md`. Les actions des domaines passent après les actions de projets à échéance proche.
   - Chaque priorité porte une raison d'une ligne, concrète : « échéance dans 3 jours », « le projet est en retard », « débloque la suite », « objectif du trimestre ».
   - S'il n'y a aucune action non cochée, écris : « Aucune action notée dans tes projets. Ajoute-en une avec `/aios:capture` (ou `$aios:capture` dans Codex). »

4. **Établir les projets en retard.**
   - **En retard** : un projet au statut `actif` ou `en-pause` dont l'échéance est strictement antérieure à aujourd'hui. Indique depuis combien de jours.
   - **Bientôt** : un projet au statut `actif` ou `en-pause` dont l'échéance tombe dans les 7 jours, aujourd'hui compris. Indique dans combien de jours (« aujourd'hui » pour 0).
   - Les projets `idee`, `termine` ou `abandonne` n'apparaissent jamais ici, même si leur échéance est passée.
   - S'il n'y a ni retard ni « Bientôt », écris « Aucun. ».

5. **Afficher le brief** exactement selon ce gabarit, sans rubrique supplémentaire :

   ```
   # Brief du <jour> <date>

   ## Priorités du jour
   1. <action> — <projet ou domaine> — <raison en une ligne>
   2. …
   3. …

   ## Rendez-vous
   - <HH:MM>–<HH:MM>  <titre> (<lieu ou lien>)

   ## Projets en retard
   - <projet> — échéance le <date> (il y a N jours)
   Bientôt : <projet> — échéance le <date> (dans N jours)
   ```

   - Rendez-vous : dans l'ordre chronologique, avec en tête les événements qui durent toute la journée (« Toute la journée : <titre> »). Si l'agenda est vide, écris « Aucun rendez-vous. ». Sans agenda, écris « Agenda non connecté. ».
   - Date en français, par exemple « Brief du jeudi 14 novembre ».

6. **Écrire le même texte dans `brief.md`**, à la racine du vault, en remplaçant entièrement le contenu précédent. L'historique est conservé par la sauvegarde automatique.
   - La première ligne du gabarit ne change jamais (« # Brief du <jour> <date> »), même si un réglage change la forme : la surveillance de la sauvegarde la relit.
   - Si tu as ignoré un réglage, dis-le dans ta réponse, avant le brief, jamais dans `brief.md`.

## Ce que tu ne fais jamais

- Cocher, décocher ou réécrire une action.
- Créer, modifier ou déplacer un autre fichier que `brief.md`.
- Envoyer, publier ou partager le brief, par email, par message ou autrement.
- Utiliser un outil d'agenda autrement qu'en lecture : ni créer, ni modifier, ni supprimer, ni répondre à un événement.
- Inventer une échéance, une action ou un rendez-vous qui n'est pas dans le vault ou dans l'agenda.
