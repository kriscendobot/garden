Job complete. Summary:

## Completion report — Ironhorse fuzz finding `5565a021a8cc30bc` (`differential_regexp`)

**Reproduced.** Decoded the 4-byte minimized input (`0b df 4d 14`, sha256 verified `473e9934…88bc93`), set up the pinned fuzz env (c/moddable peer-init, `nightly-2026-08-15`, cargo-fuzz), and reproduced the crash **at the fuzzed SHA `38ca1d18`**: a `differential_regexp` **match-meter divergence** — `ironhorse=8411414528` vs `pin=4116447232`. The 4 bytes fold via `gen_regexp` into a 44-group backreference-heavy alternation over subject `"b 0bb"` with the `s` flag; it does **not** match, but the exhaustive backtrack-to-failure dispatches 128 348 metered steps → raw meter `128_348 × 65536 = 8_411_414_528`, nearly 2× past `u32::MAX`.

**Root cause / fix.** Same 32-bit-meter-truncation class as siblings `493390fc`, `5d122a6f`, `8275793b`: the pin's meter wraps at 2³² (`8_411_414_528 mod 2³² = 4_116_447_232`, exactly the reported pin value). Already resolved on the standing branch by commit `c8497fd88` (widening the XS oracle's meter fields to `txU8`). Confirmed the case **no longer crashes at branch HEAD** — no new code fix needed, mirroring how the sibling meter findings landed as test-only locks.

**Regression lock (load-bearing).** Added `rust/engine/ironhorse-vm/tests/finding_5565a021a8cc30bc_regexp_meter_overflow.rs` — pins the port's full-width meter (`matched=false`, `meter=8_411_414_528`) for the exact reproducing pattern, needs neither the oracle nor the submodule, and asserts the meter never equals the 32-bit-wrapped figure. This is a **distinct witness**: unlike the sibling meter findings (all matches), this one guards the meter along the **non-match** exhaustive-backtrack path. Test passes; file is rustfmt-clean.

**Landed.** Committed and pushed to the standing branch `kriscendobot:ironhorse-fuzz-findings` with fetch/rebase CAS (rebased cleanly over concurrent peer findings; my commit `c8a7d0135` confirmed an ancestor of the current remote tip). Adopted the standing PR **#1088** via `ensure-pr.sh` (no duplicate created) and documented finding `5565a021a8cc30bc` as a PR comment.

**Follow-ups:** none. (Noted but out of scope: `cargo fmt --check` flags pre-existing formatting drift on ~17 other files on the branch — unrelated to this finding.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-5565a021a8cc30bc-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 84 tokens (2780579 cached reads)
- Output: 26615 tokens
- Cost: $2.9111054999999997 (1 engagement(s) unpriced)
- Wall-clock: 666s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
