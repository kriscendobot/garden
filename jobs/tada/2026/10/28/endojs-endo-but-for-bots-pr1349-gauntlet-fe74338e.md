I staged a fresh gauntlet for PR #1349 at head `fe74338e`. I did not restage the ferry: the existing review at that exact head does not actually clear.

**What I found**
- The PR is open, not a draft, mergeable, and CI is green at `fe74338e19e2`.
- A panel already ran at this head (review 5675257967, panel-2 of the earlier `…-gauntlet-20261027-b122ff91` gauntlet), and its final decision step judged it "pass". But its **integrator** seat raised two must-fix items that are still open. I checked both against the PR as it stands now:
  1. **The description claims a change the diff doesn't make.** The PR body says "`ci.yml` gets the exact `dorny/paths-filter` version comment". The PR's 25 files include no `ci.yml`; the only workflow files are `browser-test.yml` and `depcheck.yml`.
  2. **The dependency on #1425 is unresolved.** The body says "Depends on: endojs/endo-but-for-bots#1425", which is still an open draft. Both PRs change `packages/ses/src-xs/lockdown-shim.js` and `depcheck.yml`, and the description doesn't say which PR owns that code.
- The ferry directive `jobs/ferry/endojs-endo-but-for-bots-pr1349.md` still names head `b122ff91ef`. If someone runs `scripts/ferry.sh` now, its head check will stop it with a blocked report, so I left the directive untouched.

**What I posted**
- **Fresh gauntlet `endojs-endo-but-for-bots-pr1349-gauntlet-20261028-fe74338e`** (feature kind, up to 6 review rounds). It runs viability → clean → panel → fix rounds → un-draft. If the new panel repeats those findings, a fix round should correct the description and settle the #1425 question.
- **Parked job `endojs-endo-but-for-bots-pr1349-ferry-restage-20261028`**, which waits on that gauntlet and starts when it finishes. It restages the ferry directive only if all of these hold:
  - the gauntlet completed;
  - its last panel passed at the PR's current exact head with no open in-scope must-fix, including the two items above;
  - CI is green at that head.

  If those hold, it updates `downstream_head` and the preconditions, keeps the maintainer's `identity_switch_authorized: true` exactly as transcribed, and moves the directive back out of `doing/` if a blocked ferry run left it there. If they don't, it reports what blocks the ferry and messages the maintainer instead.

**Follow-ups**
- The #1425 overlap may need the maintainer to decide which PR owns the XS lockdown-shim change.
- The decision step called the panel "pass" even though a seat raised must-fix items. That looks like a misjudgment worth watching if it happens again.
- No garden or project files changed.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `6a90463e36a7685cd1296759afb18efffbf4e917`; this job presented `2db6a8171422b8d4b23a05599ceb267530a36a2a`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-fe74338e.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1492897 cached reads)
- Output: 11097 tokens
- Cost: $1.1385513999999999
- Wall-clock: 194s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
