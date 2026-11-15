#!/usr/bin/env bash
# Hook PreToolUse AIOS : exige une validation pour toute action sensible d'un
# connecteur (outils mcp__…) : envoi, publication, programmation, suppression…
# et pour toute modification d'une donnée existante (update, edit, move…).
# Créer reste libre, sauf un événement d'agenda (il s'affiche aussitôt et invite ses participants) ;
# un brouillon reste libre, même modifié ; une lecture aussi ;
# les outils de l'app Claude sur elle-même (serveur ccd_…) ne sont pas des modifications.
# Ne s'applique que dans un vault AIOS. En mode automatique, et toujours dans Codex, l'action est refusée.
# Rapide : la vérification du verbe se fait en bash pur avant toute autre chose.
ICI="${BASH_SOURCE[0]%/*}"
. "$ICI/lib.sh"

VERBES_SENSIBLES=" send forward reply respond post publish unpublish schedule delete trash remove cancel merge unsubscribe "
# Repli : ces mots détectés même collés à d'autres (ex. "sendemail").
SOUS_CHAINES="send publish delete trash schedule"
# Modifications de l'existant : mots entiers seulement (un repli retiendrait get_updates).
VERBES_MODIFICATION=" update edit modify replace overwrite patch move rename archive unarchive restore convert write upsert put revert reset clear "
# Si l'un de ces mots vient avant tout verbe de modification, l'outil est une lecture :
# les mots de modification qui suivent sont des noms (notion-get-suggested-edit).
# « find » n'y est pas : find_and_replace modifie.
VERBES_LECTURE=" get list search read fetch query view count describe export download "
# Création d'agenda : un verbe de création dans un nom d'outil qui parle d'un événement.
# « meeting » n'y est pas : une note de réunion est une page.
VERBES_CREATION=" create add insert new "
NOMS_AGENDA=" event events appointment appointments "

# verbe_sensible <nom-outil> : met le premier verbe gardé dans VERBE, ou "".
# GENRE vaut "action sensible", "modification" ou "création d'agenda".
verbe_sensible() {
  local nom="${1##*__}" sep="" i c prec="" j s
  VERBE=""; GENRE="action sensible"
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
  # Aucun verbe sensible : chercher une modification ou une création d'agenda,
  # sauf brouillon ou lecture.
  [ "${#mots[@]}" -gt 0 ] || return
  local compose=0 avant="" agenda=0
  for j in "${mots[@]}"; do
    if [[ "$NOMS_AGENDA" == *" $j "* ]]; then agenda=1; fi
    # Un nom composé (search_and_replace, get_or_update) n'est pas une simple lecture.
    case "$j" in and|or|then) compose=1 ;; esac
    # Brouillon : libre, sauf « to draft » (remettre en brouillon dépublie).
    if { [ "$j" = "draft" ] || [ "$j" = "drafts" ]; } && [ "$avant" != "to" ]; then return; fi
    avant="$j"
  done
  for j in "${mots[@]}"; do
    if [ "$compose" -eq 0 ] && [[ "$VERBES_LECTURE" == *" $j "* ]]; then return; fi
    if [[ "$VERBES_MODIFICATION" == *" $j "* ]]; then VERBE="$j"; GENRE="modification"; return; fi
    if [ "$agenda" -eq 1 ] && [[ "$VERBES_CREATION" == *" $j "* ]]; then VERBE="$j"; GENRE="création d'agenda"; return; fi
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
# L'app Claude qui agit sur elle-même (sa liste de tâches, sa barre latérale, ses sessions)
# ne modifie pas une donnée de l'utilisateur. Ses actions sensibles (envoi, suppression) restent gardées.
if [ "$GENRE" = "modification" ]; then
  case "$outil" in mcp__ccd_*__*) exit 0 ;; esac
fi

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
    raison="AIOS : $GENRE ($VERBE) bloquée dans Codex — fais-la toi-même (par exemple directement dans l'app concernée) ou depuis Claude."
    ;;
  default|acceptEdits|plan|"")
    decision="ask"
    raison="AIOS : $GENRE ($VERBE) — validation requise."
    ;;
  *)
    decision="deny"
    raison="AIOS : $GENRE ($VERBE) bloquée en mode automatique — fais-la toi-même ou repasse en mode normal."
    ;;
esac

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}\n' \
  "$decision" "$raison"
exit 0
