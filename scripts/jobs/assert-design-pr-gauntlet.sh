#!/bin/bash
# assert-design-pr-gauntlet.sh — DETERMINISTIC completion-time SENSOR for the
# design-PR gauntlet-bypass class (review-misses cluster
# `garden-design-pr-gauntlet-bypass`: kriskowal/garden #7, endojs/endo-but-for-bots
# #809, kriscendobot/minion.town #41 — each a garden-owned design PR that reached
# maintainer review with no design panel staged).
#
# This is the SENSING half of the fix; auto-gauntlet-handoff.sh is the PREVENTION
# half. INDEPENDENTLY of the stager, it re-derives whether a completing job produced
# a bot-authored, OPEN, DRAFT, DESIGN-ONLY PR and, if so, senses ABSENCE of the
# EVALUATOR: it FAILS (rc 1) unless a staged-gauntlet RECORD already covers that PR.
# gardener.sh treats a non-zero exactly like a failed handoff — the job stays in doin
# and the reaper retries — so a garden-owned design PR can never be recorded complete
# (doin→tada) without its design panel staged. Because the stager runs first, the
# ordinary path passes on the same cycle; the sensor only bites when a design PR
# reached completion with no gauntlet — the exact bypass shape of the three misses,
# and any future producer that opens a design PR without going through the stager.
#
# It senses the evaluator's ABSENCE (a missing gauntlet record), never document
# quality. Fully deterministic, NO LLM: PR metadata + file PATHS + trusted journal
# records only — never a PR body/title/comment into a model.
#
# Scope: NON-builder completions only. A builder's own PR coverage is the
# auto-gauntlet-handoff builder path (feature → gauntlet, probe → parked), already
# guarded and tested; re-checking it here would only double the read cost.
#
# Usage: assert-design-pr-gauntlet.sh <base> <job-file> <completion-report>
#   rc 0: nothing owed — not a design PR, a probe, a ready PR, an inconclusive read,
#         or a design PR already covered by a gauntlet record.
#   rc 1: a bot-authored OPEN DRAFT DESIGN-ONLY PR named in the report has NO
#         gauntlet record — block completion (leave the job in doin).
#
# Fail-toward-not-wedging on INCONCLUSIVE reads (gh error, unparsable JSON, clone
# unreachable): return rc 0 rather than block a completion on a transient blip. The
# stager and the standing audit remain the other two coverage layers, and a genuine
# miss re-surfaces on the next reconciliation; a wedged completion during an outage
# would be worse. The sensor bites ONLY on a POSITIVE design-PR + POSITIVE
# no-record determination.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="assert-design-pr-gauntlet"

base="${1:?base}"; jobfile="${2:?job file}"; report="${3:?completion report}"

role="$(plan_role "$jobfile" 2>/dev/null || true)"
# Builder coverage is the auto-gauntlet-handoff builder path; this sensor guards the
# NON-builder design-PR bypass only.
[ "$role" = builder ] && exit 0

# Same report-only discovery the stager uses: only the completion REPORT may name
# the PR the job produced (a job-file URL is a citation, not an artifact).
pr_url="$(grep -hEo 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/pull/[0-9]+' "$report" 2>/dev/null \
          | awk '!seen[$0]++' | head -1 || true)"
[ -n "$pr_url" ] || exit 0

gh_bin="${GARDEN_GH:-gh}"
case "$gh_bin" in
  */*) [ -x "$gh_bin" ] || { log "sensor: gh unavailable to inspect $pr_url; inconclusive, not blocking"; exit 0; } ;;
  *)   command -v "$gh_bin" >/dev/null 2>&1 || { log "sensor: gh unavailable to inspect $pr_url; inconclusive, not blocking"; exit 0; } ;;
esac
pr_json="$("$gh_bin" pr view "$pr_url" --json url,isDraft,state,title,body,author,files 2>/dev/null || true)"
[ -n "$pr_json" ] || { log "sensor: could not read $pr_url; inconclusive, not blocking"; exit 0; }

state="$(printf '%s' "$pr_json" | jq -r '.state // empty' 2>/dev/null || true)"
draft="$(printf '%s' "$pr_json" | jq -r '.isDraft // false' 2>/dev/null || true)"
author="$(printf '%s' "$pr_json" | jq -r '.author.login // empty' 2>/dev/null || true)"

# Not the garden's own artifact → out of scope (a citation of another author's PR).
[ -n "$author" ] && [ "$author" != "$GARDEN_BOT_LOGIN" ] && exit 0
# Not an open PR → nothing to gate.
[ "$state" = OPEN ] || exit 0

# A probe intentionally stays draft with no gauntlet — never a miss.
if printf '%s\n' "$pr_json" | jq -r '[.title, .body] | join("\\n")' 2>/dev/null | grep -qi 'gap-revealing prototype' \
   || grep -qiE '(^|[^[:alnum:]])probe([^[:alnum:]]|$)|gap-revealing' "$jobfile" 2>/dev/null; then
  exit 0
fi

mapfile -t _pr_files < <(printf '%s' "$pr_json" | jq -r '(.files // [])[].path // empty' 2>/dev/null || true)
# Not a design-only diff → the design-PR invariant does not apply here.
if [ "${#_pr_files[@]}" -eq 0 ] || ! design_only_paths "${_pr_files[@]}"; then
  exit 0
fi
# A ready design PR without a gauntlet is a coordination hazard to touch here (it may
# be under maintainer review); the standing audit alerts on it. Do not wedge this
# job's completion on a PR whose draft state it did not create.
[ "$draft" = true ] || exit 0

# POSITIVE design-PR. Now sense the evaluator: does ANY gauntlet record cover it?
if ! ref="$(parse_pr_ref "$pr_url")"; then
  log "sensor: could not parse a PR reference from $pr_url; inconclusive, not blocking"
  exit 0
fi
repo="$(printf '%s' "$ref" | cut -f1)"
pr_number="$(printf '%s' "$ref" | cut -f2)"
slug="${repo%/*}-${repo#*/}"

# Read the producer clone the stager just wrote+pushed to (local, so a network blip
# cannot wedge completion after the record already landed). Best-effort sync so a
# record another host staged is also seen.
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
if ! ensure_clone "$DIR" 2>/dev/null; then
  log "sensor: producer clone $DIR unavailable; inconclusive, not blocking"
  exit 0
fi
sync_clone "$DIR" >/dev/null 2>&1 || true

if gauntlet_record_for_pr "$DIR" "$repo" "$pr_number" >/dev/null \
   || [ -e "$DIR/$JOBS_GAUNTLET/${slug}-pr${pr_number}-gauntlet.md" ] \
   || [ -e "$DIR/$JOBS_TADA/${slug}-pr${pr_number}-gauntlet.md" ]; then
  exit 0
fi

log "sensor: BLOCK — design PR $pr_url ($repo#$pr_number) named by completing job '$base' (role ${role:-none}) has NO staged design-gauntlet record; the design panel has not been invoked. Refusing to record the job complete until its gauntlet is staged."
exit 1
