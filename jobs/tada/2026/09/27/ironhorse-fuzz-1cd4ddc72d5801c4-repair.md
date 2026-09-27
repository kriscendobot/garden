## Completion report: ironhorse-fuzz-1cd4ddc72d5801c4-repair

**Outcome:** the finding reproduces at the recorded SHA but not at the current branch head. It needed regression tests, not a code change. Both tests are pushed to the standing branch and the case is written up on PR #1298.

The prior attempt left nothing behind: no commit on `ironhorse-fuzz-findings` and no mention of this finding in the PR.

**Reproduction**
- I rebuilt the input from the journal's `input_base64`, and its sha256 matched `b847cc74…d031`.
- At `38ca1d18`, the fuzz target fails: `computrons: oracle=49 ironhorse=50`.
- The generated program is `new RegExp("((?:\\1+?\\1*?)…)|\\1+?\\1*?", "").toString()`. It renders a pattern made of lazy repeated backreferences.
- Both engines returned exactly the same text. They differed only in the computron count, by one.
- At the current branch head the same fuzz run exits 0. The meter-v4 change (upstream de16989204) made a computron difference against XS a warning rather than a failure. This is the same class as findings `1cb63ec6f8e6fc22` and `3a6aab9d9d140c2c`, so the engine itself needs no fix.

**What changed** (commit `62e4981211` on `kriscendobot:ironhorse-fuzz-findings`)
- **New test in `ironhorse-vm`:** `rust/engine/ironhorse-vm/tests/finding_1cd4ddc72d5801c4_regexp_surface_meter.rs`, with fixtures for the exact input and the bytecode, symbols and expected result the XS oracle emits.
  - It checks that the program completes and returns the identical rendered source.
  - It doesn't need the XS submodule, so it runs in CI. It deliberately doesn't pin the computron count.
- **New test in `ironhorse-fuzz`:** `finding_1cd4ddc72d5801c4_regexp_backreference_cost_gap_is_advisory` in `src/lib.rs`. It runs the full comparison against the XS oracle, which needs the submodule, so it only runs locally.
- Both tests pass and rustfmt is clean, rechecked after rebasing onto a peer's push (`bbd65a4055`).

**PR:** `ensure-pr.sh` found the existing standing PR, endojs/endo-but-for-bots#1298, and did not open a new one. The write-up is at https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854471951. The PR's review pipeline is already queued (its first stage, `endojs-endo-but-for-bots-pr1298-gauntlet-viability`, is waiting to be picked up), so it will cover the new head. I didn't queue another one.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-1cd4ddc72d5801c4-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 3 host(s) (4 unmetered)
- Input: 56 tokens (1940436 cached reads)
- Output: 13546 tokens
- Cost: $1.2829351999999998 (4 engagement(s) unpriced)
- Wall-clock: 790s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
