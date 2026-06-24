---
title: Status of Overlapping Designs
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

This design **partially supersedes** two existing designs by extracting a shared retention-path component out of each:

| Design | Overlap | Resolution |
|---|---|---|
| `formula-inspector` (Not Started) | Mentions "Provide a facility for revealing every retention path in the formula graph for identified formulas" as a one-line aside. | The retention-path facility moves here; `formula-inspector` remains responsible for *non-retention* metadata (formula type, fields, source, etc.). The two compose: the inspector panel in Chat embeds the paths panel below the formula fields. |
| `workers-panel` (Not Started) | Has a "Pet Name Retention Paths" subsection with a proposed `E(agent).retentionPath(petName)` API returning a flat array. | The workers panel keeps its event-loop-latency sparkline and tenant list, but imports the paths viewer from this design rather than defining its own. The flat-array API in `workers-panel.md` is replaced by the richer `RetentionPath[]` shape defined here. |

`daemon-cross-peer-gc` (Complete) supplies one of the *kinds* of edges this design surfaces: `retention` edges from a peer's local agent ID to formulas that peer is keeping alive. This design does not change the cross-peer mechanism; it just renders those edges.

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
