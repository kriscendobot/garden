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
kind: index
section_count: 2
---

> Abstract: **Problem**: the daemon already computes retention paths (`packages/daemon/src/graph.js:748` `listRetentionPaths`) but the function is **private to GC** — not exposed to host, CLI, or Chat UI. Users can't ask "why is this value still alive, and what would I delete/cancel to release it?" — missing observability for cross-peer GC, workers panel, and formula inspector. **Four wants**: (1) a host-only (not guest) daemon API returning every retention path to a target locator, in notation distinguishing pet-name edges from internal formula-to-formula edges; (2) a subscription form matching the `follow*` family's release-via-dropped-far-ref pattern; (3) a CLI verb `endo paths <name-or-locator>`; (4) a Chat UI button on every value opening a paths panel with delete-pet-name + disincarnate/reincarnate affordances. **Partially supersedes** two existing designs by extracting a shared retention-path component: `formula-inspector` (Not Started) — its retention-path facility moves here; formula-inspector keeps non-retention metadata; the two compose (inspector panel embeds paths panel). `workers-panel` (Not Started) — its `E(agent).retentionPath(petName)` flat-array API is replaced by `RetentionPath[]`; workers-panel imports the paths viewer from here. `daemon-cross-peer-gc` (Complete) supplies the `retention` edge kind this renders (no change to the cross-peer mechanism).

Sections:

- [What is the Problem Being Solved?](endo-but-for-bots--llm-designs-drp--problem-and-overlapping-designs--what-is-the-problem-being-solved.md)
- [Status of Overlapping Designs](endo-but-for-bots--llm-designs-drp--problem-and-overlapping-designs--status-of-overlapping-designs.md)

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
