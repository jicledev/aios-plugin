#!/usr/bin/env bash
# Sauvegarde AIOS : enregistre (commit) les changements du vault et les pousse
# en arrière-plan si un remote "origin" existe. Toujours silencieux, toujours code 0.
# Usage : hook Stop (JSON avec "cwd" sur stdin), ou  sauvegarde.sh <dossier-du-vault>
ICI="${BASH_SOURCE[0]%/*}"
. "$ICI/lib.sh"

if [ -n "${1:-}" ]; then
  depart="$1"
else
  IFS= read -r -d '' entree
  json_extraire "$entree" cwd
  depart="${JSON_VAL:-$PWD}"
fi
vault="$(trouver_vault "$depart")" || vault="$(trouver_vault "$PWD")" || exit 0
[ -d "$vault/.git" ] || exit 0

# Identité de repli : sans elle, aucune sauvegarde ne se ferait jamais.
if [ -z "$(git -C "$vault" config user.email 2>/dev/null)" ] || [ -z "$(git -C "$vault" config user.name 2>/dev/null)" ]; then
  export GIT_AUTHOR_NAME="AIOS" GIT_AUTHOR_EMAIL="aios@localhost" \
         GIT_COMMITTER_NAME="AIOS" GIT_COMMITTER_EMAIL="aios@localhost"
fi

log="$vault/.git/aios-sauvegarde.log"
{
  printf '\n[%s]\n' "$(date '+%Y-%m-%d %H:%M:%S')"
  git -C "$vault" add -A
  # Un dépôt de code placé dans le vault ne doit pas y être enregistré (spec §7).
  git -C "$vault" ls-files -s | while IFS= read -r ligne; do
    case "$ligne" in
      160000\ *)
        p="${ligne#*$'\t'}"
        git -C "$vault" rm -q -f --cached "$p"
        grep -qxF "/$p/" "$vault/.git/info/exclude" 2>/dev/null || printf '/%s/\n' "$p" >>"$vault/.git/info/exclude"
        echo "dépôt imbriqué ignoré : $p (le code doit vivre hors du vault)"
        ;;
    esac
  done
  n="$(git -C "$vault" diff --cached --name-only | wc -l | tr -d ' ')"
  if [ "$n" -gt 0 ]; then
    if [ "$n" -gt 1 ]; then pluriel="fichiers"; else pluriel="fichier"; fi
    git -C "$vault" commit -q -m "sauvegarde auto $(date '+%Y-%m-%d %H:%M') — $n $pluriel"
  else
    echo "rien à enregistrer"
  fi
} >>"$log" 2>&1

# Push en arrière-plan : jamais d'invite de connexion, un seul à la fois.
if git -C "$vault" remote get-url origin >/dev/null 2>&1; then
  verrou="$vault/.git/aios-push.lock"
  find "$verrou" -maxdepth 0 -mmin +10 -exec rmdir {} \; 2>/dev/null
  if mkdir "$verrou" 2>/dev/null; then
    (
      GIT_TERMINAL_PROMPT=0 GCM_INTERACTIVE=never \
        git -C "$vault" push -q -u origin HEAD
      rmdir "$verrou"
    ) </dev/null >>"$vault/.git/aios-push.log" 2>&1 &
  fi
fi
exit 0
