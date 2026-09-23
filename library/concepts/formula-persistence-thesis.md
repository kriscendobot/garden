---
id: formula-persistence-thesis
aliases: ["Formula Persistence", "formula persistence", "pass by construction", "daemon persistence strategy", "petname graph as persistence root", "persist construction not content"]
topics: [daemon, persistence, capability-security]
---

# formula-persistence-thesis

The Endo Daemon's persistence strategy, named in endojs/endo#3121
(draft). The thesis: the petname graph **is** the persistence root,
not a layer on top of sturdy references or web-keys. The system
persists *construction*, not content — each capability is described
by a *formula* (a recipe for reconstructing the live reference and
its transitive dependencies on demand). The position is *between*
Waterken (masked partition + orthogonal persistence) and E (per-
reference exposed partition + manual sturdy references): Formula
Persistence exposes per-cohort. Properties: petname-as-root,
destruction-by-cohort, acyclic-formula-graph (local refcount, no
distributed GC), revocation-by-withdrawal.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dp/frame-and-position-in-design-space](../sections/endo--designs-dp--frame-and-position-in-design-space.md) | Thesis + the three-position comparison table (Waterken / E / Formula Persistence). |
| [dp/waterken-and-e-as-endpoints](../sections/endo--designs-dp--waterken-and-e-as-endpoints.md) | The two entangled dimensions; the endpoints; the common URL-like-reference substrate. |
| [dp/formula-graph-and-cohort-destruction](../sections/endo--designs-dp--formula-graph-and-cohort-destruction.md) | The inversion: petnames are the persistence root; formulas as recipes. |
| [dp/system-fit-and-not-orthogonal](../sections/endo--designs-dp--system-fit-and-not-orthogonal.md) | Why a user agent needs this rather than orthogonal persistence. |

## See also

- [[formula-graph]] — the substrate.
- [[cohort-destruction]] — the partition response.
- [[revocation-by-withdrawal]] — the user-initiated cohort destruction.
- [[four-tables-coordinated-retention]] — the cross-peer data model.
- [[six-aspects-of-sharing]] — the framework against which Formula Persistence is evaluated.

## Source provenance note

This concept is canonized in `endojs/endo#3121` which is still **draft** as of 2026-05-14 (PR head `aefc1b87da0c`). Lookups touching this concept should re-check the PR head per the unmerged-PR discipline in [`conventions.md`](../conventions.md).
