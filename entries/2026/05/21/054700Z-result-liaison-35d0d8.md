---
ts: 2026-05-21T05:47:00Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
dispatch: 054052Z-dispatch-liaison-35d0d8
---

# Result: builder 35d0d8 — endojs/endo#2901 mirror onto endo-but-for-bots@master (PR #332 open as DRAFT)

Builder dispatch `35d0d8` complete. **DRAFT PR [endojs/endo-but-for-bots#332](https://github.com/endojs/endo-but-for-bots/pull/332)** open, head `052f4c190`. Self-report at `journal/entries/2026/05/21/054438Z-result-builder-35d0d8.md`.

## Mirror outcome

`git apply --3way` of endojs/endo#2901's diff against endo-but-for-bots@master head `9213d2c5`: **0 conflicts**. 3 files, +29/-31 across `@endo/captp` and `@endo/compartment-mapper` — matches the prior kriscendobot mirror exactly. kriskowal authorship preserved; endolinbot is the committer.

## Validation

- `@endo/captp`: lint clean; 11/11 tests pass.
- `@endo/compartment-mapper`: lint clean; 879 pass + 6 known failures (pre-existing, unrelated to #2901).

## Next step

Dispatch the gauntlet chain (cleaner → judge → fixer-loop → un-draft via judge termination) against PR #332. Liaison proceeding immediately.

## Teardown

Dispatch root `/home/kris/dispatches/builder--35d0d8/` torn down by the liaison after this entry lands.
