**PR #1359 viability: overtaken.** The PR is still open and in draft, but its core fix is already on `llm`, so the gauntlet should not start.

Deciding question: Does the current `llm` branch still lack the fix this PR exists to deliver, which is installing the Math/Number numeric constants and TypedArray `BYTES_PER_ELEMENT` as non-writable, non-enumerable and non-configurable?

Answer: No. `llm` already has it.

Evidence:
- **PR facts:** OPEN, draft, never merged. Head `f6a8388bf1`, base is the frozen snapshot `llm-47f6965`. `llm` is now 753 commits past that base. The PR has no comments and no reviews.
- **The same fix is on `llm`:** commit `25d95061b4` (2026-10-01), "fix(ironhorse-vm): make the numeric constants non-writable, non-enumerable and non-configurable". It touches the same file (`rust/engine/ironhorse-vm/src/interp/link.rs`) and covers the same constants: Math's 8, Number's 8, and `BYTES_PER_ELEMENT` on every TypedArray constructor and prototype.
- **It landed through a merged PR:** #1413, "fix(ironhorse): engine bugs matched to XS…".
- **Its tests cover the same ground:** `intrinsic_surface.rs` checks the attributes of all 38 constants plus writes, deletion and enumeration. `ordinary_index_properties.rs` is extended to cover Math, Number and `Uint8Array.prototype`. This duplicates what #1359's `intrinsic_numeric_constants.rs` tests.
- **The `Object.create` / `Object.defineProperties` fix is the same change:** that bug came from the constants being enumerable, so it went away when the constants were made non-enumerable.
- **The rest of the PR is out of date:** the other files are the 2026-09-28 coverage baseline (`baseline/refresh-20260928/*`). It was measured against `llm-47f6965` before the fix landed and before 753 newer commits, so it no longer describes the current branch. The PR body also says the zero-loss floor was not met, so the measurement was never meant to stand in for the floor.

Option: close as superseded

If the round-3 coverage numbers are still wanted, the better route is a fresh baseline measured against current `llm`, not rebasing this PR.

I spent no clean, panel, fix, CI-wait or un-draft budget, and changed no repos.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1359-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (179977 cached reads)
- Output: 1971 tokens
- Cost: $0.4456634
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
