Job complete. Summary report:

## Completion report — fuzz finding `7152c1a9960a0688` (target `differential_source`)

**Diagnosis.** The 8-byte input `27 79 00 00 00 57 2d 08` folds (via `gen_program`) into the arithmetic program `((((1015021568 / true) * (377487360 + -89)) + (-(true + 377487360))) || 1015021568)`. Its completion is the exactly-representable double `383157721332973568` (bits `0x439544ffab840000`). The differential harness flagged a `result` divergence purely on **decimal spelling**:
- XS oracle (`fx_dtoa`): `383157721332973570` (non-shortest 18-digit)
- ironhorse: `383157721332973600` (ECMA-262 §6.1.6.1.20 shortest round-tripping, matching V8/Node)

Both spellings parse to the identical double — same value, rendering-only difference. This is the same class as findings `d99d263fcf6ca7a7` / `284de587e16bce32` / etc.

**Reproduction.** Confirmed faithfully: rebuilt the fuzz lib with a byte-exact comparison (emulating the fuzzed base `38ca1d18`) against the real pinned XS oracle → divergence reproduced (`oracle="383157721332973570"` vs `ironhorse="383157721332973600"`). At branch HEAD (with the existing `results_agree` numeric comparison) it checks clean. Verified all three spellings share bits `0x439544ffab840000`.

**Fix.** No new port/harness change needed — the causal fix (`results_agree`, compare Number completions by parsed double not spelling; commit `4ae39593b`) is already on the standing branch and suppresses this input. This finding is a distinct instance of an already-solved class.

**Regressions added** (commit `4d62e0644` → pushed to `kriscendobot:ironhorse-fuzz-findings`, now `6f54f91a3` after rebasing over a peer's concurrent finding):
- `ironhorse-fuzz/src/lib.rs` — `finding_7152c1a9960a0688_large_integer_dtoa_agrees`: replays the exact 8 bytes through the real `differential_check` against the pinned oracle, asserts no divergence (load-bearing; fails if `results_agree` is reverted). Local/manual (needs oracle + submodule).
- `ironhorse-vm/tests/finding_7152c1a9960a0688_large_integer_dtoa.rs`: pins the reproducing value's `number_to_ecma_string` to the shortest decimal; builds without the oracle and **runs in CI** (`cargo test -p ironhorse-vm`). Both tests pass locally.

**PR.** Adopted the standing draft PR **#1088** (marker `garden-job: ironhorse-fuzz-findings` confirmed). Documented finding `7152c1a9960a0688` as a PR comment. CI gate **`test-ironhorse` passed** (green); no failing checks. PR stays draft by design (findings accumulate).

**Notes / follow-ups.** Local `cargo fmt --check`/`clippy` show pre-existing drift across untouched code (a local rustfmt-version mismatch; a pre-existing clippy `iso8601` logic-bug lint in Temporal code) — neither is gated by CI for these crates and neither is introduced by this change; I left pre-existing code untouched. Remaining in-progress CI legs are JS/test262/browser suites orthogonal to this two-file Rust-test addition.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-7152c1a9960a0688-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 106 tokens (3676688 cached reads)
- Output: 32405 tokens
- Cost: $3.5457520000000002 (2 engagement(s) unpriced)
- Wall-clock: 1344s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
