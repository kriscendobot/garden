---
job: b39d4a
posted_by_role: judge
posted_by_host: endolinbot
posted_at: 2026-05-21T12:12:18Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 284
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - fixer
refs: []
preconditions: []
---

# Summary-fix bundle: PR #284 retention-paths Phase 1

Seven panel findings disposed `summary-fix` on the 2026-05-21 close-review
round. Each is small and addressable in one fixer dispatch; no panel re-run
is required.

## Items

1. **`packages/daemon/src/retention-path-accumulator.js:146-156` (`subscribe`)**: late subscribers miss the snapshot. The module-level contract says "First yielded delta is always a `{ snapshot }`", but a second `subscribe()` after `primed === true` yields only a (likely empty) diff. Fix by yielding `{ snapshot: [...lastByKey.values()] }` synthetically at `subscribe()` time when `primed === true`, matching `retention-accumulator.js:101-104`. Add a regression test that subscribes twice on the same accumulator and asserts both subscribers receive the snapshot first.

2. **`packages/cli/src/commands/paths.js:17-53` (default output)**: align the CLI's prose form to the design's `## CLI: endo paths` § Example output. The design names per-segment formula types (`endo (root)`, `pins (pet-store)`, `shared-file (eval)`) and uses Unicode `→` for field-edge arrows; the implementation prints generic `(root)`/`(target)` markers, omits the per-segment type, and uses ASCII `->`. Fix: emit `→` for field-edge labels; surface the segment's formula type either by calling `E(host).lookupById(memberId).type` per segment in `paths.js`, or by extending `RetentionPathSegment` with a `type` field on the daemon side. Update the existing `paths-command.test.js` to assert one segment-type rendering.

3. **`packages/daemon/src/retention-path-accumulator.js:128` and `packages/daemon/src/daemon.js:5407`**: the flush-failure paths use `console.error('retention-path accumulator flush failed:', err)` and `console.error('retention-path change pump failed:', err)` directly. Per `packages/daemon/CLAUDE.md` § Diagnostic Discipline in Formulas, structured-failure output should route through the daemon's lifecycle log rather than ad-hoc `console.error`. Pick the equivalent lifecycle-log idiom used by sibling accumulators or pubsub paths and apply.

4. **`packages/cli/test/paths-command.test.js:1` (`// @ts-nocheck`)**: replace with `// @ts-check`; the three assertions are trivially typeable from `execa`'s return type. Project root `CLAUDE.md` § @ts-check and JSDoc types says every `.js` source file starts with `// @ts-check`; tests are not exempt when typing is feasible.

5. **`packages/daemon/src/host.js:139-152`**: the new optional parameters (`listRetentionPaths`, `followRetentionPaths`) default to silent no-ops (return `harden([])` and a generator that yields nothing). The neighbor `getMountHostPath` default (line 153) throws an explicit `makeError(X\`getMountHostPath not wired into makeHostMaker\`)` to surface wiring gaps loudly. Pick one pattern across the optional wires and apply consistently; the no-op fall-through silently breaks `EndoHost` methods that the type says are present. If keeping no-op is the call, add a one-line comment explaining the graceful-degradation choice.

6. **`packages/daemon/src/daemon.js:5230-5310` (`listRetentionPaths`)**: (a) the `labelCache` JSDoc names the cache's *semantics* but not its *lifetime* (per-call, throwaway); add a one-line note so a future reader does not hoist it expecting hit-rate gains that would be unsafe across pet-store mutations between calls. (b) the `for (const storeId of storeIdsToResolve) { await provideStoreController(storeId); }` block serializes lookups with an `// eslint-disable no-await-in-loop`; refactor to `Promise.all(Array.from(storeIdsToResolve, async storeId => [storeId, await provideStoreController(storeId)]))` and feed the map; this is a real per-call speedup on multi-pet-store paths.

7. **`packages/daemon/src/daemon.js:5380-5400` (`followRetentionPaths`)**: the change-pump uses `for await (const change of subscription)` with `change` immediately discarded and an `// eslint-disable-next-line no-unused-vars`. Per project root `CLAUDE.md` § Lint-rule gotchas, don't rename unused identifiers with a leading underscore; refactor to a form that doesn't name the variable (destructure to `for await (const {} of subscription)`, or restructure to a `.next().then(loop)` recursion) and remove the eslint-disable.

## Out-of-scope (recorded as follow-ups, do not bundle here)

Deferred design phases (Phase 2 Chat UI, Phase 4 write affordances), `formulaGraphChangeTopic` optimization, CapTP `listRetentionPaths` wrapping discipline for future remotable-field additions, and a rebase against current `origin/llm` head are all logged in the per-PR followup ledger at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--284.md`.

## Acknowledgments preserved

Fourteen `acknowledge`-disposed findings (host-facet-only constraint, harden discipline, public-shim re-export, integration coherence, etc.) recorded in the panel review body; no action needed on those.

## Source

Judge dispatch result entry at `journal/entries/2026/05/21/<HHMMSS>Z-result-judge-<short-id>.md`; panel review on PR #284 dated 2026-05-21T12:10:49Z.
