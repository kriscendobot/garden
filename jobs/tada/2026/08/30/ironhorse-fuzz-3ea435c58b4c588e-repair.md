**`test-ironhorse` has passed again** on the current CI run (`a2733761a`), which includes my commit `e29083075` and runs my new ironhorse-vm frozen regression test — definitive CI evidence. The remaining pending jobs (test-xs and JS jobs) are unrelated to my Rust-test-only change and show zero failures. The deliverable is complete: my regression commit is durably in the standing branch and PR #1088.

## Completion report

**Finding `3ea435c58b4c588e`** (target `differential_regexp_surface`, toolchain `nightly-2026-08-15`, 4-byte input `8c 8c 8c a2`, sha256 `9df4e2b4…16e1638`) — reproduced, diagnosed, regression-locked, and amended onto the standing PR.

**What the crash was.** The structure-aware generator folds these 4 bytes into a deeply nested `new RegExp("(?:0{1,3}…", "s").toString()`. The completion value — the `/source/flags` string — is **1128 bytes**.

**Root cause — oracle-side, not the engine (same class as finding `493390fc03979205`).** I peer-initialized the `c/moddable` submodule (pin `23b4d6b0`) and reproduced the crash from the durable artifact (sha256 verified). On the `llm` base the fuzzer tests (old 1024-byte capture buffer) the crash reproduces: `Divergence { detail: "result: oracle=\"/(?:0{1,3}…\" (truncated ~1023 B) ironhorse=\"/…/s\"" }`, exit 77. The XS differential oracle truncated its *own* reference completion value at its fixed buffer, so the harness read the port's **correct** full 1128-byte result as a divergence. The port was never wrong.

**Fix — already present; no code change needed.** The causal defect was fixed for the same-class finding `493390fc03979205` (grow `ENDOR_RESULT_MAX` to 16 KiB + honest `result_truncated` skip on overflow). At the standing branch tip the oracle now captures the full 1128-byte result (`result_truncated=false`, under the 16 KiB buffer) and both engines agree. Confirmed clean: same repro command on the standing branch → `Executed … in 7 ms`, exit 0. This finding is a distinct minimized input the standing-branch fix already covers — the fuzzer keeps re-surfacing this class because it fuzzes `llm`, which never receives the standing-branch fixes.

**Regression lock added** (`fuzz/corpus` is gitignored, so a corpus seed is not permanent):
- `ironhorse-fuzz` unit test `finding_3ea435c58b4c588e_regexp_tostring_agrees` — replays the exact 4 bytes through the real `differential_check_with_symbols` and asserts no divergence (load-bearing; fails if the oracle buffer fix is reverted). Passes locally.
- `ironhorse-vm/tests/finding_3ea435c58b4c588e_regexp_tostring.rs` — replays the finding's program as **frozen bytecode+symbols** (no XS oracle / no `c/moddable`), asserting the port renders the whole 1128-byte result (`> 1023` bytes) without panicking or truncating. Passes locally **and in CI** (`test-ironhorse` green, twice).

**Landed.** Committed `e29083075`, pushed to `kriscendobot:ironhorse-fuzz-findings` with fetch/rebase/CAS discipline (rebased onto a concurrent peer finding), standing **PR #1088** confirmed via `ensure-pr.sh` (adopted, not duplicated). Finding documented as a PR comment (`#issuecomment-5467102005`). A peer has since stacked finding `5c29667cc15d6d93` on top; my commit remains a durable ancestor of the branch tip. The standing PR intentionally stays draft (findings collector).

**Verification (real execution).** Crash reproduced on `llm` (exit 77, divergence captured); clean on standing branch (exit 0); both regression tests pass locally; `test-ironhorse` (runs the frozen ironhorse-vm test) green on CI. No failures across the CI suite; `test-xs`/JS jobs pending are unrelated to this Rust-test-only change.

**Follow-up (not blocking, pre-existing).** These oracle-truncation findings recur only because the fixes live on the standing branch and are never merged back to `llm`; each merge of #1088 would stop the re-discovery. Clippy is not installed for the pinned `nightly-2026-08-15` toolchain in this environment (CI's `lint` job runs it properly); the change is additive test code.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-3ea435c58b4c588e-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 198 tokens (12404158 cached reads)
- Output: 61671 tokens
- Cost: $10.867123999999997
- Wall-clock: 1203s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
