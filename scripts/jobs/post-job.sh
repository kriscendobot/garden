#!/bin/bash
# post-job.sh — producer primitive: put a job onto the board's todo/.
#
# Usage: post-job.sh <basename> [<body-file>]
#   <basename>   reserved job name; the spine that ties todo↔doin↔tada↔worktree.
#                Must be filesystem- and git-ref-safe; keep it short.
#   <body-file>  optional file whose contents become the job body. If omitted,
#                the body is read from stdin (or a one-line placeholder).
#
# Idempotent: if <basename> already exists anywhere in the lifecycle
# (todo/doin/tada) the post is a no-op success — a triager that re-sees the
# same change across ticks will not duplicate the job, provided the basename
# is derived deterministically from the change identity.
#
# Posts are ADDS, which never conflict the way claims do, so on a rejected
# push we simply re-sync and retry.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="post"

usage() {
  cat <<'EOF'
post-job.sh — put a job onto the board's todo/.

Usage: post-job.sh <basename> [<body-file>]
  <basename>   reserved job name (filesystem- and git-ref-safe; must not start
               with '-'); the spine tying todo<->doin<->tada<->worktree.
  <body-file>  optional; the job body. If omitted, read from stdin (or a
               one-line placeholder).
EOF
}

# Intercept help BEFORE consuming the positional, so a '--help' typo cannot be
# posted verbatim as a real job basename.
case "${1:-}" in -h|--help) usage; exit 0;; esac

base="${1:?usage: post-job.sh <basename> [body-file]}"
body_src="${2:-}"

case "$base" in
  -*)        die "illegal basename: '$base' (names must not start with '-'; run --help for usage)";;
  */*|.*|'') die "illegal basename: '$base'";;
esac

# Body source guard: a non-empty $2 that is not a readable file is almost always
# a mistake (an inline body STRING passed where a body-FILE path is expected).
# Without this, read_body falls through to `cat` on stdin — and with a non-tty
# stdin (every background / `claude -p` / systemd context) that blocks forever,
# wedging the shared producer lock (garden-harden-producer-body-read-hang). Fail
# fast, mirroring journal-entry.sh and land-journal-edit.sh.
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path, or feed the body on stdin / leave \$2 empty for a placeholder)"
fi

# Producer uses a shared clone (one is fine; posts don't compete on a worktree).
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

read_body() {
  if   [ -n "$body_src" ] && [ -f "$body_src" ]; then cat "$body_src"
  elif [ ! -t 0 ];                                then cat
  else printf '# %s\n\n(posted %s by %s)\n' "$base" "$(date -u +%FT%TZ)" "$GARDEN_HOST"
  fi
}
BODY="$(read_body)"

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  if [ -e "$DIR/$JOBS_TODO/$base.md" ] || [ -e "$DIR/$JOBS_DOIN/$base.md" ] || [ -e "$DIR/$JOBS_TADA/$base.md" ]; then
    log "job '$base' already present in lifecycle; nothing to do"
    exit 0
  fi
  mkdir -p "$DIR/$JOBS_TODO"
  printf '%s\n' "$BODY" > "$DIR/$JOBS_TODO/$base.md"
  git -C "$DIR" add "$JOBS_TODO/$base.md"
  if commit_and_push "$DIR" "todo($base) posted by $GARDEN_HOST"; then
    log "posted '$base'"
    exit 0
  fi
  log "post of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff
done
die "could not post '$base' after retries"
