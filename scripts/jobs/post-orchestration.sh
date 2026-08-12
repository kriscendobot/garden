#!/bin/bash
# post-orchestration.sh — producer primitive: record an ORCHESTRATION over a set
# of already-parked child sub-jobs, so the deterministic orchestrate.sh watcher
# sequences them into todo/ and watches them to completion.
#
# The maintainer directive (kriskowal 2026-07-01): for a MULTI-PART job, always
# make ONE orchestration job that moves the planned sub-jobs off plan/ into todo/
# in sequence (default) or in parallel, and WATCHES the children so it is less
# likely to forget to follow up with the next one. This is that job.
#
# Shape:
#   1. Park each child sub-job first with:
#        post-plan.sh --orchestrated --orchestrated-by <orch-base> <child> [body]
#      (gate=orchestrated → invisible to the foreman AND the unblock watcher; only
#      orchestrate.sh promotes it.)
#   2. Record the orchestration with THIS script, naming the children in run order.
#   The orchestrate.sh watcher then, deterministically and with NO `claude -p`:
#      - serial   : promote child #1, WATCH it reach jobs/tada/, then #2, …
#      - parallel : promote ALL children at once, then watch them all.
#   It reports progress, and on a child FAILURE applies the on-child-failure policy
#   (halt a serial run, or continue) rather than silently stalling.
#
# Relationship to blocked_on/unblock: the blocked_on + unblock.sh chain is the
# other deterministic serial primitive (child B blocked_on A → promoted when A
# lands in tada). The orchestrator builds on that same "promote when the board
# reaches a state" substrate but OWNS promotion of its children (so it can express
# parallelism, an active progress report, and a failure policy that unblock's pure
# edge-following cannot). See skills/orchestration/SKILL.md § Why not just blocked_on.
#
# Usage:
#   post-orchestration.sh [--serial|--parallel] [--on-child-failure halt|continue]
#                         [--budget-tokens N] [--resume-from TERMINAL-CAMPAIGN]
#                         [--by ROLE] [--no-validate] <orch-base> <child>... [-- body-file]
#
#   --serial | --parallel        ordering of the children (default --serial).
#   --on-child-failure halt|continue   policy on a child failure (default halt).
#   --budget-tokens N           positive billable-token cap (serial only).
#   --resume-from CAMPAIGN      adopt that terminal campaign's parked remainder.
#   --by ROLE                    provenance (default: $GARDEN_SENDER or "producer").
#   --no-validate                skip the "each child is parked in plan/" check
#                                (use only when children are posted concurrently).
#   <orch-base>                  the orchestration spine (its own basename).
#   <child>...                   child job basenames, in the order they run.
#   [-- body-file]               optional human description file for the record;
#                                if omitted a one-line placeholder is written.
#
# Idempotent on <orch-base>: if the record (or a completed tada/<orch-base>)
# already exists, the post is a no-op success. Posts are ADDs, so a rejected push
# re-syncs and retries.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="post-orch"

usage() {
  cat <<'EOF'
post-orchestration.sh — record an orchestration over parked child sub-jobs.

Usage:
  post-orchestration.sh [--serial|--parallel] [--on-child-failure halt|continue]
                        [--budget-tokens N] [--resume-from TERMINAL-CAMPAIGN]
                        [--by ROLE] [--no-validate] <orch-base> <child>... [-- body-file]

  --serial | --parallel              ordering (default --serial).
  --on-child-failure halt|continue   policy on a child failure (default halt).
  --budget-tokens N                 positive billable-token cap (serial only).
  --resume-from CAMPAIGN            atomically adopt its parked remainder under
                                    this new campaign and budget epoch.
  --by ROLE                          provenance (default $GARDEN_SENDER or producer).
  --no-validate                      skip the "child parked in plan/" precheck.
  <orch-base>                        the orchestration spine.
  <child>...                         child job basenames, in run order.
  [-- body-file]                     optional description file.
EOF
}

order="serial"
policy="halt"
by="${GARDEN_SENDER:-producer}"
validate=1
body_src=""
budget_tokens=""
resume_from=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)          usage; exit 0;;
    --serial)           order="serial"; shift;;
    --parallel)         order="parallel"; shift;;
    --on-child-failure) policy="${2:?--on-child-failure needs halt|continue}"; shift 2;;
    --budget-tokens)   budget_tokens="${2:?--budget-tokens needs a positive integer}"; shift 2;;
    --resume-from)     resume_from="${2:?--resume-from needs a terminal campaign base}"; shift 2;;
    --by)               by="${2:?--by needs a value}"; shift 2;;
    --no-validate)      validate=0; shift;;
    --)                 shift; break;;   # end of options; positionals (and a trailing
                                           # `-- body-file`) are parsed below — consuming
                                           # the next token HERE bound it as body_src AND
                                           # base at once, corrupting a conventional
                                           # leading `--` call
    -*)                 die "unknown option: '$1' (run --help for usage)";;
    *)                  break;;
  esac
done

base="${1:?usage: post-orchestration.sh [--serial|--parallel] <orch-base> <child>...}"
shift || true
case "$base" in
  -*)        die "illegal orchestration base: '$base' (names must not start with '-')";;
  */*|.*|'') die "illegal orchestration base: '$base'";;
esac
case "$order" in serial|parallel) :;; *) die "illegal order: '$order' (serial|parallel)";; esac
case "$policy" in halt|continue) :;; *) die "illegal on-child-failure: '$policy' (halt|continue)";; esac
if [ -n "$budget_tokens" ]; then
  case "$budget_tokens" in 0|*[!0-9]*) die "--budget-tokens must be a positive base-10 integer";; esac
  budget_tokens="$(sed 's/^0*//' <<<"$budget_tokens")"
  [ -n "$budget_tokens" ] || die "--budget-tokens must be greater than zero"
  [ "$order" = serial ] || die "--budget-tokens is supported only with --serial"
fi
case "$resume_from" in */*|.*|-*) die "illegal --resume-from campaign: '$resume_from'";; esac

# Collect the child basenames (everything up to a lone `--`, which starts the body).
children=()
while [ $# -gt 0 ]; do
  case "$1" in
    --) shift; body_src="${1:-}"; break;;
    *)  case "$1" in */*|.*|-*|'') die "illegal child basename: '$1'";; esac
        children+=("$1"); shift;;
  esac
done
[ "${#children[@]}" -ge 1 ] || die "an orchestration needs at least one child sub-job"

# Reject a duplicated child (a repeated basename would corrupt serial ordering and
# the done-count).
if [ "$(printf '%s\n' "${children[@]}" | sort | uniq -d | head -1)" != "" ]; then
  die "duplicate child basename in the children list"
fi

# Body guard (same rationale as post-plan.sh: an inline STRING where a FILE path is
# expected wedges the producer lock on a `cat` of a non-tty stdin).
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path or leave it empty)"
fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

read_body() {
  if   [ -n "$body_src" ] && [ -f "$body_src" ]; then cat "$body_src"
  else printf '# orchestration %s\n\n%s children (%s), on-child-failure=%s.\n' \
         "$base" "${#children[@]}" "$order" "$policy"
  fi
}
BODY="$(read_body)"

compose() {
  printf -- '---\n'
  printf 'order: %s\n' "$order"
  printf 'children: %s\n' "${children[*]}"
  printf 'on-child-failure: %s\n' "$policy"
  printf 'state: pending\n'
  [ -n "$budget_tokens" ] && printf 'budget_tokens: %s\n' "$budget_tokens"
  [ -n "$resume_from" ] && printf 'resume_from: %s\n' "$resume_from"
  printf 'created_by: %s\n' "$by"
  printf 'created_at: %s\n' "$(date -u +%FT%TZ)"
  printf -- '---\n\n'
  printf '%s\n' "$BODY"
}

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  if [ -e "$DIR/$JOBS_ORCH/$base.md" ] || [ -e "$DIR/$JOBS_TADA/$base.md" ]; then
    log "orchestration '$base' already recorded; nothing to do"
    exit 0
  fi
  resume_children=()
  if [ -n "$resume_from" ]; then
    terminal="$DIR/$JOBS_TADA/$resume_from.md"
    [ -f "$terminal" ] || die "--resume-from campaign '$resume_from' has no terminal tada report"
    grep -qE '^orchestration-status: (budget-exhausted|budget-meter-incomplete)$' "$terminal" \
      || die "--resume-from campaign '$resume_from' is not a resumable budget terminal outcome"
    read -ra resume_children <<<"$(sed -n 's/^campaign-parked-children:[[:space:]]*//p' "$terminal" | head -1)"
    [ "${#resume_children[@]}" -gt 0 ] \
      || die "--resume-from campaign '$resume_from' names no parked remainder"
    for c in "${resume_children[@]}"; do
      printf '%s\n' "${children[@]}" | grep -qx "$c" \
        || die "parked remainder child '$c' is absent from the new campaign child list"
      plan="$DIR/$JOBS_PLAN/$c.md"
      [ -f "$plan" ] || die "parked remainder child '$c' is no longer in plan/"
      [ "$(plan_gate "$plan")" = orchestrated ] \
        || die "parked remainder child '$c' is not orchestrated"
      [ "$(plan_field "$plan" orchestrated_by)" = "$resume_from" ] \
        || die "parked remainder child '$c' is not owned by '$resume_from'"
    done
  fi
  # Validate each child is parked in plan/ (the producer must park children BEFORE
  # recording the orchestration, so the watcher has something to promote). A child
  # already promoted (todo/doin/tada) is also accepted — a restart-safe re-post.
  if [ "$validate" -eq 1 ]; then
    for c in "${children[@]}"; do
      if [ ! -e "$DIR/$JOBS_PLAN/$c.md" ] && ! job_in_lifecycle "$DIR" "$c"; then
        die "child '$c' is not parked in plan/ (or anywhere on the board); park it first with post-plan.sh --orchestrated --orchestrated-by $base $c"
      fi
    done
  fi
  mkdir -p "$DIR/$JOBS_ORCH"
  compose > "$DIR/$JOBS_ORCH/$base.md"
  git -C "$DIR" add "$JOBS_ORCH/$base.md"
  # Adoption and the new orchestration record are one journal commit: a watcher
  # can see either the old ownership or the complete new budget epoch, never a
  # half-retagged remainder.
  for c in "${resume_children[@]}"; do
    sed -i "s/^orchestrated_by:.*/orchestrated_by: $base/" "$DIR/$JOBS_PLAN/$c.md"
    git -C "$DIR" add "$JOBS_PLAN/$c.md"
  done
  if commit_and_push "$DIR" "orch($base) recorded [$order/$policy, ${#children[@]} children] by $GARDEN"; then
    log "recorded orchestration '$base' ($order, ${#children[@]} children, on-child-failure=$policy)"
    exit 0
  fi
  log "post-orchestration of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not record orchestration '$base' after retries"
