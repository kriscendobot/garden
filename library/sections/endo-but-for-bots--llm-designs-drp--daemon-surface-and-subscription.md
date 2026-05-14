---
title: Daemon surface (host-only) + subscription (followRetentionPaths)
source: designs/daemon-retention-paths.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a0a4305b63f44e02e49a985243da67641fbc5552
source_date: 2026-05-01
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security, eventual-send]
status: current
notes: The host-only rule is the canonical capability-discipline answer for daemon-internals observability: a guest's `listRetentionPaths(myLocator)` would reveal host naming + peer relationships + cross-guest shared roots. The `RetentionPathDelta = {snapshot} | {added, removed}` shape with first delta always a snapshot is the canonical follow-family pattern in Endo (matches `followNameChanges`, `followLocatorNameChanges`, `followMessages`). Subscription-release-by-dropping-far-reference replaces explicit `unsubscribe`.
---

> Abstract: Two new methods on `EndoHost` (and the corresponding `Mail` interface). **listRetentionPaths(locator): Promise<RetentionPath[]>** — snapshot every path from a GC root to the target. **followRetentionPaths(locator): Promise<FarRef<AsyncIterableIterator<RetentionPathDelta>>>** — stream snapshots; first delta is the current snapshot; subsequent deltas are diffs emitted on formulation/collection/pet-store-write/pet-store-remove/retention-edge-add/remove/peer-connect/disconnect. **RetentionPathDelta** is `{snapshot: RetentionPath[]}` or `{added: RetentionPath[]; removed: RetentionPath[]}`. Path equality is **structural** (deep equal on segment representatives + labels), not pointer identity. Collected target → iterator yields `{snapshot: []}` and ends. **Why host-only**: guests must not enumerate paths through caps they don't own; a guest's `listRetentionPaths(myLocator)` would reveal host naming, peer relationships, and which other guests share common roots. Methods added to `MailInterface` + `Host` exo surface + `EndoHost` Far facet only; **NOT** to `EndoGuest` or the gateway; the CapTP `provide` boundary has no exposure. **Subscription release**: matches `followLocatorNameChanges` pattern at `host.js:1227` — host returns `makeIteratorRef(iterator)`; dropping the far reference (or CapTP collection) terminates the generator. **Plumbing**: `graph.js:748` already returns the snapshot; what's missing is a `formulaGraphChangeTopic` (or extension of `formulaChangeTopic`) to know *when* to recompute, a debouncing wrapper (analogous to `retention-accumulator.js`) so a burst of formulations produces a single delta, and structural diffing of the new vs last-emitted snapshot.

### Daemon surface (host-only)

Two new methods on `EndoHost` (and on the corresponding `Mail` interface used by the host wrapper):

```typescript
interface EndoHost {
  /**
   * Snapshot every retention path from a GC root to the target.
   * Locator is in the same string form as `locate()`.
   */
  listRetentionPaths(
    locator: string,
  ): Promise<RetentionPath[]>;

  /**
   * Stream retention-path snapshots for the target.  The first delta
   * is the current snapshot; subsequent deltas are emitted whenever
   * the set of paths changes (formulation, collection, pet-store
   * write, pet-store remove, retention-edge add/remove, peer
   * connect/disconnect).
   *
   * The returned reference is a far reference to an
   * `AsyncIterableIterator<RetentionPathDelta>`.  Drop the reference
   * to release the subscription, exactly as with
   * `followNameChanges` / `followLocatorNameChanges`.
   */
  followRetentionPaths(
    locator: string,
  ): Promise<FarRef<AsyncIterableIterator<RetentionPathDelta>>>;
}

type RetentionPathDelta =
  | { snapshot: RetentionPath[] }
  | { added: RetentionPath[]; removed: RetentionPath[] };
```

The first delta is always a `snapshot`. Subsequent deltas are diffs. A diff over a path uses *path equality* (deep equal on the segments' group representatives and labels) — not pointer identity. If the target locator becomes invalid (the formula has been collected), the iterator yields `{ snapshot: [] }` and ends.

#### Why host-only

Guests must not be able to enumerate paths through capabilities they do not own. A guest's `listRetentionPaths(myLocator)` would reveal the host's internal naming, peer relationships, and which other guests share common roots. The methods are added to:

- `MailInterface` and the `Host` exo's surface (`packages/daemon/src/interfaces.js:101-176`)
- The `EndoHost` Far facet (`host.js:1014-1077`)

…and **not** to `EndoGuest` or to the gateway. The CapTP `provide` boundary has no exposure to these methods.

#### Subscription release

Match `followLocatorNameChanges`'s pattern at `host.js:1227`: the host returns `makeIteratorRef(iterator)`, the consumer holds a far reference, and dropping the reference (or letting the CapTP session collect it) terminates the underlying generator. Implementation of the producer uses `formulaChangeTopic` from `daemon.js:445` plus a new `petStoreChangeTopic` (or a re-use of the existing per-store change topics — TBD in implementation; the spec is independent).

#### Daemon plumbing

`graph.js:748` already returns the snapshot. What's missing:

1. A `formulaGraphChangeTopic` (or extension of `formulaChangeTopic` to carry edge-add / edge-remove events) that lets us know *when* to recompute.
2. A debouncing wrapper that recomputes paths once per microtask batch — analogous to `retention-accumulator.js`. A burst of formulations should produce a single delta.
3. Diffing the new snapshot against the last-emitted snapshot to produce `{ added, removed }` deltas. Path equality is structural over `[referencedBy, labels[], groupMembers[]]`.

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
