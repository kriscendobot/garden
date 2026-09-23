All 22 checks pass with zero failures; only JS `lint` (unrelated to this Rust-only change) is still pending. The decisive engine checks — `test-ironhorse` and `test-xs`, which build the XS oracle with the submodule and run both new regression tests — pass. The job is complete.

---

## Completion report

**Finding `5d122a6fc10babd9`** (target `differential_regexp`, toolchain `nightly-2026-08-15`, 3-byte input sha256 `79942bf9…d7a917`) — reproduced, diagnosed, fixed, regression-locked, and amended onto the standing PR.

**What the crash actually was.** A `differential_regexp` "match meter" divergence: `ironhorse=15969222656` vs `pin=3084320768` on a deeply nested empty-matchable pattern over `"00b00"`@2. I peer-initialized the `c/moddable` submodule (pin `23b4d6b0` = 8.3.1) from a peer worktree and reproduced the crash with the prescribed `cargo +nightly-2026-08-15 fuzz run` command.

**Root cause — harness-side, not the engine.** I instrumented both matchers with a per-opcode histogram: they dispatch the **identical** 243671 steps (op-for-op equal). So the port's meter was correct. The raw 16.16 meter is `243671 × 65536 = 15_969_222_656`, past 2³². XS's own `meterIndex` is a `txU8` and the port meters into a `u64` — both hold the full value — but the differential **oracle shim** copied the meter into a 32-bit `txU4` field and wrapped it (`15969222656 mod 2³² = 3084320768`; the gap is exactly `3 × 2³²`). Same class as the prior standing finding `493390fc03979205` (an oracle-side truncation of a value the port computes correctly).

**Fix (oracle-side only, minimal).** Widened the regexp meter fields to 64-bit end to end — `EndorRegExpResult` in `xs_shim.c` and `XsRegExpResultRaw`/`RegExpOutcome` in `xs-oracle/src/lib.rs` — and dropped the now-redundant `as u64` casts at the two comparison sites (fuzz arm + parity suite). No engine/port code changed.

**Regressions added.**
- `xs-oracle` unit test `regexp_match_meter_is_not_truncated_to_32_bits` — asserts the oracle reports the full `15_969_222_656` (fails pre-fix with the wrapped value). Needs the submodule, like its siblings.
- `ironhorse-vm/tests/finding_5d122a6fc10babd9_regexp_meter_overflow.rs` — replays the exact case through the port's `compile`+`match_regexp`, asserting no panic and the full-width meter `> u32::MAX`. Builds without the oracle or submodule, per the standing-branch convention.

**Verification.** Fuzz repro now exits clean. `cargo test` green for `xs-oracle`, `ironhorse-regexp` (parity), `ironhorse-fuzz`, and `ironhorse-vm`; clippy adds zero new warnings. (The parity `unicode_sets` test needs `RUST_MIN_STACK` bumped for a **pre-existing** debug-build stack-depth issue — confirmed present on the untouched base — unrelated to this change.)

**Landed.** Committed `c8497fd88b` and amended the standing branch `kriscendobot:ironhorse-fuzz-findings` with fetch/CAS discipline; standing PR **#1088** confirmed via `ensure-pr.sh` (adopted, not duplicated); finding documented as a PR comment. All 22 substantive CI checks pass (`test-ironhorse`, `test-xs` included); only JS `lint` is still pending and no check failed.

**Follow-up (not blocking).** The script/module oracle path (`XsOracleResultRaw.meter_raw` / `computrons`, `OracleOutcome`/`ModuleRunOutcome.meter_raw`) is still `u32` and shares the same latent 32-bit truncation for any long-running program whose raw meter exceeds 2³². Worth a preemptive widening before a future finding surfaces it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-5d122a6fc10babd9-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 212 tokens (13728543 cached reads)
- Output: 82786 tokens
- Cost: $10.9415835
- Wall-clock: 2339s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
