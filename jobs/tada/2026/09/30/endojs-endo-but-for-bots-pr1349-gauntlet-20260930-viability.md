**Viability report: endojs/endo-but-for-bots#1349**

I did the viability gate only. No clean, panel, fix, CI-wait or un-draft budget was spent, and nothing was changed.

**PR facts:** #1349 is OPEN, a draft, and not merged. Its title is "test(ses): XS smoke check for hardened TextEncoder/TextDecoder". It merges head `build/hardened-text-codecs-shim` @ `d98467c6b5` into the frozen base `master-6ee3fda`, and that base is currently the same commit as `master`. It has no reviews and no comments.

**Deciding question:** Does current `master` (or `llm`, or upstream endojs/endo `master`) still lack the XS smoke test from item 6 of the design's test plan, and does the design still treat that test as open work?

**Answer: yes, on both counts.**

**Evidence:**
- The PR adds a check to `packages/ses/test/_xs.js`: whether `TextEncoder` and `TextDecoder` exist in a compartment after lockdown must match the host, and each codec that exists must be frozen.
- Neither `packages/ses/test/_xs.js` on fork `master` nor the same file on upstream endojs/endo `master` mentions TextEncoder, TextDecoder or codecs. The same lookup on `llm` returned 404, so `llm` was not checked. The base is up to date: `master` is 0 commits ahead of `6ee3fda` ("identical").
- A search for PRs on TextEncoder/XS found no competing or newer implementation. #259 (the permits PR) is closed; phases 1 and 2 landed upstream as endojs/endo#3322.
- The sibling docs PR #1381 (OPEN, marking the design "Implemented (Phases 1-2)") names "the XS smoke test (#1349)" as an item that is still open. So the design companion depends on this PR rather than replacing it.
- The reason for the PR still stands: the XS runner (`yarn test:xs`) does not cover the codecs.

**Note for the panel:** the diff also includes an unrelated one-line change to `.github/workflows/ci.yml`, a pin comment going from `# v3` to `# v3.0.3` on `dorny/paths-filter`. This is a scope and cleanliness question for the clean step, not a viability problem.

**Follow-ups:** none. The gauntlet may begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20260930-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (170604 cached reads)
- Output: 1939 tokens
- Cost: $0.43108479999999993
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
