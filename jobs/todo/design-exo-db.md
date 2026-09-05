---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: an `exo-db` package — passable databases in Endo

Repo: **endojs/endo-but-for-bots**. Deliverable: a single self-contained design at
`designs/exo-db.md`, complete enough for a later builder dispatch to implement from.
Read `designs/CLAUDE.md` (or equivalent) first and match the project's design
conventions; do not invent new metadata fields.

Maintainer prompt (kriskowal, 2026-09-05), to be expanded — not narrowed:

> Introduce an `exo-db` package with exo database interfaces, and an implementation
> `exo-db/sqlite` based on platform-specific sqlite bindings (covering both node and
> endor), such that we can model databases, tables, and rows of passable data in Endo.
> Also propose formulas for durably persisting abstract passable databases in the daemon.

## What the design must cover

1. **The exo interfaces.** Model databases, tables, and rows of *passable* data.
   Name the exo boundaries, their methods, and what is a capability vs. a plain value.

2. **`exo-db/sqlite`.** An implementation over platform-specific sqlite bindings that
   works on **both node and endor**. Say how the platform-specific binding is selected
   and what the shared surface is. (See how `@endo/platform` already handles
   per-platform capability provision — reuse that shape rather than inventing one.)

3. **Compact ordered encoding for keys.** This is necessarily entrained by the above:
   ordered key encoding is a prerequisite for range scans and sorted iteration over
   passable keys. Treat it as in-scope and specify it (or name precisely the existing
   art it should stand on).

4. **The type story — three bands, deliberately.**
   - *Narrow:* it must be possible to prescribe cell types precisely, as one can in
     sqlite.
   - *Broad:* it must also be possible to cover all durably passable values in Endo,
     **including references**.
   - *The JSON subset specifically:* call this out as its own band, because a native
     database — **dynamodb and sqlite both** — can provide richer features (indexing,
     projection, native predicates) over JSON-shaped data than over opaque blobs.

5. **Portability is a deliberate constraint, not an accident.** Limit the design to a
   *portable subset of expressible databases*, specifically so the same abstraction can
   stand on **dynamodb or sqlite** depending on how a given Endo daemon is deployed.
   Be explicit about what that subset excludes and why, and about which sqlite or
   dynamodb features are deliberately left unreachable to preserve portability.

6. **Daemon formulas.** Propose formulas for durably persisting abstract passable
   databases in the daemon. The expectation: when running on sqlite, the daemon supports
   **multiple separate database files**, each with its own place in Endo's state
   directory keyed by its **assigned formula identifier**.

## Notes

- Use [library-lookup] before drafting so this design names things the way the existing
  corpus already names them (passables, exos, formulas, the daemon's state directory
  layout, `@endo/platform`'s per-platform provisioning, any prior ordered-encoding art)
  and references prior art rather than reinventing it.
- Where a real fork in the design exists that only the maintainer can settle, put it in
  `## Open questions`. Per the garden's carve-out, a design landing with a non-empty
  open-questions section is presented as a review PR rather than landed bare.
