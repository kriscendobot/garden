Everything is verified and landed. The job is complete.

## Completion report

**Finding `493390fc03979205`** (target `differential_regexp_surface`, toolchain `nightly-2026-08-15`, 4-byte input sha256 `450a95b7…dabbcf7`) — reproduced, root-caused, fixed, regression-locked, and amended onto the standing PR.

**Reproduced.** Decoded `input_base64` (`CHR0Kg==` → `08 74 74 2a`, sha256 verified). The generator folds it into a deeply nested `new RegExp(<pattern>, "s").toString()` whose completion value is **1099 bytes**. Reproduced the divergence two ways: the pure-Rust path (`ironhorse_compile::compile_atoms` → `ironhorse_vm::run_program_with_symbols`) and the real XS differential (`xs_oracle::run`, building the oracle against a host-local `c/moddable` at the pinned SHA `23b4d6b0`, symlinked from `.garden-state` to avoid the multi-GB fetch).

**Root cause — harness-side, not the engine.** The XS oracle shim captured the completion value into a fixed `char result[1024]` and `strncpy`-truncated it to **1023 bytes**. The port (ironhorse) rendered the whole 1099-byte string *correctly*, so the harness compared its own truncated prefix against the port's full result and panicked on a false "result divergence." (Same class as the peer's finding `5d122a6fc10babd9`, an oracle-side 32-bit meter truncation — both are oracle-harness defects, not port bugs.)

**Fix (oracle-side, minimal).** Grew `ENDOR_RESULT_MAX` to 16 KiB and recorded the untruncated length (`result_len`) at both capture sites in `xs_shim.c`; surfaced `OracleOutcome::result_truncated` in `xs-oracle/src/lib.rs`; and made `differential_check_with_symbols`/`differential_check_result_only` **skip honestly** when a result still overflows the buffer — closing the false-positive class at any size. No engine/port code changed.

**Regressions added (all green).**
- `ironhorse-vm/tests/finding_493390fc03979205_long_regexp_tostring.rs` — replays the finding's program as frozen bytecode+symbols, asserts no panic and the full untruncated 1099-byte result. **Builds without the oracle/submodule** — the CI-visible regression (`test-ironhorse` runs it).
- `xs-oracle` unit test — a 2000-char completion value is captured untruncated and not flagged.
- `ironhorse-fuzz` unit test — replays the exact input through the real differential check, asserts no divergence (load-bearing; fails if the fix is reverted).

**Landed & verified.** Committed `7fae4aea2f`, created the standing branch `kriscendobot:ironhorse-fuzz-findings`, and opened standing PR **#1088** via `ensure-pr.sh` (marker-adopted). The peer finding `5d122a6fc10babd9` subsequently stacked additively (branch tip `c8497fd88b`); confirmed my commit and every one of my changes survive intact at the tip. Finding documented in the PR body. **All 24 CI checks pass** at the current head, including `test-ironhorse` (my regression) and `test-xs` (7m51s, oracle-linked tests with the submodule). Per the standing-PR convention (and the peer's completed precedent), the PR stays **draft** across the generation rather than being un-drafted per finding.

**Follow-up (not blocking).** The script/module oracle path (`XsOracleResultRaw.meter_raw`/`computrons`, `ModuleRunOutcome`) still carries `u32` meter fields and an unconsulted `result_truncated` on the module path — the same latent truncation class. Worth a preemptive widening before a future finding surfaces it (independently flagged by the peer too).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-493390fc03979205-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 242 tokens (15839877 cached reads)
- Output: 95188 tokens
- Cost: $14.130158499999997
- Wall-clock: 1748s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
