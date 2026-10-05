#!/bin/bash
# auto-gauntlet-handoff.sh — stage the review gauntlet owed by a completed
# producer job.
#
# Usage: auto-gauntlet-handoff.sh <job-base> <job-file> <completion-report>
#
# This is a completion-path edge, not a backlog reconciler. It considers only a
# PR newly named by the completion report, so restoring automatic handoff cannot
# repeat the 2026-08-30 mass-stage incident. Every bot-authored draft artifact
# owes a feature gauntlet, independent of which role (if any) produced it. Probes
# and garden open-question answer surfaces remain deliberate draft exceptions.
#
# The hook never changes PR state. Producers already have an unconditional draft
# rule; an accidentally ready PR is left to assert-producer-pr-draft.sh, which
# records a maintainer-visible disposition without disrupting live review.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="auto-gauntlet-handoff"

base="${1:?job basename}"
jobfile="${2:?job file}"
report="${3:?completion report}"
# The producer's arc rides into the gauntlet record so every stage is charged
# to it (designs/accountant-arc-apportionment.md § The arc).
arc_args=()
producer_arc="$(job_arc "$jobfile" 2>/dev/null || true)"
[ -z "$producer_arc" ] || arc_args=(--arc "$producer_arc")

pr_urls="$(extract_pr_refs_from_text "$report" || true)"
pr_url="$(printf '%s\n' "$pr_urls" | head -1)"
if [ -z "$pr_url" ]; then
  exit 0
fi
if [ "$(printf '%s\n' "$pr_urls" | sed '/^$/d' | wc -l)" -gt 1 ]; then
  log "auto-gauntlet: '$base' named several PRs; treating the first, $pr_url, as its artifact"
fi

gh_bin="${GARDEN_GH:-gh}"
case "$gh_bin" in
  */*) [ -x "$gh_bin" ] || die "auto-gauntlet: gh is required to inspect $pr_url" ;;
  *) command -v "$gh_bin" >/dev/null 2>&1 || die "auto-gauntlet: gh is required to inspect $pr_url" ;;
esac

# gh_pr_view_retry absorbs a transient transport/API blip (a TLS handshake
# timeout failed a producer completion on 2026-09-30) under bounded backoff, and
# returns at once on a definitive failure, so a non-PR still no-ops immediately.
# Its log lines carry gh's stderr, which is where the non-PR wording is found.
err="$(mktemp "${TMPDIR:-/tmp}/garden-auto-gauntlet.XXXXXX")"
if ! pr_json="$(gh_pr_view_retry "$pr_url" --json url,isDraft,state,title,body,author,files 2>"$err")"; then
  if grep -qi 'Could not resolve to a PullRequest' "$err"; then
    rm -f "$err"
    log "auto-gauntlet: $pr_url is not a pull request; no handoff"
    exit 0
  fi
  cat "$err" >&2 || true
  rm -f "$err"
  die "auto-gauntlet: gh could not inspect $pr_url"
fi
cat "$err" >&2 || true
rm -f "$err"

state="$(printf '%s' "$pr_json" | jq -r '.state // empty')"
draft="$(printf '%s' "$pr_json" | jq -r '.isDraft // false')"
author="$(printf '%s' "$pr_json" | jq -r '.author.login // empty')"

if [ -n "$author" ] && [ "$author" != "$GARDEN_BOT_LOGIN" ]; then
  log "auto-gauntlet: $pr_url is authored by '$author', not '$GARDEN_BOT_LOGIN'; treating it as a citation"
  exit 0
fi
[ "$state" = OPEN ] || { log "auto-gauntlet: $pr_url is state=$state; no handoff"; exit 0; }

# Only a draft producer artifact is safe to hand to the gauntlet automatically.
# The completion guard handles a ready artifact without mutating it.
if [ "$draft" != true ]; then
  log "auto-gauntlet: $pr_url is already non-draft; leaving it untouched for the completion guard"
  exit 0
fi

if printf '%s\n' "$pr_json" | jq -r '[.title, .body] | join("\\n")' | grep -qi 'gap-revealing prototype' \
   || grep -qiE '(^|[^[:alnum:]])probe([^[:alnum:]]|$)|gap-revealing' "$jobfile"; then
  log "auto-gauntlet: $pr_url is a probe; leaving it draft"
  exit 0
fi

if is_open_questions_design_pr "$pr_json"; then
  log "auto-gauntlet: $pr_url is a garden open-questions answer surface; no gauntlet owed"
  exit 0
fi

ref="$(parse_pr_ref "$pr_url")" || die "auto-gauntlet: could not parse $pr_url"
repo="$(printf '%s' "$ref" | cut -f1)"
pr_number="$(printf '%s' "$ref" | cut -f2)"
slug="${repo%/*}-${repo#*/}"
gauntlet_base="${slug}-pr${pr_number}-gauntlet"

# The PR-keyed base makes repeated producer completions converge on one record.
# post-gauntlet.sh supplies the journal-side active/completed idempotence.
"$HERE/post-gauntlet.sh" --build-job "$base" "${arc_args[@]}" "$gauntlet_base" "$pr_url"
log "auto-gauntlet: '$base' recorded gauntlet '$gauntlet_base' for $pr_url"
