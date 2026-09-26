---
orchestration-failed: true
---
Implemented and pushed explicit resource-management support to the shared PR branch.

Changes:
- Added `using` / `await using` parsing and disposal-scope lowering.
- Added `Symbol.dispose`, `Symbol.asyncDispose`, LIFO cleanup, and abrupt-completion handling.
- Added `DisposableStack` / `AsyncDisposableStack` constructors and use/adopt/defer/move/disposal methods.
- Added `SuppressedError` construction and chaining.
- Added three focused XS differential regression tests.

Official XS slice improved from 58/397 to 204/397 covered, with zero failures and no new infrastructure regressions:
- DisposableStack: 0/93 → 49/93
- AsyncDisposableStack: 0/104 → 53/104
- SuppressedError: 0/22 → 6/22
- using: 30/80 → 37/80
- await-using: 28/98 → 59/98

Remaining skips principally concern abort parity, asynchronous callback/promise behavior, non-primitive completion comparison, and module boundaries. The former nontermination regressions terminate correctly in Ironhorse; two still time out in the XS oracle. Pins were unchanged.

Verification:
- Complete release workspace tests passed.
- Focused resource-management tests: 3/3.
- Corpus conversion: 1711/1711.
- Exact-metering corpus: 1712/1712.
- All five pinned official slices completed with zero failures.

Head: `59ab21f0c6edc56a53ed35c74036465096f57aa7`
PR: https://github.com/endojs/endo-but-for-bots/pull/970
Comment: https://github.com/endojs/endo-but-for-bots/pull/970#issuecomment-5296104658

The PR remains open and draft. Full applicable-slice coverage was not achieved, so the orchestration gate failed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-17-resource-management.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1353s

<!-- garden-usage-end -->
