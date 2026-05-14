---
title: Notation (paths + segments) + Edge-label conventions
source: designs/daemon-retention-paths.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a0a4305b63f44e02e49a985243da67641fbc5552
source_date: 2026-05-01
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon]
status: current
notes: Compare to the **sibling** `endo-but-for-bots--llm-designs-rpn--retention-path-model` (cycle 42) — same segment shape but RPN refines with per-segment `locator` + `mergeKind` + `rootKind: 'persistent'|'transient'` fields. This design defines the original; RPN adds the refinements. The `pet:` prefix on pet-name edges is unambiguous because pet names never start with `:`.
---

> Abstract: Reuses `graph.js`'s existing `RetentionPathSegment` types (`groupMembers`, `referencedBy?`, `labels?`, `type?: 'root'`). **RetentionPath = RetentionPathSegment[]**. The **leaf segment is the target group**; subsequent segments walk *upstream* toward a root. Matches `listRetentionPaths`'s shape. **Four edge-label conventions**: (1) **`pet:<name>`** — the upstream's pet store contains the literal pet name mapping to this group (source: `onPetStoreWrite`); (2) **`<field>`** plain — a static formula-field reference (`worker`, `handle`, `petStore`, `hub`, `powers`, `slot0`, `bundle`, `agent`, `mailbox`, `mailHub`, `inspector`, `endo`, `networks`, `pins`; source: `extractLabeledDeps` at `daemon.js:476`); (3) **`retention`** — a cross-peer retention edge (the upstream agent's peer is holding this formula; source: `formulaGraph.addRetention`); (4) **`transient`** — a short-lived pin held by an in-flight host operation (source: `transientRoots`). The `pet:` prefix is the central point of the user's request: CLI + UI must distinguish *human-facing names* from *internal links*. Unambiguous because pet names never start with `:`.

## Design

### Notation: paths and segments

Reuse `graph.js:12`'s existing types, exported here for consumers:

```typescript
type RetentionPathSegment = {
  /** Members of the same union-find group as the segment's anchor. */
  groupMembers: FormulaIdentifier[];
  /** The group representative on the *upstream* side of this edge.
   * Absent on the root segment. */
  referencedBy?: FormulaIdentifier;
  /** Edge labels from `referencedBy` into this group.
   * Distinguishes pet-name edges (`"pet:<name>"`) from internal links
   * (`"worker"`, `"handle"`, `"hub"`, `"powers"`, `"slot0"`, etc.) and
   * cross-peer retention edges (`"retention"`). */
  labels?: string[];
  /** Present on the topmost segment if the group is a GC root
   * (e.g. `endo`, `known-peers-store`). */
  type?: 'root';
};

type RetentionPath = RetentionPathSegment[];
```

The leaf segment is the target group; subsequent segments walk *upstream* toward a root. This matches `listRetentionPaths` already.

### Edge-label conventions

`graph.js` already records labels on `addLabeledEdge`. The labels we expose:

| Label form | Meaning | Source |
|---|---|---|
| `pet:<name>` | The upstream's pet store contains the literal pet name `<name>` mapping to a formula in this group. | `onPetStoreWrite` paths |
| `<field>` (e.g. `worker`, `handle`, `petStore`, `hub`, `powers`, `slot0`, `bundle`, `agent`, `mailbox`, `mailHub`, `inspector`, `endo`, `networks`, `pins`) | A static formula-field reference. | `extractLabeledDeps` in `daemon.js:476` |
| `retention` | A cross-peer retention edge: the upstream agent's peer is holding this formula. | `formulaGraph.addRetention` |
| `transient` | A short-lived pin held by an in-flight host operation. | `transientRoots` |

The `pet:` prefix is the central point of the user's request: the CLI and UI must distinguish *human-facing names* from *internal links*. The prefix is unambiguous because pet names never start with `:`.

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
