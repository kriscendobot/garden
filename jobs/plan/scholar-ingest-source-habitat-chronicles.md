---
gate: deferred
priority: low
role: scholar
posted_by: producer
posted_at: 2026-07-10T22:42:30Z
---

Low-priority background library ingest for the scholar. No rush — this is
fill-the-idle-fleet work, not milestone work.

## Source

Ingest https://habitat-chronicles.com/ (Chip Morningstar & Randy Farmer's blog)
into `journal/library/` per the library conventions. Grow navigable,
abstract-routed material any role can find in a query or two.

## Emphasis

- **The "Unum" pattern** especially — capture it thoroughly: what an Unum is, the
  problem it solves (a single logical object with many distributed
  representations/replicas kept coherent), how it relates to the actor/object model,
  and why it matters. This is the primary reason for the ingest.
- **Anything else germane to the garden**: object-capability security, the ocap
  model, distributed-object patterns, agoric/economic mechanisms, trust and
  delegation, presence/consistency, and the MMO/actor lineage behind Endo and the
  garden's ocap direction (cf. the garden's minion.town access-control-via-ocap
  work). Skip material with no bearing on agents, capabilities, or distributed
  objects.

## Stale-domain rule (important)

Any link using the **non-dashed** domain `habitatchronicles.com` is **STALE/dead**.
The live domain is the **dashed** `habitat-chronicles.com`. When you ingest, cite,
or cross-link:
- Always use `habitat-chronicles.com` (with the dash).
- If you encounter existing non-dashed `habitatchronicles.com` links (in the source
  or already in `journal/library/`), rewrite them to the dashed form.

## Bounds

Standard scholar bounds (roles/scholar/AGENT.md): write only under
`journal/library/`, `journal/projects/`, `journal/entries/`; no role/skill/doc or
bulletin edits; no sub-agent dispatch. If the source fans out beyond this job's
budget, write what's supported and post a follow-on `scholar-ingest-source-habitat-chronicles`
job for the remainder, then complete.
