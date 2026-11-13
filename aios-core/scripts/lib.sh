# Fonctions communes des scripts AIOS (à sourcer). Bash pur, sans jq/node/python.

# json_extraire <json> <nom> : met dans JSON_VAL la valeur de la première clé
# chaîne "nom" (échappements JSON décodés, \uXXXX compris), ou "". Sans sous-processus.
json_extraire() {
  local json="$1" reste c h i=0 n
  JSON_VAL=""
  reste="${json#*\"$2\"}"
  [ "$reste" = "$json" ] && return 0
  reste="${reste#"${reste%%[![:space:]]*}"}"
  [ "${reste:0:1}" = ":" ] || return 0
  reste="${reste:1}"
  reste="${reste#"${reste%%[![:space:]]*}"}"
  [ "${reste:0:1}" = '"' ] || return 0
  reste="${reste:1}"
  n=${#reste}
  while [ "$i" -lt "$n" ]; do
    c="${reste:i:1}"
    if [ "$c" = "\\" ]; then
      i=$((i + 1)); c="${reste:i:1}"
      case "$c" in
        n) JSON_VAL+=$'\n' ;;
        t) JSON_VAL+=$'\t' ;;
        r) JSON_VAL+=$'\r' ;;
        b) JSON_VAL+=$'\b' ;;
        f) JSON_VAL+=$'\f' ;;
        u) h="${reste:i+1:4}"; printf -v c "\\u$h"; JSON_VAL+="$c"; i=$((i + 4)) ;;
        *) JSON_VAL+="$c" ;;
      esac
    elif [ "$c" = '"' ]; then
      break
    else
      JSON_VAL+="$c"
    fi
    i=$((i + 1))
  done
}

# json_champ <nom> : comme json_extraire, en lisant le JSON sur stdin et en affichant la valeur.
json_champ() {
  local json
  IFS= read -r -d '' json
  json_extraire "$json" "$1"
  printf '%s' "$JSON_VAL"
}

# chemin_unix <chemin> : convertit un chemin Windows (C:\…) en chemin utilisable par bash.
chemin_unix() {
  case "$1" in
    *\\*|[A-Za-z]:*)
      if command -v cygpath >/dev/null 2>&1; then cygpath -u "$1"; return; fi ;;
  esac
  printf '%s' "$1"
}

# trouver_vault <dossier> : affiche la racine du vault (dossier contenant
# .aios-vault) en remontant depuis <dossier>. Code 1 si aucun.
trouver_vault() {
  local d
  d="$(cd "$(chemin_unix "${1:-.}")" 2>/dev/null && pwd)" || return 1
  while [ -n "$d" ]; do
    if [ -f "$d/.aios-vault" ]; then
      printf '%s' "$d"
      return 0
    fi
    [ "$d" = "/" ] && return 1
    d="${d%/*}"
    [ -z "$d" ] && d="/"
  done
  return 1
}
