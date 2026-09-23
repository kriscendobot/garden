Job complete. Writing the report.

---

## Completion report — `ironhorse-fuzz-f83dc8932cd3b41a-repair`

**Finding:** `differential_regexp` fuzz finding f83dc8932cd3b41a (toolchain `nightly-2026-08-15`, project SHA `38ca1d1893`).

**What I did**
- Recovered the 44-byte minimized reproducer from the journal finding's `input_base64` to a file (sha256 verified `146b8f44…3ad26c`, 44 bytes) — never inlined the bytes into a prompt or shell arg.
- Set up the pinned fuzz env: peer-inited the `c/moddable` submodule (pin `23b4d6b0`) from the fuzz-service checkout, built `differential_regexp` on `nightly-2026-08-15`.
- Decoded the exact generated case via the real `ironhorse_fuzz::gen_regexp`: a nested backreference pattern (`(((a*){1,2}.{2})?a*|…\6…\2…\8…)`), flags `s`, subject `"a0aaaaaa"`, start `0`. Non-matching; port matcher meters `168576 × 65536 = 11047796736` raw, **past `u32::MAX`** (wraps to `2457862144`).

**Root cause / diagnosis**
- This is the **same meter-overflow class** as siblings `5d122a6f` / `8275793b` / `407764ab` / `637d760b` / `8b8afc47`. The port's matcher meters into a `u64` and was always correct; the divergence was the pre-fix XS oracle truncating the pin's 64-bit meter to a 32-bit `txU4`, manufacturing a false `ironhorse=11047796736 pin=2457862144`.
- The causal fix `c8497fd88` (widen oracle meter to 64-bit) is **already an ancestor of the standing branch** and is **not** in the finding SHA `38ca1d1893`. The reproducer therefore no longer crashes at the branch head — verified by running the target (`-runs=1`, no divergence).

**What changed**
- Added load-bearing regression `rust/engine/ironhorse-vm/tests/finding_f83dc8932cd3b41a_regexp_meter_overflow.rs`, which replays the exact case through `ironhorse_regexp` (no oracle/submodule) and pins the full-width meter `11047796736` bit-exact, asserting no 32-bit narrowing. Builds and passes.
- Committed `3064337d6`, CAS-rebased and pushed to standing branch `kriscendobot:ironhorse-fuzz-findings`.
- `ensure-pr.sh` adopted the existing standing PR **endojs/endo-but-for-bots#1298** (marker `garden-job: ironhorse-fuzz-findings`); documented finding f83dc8932cd3b41a as a new section in the PR body.

**Follow-ups**
- PR #1298 is DRAFT/MERGEABLE with CI in progress; the gauntlet is maintainer-triggered under the manual-gauntlet regime (**run the gauntlet #1298**).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-f83dc8932cd3b41a-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 90 tokens (3187961 cached reads)
- Output: 24702 tokens
- Cost: $3.048560500000001 (1 engagement(s) unpriced)
- Wall-clock: 818s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
