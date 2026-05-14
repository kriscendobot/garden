---
title: RetentionPath model (typed segment shape with locator + mergeKind + rootKind)
source: designs/retention-path-notation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: dea3e7186cb482a5fc9c368d0cc95355e3f0271d
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, exo]
status: current
notes: The per-segment `locator` field is the load-bearing addition over `daemon-retention-paths.md` — it's what lets the CLI/chat consumer "click any component to drill in" without a second round-trip. `mergeKind` examples (host+handle, channel+handle, promise+resolver) come from `graph.js`'s union-find. `rootKind` distinguishes `persistent` (entries in `roots` like `@endo`, `@known-peers-store`) from `transient` (in-flight host-operation pins, in `transientRoots`).
---

> Abstract: Refines the segment shape from `daemon-retention-paths.md` so each component carries its own locator and so the union-find merge kind is explicit on segments representing merged groups. **RetentionPathSegment**: `locator` (group representative's locator; always present; the "click target"); `groupMembers: FormulaIdentifier[]` (length 1 if not a merged group); `mergeKind?: string` (when groupMembers.length > 1; examples `'host+handle'`, `'channel+handle'`, `'promise+resolver'`); `referencedBy?: string` (locator of the upstream group representative; absent on root segment); `labels?: string[]` (edge labels from referencedBy into this group — pet-name `'pet:<name>'`, internal `'worker'`/`'handle'`/`'hub'`/etc., cross-peer `'retention'`); `rootKind?: 'persistent' | 'transient'` (present on the topmost segment; `persistent` for entries in `roots`, `transient` for entries in `transientRoots`). **RetentionPath = RetentionPathSegment[]**. The leaf segment is the target group; subsequent segments walk *upstream* toward a root. The topmost segment carries `rootKind`. `graph.js` already has the locator + merge metadata; surfacing them is a render-side change, not a graph-side one. New fields relative to `daemon-retention-paths.md`: the per-segment `locator`, `mergeKind`, `rootKind`.

## RetentionPath model

This sibling refines the segment shape in `daemon-retention-paths.md` so each component carries its own locator and so the union-find merge kind is explicit on segments that represent merged groups.

```typescript
type RetentionPathSegment = {
  /**
   * Locator of the group representative for this segment.
   * Always present; consumers use this as the "click target" for
   * drilling into a segment.
   */
  locator: string;
  /**
   * All formula identifiers in the same union-find group as the
   * representative.
   * Length 1 if the segment is not a merged group.
   */
  groupMembers: FormulaIdentifier[];
  /**
   * The kind of merge that produced this group, when length > 1.
   * Examples: `'host+handle'`, `'channel+handle'`,
   * `'promise+resolver'`.
   * Absent when `groupMembers.length === 1`.
   */
  mergeKind?: string;
  /**
   * The locator of the group representative on the upstream side of
   * the edge into this segment.
   * Absent on the root segment.
   */
  referencedBy?: string;
  /**
   * Edge labels from `referencedBy` into this group.
   * Distinguishes pet-name edges (`'pet:<name>'`) from internal links
   * (`'worker'`, `'handle'`, `'hub'`, `'powers'`, `'slot0'`, etc.) and
   * cross-peer retention edges (`'retention'`).
   */
  labels?: string[];
  /**
   * Present on the topmost segment if the group is a GC root.
   * `'persistent'` for entries in `roots` (e.g., `endo`,
   * `known-peers-store`).
   * `'transient'` for entries pinned by an in-flight host operation
   * (entries in `transientRoots`).
   */
  rootKind?: 'persistent' | 'transient';
};

type RetentionPath = RetentionPathSegment[];
```

The leaf segment is the target group; subsequent segments walk *upstream* toward a root. The topmost segment carries `rootKind`. `mergeKind` and `rootKind` are new relative to `daemon-retention-paths.md`; the per-segment `locator` field is also new and is the load-bearing addition for "click any component to drill in" UX in both CLI and chat.

`graph.js` produces the segment with the locator and merge metadata already available; surfacing them is a render-side change rather than a graph-side one.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
