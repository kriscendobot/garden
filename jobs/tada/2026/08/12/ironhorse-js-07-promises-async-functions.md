---
orchestration-failed: true
---
Implemented Promise/async-function execution improvements on PR https://github.com/endojs/endo-but-for-bots/pull/970 at `c9adba4e09c82572de25470e5a31cc95bf09bc76`.

Changes:
- Added thenable assimilation and rejection propagation for throwing executors, handlers, and thenables.
- Added native-promise adoption, self-resolution TypeError rejection, and own-`then` handling.
- Preserved async `try`/`catch` state across `await`.
- Corrected static combinator species behavior.
- Added sparse-array and Unicode string combinator inputs.
- Added TypeError rejection for non-iterables and invalid iterator results.
- Added 10 focused XS-differential Promise/async regressions.

Pinned official XS slice:
- Pins unchanged: test262 `be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`.
- Before: 896 total, 288 covered, 4 failures, 604 unsupported, 0 infrastructure.
- After: 896 total, 407 covered, 0 failures, 489 unsupported, 0 infrastructure.
- Promise: 167→261 covered; async expressions: 65→79; async statements: 56→67.
- No previously covered case regressed.
- Eliminated handler-throw, native-promise-adoption, self-resolution, executor-throw, thenable-throw, and await-in-try skip reasons. General non-array iterable skips were reduced/reclassified; 43 custom iterator-next cases remain.

Validation:
- Official three-slice `full-run.sh` commands with oracle enabled: all passed with zero Ironhorse failures/infrastructure results.
- `cargo test --workspace --release`: 613 passed, 0 failed, 1 ignored.
- Exact-meter corpus: 1,711/1,711 covered, 0 failed/skipped; expectations unchanged.
- Focused Promise suite: 25/25 passed.

Follow-up: gated full coverage remains incomplete. Residual cases primarily require re-entrant general iterator execution, compiler/runtime support behind aborted cases, harness completion behavior, `with`, `store_arrow`, and thenable-return sequencing for `finally`. PR remains open and draft.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-07-promises-async-functions.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1147s

<!-- garden-usage-end -->
