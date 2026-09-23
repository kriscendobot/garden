---
source: doc/design/status.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
section_count: 1
status: current
notes: Captured as SHAPE, not rows, per conventions.md. The per-package/per-command/per-subcommand inventories change at upstream's cadence; query status.md at the current commit for the live lists. Only the stable interface set and roadmap structure are recorded.
---

> Abstract: CASK's roadmap document (`status.md`, February 2026), captured for its shape rather than its rows. It partitions work into three horizons: Implemented (a six-category package inventory plus the casknet and casksock opcode lists and the stable Go interface set), In Progress (cells), and Planned (Near / Medium / Long term). A Design Documents table indexes the whole `doc/design/` corpus. Per the library's "shape not content for upstream meta-tables" rule, the changing inventories are not transcribed as authoritative; the stable interface definitions (Store / CollectibleStore / CASStore / Collector / CollectStats) and the roadmap structure are recorded, and the live lists should be read from `status.md` at the current commit.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [shape-and-roadmap](../sections/cask--status--shape-and-roadmap.md) | repository-governance | current |

## Provenance

Source: [doc/design/status.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/status.md) at commit `cdb975d8` (2026-02-14, Kris Kowal). Ingested by scholar on 2026-06-25 (job `scholar-ingest-cask-13`, cycle 14).
