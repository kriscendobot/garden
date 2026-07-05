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
  # per-role model pin (designer→Fable, builder→Opus) and the per-job handler
  # budget are resolved from the CLAIMED todo file, so dropping them silently
  # demoted every planned designer/builder job to the fleet default model.
  role="$(plan_field "$src" role)"
  model="$(plan_field "$src" model)"
  htimeout="$(plan_field "$src" handler-timeout)"
  mkdir -p "$DIR/$JOBS_TODO"
  {
    if [ -n "$role$model$htimeout" ]; then
      printf -- '---\n'
      [ -n "$role" ]     && printf 'role: %s\n' "$role"
      [ -n "$model" ]    && printf 'model: %s\n' "$model"
      [ -n "$htimeout" ] && printf 'handler-timeout: %s\n' "$htimeout"
      printf -- '---\n'
    fi
    printf '<!-- garden-promoted-from-plan: gate=%s priority=%s at=%s -->\n\n' \
      "$gate" "$priority" "$(date -u +%FT%TZ)"
    strip_frontmatter "$src"
  } > "$DIR/$JOBS_TODO/$base.md"
  git -C "$DIR" rm -q "$JOBS_PLAN/$base.md"
  git -C "$DIR" add "$JOBS_TODO/$base.md"

  if commit_and_push "$DIR" "promote($base) plan→todo [$gate/$priority] by $GARDEN"; then
    log "promoted '$base' plan→todo (gate=$gate priority=$priority)"
    exit 0
  fi
  log "promote of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not promote '$base' after retries"
