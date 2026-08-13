#!/bin/bash
# promote-plan.sh — move a parked plan job into the live queue: plan/<base> →
# todo/<base>, so a gardener can claim it normally.
#
# Usage: promote-plan.sh <basename>
#
# Two promotion paths feed this one primitive:
#   1. MAINTAINER GO-AHEAD — the liaison (or the proxy within its bounds) runs this
#      when the maintainer authorizes a go-ahead-gated plan job ("go ahead on X").
#      A go-ahead job is ONLY ever promoted by maintainer authorization.
#   2. PRIORITY/URGENCY SELECTION — the foreman runs this to promote the top
#      deferred plan job when the board is idle (see foreman.sh).
#
# On promotion the leading plan frontmatter (gate/priority/roadmap/provenance) is
# stripped so the todo job is the clean work body the gardener acts on; a one-line
# provenance marker records that it came from plan/. This is a move that touches
# only the job's own basename (rm plan + add todo), so — like a completion — it
# RETRIES WITH BACKOFF until it lands, rather than backing off like a claim.
#
# PROMOTION RESETS THE REAPER'S CYCLE COUNTERS. When the reaper DOOMS a job it
# parks it here in plan/ (gate=go-ahead) with its cycle markers still in the body —
# notably `<!-- garden-deadline-overrun: N -->`, which clean_body deliberately
# preserves across a requeue so the count accumulates. Passing that body through
# verbatim carried N forward into todo/, and at GARDEN_REAP_OVERRUN_THRESHOLD=1 the
# next reap cycle re-read the stale count and parked the job straight back in plan/
# WITHOUT ever granting it a requeue — promotion was a no-op the job could not
# escape (the 07-26 endo-sturdyref-agent-surface-build-gauntlet park, which then sat
# behind a go-ahead for days while the press tick advised that "a promoting liaison
# should clear or requeue past it" — a manual step no promoter reliably performs).
# So promotion CLEARS the whole marker family (reap-count, deadline-overrun, and the
# per-cycle reap-now / productive-cycle / outage-cycle hints, which are re-earned
# each cycle by construction) and records what it cleared in the provenance comment,
# so the reset is auditable rather than silent. Promotion is a deliberate "run this
# again" act, so a clean counter is the correct semantics; the reaper's protection is
# unchanged, since a job that still fails deterministically re-accumulates and
# re-dooms on its own.
#
# This is the PROMOTION half of the reset. post-plan.sh performs the same strip on the
# PARKING side, so a producer that re-parks a live job body cannot smuggle a stale
# counter into plan/ in the first place; the two share common.sh's strip helpers.
#
# Idempotent: if <base> is already past plan/ (in todo/doin/tada) the promotion is
# a no-op success. If <base> is nowhere, it is an error.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="promote-plan"

base="${1:?usage: promote-plan.sh <basename>}"
case "$base" in
  -*)        die "illegal basename: '$base'";;
  */*|.*|'') die "illegal basename: '$base'";;
esac
base="${base%.md}"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

# Strip a single leading YAML frontmatter block (--- … ---) and any blank lines
# that immediately follow it; pass the rest through unchanged.
strip_frontmatter() {
  awk '
    NR==1 && $0=="---" { infm=1; next }
    infm && $0=="---"  { infm=0; body=1; next }
    infm              { next }
    body && NF==0 && !seen { next }   # drop leading blanks after the frontmatter
    { seen=1; body=1; print }
  ' "$1"
}

# The cycle-marker strip (`strip_cycle_markers`) and the record of what it cleared
# (`cycle_marker_summary`) live in common.sh beside the marker regexes themselves,
# shared with post-plan.sh's parking-side strip and proxy.sh's blocked-job park — one
# spelling of "the family", so a marker-format change (or a sixth marker) cannot
# half-land.

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"

  if [ ! -e "$DIR/$JOBS_PLAN/$base.md" ]; then
    if [ -e "$DIR/$JOBS_TODO/$base.md" ] || [ -e "$DIR/$JOBS_DOIN/$base.md" ] \
       || [ -e "$DIR/$JOBS_TADA/$base.md" ]; then
      log "job '$base' already promoted past plan/; nothing to do"
      exit 0
    fi
    die "no plan job '$base' to promote (not in plan/, todo/, doin/, or tada/)"
  fi

  src="$DIR/$JOBS_PLAN/$base.md"
  gate="$(plan_gate "$src")"
  priority="$(plan_priority "$src")"
  # Preserve the EXECUTION keys across promotion. strip_frontmatter drops the
  # whole plan block (gate/priority are provenance, correctly consumed here),
  # but role:/model:/handler-timeout: bind how the gardener RUNS the job — the
  # per-role model pin (designer→Opus, builder→Opus) and the per-job handler
  # budget are resolved from the CLAIMED todo file, so dropping them silently
  # demoted every planned designer/builder job to the fleet default model.
  role="$(plan_field "$src" role)"
  tier="$(plan_field "$src" tier)"
  model="$(plan_field "$src" model)"
  budget_role="$(plan_field "$src" handler-budget-role)"
  htimeout="$(plan_field "$src" handler-timeout)"
  token_budget="$(plan_field "$src" token-budget)"
  budget_epoch="$(plan_field "$src" token-budget-epoch)"
  if [ "$(plan_field "$src" budget_hold)" = true ]; then
    budget_epoch="$(date -u +%FT%TZ)"
  fi
  cleared="$(cycle_marker_summary "$src")"
  mkdir -p "$DIR/$JOBS_TODO"
  {
    if [ -n "$role$tier$model$budget_role$htimeout$token_budget$budget_epoch" ]; then
      printf -- '---\n'
      [ -n "$role" ]     && printf 'role: %s\n' "$role"
      [ -n "$tier" ]     && printf 'tier: %s\n' "$tier"
      [ -n "$model" ]    && printf 'model: %s\n' "$model"
      [ -n "$budget_role" ] && printf 'handler-budget-role: %s\n' "$budget_role"
      [ -n "$htimeout" ] && printf 'handler-timeout: %s\n' "$htimeout"
      [ -n "$token_budget" ] && printf 'token-budget: %s\n' "$token_budget"
      [ -n "$budget_epoch" ] && printf 'token-budget-epoch: %s\n' "$budget_epoch"
      printf -- '---\n'
    fi
    # `at=` stays the LAST timestamp-shaped field consumers key on (orchestrate.sh
    # parses `at=<value>`); `cleared=` is appended after it as a further token.
    printf '<!-- garden-promoted-from-plan: gate=%s priority=%s at=%s cleared=%s -->\n\n' \
      "$gate" "$priority" "$(date -u +%FT%TZ)" "$cleared"
    strip_frontmatter "$src" | strip_cycle_markers
  } > "$DIR/$JOBS_TODO/$base.md"
  git -C "$DIR" rm -q "$JOBS_PLAN/$base.md"
  git -C "$DIR" add "$JOBS_TODO/$base.md"

  if commit_and_push "$DIR" "promote($base) plan→todo [$gate/$priority] by $GARDEN"; then
    log "promoted '$base' plan→todo (gate=$gate priority=$priority cleared=$cleared)"
    exit 0
  fi
  log "promote of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not promote '$base' after retries"
