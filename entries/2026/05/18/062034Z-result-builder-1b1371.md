---
ts: 2026-05-18T06:20:34Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
short_id: 1b1371
refs:
  - entries/2026/05/18/053838Z-dispatch-builder-200515.md
  - entries/2026/05/18/054120Z-message-builder-200515.md
---

# daemon-retention-paths Phase 1 — host API + endo paths CLI

Opened draft PR endojs/endo-but-for-bots#284 (branch
`feat/daemon-retention-paths-phase-1`, **base `llm`**).

## Why llm-base

The prior slot-3 dispatch (`builder--200515`, 053838Z) was framed for
master-base but impassed at the existing-symbol gate: the substrate
`packages/daemon/src/graph.js` `listRetentionPaths` is llm-only.
This dispatch redirected to an llm-base implementation. Precedent:
PR #282 (slot 1, endor-run Phase 5) used the same llm-base pattern
when its Rust supervisor substrate was llm-only.

## What landed

- `packages/daemon/src/daemon.js`: new `listRetentionPaths(targetId)`
  function on `DaemonCore` shapes the raw `RetentionPath[]` from
  `formulaGraph.listRetentionPaths` into the design's notation. For
  each segment whose `referencedBy` resolves to a `pet-store` /
  `mailbox-store` / `known-peers-store` formula, the generic
  `'petName'` token is replaced by `pet:<name>` labels via
  `provideStoreController(storeId).reverseIdentify(memberId)`. Other
  labels (field names, `'retention'`, `'transient'`) pass through.
- `packages/daemon/src/daemon.js`: new
  `followRetentionPaths(targetId)` async generator. Wires
  `formulaChangeTopic` as the coarse recompute trigger; pipes pings
  into `makeRetentionPathAccumulator` (new helper); yields a
  `{ snapshot }` first then `{ added, removed }` diffs over a
  microtask-coalesced batch window. Drops the underlying subscription
  on `return()`.
- `packages/daemon/src/retention-path-accumulator.js` (new, 153 lines):
  the path-set analog of `retention-accumulator.js`. Computes a
  structural `pathKey` over `[referencedBy, labels, groupMembers,
  type]`, primes the snapshot eagerly on subscribe, batches
  recompute pings, publishes diff deltas only when the path set
  actually changes.
- `packages/daemon/src/host.js`: surface `host.listRetentionPaths` /
  `host.followRetentionPaths` on the `EndoHost` facet (not on
  `EndoGuest`, not on the CapTP gateway). The exo wrap converts the
  follow generator into a `makeIteratorRef` far reference matching
  the existing `followNameChanges` / `followLocatorNameChanges` /
  `followPeerChanges` pattern.
- `packages/daemon/src/interfaces.js`: `HostInterface` guards for
  the two methods (`M.call(LocatorShape).returns(M.promise())`).
- `packages/daemon/src/types.d.ts`: `EndoHost` and `DaemonCore`
  signatures; re-exports of `RetentionPathSegment`,
  `RetentionPath`, `RetentionPathDelta`.
- `packages/daemon/src/help.md` and `help-text-data.js`: in-daemon
  help text for both methods.
- `packages/cli/src/commands/paths.js` (new, 107 lines): the CLI
  command. Resolves the name argument via `E(agent).locate(...)`
  (or treats it as a locator when `--locator` is given), calls
  `E(host).listRetentionPaths(locator)`, prints per-path blocks in
  the design's leaf-to-root order with `pet:<name>` rendered as
  `"<name>"` and field labels rendered as `->name`. `--json` emits
  the raw `RetentionPath[]`.
- `packages/cli/src/endo.js`: command registration in the
  Storage-grouped help.
- `designs/daemon-retention-paths.md`: Status bumped from
  `Not Started` to `In Progress`. New Status section documents the
  Phase 1 scope and explicitly defers Phase 2 (Chat UI panel),
  Phase 4 (per-value disincarnate / reincarnate / delete-pet-name),
  the `graph.js` private-function refactor, and the finer-grained
  edge-event topic.
- `designs/README.md`: corresponding row + milestone-table row
  updated.
- `.changeset/retention-paths-phase-1.md`: `@endo/daemon` minor and
  `@endo/cli` minor.

## Affected paths + diffstat

```
 .changeset/retention-paths-phase-1.md              |  15 ++
 designs/README.md                                  |   4 +-
 designs/daemon-retention-paths.md                  |  68 +++++++-
 packages/cli/src/commands/paths.js                 | 107 ++++++++++++
 packages/cli/src/endo.js                           |  18 ++
 packages/cli/test/paths-command.test.js            |  49 ++++++
 packages/daemon/src/daemon.js                      | 170 ++++++++++++++++++
 packages/daemon/src/help-text-data.js              |   4 +
 packages/daemon/src/help.md                        |  32 ++++
 packages/daemon/src/host.js                        |  70 +++++++-
 packages/daemon/src/interfaces.js                  |   4 +
 packages/daemon/src/retention-path-accumulator.js  | 153 +++++++++++++++++
 packages/daemon/src/types.d.ts                     |  46 +++++
 .../daemon/test/retention-path-accumulator.test.js | 191 +++++++++++++++++++++
 packages/daemon/test/retention-paths.test.js       | 186 ++++++++++++++++++++
 15 files changed, 1113 insertions(+), 4 deletions(-)
```

## Test count + result

14 new tests total, all passing.

- 7 unit tests in `retention-path-accumulator.test.js`: stable
  `pathKey`, first-delta snapshot, empty snapshot still emits,
  subsequent diffs, removed-paths appear in `removed`, multiple
  `notify()` calls coalesce into one `compute()`, no-change
  recompute emits no delta.
- 4 integration tests in `retention-paths.test.js` (real daemon
  via `start`/`stop`): empty result for an unknown locator,
  single pet-name path with `pet:<name>` normalization asserted
  load-bearing on the `pet:marker` label, internal field-edge
  label pass-through (worker pet name surfaces as
  `pet:probe-worker`), multi-name fan-out (`copy` produces two
  `pet:` labels in the path set).
- 3 CLI smoke tests in `paths-command.test.js` via `execa`:
  `--help` lists the `paths` verb, `paths --help` advertises
  `--json` and `--locator`, missing-argument exits non-zero.

## CI status at PR-open time

Checks queued at submit. The PR is in draft state per the
`pr-creation-flow` contract; the judge un-drafts after a green
panel.

## Out-of-scope deferrals (in the design's new Status section)

- Phase 2: Chat UI paths affordance and panel.
- Phase 4: per-path "Delete pet name on this path" affordance,
  per-value Disincarnate / Reincarnate toggle.
- `graph.js` private `listRetentionPaths` refactor (Phase 1
  shapes its output at the host layer; a future cut may move the
  label-normalization into the substrate once the right
  edge-event topic shape is settled).
- Finer-grained `formulaGraphChangeTopic` (Phase 1 uses
  `formulaChangeTopic` as the coarse recompute trigger).

## Self-improvement

Self-improvement: nothing this time. The dispatch brief was crisp
about the Phase 1 scope, the llm-base justification (with PR #282
precedent named), the pre-flight gate sequence, and the explicit
"out of scope" deferral list. The prior dispatch's impasse message
named the substrate gap precisely (`graph.js`'s `listRetentionPaths`
is llm-only), which made the base-branch decision trivial. The
`makeRetentionPathAccumulator` was a clean mirror of the existing
`makeRetentionAccumulator` shape, which is the kind of reuse the
codebase rewards. One small kink: `yarn format` reformatted an
unrelated `packages/hex-test/package.json` JSON spread; reverting
that to keep the diff focused was a manual step. A future skill
note could be "yarn format may touch JSON files unrelated to your
diff; `git checkout` them before commit if they aren't yours". I
am not landing that note now because the friction is small and the
fix is one git command, but flagging here for the next builder.
