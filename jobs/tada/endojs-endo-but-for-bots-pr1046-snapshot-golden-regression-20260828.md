The job is complete. Here is my completion report.

## Completion report: `endojs-endo-but-for-bots-pr1046-snapshot-golden-regression`

**Finding on re-derivation:** The regression was already fixed by a prior attempt whose commit was folded into the rebased PR head. No new code change was needed — I re-verified the fix end-to-end and posted the up-to-date completion evidence.

**State when I picked it up:** The PR branch `feat/ironhorse-coverage-matrix` had advanced from the job's cited head `0b41e21bea` to `14194b562`. The stale golden hash (`6f821b0c…`) had already been re-pinned to the computed stable value `d34c62fc6ac11563e01c14e0a2316a846e872f0a2368f0ec931243772dc733ea` inside commit `5c9f59121 fix(ironhorse): harden VM dispatch and intrinsic metadata` (the rebased successor of the toStringTag fix). A prior attempt also left a shepherd summary comment (for the now-superseded head `d2c40795d4`).

**Verification I performed (real execution):**
- `golden_vector_pins_canonical_bytes_and_seal` ran **3× → identical hash each time** — proving the new canonical value is deterministic (a value change, not new nondeterminism). Delta attributable to the intended generator-family `Symbol.toStringTag` boot-heap addition.
- `cargo test -p ironhorse-snapshot --test metamorphic_determinism` → **5 passed, 0 failed** (all seven-way file+memory store agreement paths).
- `cargo test -p ironhorse-vm -p ironhorse-snapshot` (the exact `test-ironhorse` CI scope per `.github/workflows/ci.yml:755`) → **all green** locally. (The full workspace `cargo test` fails only on `xs-oracle`, which needs the Moddable submodule and is *not* in the `test-ironhorse` scope — the noted gotcha.)
- PR CI: **`test-ironhorse SUCCESS`** on head `14194b562` — run `33141444672`, job `98752995882`. Entire rollup green.

**Actions taken:**
- Posted an up-to-date completion-summary comment on PR #1046 citing the `4f8f4fad32` green → `0b41e21bea` red → fixed trace and the green run: https://github.com/endojs/endo-but-for-bots/pull/1046#issuecomment-5449209299

**No merge performed** (per mandate). No follow-ups. The golden remains an asserting pin (not loosened). Distinct async-instance-OOM and generator-frame jobs left untouched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1046-snapshot-golden-regression-20260828.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 37 tokens (1022404 cached reads)
- Output: 9181 tokens
- Cost: $1.1978549999999997 (1 engagement(s) unpriced)
- Wall-clock: 220s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
