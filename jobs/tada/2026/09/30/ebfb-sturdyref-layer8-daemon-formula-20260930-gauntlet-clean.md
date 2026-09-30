---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage FAILED: CI is red on endojs/endo-but-for-bots#1398, and the cause is lower in the SturdyRef stack

I ran the clean stage on https://github.com/endojs/endo-but-for-bots/pull/1398 (layer 8, draft, head `1d4d84b796`, based on `build/sturdyref-ocapn-enliven-f212191`). CI is red at the current head: `ci-wait-merge.sh` returned rc=3. The coverage pass itself was clean.

**Coverage and dead code:** nothing to change, so I pushed nothing.
- In an isolated checkout, `packages/daemon/test/formula-sturdyref.test.js` passes all 5 tests under c8.
- `packages/daemon/src/formula-sturdyref.js` has 100% statement, branch, function and line coverage.
- The PR only adds code (the new module, its wiring in `manager.js`, a dependency on `@endo/sturdyref`, and tsconfig references). None of it leaves dead code behind.

**Why CI is red (run 36690025489), and why it can't be fixed from layer 8:**
1. **All 7 `test`, `cover` and `test-xs` legs** fail when turbo builds its task graph: `Cyclic dependency detected: @endo/sturdyref#build <-> @endo/pass-style#build`.
   - Layer 3 made `@endo/pass-style` depend on `@endo/sturdyref`.
   - Layer 1's `packages/sturdyref/package.json` has a devDependency on `@endo/pass-style`, which only `test/sturdyref-shim.test.js` uses.
   - Turbo counts devDependencies, so the two packages depend on each other.
2. **`lint`** fails at "Build composite TypeScript declarations": `packages/captp/src/captp.js(199,39): TS2339 Property 'enliven' does not exist on type 'object'`. The line comes from layer 5/6 (`86f4a0263f`/`ef45f1dc0a`).

Neither file is in #1398's diff. Layer 7 (https://github.com/endojs/endo-but-for-bots/pull/1397) fails the same `lint`, `test` and `cover` checks.

**Follow-ups:**
- I sent the details over the bus to the jobs currently in progress on the layers that own each defect:
  - The cycle went to `ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-1`.
  - The captp TS error went to `ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-clean`.
- Once those layers are fixed, layers 7 and 8 need a restack (weave) onto the fixed bases, and then this clean stage needs to run again.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1514165 cached reads)
- Output: 7784 tokens
- Cost: $1.003913
- Wall-clock: 238s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
