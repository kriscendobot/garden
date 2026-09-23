Fix stage complete. CI is green.

## Completion report

**Job:** FIX round 1 of the `ironhorse-computron-benchmark-baseline` gauntlet on endojs/endo-but-for-bots PR #1283 (a design-doc PR; head `endojs:design/ironhorse-computron-benchmark-baseline`).

**What I did:** Read the round-1 design-panel verdict (must-fix disposition) and applied its items once to the two changed files (`designs/ironhorse-computron-benchmark-baseline.md`, `designs/README.md`), then pushed as a review-feedback follow-up commit (`be68d13ca`) via `safe-push-pr-head.sh --mode advance` and watched CI to terminal green.

**Panel items addressed:**
- **critic (must-fix):** Added a "Loads already known to diverge from CPU time (the F4 exception)" subsection — the Map/Set/`for..in`/string loads that are already quadratic-in-time while linear-in-computrons are kept under gates 1-2 (computron range still locked) with gate 3's class-match *suppressed as a tracked exception* until the F4 meter fix re-records them under a `COST_TABLE_VERSION` bump. Avoids gate 3 going red day one.
- **novice (must-fix + should-fix):** Defined "computron" and tied "oracle" to XS before first use; walked the `-20` async-gen example; introduced the `(IH)` shorthand.
- **skeptic:** Replaced the prose "don't leave a coverage gap" recommendation with a mechanical merge-order hold (job-board `blocked_on`/hold label); stated gate 3 uses a looser single-sided timing band vs gate 2's tight two-sided computron band.
- **decomplector:** Resolved the one-artifact-vs-two contradiction — a single `computron-baseline.json`; the `computrons.tsv` corpus is left untouched.
- **ergonomist:** Added per-class bands for `log n` and `n*log n` (a full class-band table); added a shared failure-message contract across gates 1-3.
- **copyeditor/pedant/orthographer:** "extends existing infrastructure; it does not duplicate it"; "Ironhorse" one word throughout; "Design decisions" sentence case; "Modeling"; removed all em-dashes and typist-hostile code points from authored prose (typist probe passes).

**Scope discipline:** Committed only the two design files with explicit pathspecs (left yarn-install artifacts `packages/floot/package.json` and fixture dirs uncommitted); reverted an unrelated `endo-workflow` README row that the typist auto-fix had touched, keeping the diff focused on the design addition.

**CI:** GREEN — `total=29 failed=0`, `lint` passed (11m38s), all test lanes skipped by the docs-only path filter. `ci-wait-merge.sh` returned rc 0.

**Follow-ups:** None for this stage. Per the gauntlet protocol I stopped after one fix pass; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-computron-benchmark-baseline-build-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 84 tokens (3987083 cached reads)
- Output: 34896 tokens
- Cost: $4.0277545
- Wall-clock: 1170s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
