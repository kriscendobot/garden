#!/bin/bash
# Place, replace, or remove one registered secret without exposing its value.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"

usage() { echo "usage: set-key.sh <kind> [--stdin|--remove] [--authorized-by LABEL]"; }
[ "$#" -ge 1 ] || { usage >&2; exit 2; }
kind="$1"; shift
mode=terminal authorized_by="maintainer:${USER:-operator}"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --stdin) [ "$mode" = terminal ] || { usage >&2; exit 2; }; mode=stdin; shift ;;
    --remove) [ "$mode" = terminal ] || { usage >&2; exit 2; }; mode=remove; shift ;;
    --authorized-by) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; authorized_by="$2"; shift 2 ;;
    *) usage >&2; exit 2 ;;
  esac
done
secret_kind_valid "$kind" || { echo "unknown secret kind: $kind" >&2; exit 2; }
[[ "$authorized_by" =~ ^[A-Za-z0-9][A-Za-z0-9._:/@+-]{0,127}$ ]] || { echo "$kind: invalid authorization label" >&2; exit 2; }
secret_ensure_directory
target="$(secret_path "$kind")"
tmp="" rollback="$GARDEN_SECRETS_DIR/.rollback.$kind.$$"
cleanup() { [ -z "$tmp" ] || rm -f "$tmp"; [ ! -e "$rollback" ] || mv -f "$rollback" "$target"; }
trap cleanup EXIT HUP INT TERM

if [ "$mode" != remove ]; then
  tmp="$(mktemp "$GARDEN_SECRETS_DIR/.new.$kind.XXXXXX")"
  chmod 0600 "$tmp"
  if [ "$mode" = stdin ]; then
    command cat > "$tmp"
  else
    [ -t 0 ] || { echo "$kind: terminal input requires a terminal; use --stdin" >&2; exit 2; }
    IFS= read -r -s value || true
    printf '\n' >&2
    printf '%s' "$value" > "$tmp"
    unset value
  fi
  secret_validate_file "$kind" "$tmp"
  sync -f "$tmp"
fi

exec {lock_fd}<"$GARDEN_SECRETS_DIR"
flock -x "$lock_fd"
[ ! -e "$target" ] || mv "$target" "$rollback"
if [ "$mode" = remove ]; then
  action=remove
else
  [ -e "$rollback" ] && action=replace || action=place
  mv "$tmp" "$target"; tmp=""
  chmod 0600 "$target"
  sync -f "$target"
fi
sync -f "$GARDEN_SECRETS_DIR"

body="$(jq -cn --arg kind "$kind" --arg action "$action" --arg at "$(date -u +%FT%TZ)" \
  --arg authorized_by "$authorized_by" '{kind:$kind,action:$action,placed_at:$at,authorized_by:$authorized_by}')"
secret_clear_env_args
if ! env "${SECRET_CLEAR_ENV_ARGS[@]}" "$HERE/../outbound/record.sh" \
  secrets "$authorized_by" EXEC "/$kind" "$body" "$kind" "$action"; then
  rm -f "$target"
  [ ! -e "$rollback" ] || mv "$rollback" "$target"
  sync -f "$GARDEN_SECRETS_DIR"
  echo "$kind: ledger write failed; prior state restored" >&2
  exit 1
fi
rm -f "$rollback"
flock -u "$lock_fd"
trap - EXIT HUP INT TERM
echo "$kind: $action recorded"
