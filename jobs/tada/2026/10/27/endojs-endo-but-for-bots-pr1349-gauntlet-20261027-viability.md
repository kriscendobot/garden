**Viability report: endojs/endo-but-for-bots#1349**

**PR facts:** OPEN, not merged, not a draft. Title: "fix(ses): encapsulate TextEncoder and TextDecoder behind SES-owned constructors". Head `8382a1f48a` (branch `build/hardened-text-codecs-shim`), base frozen at `master-6ee3fda`. GitHub reports it MERGEABLE. The latest bot follow-up (2026-10-27T10:41Z) says CI is green (16/16) and the next step is maintainer re-review.

**Deciding question:** Is the Chromium <138 problem (`lockdown()` fails on the undeletable `caller`/`arguments` that became reachable once TextEncoder and TextDecoder were permitted, endojs/endo#3369) still unfixed upstream, with no other change landed that replaces this PR's encapsulation approach?

**Evidence:** Yes, the problem is still unfixed and nothing has replaced this PR.
- Upstream endojs/endo#3369 is still OPEN. endojs/endo#3322, which permitted the codecs and created the problem, merged on 2026-07-22, so the premise holds.
- Competing upstream fixes have not landed:
  - endojs/endo#3371 ("Permit bogus caller and arguments…") is OPEN with review still required.
  - endojs/endo#3372 ("tolerate frozen null arguments/caller pills") was closed without merging on 2026-10-15.
- Upstream `master` has no `tame-text-codecs` or `encapsulate-host-constructor` module. Its latest `lockdown.js` commits are about URL, Temporal and NaN, not codecs.
- In endo-but-for-bots, the open TextEncoder PRs are this one, its dependency #1425 (open, same frozen base) and #1431 (a design-record docs PR that describes this same revision). None of them displaces #1349.
- The PR has been actively iterated through panel reviews, most recently addressing the request-changes findings in panel review 5648010120. That means the work is still current, not stale.

**Note for later stages:** #1349 depends on #1425, which is still open. Whoever merges must account for that ordering. It doesn't block starting the gauntlet.

No changes were made. This stage only gathers evidence, and the gauntlet may proceed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (239849 cached reads)
- Output: 2169 tokens
- Cost: $0.4745178
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
