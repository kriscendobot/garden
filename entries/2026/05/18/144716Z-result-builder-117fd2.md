---
ts: 2026-05-18T14:47:16Z
kind: result
role: builder
host: endolinbot
short_id: 117fd2
dispatch_root: dispatches/builder--96b1b3
repo: endojs/endo-but-for-bots
branch: feat/lal-transcript-durable-store
base: llm
pr_number: 289
project: endo
refs:
  - entries/2026/05/18/143620Z-dispatch-builder-96b1b3.md
---

Phase 1 of `designs/lal-transcript-memory-management.md` implemented and opened as DRAFT PR #289 against `llm`.

Pre-flight gates cleared.
The literal slug search ("lal-transcript OR transcript-memory OR TranscriptStore OR transcript-persistence OR durable-transcript") and the broader "transcript" search returned PR #123 (an in-flight fix for `assembleTranscript` reporting broken chains, a separate concern: a different aspect of the same surface, not the durable-persistence shape).
No load-bearing TranscriptStore or durable-transcript module exists yet; `packages/lal/agent.js` carries inlined `getNode` / `putNode` / `assembleTranscript` closures.
Design status was `Not Started`, drift-clean.

Implementation.
Extracted the transcript-node store from `packages/lal/agent.js` into a new module `packages/lal/transcript-store.js` exposing `makeTranscriptStore(powers)`.
The store provides `getNode`, `putNode`, `putAlias`, `hasNode`, `walkParents`, `assembleTranscript`, and `assembleTranscriptStrict`.
Pet-name convention `transcript-<messageId>` preserved bit-for-bit and exported as `transcriptPetName` for future tools.
`walkParents` returns a discriminated `{ ok, ... }` result so callers can distinguish a complete walk from a missing-node failure; `assembleTranscriptStrict` throws on the same condition.
The backward-compatible `assembleTranscript` is preserved on the store so existing call sites in `agent.js` continue to work unchanged.

`packages/lal/agent.js` was edited to delegate to `makeTranscriptStore(powers)` (about 73 lines removed, 15 lines added: the import, store construction, and a `putAlias` call replacing the inline alias write).
The agent's persistence boundary is unchanged: every `putNode` is awaited before the agent advances, and the agentic loop commits the leaf after every iteration.

Tests in `packages/lal/test/transcript-store.test.js` (new, 10 tests) cover the pet-name convention, cache+durable resolution, reply-chain reassembly after simulated inbox dismissal, cold-start recovery from a fresh store against the same backing, two orphan shapes (missing parent and missing leaf), alias resolution after cold start, the persistence boundary (every `putNode` writes; latest-state-wins on update), and `hasNode` durability.
Regression-evidence applied: three temporary breaks (`getNode` skipping durable lookup, `walkParents` silently truncating, `putNode` skipping durable write) each failed the expected subset of tests; the breaks were reverted.

Local pre-PR checklist green.
`yarn lint:eslint` 0 errors (warnings present only in files I did not touch).
`yarn lint:types` clean modulo five pre-existing errors in `packages/lal/providers/anthropic.js` unrelated to this change.
`yarn test` in `@endo/lal` reports 15 passed / 1 skipped (10 new transcript-store tests plus pre-existing).
`yarn format` produced no drift.

Design status updated `Not Started` -> `In Progress` with a `## Status` section listing Phase 1 deliverables and the three deferrals (GC, chat-UI visualization, schema migration).
`designs/README.md` summary row and milestone row both updated to `In Progress`.

Changeset: `@endo/lal: minor` at `.changeset/lal-transcript-durable-store.md`.
No `yarn.lock` change; no separate lockfile commit needed.

PR open as DRAFT at https://github.com/endojs/endo-but-for-bots/pull/289 (number 289, base `llm`, head `feat/lal-transcript-durable-store`).

Affected files:
- `.changeset/lal-transcript-durable-store.md` (new)
- `designs/README.md` (status row + milestone row)
- `designs/lal-transcript-memory-management.md` (Status section)
- `packages/lal/agent.js` (delegation to extracted store)
- `packages/lal/test/transcript-store.test.js` (new, 10 tests)
- `packages/lal/transcript-store.js` (new, the store module)

Diff: 6 files, +620 / -83.

CI at PR-open time: all checks `IN_PROGRESS` (browser-tests, lint x2, build, test, familiar-bundle, test 20.x / 22.x ubuntu, test 20.x / 22.x macos queued).
No conclusion yet at the time of this report; the orchestrator's next sweep (or `gh pr checks 289`) will pick up the green/red signal.

Out-of-scope deferrals (recorded in design Status section):
1. Garbage collection of transcript nodes.
2. Conversation-tree visualization in chat UI.
3. Migration from an older transcript-store shape.

Self-improvement: when an extracted module wraps powers from an unconfined guest, `@ts-check` will trip on `FarRef` shapes that the test's in-memory mock cannot satisfy.
The agent.js precedent (`@ts-nocheck` plus targeted `eslint-disable`) is the right pattern; reaching for it earlier in test authoring saves a round of type-check iteration.
