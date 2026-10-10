**Verdict: `viability=proceed`.** PR #346 is open, not superseded, and the bug it fixes is still present upstream. I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** OPEN, not draft, not merged. Title: "fix(bundle-source): bind aliased exports correctly in nestedEvaluate format (fixes endojs/endo#2981)".
- Head `6f11231cc69e` on branch `fix/bundle-source-aliased-exports-2981`.
- Base is the frozen snapshot `master-46d4edf` (upstream `endojs/endo` master at `46d4edf3171`).
- It changes 3 files: `packages/compartment-mapper/src/bundle-mjs.js` (the fan-out setter per local binding), the un-`.failing`'d `packages/bundle-source/test/export-alias.test.js`, and a changeset.
- The earlier panel verdict found no must-fix items. Its 3 summary fixes went in at 6581dd51d, and the branch was rebased cleanly onto `master-46d4edf` on 2026-07-17.

**Deciding question:** Does upstream `endojs/endo` master still emit duplicate-keyed `onceVar`/`liveVar` properties for aliased exports, with endojs/endo#2981 still open and no other fix landed or in flight?

**Evidence:** Yes, on every point.
- endojs/endo#2981 is still OPEN.
- `packages/compartment-mapper/src/bundle-mjs.js` on upstream master was last changed by ee87476e0e (2025-02-15). It still builds `onceVar`/`liveVar` with the old one-property-per-export-name `importsCellSetter`, which is the bug's root cause.
- `packages/bundle-source/test/export-alias.test.js` is still `test.failing('export alias', …)` on upstream master and on the fork's `llm` branch.
- No competing PR exists: searches on `endojs/endo` and `endojs/endo-but-for-bots` for #2981, "aliased exports" and "alias export bundle" turned up only #346 and the original tests-and-workarounds PR, endojs/endo#2980 (merged 2025-10-08).

**For the next stages:** upstream master is 89 commits ahead of the `master-46d4edf` base, but none of them touch `bundle-mjs.js`, so a re-pin should be clean if the gauntlet wants one.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr346-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (294879 cached reads)
- Output: 2110 tokens
- Cost: $0.4799518
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
