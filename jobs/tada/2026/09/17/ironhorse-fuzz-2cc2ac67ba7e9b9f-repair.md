My commit `282810735` and all four fixtures + the regression test are present on the current branch head `959072767` — peers have since landed additional findings on top, exactly as the shared standing branch is designed to work. CI is running per-push on the standing PR and `test-ironhorse-calibration` (which exercises the cost tables) passed.

Everything is durable. Here is my report.

---

## Completion report — finding `2cc2ac67ba7e9b9f` (`differential_regexp_surface`)

**Diagnosis.** Reproduced the finding faithfully at the recorded project SHA `38ca1d1893` (built the pinned `nightly-2026-08-15` + `xs-oracle` + peer-init'd `c/moddable` submodule). The 26-byte input folds through `gen_stage3b_regexp_program` into:
```js
new RegExp("((a*|\\2\\2+[abc]?)?[a-c]*|(\\1*a*)(\\4\\n?)?)?[a-c]*|((a*)? )([abc]?[abc]*|\\7{2})|a*", "i").exec("    \n\n\n\n")
```
At the finding SHA the surface arm gated on XS-computron equality and reproduced `computrons: oracle=72 ironhorse=73`. The `exec` **completion value agreed bit-for-bit** with the pin (`",,,,,,,"`) — only the meter diverged by one. This is the same class as sibling `c6c71d428a37088c`: a cost-table difference, **not a correctness defect**. The port matched, shaped the `exec` array, and coerced it identically.

**Causal fix (already landed).** The surface harness now treats XS computrons as advisory (`differential_check_meter_v4` / `compare_observations`: *"XS computron equality cannot gate an IronHorse cost-table recalibration"*), so the divergence is no longer a finding. Verified authoritatively at current `llm` HEAD with the exact repro command — `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1` runs **clean, no divergence** (port now meters 82 vs XS 72, result identical). The port was always correct on the observable value.

**What changed.**
- Added submodule-free regression `rust/engine/ironhorse-vm/tests/finding_2cc2ac67ba7e9b9f_regexp_surface_meter.rs` + 4 frozen fixtures (input, bytecode, symbols, expected-result), replaying the exact input's generated program through `run_program_with_symbols` and asserting completion + byte-identical `exec` result (computrons deliberately not pinned — advisory). Test passes; `cargo fmt --check` clean.
- Committed `282810735` with pathspecs, rebased CAS onto the standing branch, pushed to `kriscendobot:ironhorse-fuzz-findings`.
- Adopted standing PR **endojs/endo-but-for-bots#1298** via `ensure-pr.sh` and appended a finding `2cc2ac67ba7e9b9f` section to the PR body.

**Verification / gauntlet.** New test passes locally; branch builds. The standing PR's CI is running per-push; `test-ironhorse-calibration` and `zizmor` passed. My commit + files confirmed present on the current branch head after peers landed further findings on top (shared standing branch, working as designed).

**Note (not attributable to this change):** `ironhorse-vm` `tests/math_determinism.rs::special_values_and_domain_boundary_observations_are_bit_exact` fails locally (`acosh(DBL_MAX)` → finite on this host's libm vs pinned `+Inf`). Confirmed it fails **identically on the base commit** before my change — a pre-existing host-libm/environmental discrepancy, orthogonal to this regexp-only work, and green on CI's Ubuntu runners.

**Follow-ups:** none required. The finding is documented, regression-locked, and neutralized.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-2cc2ac67ba7e9b9f-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 100 tokens (4170015 cached reads)
- Output: 36646 tokens
- Cost: $4.102126500000001 (2 engagement(s) unpriced)
- Wall-clock: 1578s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
