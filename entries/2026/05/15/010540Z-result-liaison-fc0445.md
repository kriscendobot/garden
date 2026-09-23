---
ts: 2026-05-15T01:05:40Z
kind: result
role: liaison
project: garden-library
refs:
  - entries/2026/05/15/010055Z-result-liaison-b89052.md
  - entries/2026/05/15/005759Z-message-liaison-c7c53c.md
---

# Liaison: role-landings batch 2 — designer-security + designer-exo-captp-api

## Maintainer ask

Maintainer reaction to the proof-of-concept landing (`designer-protocol`,
last cycle): *"This all sounds fine. Pray continue."*

Interpreted as: proceed with the next two highest-coverage
specialist landings so three landings exist for shape-comparison.
The three thinner-coverage specialists (`designer-frontend`,
`designer-language`, `designer-ux`) stay pending until ingestion
fills out the relevant topics.

## Landed (two new seed landings)

- **[designer-security](../../../library/roles/designer-security.md)** — capability-security and policy engineering. Anchors on the `capability-security` topic (117 sections, densest in the library). Cites 11 concept pages (delegates-and-epithets, caretaker-pattern, revocation-by-withdrawal, six-aspects-of-sharing, formula-persistence-thesis, cohort-destruction, four-tables-coordinated-retention, per-agent-keypair, local-node-sentinel, pass-invariant-handle-equality, sentinel-with-rationale), the daemon-security cluster, the capability-policy cluster (tofb + gbta), and the foundational-papers lineage cluster (via `dp/six-aspects-of-sharing-and-related-work`). Conventions section codifies five disciplines: *daemon-implements-the-invariant*, *structural confinement over policy*, *local agency authoritative*, *sentinels need rationale*, and the OCapN engagement constraints + the six-aspects checklist.
- **[designer-exo-captp-api](../../../library/roles/designer-exo-captp-api.md)** — Exo class design, interface guards, CapTP API surface. Anchors on the `exo` (40 sections) + `patterns` (29) + `eventual-send` (49) + `captp` (42) + `marshal` (49) + `pass-style` (41) topics. Cites 5 concept pages (producer-typed-shape-consumer-rendering, caretaker-pattern, dehydrate-hydrate, pass-invariant-handle-equality, delegates-and-epithets). Cluster overviews cover: the Exo class taxonomy (3 forms × heap/virtual/durable zones × make-vs-prepare), the CapTP wire model, marshal / pass-style, and interface guards (patterns). Conventions section codifies five disciplines: *producer typed-shape, consumer rendering*; *interface guards on every public method*; *pick the zone deliberately*; *pass-invariant equality*; *no `globalThis` mutation post-lockdown*.

## Landing structure observations from writing three

The shape from the proof-of-concept (When / Start here / Topics / Concepts / Cluster overviews / Conventions / Adjacent) survived all three landings with no structural changes. Two soft observations from writing the next two:

1. **Adjacent landings** is the most under-used section — both new landings cross-reference each other and `designer-protocol`. As more landings land, this section becomes the lateral navigation backbone.
2. **Cluster overviews** is where landings show their length variance. `designer-protocol` cited 3 clusters (daemon, OCapN, infra). `designer-security` cited 3 clusters (daemon-security, capability-policy, foundational-papers). `designer-exo-captp-api` cited 4 *sub-areas* of one cluster (Exo taxonomy, CapTP wire, marshal, interface guards) rather than 3 source clusters — which suggests the section is flexible enough to absorb both *grouped sources* and *grouped subtopics*.

No shape changes warranted yet.

## Library state

- Sources: 102 (unchanged).
- Sections: 457 (unchanged).
- Concepts: 19 (unchanged).
- Keywords: ~167 (unchanged).
- Topics: 26 (unchanged).
- **Roles: 1 → 3** — `designer-protocol`, `designer-security`, `designer-exo-captp-api`.

## Updated roles/README

The inventory section now distinguishes:

- **Dense-coverage seed landings** (the three landed) — exist as seeds against the densest existing topic clusters.
- **Pending thinner-coverage specialists** (`designer-frontend`, `designer-language`, `designer-ux`) — to be seeded as ingestion fills out the relevant topics, or as placeholder landings that grow with the corpus.

## Coordination protocol unchanged

The gardener missive
(`entries/2026/05/15/005759Z-message-liaison-c7c53c.md`) remains the
proposal for the role-multiplexing side of the work. Landings exist
*independent of* whether `roles/<specialist>/AGENT.md` exists yet —
the role files cite the landings on dispatch when they're created.
If the gardener picks a different shape or different names for the
specialists, the landings can be renamed / restructured to match;
the slugs `designer-protocol`, `designer-security`,
`designer-exo-captp-api` are chosen to match the missive's
recommendation but are not load-bearing.

## Notes for the next cycle

- **The three thin specialist landings** (`designer-frontend`,
  `designer-language`, `designer-ux`) wait on either gardener
  recognition or substantial ingest into chat-ui / language /
  accessibility material. None of those are imminent.
- **Builder landing?** The maintainer did not name a `builder`
  specialist split, but a single `builder.md` landing would be
  useful (anchoring on `tooling`, `bundles`, `agent-conventions`,
  the build / changeset / pre-PR skills). Worth considering as a
  cycle 56 task if landings keep accruing.
- **Jury-seat landings?** The 17 jury seats also benefit from
  landings — each seat has a specific kind of review work and the
  library has material relevant to several seats (e.g.
  `designer-security` content overlaps with what a `locksmith` or
  `warden` jury seat needs). Jury landings would need to be much
  shorter (jurors decide in minutes, not hours) and probably structured
  more like a *focused checklist* than a *curated index*. Worth a
  separate maintainer ask before producing them.
