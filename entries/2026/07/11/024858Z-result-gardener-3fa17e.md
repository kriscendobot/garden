---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-11T02:48:59Z
---
---
role: scholar
job: scholar-ingest-source-habitat-chronicles
---

# scholar-ingest-source-habitat-chronicles — The Unum Pattern ingested

Ingested Chip Morningstar's **The Unum Pattern**
(https://habitat-chronicles.com/2019/08/the-unum-pattern/, 2019-08-28) into
`journal/library/` — the primary reason for the maintainer's habitat-chronicles
ingest job. First source from **habitat-chronicles.com** (the dashed live
domain; the non-dashed `habitatchronicles.com` is dead — no stale non-dashed
links were found existing in `journal/library/` to rewrite).

## Ingested (source `habitat-chronicles--unum-pattern`, web-essay, 7 sections)

Content SHA-256 `7d099818…` (fetched via `source_fetched_via=direct`; idempotency
anchor). Sections:

- `--overview` — the pattern's name/origin (Habitat → Elko → Electric Communities)
- `--unum-vs-object-two-planes` — the teacup; world-object vs OOP-object; the term *unum*
- `--presences-and-division-of-labor` — presence = per-machine portion; division of labor, NOT master/replica; asymmetric private state
- `--addressing-presences-vats-and-channels` — two-part addressing; vats & channels; client/server asymmetry
- `--four-messaging-patterns` — Reply / Neighbor / Broadcast / Point; the fanout primitive; Reply+Neighbor and Broadcast idioms
- `--behavioral-protocols-anti-rest` — behavioral (not data) protocols; knowledge-based compression; "about as anti-REST as you can be"
- `--other-divisions-of-labor-and-containership` — peer-to-peer; per-unum authority (Electric Communities); the containership problem

## New indexing structure

- **New topic** `distributed-objects` — objects that are *themselves distributed
  entities* (unum/presence, division of labor, behavioral protocols, the
  MMO/actor lineage behind the E-vat model and Endo's ocap presences); distinct
  from `change-propagation` and `capability-theory`. All 7 sections filed here.
- **New concept** `habitat-unum` (topics: distributed-objects, capability-theory)
  — 16 keyword aliases in `keywords.md`; see-also to `vat-and-compartment`,
  `granovetter-operator`, `object-capability`; a **Common confusions** block
  explicitly disambiguating it from jcorbin's unrelated `unum` task-queue source
  (`sources/unum.md`) and from the ordinary "distributed object" reading. All 7
  sections filed in its Sections table.
- **Cross-filed** into existing topics: `change-propagation` (presences,
  four-messaging), `capability-theory` (addressing/vats, containership/Electric
  Communities), `networking` (behavioral/anti-REST).
- README indexes updated: `sources/README.md` (Web essays and surveys table row),
  `topics/README.md` (distributed-objects Index row), `concepts/README.md`
  (habitat-unum bullet in the distributed-ocap cluster). No stale non-dashed
  `habitatchronicles.com` links existed to rewrite.

## Integrity gate (step 8) — PASS

- `library-link-check.sh --changed`: OK — every section-table target and
  sections-index row for the `habitat-chronicles--unum-pattern` cluster resolves
  to a committed file.
- `regenerate-topics-counts.sh --check`: reported the expected stale counts
  (6 lines) from the new/cross-filed topics; step-9 `--land` reconciled them.

## Regenerated projected indexes (step 9) — landed current

- `regenerate-sections-index.sh` → landed `sections/README.md`.
- `regenerate-topics-counts.sh` → landed `topics/README.md` (distributed-objects
  count now 7).

## Follow-on / deferred remainder

Posted `scholar-ingest-source-habitat-chronicles-2` (plan/, deferred, low)
naming the germane remainder in priority order: **What Are Capabilities?**
(2017/05, a full dense cycle on its own — the canonical ocap explainer), **A
Slightly Skeptical Perspective on REST** (2017/11, the anti-REST counterpart),
**The Tripartite Identity Pattern** (2008/10, identity/trust), and **Adventures
in LLM Land** (2026/02, agent-adjacent). The blog's 2004–2016 virtual-world /
MMO-history archive is out of scope (no bearing on agents/capabilities/
distributed objects).

Self-improvement: The `web-essay` schema handled a long, subheading-less blog
essay cleanly once sectioned by argument cluster; no convention gap surfaced.
One naming hazard worth noting for future ingests: the library already had an
unrelated `unum` source (jcorbin's task-queue) and a `unum` keyword, so this
ingest used the distinct concept-id `habitat-unum` and avoided the bare `unum`
keyword — a Common-confusions block on both the concept and source pages now
guards the collision. No role/skill edit warranted.
