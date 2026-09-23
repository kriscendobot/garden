---
orchestration-failed: true
---
Implemented and pushed a core collections increment to draft PR #970.

Changes:
- Added dense-array iterable construction for Map, Set, WeakMap, and WeakSet, including overridden `set`/`add` observation.
- Added exact collection-kind validation and catchable TypeErrors for invalid receivers and weak primitive keys.
- Added tombstone-backed live iteration across deletion, re-addition, and callback mutation.
- Added five XS-differential Rust regression groups.

Verification:
- Official pinned slice: 889 total, covered 134 → 384, failed 0 → 0, infrastructure 0; no covered regressions.
- Eliminated the 91 `collection-method:non-collection-this`, 24 `collection-iterator:non-collection`, and dense-array constructor skips. Remaining named gaps include 18 general iterables, Map.groupBy, Set methods, WeakRef, FinalizationRegistry, and GC/finalization hooks.
- `cargo test --workspace --release`: passed.
- Exact-metering corpus: 1,711/1,711 covered, zero failures or skips; expectations unchanged.
- Pins unchanged: test262 `be13516fb6441b950ba8a3df97eb34062c186972`, XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`.
- Branch advanced from `0da3af2a8b` to `e6a64b14f7a20b0725bccc892681cad775264778`.

PR: https://github.com/endojs/endo-but-for-bots/pull/970  
Report comment: https://github.com/endojs/endo-but-for-bots/pull/970#issuecomment-5295726534

The PR remains open and draft. The gated full-slice outcome was not achieved; the residual features above require follow-up work.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-15-collections.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 803s

<!-- garden-usage-end -->
