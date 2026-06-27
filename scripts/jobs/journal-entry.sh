#!/bin/bash
# journal-entry.sh — post a progress/communication entry to the journal.
#
# Usage: journal-entry.sh <kind> [<body-file>]
#   <kind>  e.g. progress, claim, result, message
#   body    from <body-file>, else stdin, else a placeholder.
#
# Adopts the garden's practice of agents narrating their work into the journal.
# Entries live under entries/<YYYY>/<MM>/<DD>/<HHMMSSZ>-<kind>-<role>-<id>.md
# and are add-only, so a rejected push just re-syncs and retries.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="entry"

# Print the leading comment block as usage (mirrors land-journal-edit.sh).
usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"; }

# -h/--help is a query, not an entry: print usage and exit without writing or
# pushing. Before this guard, `journal-entry.sh --help` wrote a permanent
# append-only entry with `kind: --help` (the stray 115515Z---help-* entry).
case "${1:-}" in -h|--help) usage; exit 0 ;; esac

kind="${1:?usage: journal-entry.sh <kind> [body-file]}"
# Reject a malformed kind before the clone/push loop so a typo or stray flag
# fails fast instead of polluting the append-only journal. A real kind is a
# lowercase-letter-led token (progress, claim, result, message, dispatch, error,
# tick, worktree, …); anything dash-led, uppercase, or otherwise shaped is a
# mistake.
case "$kind" in
  [a-z]*) : ;;
  *) die "unknown kind: '$kind' (a kind is a lowercase-letter-led token like progress, result, message; try --help)" ;;
esac
case "$kind" in
  *[!a-z0-9_-]*) die "unknown kind: '$kind' (a kind may contain only lowercase letters, digits, '_' and '-')" ;;
esac

body_src="${2:-}"
role="${GARDEN_ROLE:-gardener}"

# Body source guard: a non-empty $2 that is not a readable file is almost always
# a mistake (an inline body string passed where a body-FILE path is expected).
# Without this, the script silently falls through to reading stdin — and with a
# non-tty stdin it blocks on `cat` forever (the inline-body stdin hang, the same
# unguarded-argv class as garden-harden-producer-body-read-hang). Fail fast.
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path, or feed the body on stdin / leave \$2 empty for a placeholder)"
fi

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="(no body)"; fi

day="$(date -u +%Y/%m/%d)"
stamp="$(date -u +%H%M%SZ)"
sid="$(od -An -N3 -tx1 /dev/urandom | tr -d ' \n')"
rel="entries/$day/${stamp}-${kind}-${role}-${sid}.md"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/$(dirname "$rel")"
  {
    printf -- '---\nkind: %s\nrole: %s\nhost: %s\nat: %s\n---\n' \
      "$kind" "$role" "$GARDEN_HOST" "$(date -u +%FT%TZ)"
    printf '%s\n' "$BODY"
  } > "$DIR/$rel"
  git -C "$DIR" add "$rel"
  if commit_and_push "$DIR" "$kind: $role on $GARDEN_HOST"; then
    log "posted $rel"; exit 0
  fi
  backoff
done
die "could not post journal entry after retries"
