#!/bin/bash
# post-plan.sh — producer primitive: PARK a job in the board's plan/ category.
#
# A plan job is NOT yet ready to be claimed. Gardeners claim only from jobs/todo/;
# they never see jobs/plan/. A plan job is parked for one of two reasons (its
# "gate"):
#   - go-ahead : needs the maintainer's authorization before ANY work runs. Only
#                the maintainer (via the liaison, or the proxy within its bounds)
#                ever promotes it — never auto-selected.
#   - deferred : parked behind higher-priority items, to be SELECTED by priority/
#                urgency. The foreman may auto-promote the top deferred plan job
#                when the board is idle.
# It becomes work only when promote-plan.sh moves plan/<base> → todo/<base>.
#
# Usage:
#   post-plan.sh [--go-ahead|--deferred] [--priority LEVEL] [--roadmap ITEM]
#                [--by ROLE] <basename> [body-file]
#
#   --go-ahead / --deferred  the gate reason. Default: --deferred (the common
#                            producer action is to park; go-ahead is explicit).
#   --priority LEVEL         urgent|high|normal|low (default normal). The
#                            selection key the foreman uses for deferred jobs.
#   --roadmap ITEM           optional roadmap item / milestone this serves, so a
#                            future roadmap-aware selector can rank by it.
#   --by ROLE                provenance (default: $GARDEN_SENDER or "producer").
#   <basename>               the spine: ties plan↔todo↔doin↔tada↔worktree.
#   [body-file]              the work body; if omitted, read from stdin (or a
#                            one-line placeholder). The body becomes the todo job
#                            verbatim on promotion.
#
# Idempotent on the basename, exactly like post-job.sh: if <basename> already
# exists anywhere in the lifecycle (plan/todo/doin/tada) the post is a no-op
# success. Posts are ADDs (never conflict the way claims do), so a rejected push
# re-syncs and retries.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="post-plan"

usage() {
  cat <<'EOF'
post-plan.sh — park a job in the board's plan/ category (not yet claimable).

Usage:
  post-plan.sh [--go-ahead|--deferred] [--priority LEVEL] [--roadmap ITEM]
               [--by ROLE] <basename> [body-file]

  --go-ahead / --deferred  the gate reason (default --deferred).
  --priority LEVEL         urgent|high|normal|low (default normal).
  --roadmap ITEM           optional roadmap item this serves.
  --by ROLE                provenance (default: $GARDEN_SENDER or "producer").
  <basename>               the spine; must not start with '-'.
  [body-file]              the work body; if omitted, read from stdin.
EOF
}

gate="deferred"
priority="normal"
roadmap=""
by="${GARDEN_SENDER:-producer}"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)  usage; exit 0;;
    --go-ahead) gate="go-ahead"; shift;;
    --deferred) gate="deferred"; shift;;
    --priority) priority="${2:?--priority needs a value}"; shift 2;;
    --roadmap)  roadmap="${2:?--roadmap needs a value}"; shift 2;;
    --by)       by="${2:?--by needs a value}"; shift 2;;
    --)         shift; break;;
    -*)         die "unknown option: '$1' (run --help for usage)";;
    *)          break;;
  esac
done

base="${1:?usage: post-plan.sh [--go-ahead|--deferred] [--priority L] [--roadmap I] [--by R] <basename> [body-file]}"
body_src="${2:-}"

case "$base" in
  -*)        die "illegal basename: '$base' (names must not start with '-')";;
  */*|.*|'') die "illegal basename: '$base'";;
esac
case "$gate" in go-ahead|deferred) :;; *) die "illegal gate: '$gate'";; esac

# Body source guard: a non-empty body arg that is not a readable file is almost
# always a mistake (an inline body STRING passed where a body-FILE path is
# expected). Without this, read_body falls through to `cat` on stdin — and with a
# non-tty stdin (every background / `claude -p` / systemd context) that blocks
# forever, wedging the shared producer lock (garden-harden-producer-body-read-
# hang). Fail fast, mirroring journal-entry.sh and land-journal-edit.sh.
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path, or feed the body on stdin / leave the body arg empty for a placeholder)"
fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

read_body() {
  if   [ -n "$body_src" ] && [ -f "$body_src" ]; then cat "$body_src"
  elif [ ! -t 0 ];                                then cat
  else printf '# %s\n\n(planned %s by %s)\n' "$base" "$(date -u +%FT%TZ)" "$GARDEN_HOST"
  fi
}
BODY="$(read_body)"

# Assemble the plan job: frontmatter (gate/priority/roadmap/provenance) then body.
compose() {
  printf -- '---\n'
  printf 'gate: %s\n' "$gate"
  printf 'priority: %s\n' "$priority"
  [ -n "$roadmap" ] && printf 'roadmap: %s\n' "$roadmap"
  printf 'posted_by: %s\n' "$by"
  printf 'posted_at: %s\n' "$(date -u +%FT%TZ)"
  printf -- '---\n\n'
  printf '%s\n' "$BODY"
}

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  if [ -e "$DIR/$JOBS_PLAN/$base.md" ] || [ -e "$DIR/$JOBS_TODO/$base.md" ] \
     || [ -e "$DIR/$JOBS_DOIN/$base.md" ] || [ -e "$DIR/$JOBS_TADA/$base.md" ]; then
    log "job '$base' already present in lifecycle; nothing to do"
    exit 0
  fi
  mkdir -p "$DIR/$JOBS_PLAN"
  compose > "$DIR/$JOBS_PLAN/$base.md"
  git -C "$DIR" add "$JOBS_PLAN/$base.md"
  if commit_and_push "$DIR" "plan($base) parked [$gate/$priority] by $GARDEN_HOST"; then
    log "parked '$base' in plan/ (gate=$gate priority=$priority)"
    exit 0
  fi
  log "post-plan of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff
done
die "could not park '$base' after retries"
