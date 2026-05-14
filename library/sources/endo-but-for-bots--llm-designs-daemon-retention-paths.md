---
source: designs/daemon-retention-paths.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a0a4305b63f44e02e49a985243da67641fbc5552
source_date: 2026-05-01
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 5
status: current
notes: This is the **sibling** of `retention-path-notation.md` (ingested cycle 42) — same `RetentionPath` shape, but this design covers the per-target subscription + chat-UI affordances, while RPN covered the bulk method + CLI string notation. Together they form the daemon-retention-paths design surface: this design's `listRetentionPaths(locator): Promise<RetentionPath[]>` is the per-target multi-path API; RPN's `listRetentionPaths(targetIds): Promise<Array<RetentionPath>>` is the bulk best-path API. Note signature collision — same name, different shapes — likely resolved at integration. Partially supersedes formula-inspector + workers-panel by extracting the shared retention-path component.
---

> Abstract: Design for the **per-target subscription + chat-UI sibling** of `retention-path-notation.md` (the bulk method). Together: listRetentionPaths(locator) returns all paths to one target; bulk listRetentionPaths(targetIds) returns one best path per target. **Five sections**: problem + the partial-supersession of formula-inspector and workers-panel; notation (typed segment shape + four edge-label kinds: `pet:<name>`, field names, `retention`, `transient`); daemon surface (host-only listRetentionPaths + followRetentionPaths subscription with microtask-coalesced deltas + `RetentionPathDelta = {snapshot} | {added, removed}` + subscription-release-by-dropping-far-ref); CLI + Chat UI (endo paths command + reveal-on-every-value button + Paths panel with delete-pet-name + disincarnate/reincarnate); phased implementation + security + decisions. Host-only: guests would learn host structure if exposed.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-overlapping-designs](../sections/endo-but-for-bots--llm-designs-drp--problem-and-overlapping-designs.md) | daemon, capability-security | current |
| [notation-and-edge-labels](../sections/endo-but-for-bots--llm-designs-drp--notation-and-edge-labels.md) | daemon | current |
| [daemon-surface-and-subscription](../sections/endo-but-for-bots--llm-designs-drp--daemon-surface-and-subscription.md) | daemon, capability-security, eventual-send | current |
| [cli-and-chat-ui](../sections/endo-but-for-bots--llm-designs-drp--cli-and-chat-ui.md) | daemon, tooling | current |
| [phases-and-decisions](../sections/endo-but-for-bots--llm-designs-drp--phases-and-decisions.md) | daemon, capability-security | current |

## Cross-references

- Sibling design: `endo-but-for-bots--llm-designs-rpn--*` (cycle 42; the bulk variant with the CLI string notation).
- `daemon-cross-peer-gc` (Complete; not yet ingested) supplies the `retention` edge kind this surface renders.
- `formula-inspector` (Not Started) embeds the paths panel; this design extracts it as a shared component.
- `workers-panel` (Not Started) imports the paths panel; flat-array API replaced by `RetentionPath[]`.

## Source

[designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
