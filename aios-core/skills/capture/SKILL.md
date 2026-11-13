---
name: capture
description: Range une information dans le vault AIOS au bon endroit. À utiliser quand l'utilisateur dit « range ça », « note que », « garde ça », « ajoute à mon projet », ou colle une idée, une décision ou une info à conserver.
argument-hint: "<l'information à ranger>"
---

# Capturer une information

Tu ranges une information dans le vault en suivant les règles de rangement d'`AGENTS.md`. Rapide et sans friction : l'utilisateur doit pouvoir capturer en une phrase.

## Étapes

1. **Comprendre ce qu'il faut garder.** Si l'information est floue, pose une seule question ; sinon, avance.
2. **Choisir l'emplacement**, en suivant les règles d'`AGENTS.md` dans l'ordre :
   1. Lié à un projet (date de fin ou livrable) ? → la fiche du projet dans `10-projets/`.
   2. Lié à une responsabilité permanente ? → `20-domaines/`.
   3. Réutilisable, transversal (méthode, modèle, référence) ? → `30-ressources/`.
   4. Terminé ou abandonné ? → `90-archives/`.
   5. Pas sûr ? → `00-inbox/AAAA-MM-JJ-<sujet-court>.md`. C'est normal, le bilan s'en occupera.
3. **Compléter plutôt que créer.**
   - Cherche d'abord une fiche existante qui correspond (noms de dossiers, titres, en-têtes).
   - Une décision va dans `## Décisions` de la fiche, datée : `- AAAA-MM-JJ — <décision>`.
   - Une tâche va dans `## Prochaines actions` : `- [ ] <action>`.
   - Sinon, ajoute à `## Notes`.
   - Si c'est un nouveau projet ou domaine, crée sa fiche selon le schéma du plugin (`../../schemas/projet.md` ou `../../schemas/domaine.md`, par rapport au dossier de cette skill), et ajoute-le en `[[lien]]` dans la liste correspondante d'`AGENTS.md`.
4. **Relier.** Ajoute des `[[liens]]` vers le projet ou le domaine concerné quand c'est utile.
5. **Confirmer en une ligne** : où c'est rangé, sous forme de lien. Exemple : « Rangé dans [[lancement-app]] › Décisions. »

## Ce que tu ne fais jamais

- Supprimer quoi que ce soit, ou déplacer une fiche existante sans le dire.
- Enregistrer un mot de passe, une clé API, un code ou une donnée bancaire : préviens l'utilisateur à la place.
- Hésiter longuement : en cas de doute, l'inbox.
- Recopier dans le vault des données qui vivent ailleurs (emails entiers, listes de contacts) : garde seulement le fait ou la décision utile.
