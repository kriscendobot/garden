---
order: serial
children: design-endo-glob-grep-pushdown build-endo-glob-grep-pushdown gauntlet-endo-glob-grep-stack
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-07-10T19:39:00Z
---

# Orchestration: endo #127 glob/grep — push down into @endo/platform, design forward

Serial, halt-on-failure orchestration of the maintainer's (kriskowal) directive on
the **endo #127** stack (`kriscendobot/endo` fork): resolve the tension between a
working normative JS glob/grep and an interface that leaves room for future
performance work, by pushing the implementations down into `@endo/platform`
(revealed at the daemon layer), keeping the `Promise<Array>` Array surface,
designing forward for exo-stream streaming variants with intrinsic batching, and
decoupling glob from grep so a file stream pipelines glob→grep (grep takes an
array/`Promise<Array>` of paths, not glob-as-an-option). Includes agent-tool-
surface and primer work for the new tools.

Runs in sequence, halting if any child fails so a design tension can be re-pondered
rather than merged past:

1. `design-endo-glob-grep-pushdown` — designer (Fable): ponder and resolve the
   tensions; produce the design + per-layer implementation map.
2. `build-endo-glob-grep-pushdown` — builder (Opus): implement the design across
   the stack layers.
3. `gauntlet-endo-glob-grep-stack` — run the gauntlet on each layer of the stack,
   panels weighing the design tensions explicitly.
