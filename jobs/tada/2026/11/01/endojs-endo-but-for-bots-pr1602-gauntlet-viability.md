**PR #1602 viability gate (endojs/endo-but-for-bots): proceed**

PR #1602 adds Ironhorse's missing explicit-resource-management built-ins: `Iterator.prototype[@@dispose]`, `AsyncIteratorPrototype[@@asyncDispose]`, and the `disposed` getters on `DisposableStack` and `AsyncDisposableStack`. It also raises the test262 whole-tree expectation floor for the affected shards. The PR is open and unmerged, it is a draft, and it was created 2026-11-01T05:19Z. It has no reviews or comments yet.

Deciding question: Does the current base (`llm`) still lack these four built-ins, with no other merged or open PR supplying them?

Evidence:
- **Base is current.** The PR's frozen base `llm-9a14ddf` (9a14ddf660…) is the current `llm` tip: the compare `9a14ddf…llm` shows `ahead_by: 0`.
- **The gap still exists on `llm`.** The `built-ins/Iterator/prototype/Symbol.dispose` expectations shard still records every row as fail, for example `is-function.js`: Expected SameValue("undefined", "function").
- **The XS-only entries are still there.** `llm`'s `tests/intrinsic_key_order.rs` still lists `Symbol(Symbol.dispose)` and `Symbol(Symbol.asyncDispose)` as XS-only for the two iterator prototypes, and `disposed` for both stack prototypes. These are the four entries this PR removes.
- **Nothing supersedes it.** Searching PRs for "dispose ironhorse" (all states) finds only #1602 doing this work. Sibling #1599 (AsyncFromSyncIterator) is still open and touches a different surface. Its only interaction is the boot-heap geometry and golden-fixture regeneration (epoch-3 slots go 1100 → 1112 when the second PR lands), and the PR body already calls that out.
- **The motivation still holds.** This slice of the test262 ratchet is tracked in kriscendobot/garden#51. On the current base the gap is real: 46 case/mode rows go from fail to pass, with none regressing.

Follow-up: whichever of #1599 and #1602 lands second must regenerate the golden fixtures, the metamorphic vectors and the fuzz seeds.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1602-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (161076 cached reads)
- Output: 1926 tokens
- Cost: $0.3913992
- Wall-clock: 44s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
