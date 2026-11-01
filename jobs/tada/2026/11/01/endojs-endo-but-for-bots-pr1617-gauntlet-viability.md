Viability check for endojs/endo-but-for-bots#1617 is done: the gauntlet can begin.

- **PR facts:** The PR is open, unmerged and still a draft. It is titled "Tenth slice of the Ironhorse test262 ratchet" and was opened 2026-11-01T15:01Z. Its base is the frozen snapshot `llm-9a14ddf` (`9a14ddf660`) and it refs #1603.

**Deciding question:** Does `llm` still lack the fixes this PR makes (strict `o[k]=v` throwing on a failed `[[Set]]`, refusing `delete` on String `length`, `new String(symbol)` throwing, and the dynamic-function prototype attributes), with no newer PR having landed them?

**Evidence:**
- **The base is current.** Comparing `9a14ddf660...llm` shows `llm` is 0 commits ahead of the PR's base, so no newer base history exists to supersede it.
- **The bug is still on `llm`.** `rust/engine/ironhorse-vm/src/interp/property.rs` on `llm` still discards the result with `let _ = self.ordinary_set(...)` at lines 632 and 801. Those are the two `property_at_set` sites the PR changes.
- **No open Ironhorse PR overlaps.** I checked #1299, #1359, #1604, #1609 and #1610:
  - None of them touches `interp/property.rs`.
  - None touches the String, GeneratorFunction or AsyncGeneratorFunction shards, or the Object freeze/seal/preventExtensions/defineProperty@0011 shards.
  - #1359 does touch `interp/link.rs`, but for numeric intrinsic constants, not the dynamic-function prototype attributes.
  - #1609 and #1610 touch a different shard (`defineProperty@0010`).
- **The motivation still holds.** The ratchet arc (#1603) is active, and the 15 fail→pass rows are not fixed on the base.
- **Known risk, not supersession:** the PR body itself notes that #1602 and #1605 also move the snapshot goldens. Whichever PR lands second has to regenerate them.

I made no changes and opened no follow-ups. The panel and fix-loop stages can proceed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1617-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (184633 cached reads)
- Output: 1846 tokens
- Cost: $0.45785460000000006
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
