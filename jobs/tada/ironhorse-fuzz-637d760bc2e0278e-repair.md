Inbox empty. The job is complete.

## Completion report

**Finding `637d760bc2e0278e` (target `differential_regexp`) — reproduced, root-caused, regression-locked, PR amended.**

**Reproduced.** Decoded the 4-byte minimized input `68 d4 80 df` (sha256 verified `8c079997…4e0130`). Set up the pinned fuzz env (`c/moddable` peer-init at pin `23b4d6b0`, `nightly-2026-08-15`) and reproduced the crash at the finding SHA `38ca1d18`: a **match-meter divergence** in the differential arm — `ironhorse=30024138752` vs `pin=4254334976`. The 4 bytes fold (via `gen_regexp`) into a 999-char, deeply-nested, **backreference-heavy** pattern (`\1`…`\21`) over subject `"b 00b"`; it never matches but the port explores **458132** metered backtracking steps → raw 16.16 meter `458132 × 65536 = 30024138752` (> `u32::MAX`).

**Root cause.** `4254334976` is exactly `30024138752 mod 2³²` — the XS differential oracle copied the pin's 64-bit `meterIndex` into a 32-bit `txU4`, wrapping the value and manufacturing a false divergence. The port (`ironhorse_regexp`) meters into `u64` and was always correct. This is the **same class** as the already-landed findings `5d122a6fc10babd9` / `8275793bca439f6e` / `407764ab1120ed1a` (oracle meter-truncation). Verified: at the branch head the exact case now returns agreement (`differential_check_regexp → Ok`), so the earlier oracle-side 64-bit widening already covers this input — **no new code fix was required**.

**Regression (load-bearing).** Added `rust/engine/ironhorse-vm/tests/finding_637d760bc2e0278e_regexp_meter_overflow.rs`, byte-exact pattern generated programmatically (no manual transcription), pinning the port's full-width meter (`30024138752`) bit-exact and asserting it stays `> u32::MAX` and never equals the wrapped `4254334976`. Builds **without the XS oracle or `c/moddable` submodule** — the portable source-of-truth the oracle must agree with, guarding the matcher against ever silently narrowing the meter. This extends the class's coverage from empty-match-driven to backreference-driven blow-up.

**Landed & verified.** Committed and pushed to the standing branch `kriscendobot:ironhorse-fuzz-findings` with fetch/rebase/push CAS (rebased cleanly over concurrent peer findings; my commit `1be01ad5c` and the test file persist at branch head). Adopted standing PR **#1088** (durable marker matched — no duplicate) and appended a `## Finding 637d760bc2e0278e` section to its body. Local CI-equivalent: full `cargo test -p ironhorse-vm` green (106+ tests, 0 failures, mine included). PR CI leg **`test-ironhorse` passed** (the leg my Rust change gates).

**Notes / follow-ups.** PR #1088 stays draft by design (findings accumulate until the maintainer reviews/merges). Lint (JS-side, whole-repo) was still pending at hand-off but is unaffected by this Rust-only additive change. Pre-existing `rustfmt --check` diffs exist in two *sibling* finding files (`finding-a136f9038a1001fb`, `finding_d99d263fcf6ca7a7`) — not mine (my file is fmt-clean) and out of scope. The recurring meter-truncation family (now including a peer's concurrently-landed `5565a021a8cc30bc`) suggests the fuzz service is still exercising SHAs behind the oracle fix; not actionable here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-637d760bc2e0278e-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3119600 cached reads)
- Output: 29678 tokens
- Cost: $3.242296999999999
- Wall-clock: 657s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
