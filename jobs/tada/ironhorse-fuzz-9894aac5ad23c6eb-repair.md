All work complete. Summary below.

---

## Completion report: repair Ironhorse fuzz finding `9894aac5ad23c6eb` (target `differential_regexp`)

**Reproduced & diagnosed.** The 3-byte input `68 73 74` ("hst", sha256 verified) folds through `ironhorse_fuzz::gen_regexp` into a deeply nested capturing pattern of quantifiers and numeric backreferences (778 chars), flags `m`, subject `" "`, start `0`. I built the pinned `nightly-2026-08-15` + peer-init `c/moddable` fuzz environment and confirmed:
- **At the finding SHA `38ca1d1893`: it reproduces** — `match meter ironhorse=29761142784 pin=3991339008`.
- **At the current standing base: it agrees** (no divergence).

**Root cause (harness-side, already fixed).** `29_761_142_784 mod 2^32 = 3_991_339_008` exactly — the XS differential oracle was copying the pin's 64-bit `meterIndex` into a 32-bit field, wrapping it and manufacturing a phantom divergence. The port meters into a `u64` and was always correct. This is the **same class** as standing finding `5d122a6fc10babd9`, resolved on `llm` by `c8497fd88` (*"stop truncating the differential regexp match meter"*, widening the oracle fields to 64 bit) — an ancestor of the branch HEAD but **not** in the `38ca1d1893` SHA the finding was recorded against. No port code change was needed or made.

**Load-bearing regression added.** `rust/engine/ironhorse-regexp/tests/finding_9894aac5ad23c6eb_regexp_meter_overflow.rs` (builds without the oracle or `c/moddable` submodule, per standing-branch convention) replays the exact pattern/flags/subject/start through `compile`+`match_regexp`, asserting no panic, a match, and the full-width raw meter `29_761_142_784` (> `u32::MAX`); a second assertion forbids the wrapped `3_991_339_008` figure, so any future narrowing of the matcher's meter fails the test.

**Amended standing PR #1298** (`kriscendobot:ironhorse-fuzz-findings` → `llm-387ea66`, draft): pushed with fetch/rebase/push CAS (rebased cleanly over two concurrent peer findings). Documented finding `9894aac5ad23c6eb` in the PR body following the existing per-finding narrative.

**CI-health follow-up.** The `cargo +1.88.0 fmt --check` engine-workspace gate was red on a **peer's** already-landed file (`finding_c99f800f6a36e8a6`, a >100-col `const`). I applied the rustfmt-mandated wrap in a scoped `style(...)` commit so the shared PR's format gate is green (peer job confirmed not alive).

**Local CI-equivalent — green.** `cargo test --locked -p ironhorse-regexp -p ironhorse-vm --features ironhorse-vm/store-integrity` passes (0 failures, incl. my test); full engine-workspace `fmt --check` clean. Remote CI on #1298 is pending.

**Follow-ups.** None required — the defect was already resolved upstream; this PR is the regression lock. If remote CI goes red it would be a shepherd concern, but local parity checks pass.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-9894aac5ad23c6eb-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 116 tokens (4792116 cached reads)
- Output: 38907 tokens
- Cost: $4.480247000000001 (2 engagement(s) unpriced)
- Wall-clock: 1429s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
