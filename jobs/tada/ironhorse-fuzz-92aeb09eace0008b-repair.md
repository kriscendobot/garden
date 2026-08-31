Job complete. Summary:

## Completion report — Ironhorse fuzz finding `92aeb09eace0008b` (target `differential_regexp`)

**Diagnosis.** Recovered the 3-byte minimized input (sha256 verified `663a47b2…21adb2`) and reproduced the crash at the fuzzed SHA `38ca1d18` under `nightly-2026-08-15`. The panic was a **match-meter divergence**: `match meter ironhorse=30823809024 pin=759037952`. The bytes fold, via `gen_regexp`, into a deeply nested backreference-heavy empty-matchable pattern (dotall `s`) over subject `"a"`@0, which dispatches **470334** metered steps → raw 16.16 meter `470334×65536 = 30_823_809_024`, past 2³². `30_823_809_024 mod 2³² = 759_037_952` — exactly the pin's reported value, i.e. a phantom divergence from an oracle-side 32→bit truncation. Same class as sibling finding `5d122a6fc10babd9`.

**Fix.** No new code change was required: the causal fix (`c8497fd88` — widening the xs-oracle shim's meter fields to 64-bit end to end and dropping the redundant `as u64` casts) already landed on the standing branch and subsumes this input. Verified the exact case is **clean at the standing-branch HEAD** and diverges **only** at `38ca1d18`.

**Regression (load-bearing).** Added `rust/engine/ironhorse-vm/tests/finding_92aeb09eace0008b_regexp_meter_overflow.rs`: replays the exact generated case through the port's `compile`+`match_regexp`, asserting no panic and the full-width raw match meter `30_823_809_024` (> `u32::MAX`, never the `759_037_952` wrap). Builds without the XS oracle or the `c/moddable` submodule. Passes; full `ironhorse-vm` suite green.

**Landed.** Committed `72f17ea24` → rebased onto the advancing standing branch → pushed to `kriscendobot:ironhorse-fuzz-findings`. Adopted the standing PR **#1088** via its durable marker and appended a documented "Finding `92aeb09eace0008b`" section to the body. PR remains DRAFT per the standing-accumulator convention.

**Follow-ups:** none. Inbox empty; temp repro worktree removed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-92aeb09eace0008b-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3118011 cached reads)
- Output: 29765 tokens
- Cost: $3.2593255000000005
- Wall-clock: 590s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
