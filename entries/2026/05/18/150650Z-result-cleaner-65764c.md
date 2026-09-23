---
ts: 2026-05-18T15:06:50Z
kind: result
role: cleaner
host: endolinbot
short_id: 65764c
dispatch_root: dispatches/cleaner--65764c
repo: endojs/endo-but-for-bots
branch: feat/lal-transcript-durable-store
base: llm
pr_number: 289
project: endo
refs:
  - entries/2026/05/18/144716Z-result-builder-117fd2.md
---

Cleaner stage for PR #289 (Phase 1 of `designs/lal-transcript-memory-management.md`) on the `llm` base.

Pre-existing state on the builder's HEAD (946b45394):
- `yarn lint:eslint` on `@endo/lal`: 0 errors, 22 warnings (pre-existing across providers and simulator).
- `yarn test` on `@endo/lal`: 15 pass / 1 skip.
- `yarn prettier --check` on touched files: clean.

Adversarial sweep on persistence semantics.
The store's six adversarial surfaces (concurrent writes, crash mid-write, cold-start recovery, cyclic chains, orphaned chains, deeply nested chains) were probed.
Orphan and cold-start were already covered by the builder.
Three needed new tests and one needed a defensive fix:

1. `walkParents` had no cycle detection: an `A -> B -> A` durable entry would infinite-loop until the array push exhausted memory.
   Added an O(n) `seen: Set<string>` guard and a new `'cycle-detected'` discriminant on `WalkResult` (alongside the existing `'missing-node'`).
   `assembleTranscriptStrict` reports the cycle distinctly so diagnostics distinguish corruption from truncation.
   Ordinary `putNode` traffic cannot form a cycle; the guard exists for corrupt-pet-store recovery.
2. Concurrent `putNode` for the same messageId: the builder's choice is last-write-wins on both cache and durable storage.
   The cache write happens synchronously at call entry, the durable write follows on the awaited `storeValue`.
   Test pins this with a `writeOrder` probe so any future change (queue, CAS, first-write-wins) becomes a conscious decision rather than a silent regression.
3. Crash mid-write: the builder's `putNode` swallows storage errors with `console.error`.
   Test pins the trade-off: a failed durable write is invisible at the call site but observable on cold restart (the in-memory cache holds the new node; the durable layer does not; cold-start sees only the prior successfully-persisted state).
4. Deeply nested 100-deep chain: passes in well under 1s with the 5s timeout, exercising the cold-start path (write-through cache bypassed) so any future O(n^2) regression would be caught.

Commits (cleaner adds 2):
- `9cf7c9853` fix(lal): cycle-detect in TranscriptStore.walkParents
- `df0ae9721` test(lal): adversarial coverage for TranscriptStore persistence

Post-cleaner state.
- `yarn lint:eslint` on `@endo/lal`: 0 errors, 22 warnings (unchanged).
- `yarn test` on `@endo/lal`: 19 pass / 1 skip (was 15 pass / 1 skip; 4 new tests, all from the adversarial sweep).
- `yarn prettier --check`: clean.
- `gh pr checks 289`: all 25 checks green on cleaner's HEAD (`df0ae9721`).
- PR remains in draft.

Regression-evidence (per `skills/regression-evidence/SKILL.md`):
- Removed the cycle guard's `seen.has` check: cycle test fails with `RangeError: Invalid array length` (infinite loop ran out of memory before the assertion).
- Disabled durable writes in `putNode` (cache-only): concurrent-writes test fails (`writeOrder` is empty; expected `['first', 'second']`); persistence-boundary, crash-recovery, and pet-name tests also fail.
- Removed the `try/catch` swallow in `putNode`: crash-recovery test fails (`simulated crash` propagates as a rejection).
- All breaks were reverted; the load-bearing pattern matches the design's "each new test fails when its target code path is broken" criterion.

Drift check against the design's Phase 2 / 3 / 4 deferrals.
- Phase 2 (GC): not touched.
   No GC, expiry, eviction, or footprint-bounding logic was added.
- Phase 3 (UI): not touched.
   No Familiar-side rendering or tree-visualization surface was added.
- Phase 4 (Migration): not touched.
   The pet-name convention (`transcript-<messageId>`) is unchanged; the cycle-detection addition is an extension of `WalkResult` (new union member) with no impact on persisted shape.
- Cycle-detection is consistent with the design's "Reliable Assembly" principle: "If any node in the chain is missing... assembly fails and the agent should report the broken chain rather than producing a partial transcript."
   A cycle is a corruption mode equivalent to a broken chain; surfacing it with a structured result extends the existing missing-node protection rather than enlarging Phase 1's scope.

Out of scope.
- The pre-existing `yarn lint:types` errors in `providers/anthropic.js` (5 errors on `unknown` error-shape access) predate this PR; verified on the builder's HEAD before any cleaner work.
   Not the cleaner's surface.

Stage status.
Per `roles/cleaner/AGENT.md` § Operating norms, the cleaner does not un-draft.
The PR remains DRAFT on `df0ae9721`; next stage is the judge.

Self-improvement: nothing this time.
The cleaner's adversarial-sweep pattern (probe each persistence-corner case, pin the builder's choice with a test, add a defensive fix when the corner case is exploitable) worked cleanly here; the regression-evidence break/restore loop is well-served by a quick `cp` backup of the source file before each break.
No skill or role text needed an update.
