#!/bin/bash
# post-plan.sh — producer primitive: PARK a job in the board's plan/ category.
#
# A plan job is NOT yet ready to be claimed. Gardeners claim only from jobs/todo/;
# they never see jobs/plan/. A plan job is parked for one of three reasons (its
# "gate"):
#   - go-ahead : needs the maintainer's authorization before ANY work runs. Only
#                the maintainer (via the liaison, or the proxy within its bounds)
#                ever promotes it — never auto-selected.
#   - deferred : parked behind higher-priority items, to be SELECTED by priority/
#                urgency. The foreman may auto-promote the top deferred plan job
#                when the board is idle.
#   - blocked  : parked behind an ARTIFACT (a pull request or another job) named in
#                its `blocked_on:` field. NEVER auto-selected (not by the foreman,
#                not by priority); promoted ONLY by the unblock watcher
#                (unblock.sh) when its blocker completes — a PR merges/closes or a
#                blocking job lands in tada/. Requires --blocked-on.
#   - orchestrated : a child sub-job of an orchestration (jobs/orch/<orch-base>).
#                NEVER auto-selected (not by the foreman, not by unblock); promoted
#                ONLY by the deterministic orchestrate.sh watcher, which sequences
#                the orchestration's children into todo/ per its order (serial |
#                parallel) and watches them to completion. The `orchestrated-by:`
#                field names the owning orchestration; requires --orchestrated-by.
#                See skills/orchestration/SKILL.md.
# It becomes work only when promote-plan.sh moves plan/<base> → todo/<base>.
#
# Usage:
#   post-plan.sh [--go-ahead|--deferred|--blocked|--orchestrated]
#                [--blocked-on ARTIFACT] [--orchestrated-by ORCH-BASE]
#                [--priority LEVEL] [--roadmap ITEM] [--by ROLE] <basename> [body-file]
#
#   --go-ahead / --deferred / --blocked / --orchestrated
#                            the gate reason. Default: --deferred (the common
#                            producer action is to park; the others are explicit).
#   --blocked-on ARTIFACT    the blocker for a --blocked job: a PR URL or a job
#                            basename. Required with --blocked; illegal otherwise.
#   --orchestrated-by ORCH   the owning orchestration base for an --orchestrated
#                            child. Required with --orchestrated; illegal otherwise.
#   --priority LEVEL         urgent|high|normal|low (default normal). The
#                            selection key the foreman uses for deferred jobs.
#   --roadmap ITEM           optional roadmap item / milestone this serves, so a
#                            future roadmap-aware selector can rank by it.
#   --role ROLE              the role a gardener WEARS to do the work (designer,
#                            builder, fixer, …). Stamped as the `role:` field, it
#                            selects the per-role default model (common.sh
#                            role_default_model: designer->Fable, builder->Opus)
#                            when the job names no explicit model. Distinct from
#                            --by (the producer's provenance).
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
  post-plan.sh [--go-ahead|--deferred|--blocked|--orchestrated]
               [--blocked-on ARTIFACT] [--orchestrated-by ORCH-BASE]
               [--priority LEVEL] [--roadmap ITEM] [--by ROLE] <basename> [body-file]

  --go-ahead / --deferred / --blocked / --orchestrated  the gate reason (default --deferred).
  --blocked-on ARTIFACT    the blocker (PR URL or job basename); required with --blocked.
  --orchestrated-by ORCH   the owning orchestration base; required with --orchestrated.
  --priority LEVEL         urgent|high|normal|low (default normal).
  --roadmap ITEM           optional roadmap item this serves.
  --role ROLE              the role a gardener wears to do the work; stamped as
                           `role:` and used to pick the per-role default model.
  --by ROLE                provenance (default: $GARDEN_SENDER or "producer").
  <basename>               the spine; must not start with '-'.
  [body-file]              the work body; if omitted, read from stdin.
EOF
}

gate="deferred"
priority="normal"
roadmap=""
blocked_on=""
orchestrated_by=""
role=""
by="${GARDEN_SENDER:-producer}"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)    usage; exit 0;;
    --go-ahead)   gate="go-ahead"; shift;;
    --deferred)   gate="deferred"; shift;;
    --blocked)    gate="blocked"; shift;;
    --orchestrated) gate="orchestrated"; shift;;
    --blocked-on) blocked_on="${2:?--blocked-on needs a value}"; shift 2;;
    --orchestrated-by) orchestrated_by="${2:?--orchestrated-by needs a value}"; shift 2;;
    --priority)   priority="${2:?--priority needs a value}"; shift 2;;
    --roadmap)    roadmap="${2:?--roadmap needs a value}"; shift 2;;
    --role)       role="${2:?--role needs a value}"; shift 2;;
    --by)         by="${2:?--by needs a value}"; shift 2;;
    --)           shift; break;;
    -*)           die "unknown option: '$1' (run --help for usage)";;
    *)            break;;
  esac
done

base="${1:?usage: post-plan.sh [--go-ahead|--deferred|--blocked] [--blocked-on A] [--priority L] [--roadmap I] [--by R] <basename> [body-file]}"
body_src="${2:-}"

case "$base" in
  -*)        die "illegal basename: '$base' (names must not start with '-')";;
  */*|.*|'') die "illegal basename: '$base'";;
esac
case "$gate" in go-ahead|deferred|blocked|orchestrated) :;; *) die "illegal gate: '$gate'";; esac
# A blocked job is meaningless without its blocker; a blocker is meaningless on a
# non-blocked gate. Enforce both so the unblock watcher never sees a malformed edge.
if [ "$gate" = "blocked" ] && [ -z "$blocked_on" ]; then
  die "--blocked requires --blocked-on ARTIFACT (a PR URL or a job basename)"
fi
if [ "$gate" != "blocked" ] && [ -n "$blocked_on" ]; then
  die "--blocked-on is only valid with --blocked"
fi
# An orchestrated child must name its owning orchestration; the field is only
# meaningful on that gate.
if [ "$gate" = "orchestrated" ] && [ -z "$orchestrated_by" ]; then
  die "--orchestrated requires --orchestrated-by ORCH-BASE (the owning orchestration)"
fi
if [ "$gate" != "orchestrated" ] && [ -n "$orchestrated_by" ]; then
  die "--orchestrated-by is only valid with --orchestrated"
fi

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
  else printf '# %s\n\n(planned %s by %s)\n' "$base" "$(date -u +%FT%TZ)" "$GARDEN"
  fi
}
BODY="$(read_body)"

# Assemble the plan job: frontmatter (gate/blocked_on/priority/roadmap/provenance)
# then body.
compose() {
  printf -- '---\n'
  printf 'gate: %s\n' "$gate"
  [ -n "$blocked_on" ] && printf 'blocked_on: %s\n' "$blocked_on"
  [ -n "$orchestrated_by" ] && printf 'orchestrated_by: %s\n' "$orchestrated_by"
  printf 'priority: %s\n' "$priority"
  [ -n "$roadmap" ] && printf 'roadmap: %s\n' "$roadmap"
  [ -n "$role" ] && printf 'role: %s\n' "$role"
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
  if commit_and_push "$DIR" "plan($base) parked [$gate/$priority] by $GARDEN"; then
    log "parked '$base' in plan/ (gate=$gate priority=$priority)"
    exit 0
  fi
  log "post-plan of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not park '$base' after retries"
