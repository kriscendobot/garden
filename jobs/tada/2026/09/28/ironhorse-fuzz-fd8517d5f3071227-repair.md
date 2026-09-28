Finding `fd8517d5f3071227` is now covered by regression tests on the standing branch. It turned out to be a bug in the XS test oracle, not in Ironhorse, and that bug was already fixed, so no engine change was needed. CI on the new head had only just started (3 checks passed, 2 skipped, 2 not reported yet), and the standing PR's review is still in progress.

**Reproduction**
- I rebuilt the 30-byte input from the journal's `input_base64`, and its sha256 matches `69c4d5ae…2f4e`.
- At the fuzzed commit `38ca1d18`, `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1` crashes with `match meter ironhorse=4899799040 pin=604831744`.
- The XS number is exactly Ironhorse's number minus 2³², so the XS test harness was cutting its step counter down to 32 bits.
- On the current `ironhorse-fuzz-findings` head, the same command exits 0. Commit `c8497fd88` already widened that counter to 64 bits. About two dozen earlier findings of this same kind are already locked in the same way.

**Changes** (commit `2aecb0d1bf`, pushed to `kriscendobot:ironhorse-fuzz-findings`)
- **New Ironhorse VM test:** `rust/engine/ironhorse-vm/tests/finding_fd8517d5f3071227_regexp_meter_overflow.rs` replays the exact input bytes, with the input and the 395-byte generated pattern saved as fixtures. It checks the pattern, the flags (`m`), the subject (`0000000`), a non-match with no abort or resource refusal, and the full step count of 4899799040 against the old cut-down value. It builds without the `c/moddable` submodule, and it passes.
- **New fuzz-crate test:** `rust/engine/ironhorse-fuzz/src/regexp.rs` gains `finding_fd8517d5f3071227_regexp_meter_overflow_agrees`, which checks that the exact input now agrees with XS. It passes.
- `cargo fmt --check` is clean.

**Standing PR**
- `ensure-pr.sh --find-only` found and reused the standing PR, endojs/endo-but-for-bots#1298; nothing new was opened.
- I posted a comment on #1298 describing this finding, how it reproduced and what locks it: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5865573863
- The PR's review round `endojs-endo-but-for-bots-pr1298-gauntlet-panel-3` is already queued and will cover the new head, so I did not start a second one.

**Follow-ups:** none for this finding. Someone should watch CI on #1298 until it finishes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-fd8517d5f3071227-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 11 on 3 host(s) (5 unmetered)
- Input: 74 tokens (2472211 cached reads)
- Output: 30204 tokens
- Cost: $2.5406628999999996 (5 engagement(s) unpriced)
- Wall-clock: 1599s
- Model(s): claude-opus-4-8 ×3, claude-opus-5-5 ×3

<!-- garden-usage-end -->
