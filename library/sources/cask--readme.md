---
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 13
status: current
---

> Abstract: The root README of `kriskowal/cask`, a content-addressed block store in Go where every block is exactly 1KB. The README is unusually self-contained: it argues the design (why 1KB, what TCP costs, what blocks give you), specifies the block format and the two wire protocols, demonstrates the CLI, and catalogs the package layout. This is the highest-value single document of the three "future-forks" repos and is ingested in full; the deeper `doc/design/` documents and the Go source are deferred to a follow-on job.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/cask--readme--overview.md) | content-addressed-storage, networking | current |
| [cli-quick-start](../sections/cask--readme--cli-quick-start.md) | content-addressed-storage | current |
| [why-1kb-blocks](../sections/cask--readme--why-1kb-blocks.md) | content-addressed-storage, networking | current |
| [what-tcp-costs-you](../sections/cask--readme--what-tcp-costs-you.md) | networking | current |
| [storage-transport-single-abstraction](../sections/cask--readme--storage-transport-single-abstraction.md) | content-addressed-storage, networking | current |
| [merkle-trees-for-everything](../sections/cask--readme--merkle-trees-for-everything.md) | content-addressed-storage | current |
| [columnar-ecs-design](../sections/cask--readme--columnar-ecs-design.md) | content-addressed-storage, data-structures | current |
| [priority-load-shedding](../sections/cask--readme--priority-load-shedding.md) | networking | current |
| [noise-cryptography](../sections/cask--readme--noise-cryptography.md) | networking | current |
| [content-agnostic-gc](../sections/cask--readme--content-agnostic-gc.md) | content-addressed-storage | current |
| [block-format](../sections/cask--readme--block-format.md) | content-addressed-storage | current |
| [protocols](../sections/cask--readme--protocols.md) | networking | current |
| [package-taxonomy](../sections/cask--readme--package-taxonomy.md) | content-addressed-storage, networking, data-structures | current |

## Provenance

- Repository default branch `main`; README last modified 2026-02-17 by Kris Kowal. Repo HEAD equals the README commit (`cdb975d8`).
- This is a "begin" ingest of the README only. Deferred to a follow-on `scholar-ingest-cask` job: the `doc/design/` documents (status, architecture, package-taxonomy, parallel-arrays, trace, dbstore-design, net-crypto, net-design, net-session-init-design, gc-and-retention, gc-concurrent-design, protocol) and the Go source packages.
- Bot fork: `kriscendobot/cask` (content identical to upstream).

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
