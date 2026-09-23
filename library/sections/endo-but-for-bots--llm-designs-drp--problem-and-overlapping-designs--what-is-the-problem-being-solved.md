---
title: What is the Problem Being Solved?
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
parent: endo-but-for-bots--llm-designs-drp--problem-and-overlapping-designs
---

The daemon already computes retention paths in `packages/daemon/src/graph.js:748` (`listRetentionPaths`), but that function is private to the GC and is not exposed to the host, the CLI, or the Chat UI. Users cannot ask the question "why is this value still alive, and what would I have to delete or cancel to release it?" This is the missing observability for cross-peer GC (`daemon-cross-peer-gc.md`), the workers panel (`workers-panel.md`), and the formula inspector (`formula-inspector.md`).

We want:

1. A daemon API on the **host** (not the guest) that returns every retention path to a target locator, in a notation that distinguishes pet-name edges in pet stores from internal formula-to-formula edges.
2. The same daemon API as a **subscription** so the Chat UI can react to formulations and collections without polling, with a release handshake matching `followNameChanges` / `followLocatorNameChanges` / `followMessages`.
3. A CLI verb (`endo paths <name-or-locator>`) that prints the paths in that distinguishing notation.
4. A button on every value in Chat that opens a panel of retained paths, with affordances to delete a pet name on a path and to disincarnate or reincarnate the target value.

This doc factors the work apart from the formula inspector and the workers panel; the components below are intentionally reusable.

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
