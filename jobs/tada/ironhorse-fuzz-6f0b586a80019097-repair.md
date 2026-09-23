Zero fail legs. `test-ironhorse` — the CI leg that exercises my change — passes (45s), as does test262 22.x. The remaining pending legs (lint/test-xs/test262 24.x) are JS/other suites unaffected by my Rust-only test additions, and none have failed. A fresh workflow re-run is in flight (the standing PR re-runs CI continuously as peers amend), but my finding's obligation is discharged.

## Completion report

**Job:** Fix Ironhorse fuzz finding `6f0b586a80019097` (target `differential_regexp_surface`) and amend the standing PR.

**What I found.** Reproduced the finding's exact 5-byte minimized input (sha256 verified `7637ee2c…f965497`, decoded from the journal `input_base64`, never inlined). It folds into a deeply nested `new RegExp(pat, "").source` program whose rendered completion value is **1160 bytes**. At the finding's project SHA `38ca1d18` the XS differential oracle captured completions into a fixed **1024-byte** buffer and truncated to 1023 bytes, so the harness compared its truncated prefix against the port's correct full 1160-byte result and reported a false divergence.

**Root cause / fix.** This is a member of the **already-fixed** truncation class `493390fc03979205`. The causal oracle-side fix (grow `ENDOR_RESULT_MAX` to 16 KiB + honest-skip on overflow) landed *after* the finding SHA (confirmed via `git merge-base`). Verified at the branch head the exact input now checks clean (`differential_check_with_symbols → Ok`, full 1160-byte compare agrees). **No new code change required** — the deliverable is a load-bearing regression lock.

**What changed** (committed `3a695f3db`, pushed to the standing branch `kriscendobot:ironhorse-fuzz-findings` via fetch/rebase/push CAS):
- `ironhorse-vm/tests/finding_6f0b586a80019097_regexp_source.rs` (+ 4 frozen fixtures: input/bytecode/symbols/expected-result) — replays the program from frozen bytecode+symbols **without the XS oracle or c/moddable submodule**; asserts the port renders the whole 1160-byte source (crossing the former 1023-byte boundary) without panic or truncation. This is the leg the crate CI runs (`cargo test -p ironhorse-vm` — verified green locally, 106 + all per-finding tests pass).
- `ironhorse-fuzz/src/lib.rs` test `finding_6f0b586a80019097_regexp_source_agrees` (+ `input.bin` fixture) — replays the exact input through the real `differential_check_with_symbols`, asserting no divergence (load-bearing against an oracle-fix revert; verified green locally).

**PR.** Adopted the standing PR **#1088** via `ensure-pr.sh` (marker `<!-- garden-job: ironhorse-fuzz-findings -->`; created nothing). Documented finding `6f0b586a80019097` as a [PR comment](https://github.com/endojs/endo-but-for-bots/pull/1088#issuecomment-5473274427) (comment rather than body edit, to avoid racing concurrent findings amending the body).

**CI/gauntlet.** `test-ironhorse` passes on the pushed branch state; zero fail legs. Fmt-clean (my files), no source-code change so lint/JS suites are unaffected.

**Follow-ups:** none for this finding. The standing PR remains open and continuously accretes further fuzz findings; its CI re-runs on each peer amendment.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-6f0b586a80019097-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 110 tokens (4526367 cached reads)
- Output: 39265 tokens
- Cost: $4.3348485 (2 engagement(s) unpriced)
- Wall-clock: 1270s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
