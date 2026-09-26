Everything landed. Job complete.

## Completion report: design the endor↔node fixture-parity ratchet campaign

**Starting state (re-derived after the requeue):** clean start — no design doc on `main2`, no PR, the prior manifest job `endojs-endo-but-for-bots-pr282-fixture-parity` is `tada` (its manifest lives on PR #282 head `feat/endor-run-entry-point-deps`), and this job's inbox was empty. Nothing from a prior attempt survived, so I built from scratch.

**What I did**
- **Fetched the actual manifest** (`rust/endo/tests/compartment_mapper_fixture_parity.rs`) from the PR head and read the *exact* `reason` strings for all 40 fixtures (7 `Exercise`, 33 `Exclude`) rather than working from the job spec's approximate clusters — the manifest has more excluded fixtures (noble, policy, resolve, retained, shortest-path{,-cycle}, common-deps, symlink, strictly-inconsistent-{directories,packages}, package-imports-exports) than the spec enumerated.
- **Wrote `designs/endor-fixture-parity-ratchet.md`** and pushed it to `main2` (rebase-CAS, `PUSHED`). It delivers all five required parts:
  1. The 33 exclusions grouped into 8 capability groups (A CJS-require, B dynamic, C exports/imports, D dep-classification, E asset-languages, F host-hooks, G nested/symlink/resolve, H cm-specific), with per-fixture primary/secondary blockers; all 33 accounted (5+4+4+3+2+3+5+7).
  2. Seven ratchet increments (plus Increment 0 scaffold), easiest/highest-value first, each with an explicit acceptance gate and an exercised-floor target (7→11→16→19→23→28→30→32).
  3. The harness problem addressed as an **emulate-vs-refactor decision table per group**, on the rule "do not refactor away the thing under test" — e.g. emulate the `endo:lib` condition set and `.text` parser registration identically on both sides; keep host-hook fixtures durably excluded until endor grows a host-hook surface.
  4. A concrete ratchet mechanism: two-tier `PendingExclude`/`DurableExclude`, atomic graduation, a ratcheting anti-backslide exercised floor, and a harness-free **node reference oracle** (`gen-parity-golden.mjs`) producing committed structural golden compartment-maps as the "parity with node" assertion.
  5. Decomposition into an orchestration with one parked child per capability group, ordered, with dependencies stated. Top-level `test/fixtures` hoist kept explicitly out of scope.
- **Posted the campaign** per the standing multi-part rule: 8 orchestrated `builder` children parked in `plan/` (`endor-parity-oracle-scaffold`, `endor-walker-{cjs-require,exports-resolution,dep-classification,dynamic-import,nested-resolution,language-extensions,host-hooks}`) and the serial, halt-on-failure orchestration `endor-fixture-parity-ratchet-campaign`. Verified on the journal.

**Follow-ups:** the leader-only `garden-orchestrate` timer will now drive the campaign — promoting child 0 first, then each subsequent increment as the prior reaches `tada`. Child 7 (host-hooks) is gated: it instructs the builder to hand back if endor's `run` entry point lacks a host-hook surface rather than force it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endor-fixture-parity-ratchet.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 28 tokens (865577 cached reads)
- Output: 22708 tokens
- Cost: $1.6196685 (1 engagement(s) unpriced)
- Wall-clock: 360s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
