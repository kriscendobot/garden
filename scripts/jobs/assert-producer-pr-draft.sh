#!/bin/bash
# assert-producer-pr-draft.sh — DETERMINISTIC completion-time DRAFT GUARDRAIL for the
# manual-gauntlet-trigger regime (designs/manual-gauntlet-trigger.md, adopted
# 2026-09-16 as a cost control: gauntlets are no longer staged automatically, so a
# completing producer must not be able to slip a *ready* PR into the maintainer's
# mergeable queue with no review either).
#
# This REPLACES the old assert-design-pr-gauntlet.sh sensor. That sensor enforced
# "a bot-authored DRAFT design PR must have a staged gauntlet." Under the manual
# regime the invariant is inverted and generalized:
#
#   > A garden-authored producer PR may complete WITHOUT a gauntlet only while it is
#   > DRAFT. Moving it into the mergeable queue (non-draft) requires a separate,
#   > maintainer-visible act.
#
# So this gate passes a DRAFT PR unconditionally (draft is the hard boundary — GitHub
# merging is unavailable while it holds; the maintainer explicitly requests a gauntlet
# with `run the gauntlet #N`) and BLOCKS completion only when a completing job newly
# names a bot-authored, OPEN, NON-DRAFT PR that has NO staged/completed gauntlet
# covering it. That is the "opened ready by mistake" class (endojs/endo-but-for-bots
# #874 and peers): a producer that opened ready-for-review against the unconditional
# draft norm, silently skipping review. The gate NEVER mutates PR state (no re-draft):
# a re-draft of a PR that may be under live maintainer review is exactly the
# #671/#867 corruption hazard, so a mis-identified non-draft PR is only ever a
# blocked completion, never a touched PR.
#
# Applies to EVERY role (unlike the retired sensor, which skipped `role: builder`
# because the retired auto-gauntlet-handoff builder path re-drafted+staged for it;
# that path is gone, so builders are guarded here too).
#
# Usage: assert-producer-pr-draft.sh <base> <job-file> <completion-report>
#   rc 0: nothing owed — no PR named, a citation of another author's PR, a non-open
#         PR, a probe, an open-questions review surface, a DRAFT PR (the ordinary
#         parked-draft completion), a non-draft PR already covered by a gauntlet, or
#         any INCONCLUSIVE read (fail-open).
#   rc 1: a bot-authored OPEN NON-DRAFT PR newly named by the report has NO gauntlet
#         record — block completion (leave the job in doin for the reaper to retry).
#
# Only the completion REPORT may name the PR the job produced (a job-file URL is a
# CITATION — a PR the producer told the job about — never a newly produced artifact;
# this is the #671/#867 report-only rule the retired stager also used). Recognize BOTH
# the full-URL and the shorthand `owner/repo#N` citation forms via the shared
# extractor. Deterministic, NO LLM: PR metadata + trusted journal records only — never
# a PR body/title/comment into a model.
#
# Fail-toward-not-wedging on INCONCLUSIVE reads (gh error, unparsable JSON, clone
# unreachable): return rc 0 rather than block a completion on a transient blip. A
# wedged completion during a GitHub outage is worse than a missed catch; the
# non-mutating readiness audit remains the other coverage layer, and the gate bites
# ONLY on a POSITIVE non-draft + POSITIVE no-record determination.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="assert-producer-pr-draft"

base="${1:?base}"; jobfile="${2:?job file}"; report="${3:?completion report}"

# Report-only artifact discovery (both citation forms via the shared extractor).
pr_url="$(extract_pr_refs_from_text "$report" | head -1 || true)"
[ -n "$pr_url" ] || exit 0

gh_bin="${GARDEN_GH:-gh}"
case "$gh_bin" in
  */*) [ -x "$gh_bin" ] || { log "draft-gate: gh unavailable to inspect $pr_url; inconclusive, not blocking"; exit 0; } ;;
  *)   command -v "$gh_bin" >/dev/null 2>&1 || { log "draft-gate: gh unavailable to inspect $pr_url; inconclusive, not blocking"; exit 0; } ;;
esac
pr_json="$("$gh_bin" pr view "$pr_url" --json url,isDraft,state,title,body,author,files 2>/dev/null || true)"
[ -n "$pr_json" ] || { log "draft-gate: could not read $pr_url; inconclusive, not blocking"; exit 0; }

state="$(printf '%s' "$pr_json" | jq -r '.state // empty' 2>/dev/null || true)"
draft="$(printf '%s' "$pr_json" | jq -r '.isDraft // false' 2>/dev/null || true)"
author="$(printf '%s' "$pr_json" | jq -r '.author.login // empty' 2>/dev/null || true)"

# Not the garden's own artifact → out of scope (a citation of another author's PR).
[ -n "$author" ] && [ "$author" != "$GARDEN_BOT_LOGIN" ] && exit 0
# Not an open PR → nothing to gate.
[ "$state" = OPEN ] || exit 0

# DRAFT is the hard boundary: a draft producer PR completes with NO gauntlet owed.
# This is the whole point of the manual-gauntlet regime — the ordinary path.
[ "$draft" = true ] && exit 0

# ── Beyond here the PR is bot-authored, OPEN, and NON-DRAFT ──────────────────────
# A probe intentionally stays draft with no gauntlet; a non-draft probe is a
# contradiction, but exempt one defensively (never a miss).
if printf '%s\n' "$pr_json" | jq -r '[.title, .body] | join("\\n")' 2>/dev/null | grep -qi 'gap-revealing prototype' \
   || grep -qiE '(^|[^[:alnum:]])probe([^[:alnum:]]|$)|gap-revealing' "$jobfile" 2>/dev/null; then
  exit 0
fi

# Open-questions carve-out: a garden-own-repo design PR that is a maintainer
# answer-surface (content already on main2) is never a pending merge. It normally
# stays draft, but exempt it here too so a non-draft answer-surface is never gated.
if is_open_questions_design_pr "$pr_json"; then
  log "draft-gate: $pr_url is a garden open-questions review surface (carve-out); no gauntlet owed"
  exit 0
fi

# POSITIVE non-draft producer PR. Sense the evaluator: does ANY staged or completed
# gauntlet cover it? If so, the maintainer already requested review — pass.
if ! ref="$(parse_pr_ref "$pr_url")"; then
  log "draft-gate: could not parse a PR reference from $pr_url; inconclusive, not blocking"
  exit 0
fi
repo="$(printf '%s' "$ref" | cut -f1)"
pr_number="$(printf '%s' "$ref" | cut -f2)"
slug="${repo%/*}-${repo#*/}"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
if ! ensure_clone "$DIR" 2>/dev/null; then
  log "draft-gate: producer clone $DIR unavailable; inconclusive, not blocking"
  exit 0
fi
sync_clone "$DIR" >/dev/null 2>&1 || true

if gauntlet_record_for_pr "$DIR" "$repo" "$pr_number" >/dev/null \
   || [ -e "$DIR/$JOBS_GAUNTLET/${slug}-pr${pr_number}-gauntlet.md" ] \
   || [ -e "$DIR/$JOBS_TADA/${slug}-pr${pr_number}-gauntlet.md" ]; then
  exit 0
fi

log "draft-gate: BLOCK — $pr_url ($repo#$pr_number) named by completing job '$base' is a bot-authored OPEN NON-DRAFT PR with NO staged or completed gauntlet. Under the manual-gauntlet regime a producer PR may complete without a gauntlet only while DRAFT; a ready PR needs an explicit 'run the gauntlet #N'. Refusing to record the job complete. (Not re-drafting: the PR may be under maintainer review.)"
exit 1
