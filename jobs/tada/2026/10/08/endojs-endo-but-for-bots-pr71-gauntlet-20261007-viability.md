## Viability: PR #71 (endojs/endo-but-for-bots) can proceed

I didn't spend anything on clean, panel, fix, CI-wait or un-draft work. PR #71 is open, not merged and not a draft, so the gauntlet can begin.

**Deciding question:** Is there still no test anywhere (fork `master` or upstream `endojs/endo` `master`) that loads `@endo/env-options` *inside* a sub-compartment with its own `process.env` and checks the setting stays scoped to that compartment, with issue endojs/endo#2879 still open?
Yes, on both counts.

**Evidence:**
- **PR state:** OPEN, `mergedAt=null`, `isDraft=false`. Head is `58240c0ffa` on `design/issue-2879-env-options-per-compartment`. Base is the frozen `master-46d4edf`, which is 77 commits behind fork `master`.
- **The motivating issue is still open.** endojs/endo#2879, "Need a test for a per-compartment env-options setting and import", is OPEN.
- **The upstream copy hasn't landed.** kriskowal noted this PR mirrors endojs/endo#3299 (head `884e2a8c`). That PR is still OPEN and unmerged.
- **Nothing newer replaces it.** Neither repo has an `env-options-in-compartment` test.
  - The only related test is `packages/ses-ava/test/env-options.test.js`, which dates from 2024. It calls `makeEnvironmentCaptor(c.globalThis)` from the parent and never imports `env-options` inside a compartment.
  - Since then that file has only had lint and type commits.
  - `packages/env-options/src/` hasn't changed in substance recently either: only lint, merge and typo commits.
- **The review has been addressed.** kriskowal left four inline comments on 2026-05-01: drop `@ts-check`, drop an unused eslint directive, fix line wrapping, and use `ModuleSource`/`importLocation`. The bot answered all four the same day, and the test now uses `importLocation` from `@endo/compartment-mapper` with an entry-point fixture. There are no CHANGES_REQUESTED reviews.

**For the fix and panel stages:** the PR description is out of date. It still describes a `packages/ses-ava/test/env-options-in-compartment.test.js` and a `@endo/module-source` devDep. The diff now changes only five files:
- `packages/marshal/package.json`
- `packages/marshal/test/env-options-in-compartment.test.js`
- `packages/marshal/test/_fixtures-env-options-in-compartment/main.js`
- `packages/marshal/test/_fixtures-env-options-in-compartment/package.json`
- `yarn.lock`

The description should be brought in line with the diff during the gauntlet.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr71-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (298850 cached reads)
- Output: 2812 tokens
- Cost: $0.430994
- Wall-clock: 70s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
