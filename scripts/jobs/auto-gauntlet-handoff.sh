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

# The auto-gauntlet edge fires for EVERY completed job, not only `role: builder`.
# The producing role is the wrong key for "does this PR owe a gauntlet": a garden
# design PR is authored by a designer, a research/investigate job, or a bare
# gardener job just as often as by a builder, and coupling the invariant to
# `role: builder` is exactly what let three garden-owned DESIGN PRs reach
# maintainer review with no panel staged (review-misses cluster
# `garden-design-pr-gauntlet-bypass`: kriskowal/garden #7 via a researcher-designer
# investigate job, endojs/endo-but-for-bots #809 via a gardener issue job, and
# kriscendobot/minion.town #41 via a designer job). We branch on the role BELOW:
#   - builder   → the feature/probe path (unchanged).
#   - any other → the DESIGN-PR path: a bot-authored, OPEN, DRAFT, DESIGN-ONLY PR
#                 named in the completion report gets its design gauntlet staged,
#                 and is NEVER re-drafted (a ready design PR may be under review).
role="$(plan_role "$jobfile" 2>/dev/null || true)"

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
  # The job-file-citation diagnostics matter only for a builder (which OWNS the PR
  # it opens); the overwhelming majority of NON-builder jobs legitimately complete
  # with no PR at all, so stay silent for them rather than log on every completion.
  if [ "$role" = builder ]; then
    cited="$(grep -hEo 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/pull/[0-9]+' "$jobfile" 2>/dev/null | head -1 || true)"
    if [ -n "$cited" ]; then
      log "auto-gauntlet: build '$base' named no PR in its completion report; its job file cites $cited, which is a reference and NOT a build artifact — no handoff, and that PR is left untouched"
    else
      log "auto-gauntlet: build '$base' completed without a recognizable GitHub PR URL; no PR handoff required"
    fi
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
pr_json="$("$gh_bin" pr view "$pr_url" --json url,isDraft,state,title,body,author,files)"
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
# cleared MERGE-NOW before automatic conduct — as the botany
# that surfaced its gap, and the handoff force-drafted it, pulling it out of the
# maintainer's queue and blocking its merge.  Check BEFORE any mutation and never
# re-draft first, so a mis-identified PR is never touched at all.
if [ -n "$author" ] && [ "$author" != "$GARDEN_BOT_LOGIN" ]; then
  log "auto-gauntlet: job '$base' report names $pr_url, authored by '$author' and not by the bot '$GARDEN_BOT_LOGIN' — the garden opens its own PR under the bot identity, so this is a citation and NOT its own artifact; no handoff, and that PR is left untouched"
  exit 0
fi

if [ "$state" != OPEN ]; then
  log "auto-gauntlet: job '$base' PR $pr_url is state=$state; no handoff needed"
  exit 0
fi

if [ "$role" = builder ]; then
  # ── BUILDER path (mergeable feature or probe) — unchanged ───────────────────
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
  exit 0
fi

# ── DESIGN-PR path (any NON-builder role) — the bypass fix ────────────────────
# A non-builder completion that produced a bot-authored, OPEN, DRAFT, DESIGN-ONLY
# PR must stage that PR's design gauntlet before this job may be recorded complete,
# so panel.sh (which senses the design panel from the diff) runs before the
# maintainer reviews. Unlike a builder's own feature PR we do NOT re-draft here: a
# design PR that is already ready-for-review may be under active maintainer review,
# and force-drafting it is the endojs/endo-but-for-bots #671/#867 corruption hazard
# the report-only + bot-author guards above exist to prevent. A ready design PR
# without a gauntlet is left for the completion sensor / standing audit to surface,
# never force-drafted from here.
#
# A probe never reaches this path (probes are `role: builder`), but exempt one
# defensively so no gap-revealing prototype is ever pulled into a mergeable gauntlet.
if printf '%s\n' "$pr_json" | jq -r '[.title, .body] | join("\\n")' | grep -qi 'gap-revealing prototype' \
   || grep -qiE '(^|[^[:alnum:]])probe([^[:alnum:]]|$)|gap-revealing' "$jobfile"; then
  log "auto-gauntlet: job '$base' PR $pr_url is a probe; leaving its draft PR parked by design"
  exit 0
fi

mapfile -t _pr_files < <(printf '%s' "$pr_json" | jq -r '(.files // [])[].path // empty')
if [ "${#_pr_files[@]}" -eq 0 ] || ! design_only_paths "${_pr_files[@]}"; then
  log "auto-gauntlet: job '$base' (role ${role:-none}) PR $pr_url is not a design-only diff — the design-PR coverage path does not apply; a code PR that owes a gauntlet is the builder completion edge's job"
  exit 0
fi

if [ "$draft" != true ]; then
  log "auto-gauntlet: WARNING job '$base' PR $pr_url is a bot-authored DESIGN PR already NON-DRAFT with no gauntlet staged — NOT re-drafting (it may be under maintainer review); the design-gauntlet sensor/audit will surface it"
  exit 0
fi

if ! ref="$(parse_pr_ref "$pr_url")"; then
  die "auto-gauntlet: could not parse a PR reference from $pr_url"
fi
repo="$(printf '%s' "$ref" | cut -f1)"
pr_number="$(printf '%s' "$ref" | cut -f2)"
slug="${repo%/*}-${repo#*/}"

# PR-keyed idempotence. Base-keyed dedup is not enough on this path: a design PR can
# be named by more than one non-builder job (the original designer, then a fixer
# addressing panel feedback), and each would otherwise choose a different gauntlet
# base and record a second run for one PR. If ANY gauntlet record already covers
# this repo#PR, do nothing.
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
if ensure_clone "$DIR"; then sync_clone "$DIR" >/dev/null 2>&1 || true; fi
if existing="$(gauntlet_record_for_pr "$DIR" "$repo" "$pr_number")"; then
  log "auto-gauntlet: design PR $pr_url already covered by gauntlet record(s) [$(printf '%s' "$existing" | tr '\n' ' ')]; no new record"
  exit 0
fi

# The gauntlet base is PR-derived (owner-repo-pr<N>-gauntlet), not job-derived, so
# it is stable across every producer that could open or touch this design PR — the
# same base name post-gauntlet.sh's own usage documents. A failed record post is a
# failed handoff: the caller leaves the job in doin so the reaper retries it.
gauntlet_base="${slug}-pr${pr_number}-gauntlet"
"$HERE/post-gauntlet.sh" --build-job "$base" "$gauntlet_base" "$pr_url"
log "auto-gauntlet: job '$base' (role ${role:-none}) recorded design gauntlet '$gauntlet_base' for draft design PR $pr_url — panel.sh senses the design panel; it runs before maintainer review"
