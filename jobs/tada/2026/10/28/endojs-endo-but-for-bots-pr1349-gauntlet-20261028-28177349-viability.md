**Viability report: endojs/endo-but-for-bots PR #1349** ("fix(ses): encapsulate TextEncoder and TextDecoder behind SES-owned constructors")

The gauntlet can start: the PR is open, nothing newer has replaced it, and the bug it fixes is still unfixed upstream.

PR facts: OPEN and not a draft. Head `build/hardened-text-codecs-shim` @ `2262b4bafa` (after the retcon), base frozen at `master-ebc7904`. The latest CI result posted on the PR is green (14/14).

Deciding question: Is SES still without a merged fix for the Chromium 120–137 non-configurable `caller`/`arguments` codec-constructor `lockdown()` failure (endojs/endo#3369), with no newer implementation that has displaced this PR?

Evidence:
- **The bug is still open upstream.** endojs/endo#3369 is OPEN. That failure has been reachable since endojs/endo#3322 permitted `TextEncoder`/`TextDecoder`; #3322 merged 2026-07-22.
- **Upstream master has no fix.** `packages/ses/src` on endojs/endo master has no `tame-text-codecs` or `encapsulate-host-constructor` file. The most recent `lockdown.js` commit there is the URL permits change (2026-08-21) and touches nothing codec-related.
- **One competing upstream PR exists but has not displaced this one.** endojs/endo#3371 by naugtur takes a narrower permits approach: it allows a `null` `caller`/`arguments` descriptor. It is OPEN with review required and has been idle since 2026-10-05. naugtur also reviewed #1349 on 2026-10-09.
- **The maintainer chose this PR after #3371 existed.** On 2026-10-27 kriskowal reviewed #1349 with "Please ferry upstream." That postdates #3371 and naugtur's review, so the motivating need still holds and this PR is the chosen vehicle.
- **The overlap with #1425 is managed, not a supersession.** endojs/endo-but-for-bots#1425 (the XS lockdown Compartment change) is still OPEN. The PR body says #1425 owns that piece and whichever lands second drops the duplicate.
- **The workflow edits were split out deliberately.** The retcon moved them to endojs/endo-but-for-bots#1582; that is a split, not a replacement.

I spent no clean, panel, fix, CI-wait or un-draft budget, and changed nothing.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-28177349-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (259289 cached reads)
- Output: 2400 tokens
- Cost: $0.5561618
- Wall-clock: 58s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
