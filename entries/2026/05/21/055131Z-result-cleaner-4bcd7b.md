---
ts: 2026-05-21T05:51:31Z
kind: result
role: cleaner
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/21/054640Z-dispatch-liaison-4bcd7b.md
  - entries/2026/05/21/054438Z-result-builder-35d0d8.md
---

# Result: cleaner 4bcd7b - endojs/endo-but-for-bots#332 (mirror of endojs/endo#2901, refactor: Embrace default chaining)

PR head `052f4c190`. No commits landed. The refactor is behavior-preserving and the existing test surface already exercises the happy paths.

## 1. Coverage assessment per touched file

- `packages/captp/src/finalize.js`: 96.99% stmts, **100% branches** (after refactor) under `finalizing-map.test.js`. The new `get: key => keyToRef.get(key)?.deref()` is fully exercised: present-key path via `t.is(map.get(droppedKey), obj)` and `t.is(map.get('preserved'), preserved)`, absent-key path via the post-gc `has(...)` ladder. Uncovered lines 95-98 are `clearWithoutFinalizing`'s body (a pre-existing gap, not touched by this refactor).
- `packages/compartment-mapper/src/bundle.js`: 86.52% stmts, 75.51% branches under the full `compartment-mapper` suite (879 pass + 6 known failures). The refactor's happy-path (`modulesByKey[alias ?? key]`) is exercised by every bundle test. The two new error branches (lines 433-446: "no-alias not found" and "via-alias not found") are uncovered. They are defensive guards against a `sortedModules` invariant violation; reaching them from the public API requires either stubbing `sortedModules` or hand-constructing a malformed compartment map. Both fall in the `coverage-driven-testing` *Pitfalls* section ("elaborate mock = wrong shape"). The pre-refactor code had the same defensive guard with a single error message and was also uncovered; the refactor only diversified the diagnostic, did not add new reachable behavior.
- `packages/compartment-mapper/src/bundle-lite.js`: identical hunk to `bundle.js`; file shows 0% under c8 because **no test in `packages/compartment-mapper/test/` imports `bundle-lite.js` or its `functor-lite.js`/`script-lite.js` shims**. This is a pre-existing structural gap (the `-lite` surface lacks its own integration test); the refactor neither creates nor worsens it.

## 2. Commits landed

**No commits.** No realistic test additions are appropriate (defensive-guard error branches that are pitfall-y to test), no dead code surfaced for deletion (the diff already removed the obsolete UNTIL-#1514 comments and the verbose pre-`?.` if/return scaffolding), and the existing happy-path coverage is sufficient for a behavior-preserving operator-sweep refactor of this size. This matches the cleaner role's "skip the cleaner pass" pattern for diffs equivalent to a one-file format sweep.

Head SHA unchanged at `052f4c190`.

## 3. CI status at end of dispatch

`gh pr checks 332`: **25 pass, 2 pending, 0 fail** at 2026-05-21T05:51Z. Pending: `viable-release (18.x, ubuntu-latest)`, `viable-release (20.x, ubuntu-latest)`. All `test`, `cover`, `test262`, `lint`, `browser-tests`, `test-hermes`, `test-async-hooks`, `test-xs`, `test-ocapn-python`, `check-action-pins`, and `zizmor` checks are green. No infra red. PR remains DRAFT; head is `052f4c190`.

## 4. Self-improvement

Self-improvement: nothing this time. The cleaner's "skip the cleaner pass" rationale for operator-sweep refactors is already documented in `roles/cleaner/AGENT.md` § Operating norms ("Skip the cleaner pass when the PR is ... a one-file format sweep"); applying that rationale to a multi-file mechanical `?.` chaining sweep is a natural extension and does not warrant a role/skill edit.
