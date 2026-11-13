#!/usr/bin/env bash
# Pose la structure d'un vault AIOS dans <dossier-cible>, sans jamais écraser.
# Affiche "+ chemin" pour chaque fichier créé.
set -u
ICI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$ICI/lib.sh"
TEMPLATE="$ICI/../template"

cible="$(chemin_unix "${1:?usage: poser-structure.sh <dossier-cible>}")"
mkdir -p "$cible" || exit 1

cd "$TEMPLATE" || exit 1
find . -type f | sort | while IFS= read -r f; do
  rel="${f#./}"
  if [ ! -e "$cible/$rel" ]; then
    mkdir -p "$cible/$(dirname "$rel")"
    cp "$f" "$cible/$rel"
    printf '+ %s\n' "$rel"
  fi
done

if [ ! -d "$cible/.git" ]; then
  # Sans -b (Git < 2.28) : la branche par défaut est fixée à "main" ensuite.
  if git -C "$cible" init -q 2>/dev/null && git -C "$cible" symbolic-ref HEAD refs/heads/main 2>/dev/null; then
    printf '+ %s\n' ".git (dépôt initialisé)"
  else
    printf "Attention : Git n'a pas pu créer le dépôt de sauvegarde dans %s. Installe Git (Git for Windows), puis relance.\n" "$cible" >&2
    exit 1
  fi
fi
exit 0
