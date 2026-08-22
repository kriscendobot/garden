#!/bin/bash
# withdraw-plan.sh — producer primitive: PRUNE a parked plan job from the board,
# recording WHY, so a dead entry leaves the queue without a silent `git rm`.
#
# A plan job is parked work waiting on a gate (go-ahead / deferred / blocked /
# orchestrated; see post-plan.sh). When the reason for that work disappears —
# its target PR merged or closed, a peer job already resolved the feedback, the
# design it served was superseded — the parked entry becomes DEAD WEIGHT: it will
# never advance and only clutters the queue a producer/selector reads. This
# primitive removes such an entry the same auditable way every other board
# mutation lands: a single-basename change committed with a CAS push, NOT a
# hand `git rm` whose "why" survives only in a maintainer's memory.
#
# Withdrawal is a MOVE, not a delete: plan/<base>.md → jobs/withdrawn/<base>.md,
# with a leading `withdrawn:` frontmatter block (reason + who + when) prepended
# and the original body preserved verbatim below it. The tombstone is greppable
# ("why was X pruned?" is answered by `cat jobs/withdrawn/X.md`), and nothing in
# the fleet scans jobs/withdrawn/ as work (every watcher enumerates its own
# specific lifecycle directory — todo/doin/tada/plan's gated subsets — so the new
# sibling directory is inert), exactly as tada/ is the completion record and
# withdrawn/ is the "removed-without-completing" record.
#
# This is for MOOT entries only. Do NOT use it to shelve wanted work: a job that
# is merely deprioritized stays parked (its gate already expresses "not now"); a
# job still blocked on a live artifact stays blocked. Withdrawal asserts the work
# no longer needs doing at all.
#
# Usage:
#   withdraw-plan.sh [--by ROLE] <basename> <reason>
#
#   --by ROLE     provenance (default: $GARDEN_SENDER or "producer").
#   <basename>    the plan job to withdraw (the spine; the trailing .md is
#                 tolerated and stripped).
#   <reason>      a one-line human reason, REQUIRED — the whole point is the
#                 durable "why". Recorded in the tombstone frontmatter and the
#                 commit message.
#
# Idempotent and safe on a moved target, exactly like promote-plan.sh: if <base>
# is not in plan/ but is already past it (todo/doin/tada) or already withdrawn,
# the withdrawal is a no-op SUCCESS (a grooming pass re-run, or a job that
# completed/was-promoted out from under the survey, is not an error). Only a base
# that exists NOWHERE in the lifecycle is an error — that names a typo, not a
# resolved job. Withdrawal is a move touching one basename, so — like a promotion
# or a completion — it RETRIES WITH BACKOFF until it lands rather than backing off
# like a claim.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="withdraw-plan"

# The withdrawn tombstone shelf. A sibling of plan/todo/doin/tada under jobs/,
# deliberately NOT one of the JOBS_* lifecycle dirs any watcher enumerates.
JOBS_WITHDRAWN="jobs/withdrawn"

usage() {
  cat <<'EOF'
withdraw-plan.sh — prune a moot parked plan job, recording why.

Usage:
  withdraw-plan.sh [--by ROLE] <basename> <reason>

  --by ROLE     provenance (default: $GARDEN_SENDER or "producer").
  <basename>    the plan job to withdraw (trailing .md tolerated).
  <reason>      REQUIRED one-line reason (the durable "why").

Moves plan/<base>.md → jobs/withdrawn/<base>.md with a `withdrawn:` frontmatter
block prepended and the original body preserved. No-op success if <base> already
moved past plan/ (todo/doin/tada) or is already withdrawn; error only if <base>
is nowhere in the lifecycle.
EOF
}

by="${GARDEN_SENDER:-producer}"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --by)      by="${2:?--by needs a value}"; shift 2;;
    --)        shift; break;;
    -*)        die "unknown option: '$1' (run --help for usage)";;
    *)         break;;
  esac
done

base="${1:?usage: withdraw-plan.sh [--by ROLE] <basename> <reason>}"
reason="${2:-}"
case "$base" in
  -*)        die "illegal basename: '$base' (names must not start with '-')";;
  */*|.*|'') die "illegal basename: '$base'";;
esac
base="${base%.md}"
[ -n "$reason" ] || die "a withdrawal reason is REQUIRED (the durable 'why'): withdraw-plan.sh <basename> <reason>"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"

  if [ ! -e "$DIR/$JOBS_PLAN/$base.md" ]; then
    # Already moved past plan/ (promoted/claimed/completed) or already withdrawn:
    # a re-run or a job resolved out from under the survey — a no-op, not a fault.
    if [ -e "$DIR/$JOBS_TODO/$base.md" ] || [ -e "$DIR/$JOBS_DOIN/$base.md" ] \
       || [ -e "$DIR/$JOBS_WITHDRAWN/$base.md" ] || tada_exists "$DIR" "$base"; then
      log "job '$base' is not in plan/ (already promoted, completed, or withdrawn); nothing to do"
      clone_unlock "$DIR"
      exit 0
    fi
    clone_unlock "$DIR"
    die "no plan job '$base' to withdraw (not in plan/, todo/, doin/, tada/, or withdrawn/)"
  fi

  src="$DIR/$JOBS_PLAN/$base.md"
  gate="$(plan_gate "$src")"
  mkdir -p "$DIR/$JOBS_WITHDRAWN"
  {
    printf -- '---\n'
    printf 'withdrawn: true\n'
    printf 'withdrawn_reason: %s\n' "$reason"
    printf 'withdrawn_by: %s\n' "$by"
    printf 'withdrawn_at: %s\n' "$(date -u +%FT%TZ)"
    printf 'withdrawn_from_gate: %s\n' "$gate"
    printf -- '---\n\n'
    cat "$src"
  } > "$DIR/$JOBS_WITHDRAWN/$base.md"
  git -C "$DIR" rm -q "$JOBS_PLAN/$base.md"
  git -C "$DIR" add "$JOBS_WITHDRAWN/$base.md"

  if commit_and_push "$DIR" "withdraw($base) plan→withdrawn [$gate] by $GARDEN — $reason"; then
    log "withdrew '$base' (gate=$gate): $reason"
    exit 0
  fi
  log "withdraw of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not withdraw '$base' after retries"
