The `test-ironhorse` CI leg — which runs the exact CI-gated suite (`cargo test -p ironhorse-vm -p ironhorse-snapshot`) including my new regression test — **passed** (45s). The job is complete.

## Completion report

**Finding `7277b0fc4a72d8d6`** (target `differential_source`, toolchain `nightly-2026-08-15`) — reproduced, diagnosed, and regression-locked. It was **already fixed** at the standing branch head; the deliverable is a load-bearing regression lock plus documentation.

**What I did**
- Recovered the 3-byte minimized input (`3f f7 de`) from the journal `input_base64`; verified sha256 = `0792c486…d08b`.
- Set up the pinned fuzz env (peer-init of the `c/moddable` submodule at `23b4d6b0`, `nightly-2026-08-15`, cargo-fuzz).
- **Reproduced faithfully**: crashes at the fuzz SHA `38ca1d18…`, does **not** crash at branch HEAD. Panic detail: `result: oracle="22799472811573248" ironhorse="22799472811573250"`.
- **Root cause**: the program folds to `150994943² = 22799472811573248`, an exactly-representable double. XS's `fx_dtoa` prints the exact 17-digit integer; ironhorse prints the ECMA-262/V8-shortest `22799472811573250`. Both parse to the identical double — a pure decimal-spelling divergence, the same class as `284de587e16bce32`/`d99d263fcf6ca7a7`/etc., already suppressed by the numeric `results_agree` comparison (`4ae39593b`). **No port or harness change was needed.**

**What changed** (commit `0fa3cecf2` → rebased/pushed as `7205b4b3c` on `kriscendobot:ironhorse-fuzz-findings`):
- `ironhorse-fuzz` `tests::finding_7277b0fc4a72d8d6_large_integer_dtoa_agrees` — replays the exact 3 bytes through the real `differential_check`; load-bearing against the pinned XS oracle (fails if `results_agree` is reverted). Verified locally: **passes**.
- `ironhorse-vm/tests/finding_7277b0fc4a72d8d6_large_integer_dtoa.rs` — pins the reproducing value's `number_to_ecma_string` to the shortest decimal (CI-gated, no oracle/submodule). Verified via CI `test-ironhorse` leg: **pass**.
- Resolved a rebase conflict against a peer's concurrent finding `7152c1a9960a0688` (both tests now coexist; peer's test still passes).

**PR**: adopted the standing draft PR #1088 (marker `garden-job: ironhorse-fuzz-findings` confirmed); documented this finding as a PR comment (`#issuecomment-5473312550`). Full ironhorse test suite green locally; `test-ironhorse` CI leg passed.

**Follow-ups**: none. The dtoa-spelling class is fully suppressed and now has per-input regression coverage extended to this case.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-7277b0fc4a72d8d6-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 116 tokens (4662610 cached reads)
- Output: 37294 tokens
- Cost: $4.330239
- Wall-clock: 681s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
