---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-10-24T04:21:39Z
---
**Verdict:** request-changes

**Findings:**
- **must-fix**: designs/recursive-dynamodb-capabilities.md:622-625 assumes a one-time backfill is complete while the old adapter stays live. That adapter writes the old JSON shape, so rows created or changed after its scan can lack queue and due; after cutover the new sweep and recount cannot query them. Specify a race-free sequence such as legacy dual-write before backfill, a catch-up pass with a durable high-water mark, then cutover, and test concurrent legacy writes during it. [proposed-rule: An online schema or index migration must define and test a race-free cutover that keeps every live write visible to the new access path.]

- **must-fix**: Sections 3.3 and 3.6 disagree about read guards. Section 3.3 requires a guard to run on the complete item before projection, but :298-301 projects the root item before the child checks its guard. A child guard that depends on a field hidden by an ancestor is then unevaluable, so the asserted recursive check cannot be implemented as written. Define one order, preferably evaluating every ancestor guard on the unprojected item before any projection, and add that chain to the property tests. [proposed-rule: A recursively attenuated read protocol must evaluate each ancestor guard on unprojected data, or reject guards whose fields an earlier projection removes.]

- **should-fix**: :431-439 rebuilds a named grant from the current root catalog but does not say that its physical table identity and key or index schema are pinned or checked. A catalog remap while the process is down can silently rebind a durable grant to a different table or schema, contradicting the promised same effective restriction. Persist a catalog identity or schema digest with the recipe and fail closed on mismatch, with a restart test for catalog drift. [proposed-rule: A durable named capability reconstructed from a catalog must pin or validate the catalog identity and schema at restart, failing closed on mismatch.]

Originating dispatch: kriscendobot-minion.town-pr221-gauntlet-panel-3; PR #221.

Self-improvement: nothing this time.
