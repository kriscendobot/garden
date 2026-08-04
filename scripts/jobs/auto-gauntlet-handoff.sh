#!/bin/bash
# auto-gauntlet-handoff.sh: turn a completed feature build's draft PR into the
# next, separately claimable gauntlet job.  This is deliberately in the worker
# completion path, rather than left as an instruction for the builder: producers
# may park/promote a build and a successful builder has no further board edge.
#
# Usage: auto-gauntlet-handoff.sh <build-base> <job-file> <completion-report>
#
# A failed post is a failed handoff.  The caller leaves the build in doin so the
# reaper retries it; completing the build without its gauntlet would recreate the
# silent draft-PR stall this hook exists to prevent.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

base="${1:?build basename}"; jobfile="${2:?job file}"; report="${3:?completion report}"

if [ "$(plan_role "$jobfile")" != builder ]; then
  exit 0
fi

# Only the COMPLETION REPORT may name the build's own pull request.  A PR the build
# opened did not exist when the build was posted, so a URL in the JOB FILE is by
# construction a CITATION — a PR the producer told the build about — never an
# artifact the build created.  Scraping both and taking the first match is how
# `fix-pr-feedback-preflight-argv-e2big` (a garden-`main2` fix that opened no PR at
# all) got endojs/endo-but-for-bots#671 force-drafted on 2026-07-29: its job body
# cited that PR six times as the one whose preflight had crashed, this hook read the
# citation as the build's artifact, converted a PR that had been ready-for-review
# since 07-11 back to draft under a live peer worker, and posted a gauntlet to
# review it "cold".  The trade this makes deliberately: a builder that pushed to a
# pre-existing PR named only in its job file no longer gets an automatic handoff.
# That is the right side to fail on — a missed handoff is still caught by the
# foreman and the watchers, whereas force-drafting a live PR corrupts someone
# else's in-flight work and cannot be caught by anything.
pr_urls="$(grep -hEo 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/pull/[0-9]+' "$report" 2>/dev/null | awk '!seen[$0]++' || true)"
pr_url="$(printf '%s\n' "$pr_urls" | head -1)"
if [ -z "$pr_url" ]; then
  cited="$(grep -hEo 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/pull/[0-9]+' "$jobfile" 2>/dev/null | head -1 || true)"
  if [ -n "$cited" ]; then
    log "auto-gauntlet: build '$base' named no PR in its completion report; its job file cites $cited, which is a reference and NOT a build artifact — no handoff, and that PR is left untouched"
  else
    log "auto-gauntlet: build '$base' completed without a recognizable GitHub PR URL; no PR handoff required"
  fi
  exit 0
fi
# Ambiguity is not resolvable here, but it must not be invisible: a report that
# names several PRs is the remaining way this hook can pick the wrong one.
if [ "$(printf '%s\n' "$pr_urls" | wc -l)" -gt 1 ]; then
  log "auto-gauntlet: build '$base' report names $(printf '%s\n' "$pr_urls" | wc -l) distinct PR URLs ($(printf '%s' "$pr_urls" | tr '\n' ' ')); treating the first, $pr_url, as the build's own"
fi

gh_bin="${GARDEN_GH:-gh}"
case "$gh_bin" in
  */*) [ -x "$gh_bin" ] || die "auto-gauntlet: gh is required to inspect $pr_url" ;;
  *)   command -v "$gh_bin" >/dev/null 2>&1 || die "auto-gauntlet: gh is required to inspect $pr_url" ;;
esac
pr_json="$("$gh_bin" pr view "$pr_url" --json url,isDraft,state,title,body,author)"
state="$(printf '%s' "$pr_json" | jq -r '.state // empty')"
draft="$(printf '%s' "$pr_json" | jq -r '.isDraft // false')"
author="$(printf '%s' "$pr_json" | jq -r '.author.login // empty')"

# Second, independent artifact test — the AUTHOR IDENTITY.  A PR the build opened is
# opened under the BOT identity (the fleet's gh wrapper pins every call to it), so a
# PR authored by anyone else cannot be this build's artifact no matter which document
# named it or in what form.  The report-only rule above closes the job-file path; this
# closes the remaining one, a completion report that cites some OTHER author's PR by
# full URL (a related-work link), which the report-only scrape would otherwise take as
# the build's own and force-draft.  It is what stops a dependabot PR from being drafted
# out from under the maintainer: on 2026-07-29 the build
# `fix-botanist-scripts-enabled-install-gap` (a garden-`main2` fix that opened no PR)
# cited endojs/endo-but-for-bots#867 — a live `@noble/curves` bump a botanist had just
# cleared MERGE-NOW and that was waiting on the maintainer's approval — as the botany
# that surfaced its gap, and the handoff force-drafted it, pulling it out of the
# maintainer's queue and blocking its merge.  Check BEFORE any mutation and never
# re-draft first, so a mis-identified PR is never touched at all.
if [ -n "$author" ] && [ "$author" != "$GARDEN_BOT_LOGIN" ]; then
  log "auto-gauntlet: build '$base' report names $pr_url, authored by '$author' and not by the bot '$GARDEN_BOT_LOGIN' — a build opens its own PR under the bot identity, so this is a citation and NOT a build artifact; no handoff, and that PR is left untouched"
  exit 0
fi

if [ "$state" != OPEN ]; then
  log "auto-gauntlet: build '$base' PR $pr_url is state=$state; no handoff needed"
  exit 0
fi

# A non-draft PR is a DEFECT here, not a finished chain.  Treating draft=false as
# "nothing owed" is precisely how endojs/endo-but-for-bots#874 (and three peers)
# skipped panel review entirely: the builder opened ready-for-review against the
# unconditional draft norm (roles/builder/AGENT.md), this hook read that as done,
# and an unreviewed PR landed in the maintainer's queue until a human noticed
# (dckc, 2026-07-27: "you skipped DRAFT stage").  The draft flag is what TRIGGERS
# the gauntlet, so restore it deterministically and hand off anyway.  A failed
# re-draft still hands off: the gauntlet can re-draft, whereas skipping the
# handoff would resurrect the silent-skip this hook exists to prevent.
redrafted=
if [ "$draft" != true ]; then
  if "$gh_bin" pr ready "$pr_url" --undo >/dev/null 2>&1; then
    redrafted=yes
    log "auto-gauntlet: build '$base' PR $pr_url was non-draft (norm violation); converted back to draft"
  else
    log "auto-gauntlet: WARNING build '$base' PR $pr_url is non-draft and could not be converted back to draft; handing off anyway"
  fi
fi

# Probe builds intentionally remain draft.  Prefer the PR's durable annotation,
# and retain the job-body check for older probe reports that lack it.
if printf '%s\n' "$pr_json" | jq -r '[.title, .body] | join("\\n")' | grep -qi 'gap-revealing prototype' \
   || grep -qiE '(^|[^[:alnum:]])probe([^[:alnum:]]|$)|gap-revealing' "$jobfile"; then
  log "auto-gauntlet: build '$base' PR $pr_url is a probe; leaving its draft PR parked by design"
  exit 0
fi

# Create a staged-gauntlet RECORD, not a monolithic job (designs/staged-gauntlet.md).
# The old handoff posted ONE `<base>-gauntlet` job whose handler had to span the whole
# clean → panel → fix-loop → un-draft chain — a sum that fits no handler budget (nine
# jobs doomed on deadline-overrun 2026-07-28). Instead we record a gauntlet the
# deterministic gauntlet.sh driver walks one claim-sized stage at a time. A failed
# record post is a failed handoff, exactly like the old failed job post: the caller
# leaves the build in doin so the reaper retries it — completing the build without its
# gauntlet would recreate the silent draft-PR stall this hook exists to prevent.
gauntlet_base="$base-gauntlet"
"$HERE/post-gauntlet.sh" --build-job "$base" "$gauntlet_base" "$pr_url"
if [ -n "$redrafted" ]; then
  log "auto-gauntlet: build '$base' recorded gauntlet '$gauntlet_base' for draft PR $pr_url (PR was found NON-DRAFT and re-drafted; the staged panel reviews it cold)"
else
  log "auto-gauntlet: build '$base' recorded gauntlet '$gauntlet_base' for draft PR $pr_url"
fi
