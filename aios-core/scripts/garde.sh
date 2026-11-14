#!/usr/bin/env bash
# Hook PreToolUse AIOS : exige une validation pour toute action sensible d'un
# connecteur (outils mcp__…) : envoi, publication, programmation, suppression…
# Ne s'applique que dans un vault AIOS. En mode automatique, et toujours dans Codex, l'action est refusée.
# Rapide : la vérification du verbe se fait en bash pur avant toute autre chose.
ICI="${BASH_SOURCE[0]%/*}"
. "$ICI/lib.sh"

VERBES_SENSIBLES=" send forward reply respond post publish unpublish schedule delete trash remove cancel merge unsubscribe "
# Repli : ces mots détectés même collés à d'autres (ex. "sendemail").
SOUS_CHAINES="send publish delete trash schedule"

# verbe_sensible <nom-outil> : met le premier verbe sensible dans VERBE, ou "".
verbe_sensible() {
  local nom="${1##*__}" sep="" i c prec="" j s
  VERBE=""
  # Séparer camelCase (minuscule/chiffre suivi d'une majuscule)
  for ((i = 0; i < ${#nom}; i++)); do
    c="${nom:i:1}"
    if [[ "$c" == [A-Z] && "$prec" == [a-z0-9] ]]; then sep+=" "; fi
    sep+="$c"; prec="$c"
  done
  sep="${sep,,}"
  sep="${sep//[^a-z0-9]/ }"
  local mots=($sep) k
  for ((k = 0; k < ${#mots[@]}; k++)); do
    j="${mots[k]}"
    # "post" en dernier mot est un nom (get_blog_post), pas un verbe (post_message).
    if [ "$j" = "post" ] && [ "$k" -eq $((${#mots[@]} - 1)) ] && [ "$k" -gt 0 ]; then continue; fi
    if [[ "$VERBES_SENSIBLES" == *" $j "* ]]; then VERBE="$j"; return; fi
  done
  for s in $SOUS_CHAINES; do
    if [[ "$sep" == *"$s"* ]]; then VERBE="$s"; return; fi
  done
}

IFS= read -r -d '' entree
json_extraire "$entree" tool_name
outil="$JSON_VAL"
[[ "$outil" == mcp__* ]] || exit 0
# Tâches programmées de l'app de bureau : créer et lister sont libres (local, sans envoi).
# Modifier, supprimer ou lancer une tâche existante reste gardé : une consigne réécrite
# tournerait ensuite chaque jour sans contrôle.
case "$outil" in
  mcp__scheduled-tasks__create_scheduled_task|mcp__scheduled-tasks__list_*) exit 0 ;;
esac
verbe_sensible "$outil"
[ -n "$VERBE" ] || exit 0

json_extraire "$entree" cwd
cwd="$JSON_VAL"
trouver_vault "${cwd:-.}" >/dev/null || trouver_vault "$PWD" >/dev/null || exit 0

json_extraire "$entree" permission_mode
# Codex ne sait pas « demander » depuis un hook (un ask est ignoré et l'action part) :
# on y refuse toute action sensible, l'utilisateur la fait lui-même.
if [ -n "${CODEX_SHELL:-}" ] || [ "${AIOS_MOTEUR:-}" = "codex" ]; then JSON_VAL="codex"; fi
case "$JSON_VAL" in
  codex)
    decision="deny"
    raison="AIOS : action sensible ($VERBE) bloquée dans Codex — fais-la toi-même (par exemple directement dans l'app concernée) ou depuis Claude."
    ;;
  default|acceptEdits|plan|"")
    decision="ask"
    raison="AIOS : action sensible ($VERBE) — validation requise."
    ;;
  *)
    decision="deny"
    raison="AIOS : action sensible ($VERBE) bloquée en mode automatique — fais-la toi-même ou repasse en mode normal."
    ;;
esac

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}\n' \
  "$decision" "$raison"
exit 0
