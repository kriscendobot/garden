---
title: Problem + Status of overlapping designs (formula-inspector + workers-panel)
source: designs/daemon-retention-paths.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a0a4305b63f44e02e49a985243da67641fbc5552
source_date: 2026-05-01
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: The "partially supersedes" pattern names how this design extracts shared retention-path components out of two siblings. workers-panel's flat-array `E(agent).retentionPath(petName)` API is replaced by the richer `RetentionPath[]` shape; formula-inspector embeds the panel below its formula fields. daemon-cross-peer-gc (Complete) is the source of the `retention` edge kind this surface renders.
---

> Abstract: **Problem**: the daemon already computes retention paths (`packages/daemon/src/graph.js:748` `listRetentionPaths`) but the function is **private to GC** — not exposed to host, CLI, or Chat UI. Users can't ask "why is this value still alive, and what would I delete/cancel to release it?" — missing observability for cross-peer GC, workers panel, and formula inspector. **Four wants**: (1) a host-only (not guest) daemon API returning every retention path to a target locator, in notation distinguishing pet-name edges from internal formula-to-formula edges; (2) a subscription form matching the `follow*` family's release-via-dropped-far-ref pattern; (3) a CLI verb `endo paths <name-or-locator>`; (4) a Chat UI button on every value opening a paths panel with delete-pet-name + disincarnate/reincarnate affordances. **Partially supersedes** two existing designs by extracting a shared retention-path component: `formula-inspector` (Not Started) — its retention-path facility moves here; formula-inspector keeps non-retention metadata; the two compose (inspector panel embeds paths panel). `workers-panel` (Not Started) — its `E(agent).retentionPath(petName)` flat-array API is replaced by `RetentionPath[]`; workers-panel imports the paths viewer from here. `daemon-cross-peer-gc` (Complete) supplies the `retention` edge kind this renders (no change to the cross-peer mechanism).

## What is the Problem Being Solved?

The daemon already computes retention paths in `packages/daemon/src/graph.js:748` (`listRetentionPaths`), but that function is private to the GC and is not exposed to the host, the CLI, or the Chat UI. Users cannot ask the question "why is this value still alive, and what would I have to delete or cancel to release it?" This is the missing observability for cross-peer GC (`daemon-cross-peer-gc.md`), the workers panel (`workers-panel.md`), and the formula inspector (`formula-inspector.md`).

We want:

1. A daemon API on the **host** (not the guest) that returns every retention path to a target locator, in a notation that distinguishes pet-name edges in pet stores from internal formula-to-formula edges.
2. The same daemon API as a **subscription** so the Chat UI can react to formulations and collections without polling, with a release handshake matching `followNameChanges` / `followLocatorNameChanges` / `followMessages`.
3. A CLI verb (`endo paths <name-or-locator>`) that prints the paths in that distinguishing notation.
4. A button on every value in Chat that opens a panel of retained paths, with affordances to delete a pet name on a path and to disincarnate or reincarnate the target value.

This doc factors the work apart from the formula inspector and the workers panel; the components below are intentionally reusable.

## Status of Overlapping Designs

This design **partially supersedes** two existing designs by extracting a shared retention-path component out of each:

| Design | Overlap | Resolution |
|---|---|---|
| `formula-inspector` (Not Started) | Mentions "Provide a facility for revealing every retention path in the formula graph for identified formulas" as a one-line aside. | The retention-path facility moves here; `formula-inspector` remains responsible for *non-retention* metadata (formula type, fields, source, etc.). The two compose: the inspector panel in Chat embeds the paths panel below the formula fields. |
| `workers-panel` (Not Started) | Has a "Pet Name Retention Paths" subsection with a proposed `E(agent).retentionPath(petName)` API returning a flat array. | The workers panel keeps its event-loop-latency sparkline and tenant list, but imports the paths viewer from this design rather than defining its own. The flat-array API in `workers-panel.md` is replaced by the richer `RetentionPath[]` shape defined here. |

`daemon-cross-peer-gc` (Complete) supplies one of the *kinds* of edges this design surfaces: `retention` edges from a peer's local agent ID to formulas that peer is keeping alive. This design does not change the cross-peer mechanism; it just renders those edges.

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
