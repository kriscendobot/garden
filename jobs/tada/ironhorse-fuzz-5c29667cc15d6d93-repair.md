## Completion report — fuzz finding `5c29667cc15d6d93` (`differential_source`)

**Outcome: regression-only amend to standing PR #1088. This finding is a duplicate of the already-fixed dtoa class (`d99d263fcf6ca7a7`); no new port or harness code change was needed.**

### What I found (reproduced, oracle-verified)
- The 5-byte input `e1 1b dc dc dc` (sha256 verified `203db557…449e2`) folds, via the real `ironhorse_fuzz::gen_program`, into `((-(-(-226492416))) * (-(-(-226492416))))`.
- `226492416 = 27·2²³`; the triple negate collapses to `-x`, so the value is `226492416² = 729·2⁴⁶ = 51298814505517056`, an exactly-representable double.
- Built the pinned XS oracle (moddable `23b4d6b`, symlinked from the host's preserved copy) and ran the differential directly:
  - XS `fx_dtoa` → `"51298814505517056"` (17-digit exact integer)
  - ironhorse → `"51298814505517060"` (shortest round-trip, **byte-identical to Node/V8**)
  - **BYTE-EQUAL = false** → at the fuzzed base SHA `differential_check` compared strings byte-for-byte and panicked (the crash). **SAME-DOUBLE = true** → the standing branch's `results_agree` (compare Number completions by `f64`, landed for `d99d263`) already suppresses it. ironhorse is the spec-conformant side (ECMA-262 §6.1.6.1.20).

### What changed (commit `a2733761a5` on `kriscendobot:ironhorse-fuzz-findings`)
- **`ironhorse-vm/tests/finding_5c29667cc15d6d93_large_integer_dtoa.rs`** — the load-bearing, CI-visible, submodule-free regression: pins `number_to_ecma_string(729·2⁴⁶) == "51298814505517060"` so the port can never be "corrected" to XS's non-conformant exact-integer spelling.
- **`ironhorse-fuzz` test `finding_5c29667cc15d6d93_large_integer_dtoa_agrees`** — replays the exact bytes through `gen_program` + `differential_check`, asserts no divergence (oracle-verified).

### Verification
- Full `cargo test -p ironhorse-vm` suite: green. Oracle-linked `ironhorse-fuzz` finding tests: green (3/3).
- Pushed with fetch/rebase/push CAS (rebased over a concurrent finding amend). Adopted standing PR **#1088** via `ensure-pr.sh` (marker present, nothing created). Documented the case+solution as a PR comment.
- **Gauntlet: the relevant engine gate `test-ironhorse` CI job (which runs the new ironhorse-vm regression) passed green (54s)** on the pushed commit; remaining JS-side checks are pending and unaffected by this rust-only additive change.

### Follow-ups
- None required for this finding. The dtoa class remains fully suppressed by `results_agree`; the fuzzer will keep rediscovering this class only because it runs against `origin/llm` (pre-fix), which is by design — each such rediscovery is a duplicate that this repair-job flow absorbs into the standing PR as a pinned regression.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-5c29667cc15d6d93-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (5546565 cached reads)
- Output: 45462 tokens
- Cost: $5.062193499999998
- Wall-clock: 862s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
