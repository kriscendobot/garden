**Viability report: endojs/endo-but-for-bots#1349** ("fix(ses): encapsulate TextEncoder and TextDecoder behind SES-owned constructors")

**Verdict: proceed.** The PR is open, not merged, and not a draft. Head is `991f8af47e`, base is the frozen `master-ebc7904`. Nothing has replaced it and the bug it fixes is still open upstream, so the gauntlet can start.

Deciding question: Is the problem from endojs/endo#3369 still unfixed on current upstream `endojs/endo` master, with no fix landed there or on the fork? (The problem: `lockdown()` fails on non-deletable `caller`/`arguments` on `TextEncoder`/`TextDecoder` in Chromium 120–137.) **Yes.**

Evidence:
- **Issue still open:** endojs/endo#3369 is OPEN. The PR that introduced the problem, endojs/endo#3322 (permit TextEncoder/TextDecoder), is merged, so the failure can still be hit.
- **Base is current:** upstream master tip is still `ebc7904d87` (2026-10-14), which is exactly this PR's base. Upstream has no `packages/ses/src/tame-text-codecs.js`. The last upstream commit to `lockdown.js` is from 2026-08-21 and is unrelated (URL permits).
- **Rival fix not landed:** naugtur opened a different fix upstream, endojs/endo#3371 ("permit bogus caller/arguments"). It is OPEN, has no review decision and has had no activity since 2026-10-05, so it does not replace #1349. The conditional-taming disagreement on #1349 was settled in naugtur's favor (commit `b43f86c0d3`).
- **Overlapping PR still open:** endojs/endo-but-for-bots#1425 is OPEN. It is the XS lockdown-Compartment change that this PR also carries, and the PR body already says how the duplicate gets dropped. It is a dependency to coordinate, not a replacement.
- **Maintainer wants it shipped:** on 2026-10-27, kriskowal asked to "weave and send back to the ferry". The weave onto `master-ebc7904` is done and the ferry has been restaged. Activity continued through 2026-10-28T04:48Z.

No budget was spent on clean, panel, fix, CI-wait or un-draft work, and nothing in the garden or project repos changed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-991f8af4-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (197568 cached reads)
- Output: 2083 tokens
- Cost: $0.5180775999999999
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
