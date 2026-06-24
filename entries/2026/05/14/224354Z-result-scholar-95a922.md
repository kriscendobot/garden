---
date: 2026-05-14T22:43:54Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--98a2fc
cycle: 51
---

# Scholar cycle 51: hardened-text-codecs-shim — sibling of hurl; new `permits-buckets` concept page; library crosses 100 sources

## Ingested

`endo-but-for-bots/llm/designs/hardened-text-codecs-shim.md` —
**Not Started** upstream, 194 lines, 2026-05-04. Sibling of
`hardened-url-shim.md` (split out per PR #84 review on the URL shim).
Author: Kris Kowal. Upstream commit
`6d2f3a03a0648edda82a0444898f1d1ff0c25806`. No prior source-index;
fresh ingestion.

Slug `htcs`. Picked to widen the corpus *off* the daemon cluster
after cycles 46–50 stacked nine daemon-cluster sources; this design
extends the hardened-javascript / compartments topics and provides
the second worked example of the permits-bucket framework.

## Section files (3)

- `htcs/problem-and-permits` — TextEncoder/TextDecoder placement on
  `universalPropertyNames` (simplest of the three buckets because the
  codecs have no ambient-authority statics and no exposed iterator
  prototype); permits table.
- `htcs/sampling-degradation-and-lockdown` — `sampleGlobals` handles
  absent permits, so XS degrades automatically with no new lockdown
  phase; the six standard SES-intrinsics test cases as a template for
  future taming PRs.
- `htcs/phases-tests-and-design-decisions` — three S-sized phases;
  three design decisions (universal-not-start, tame-inside-SES,
  no-polyfill); phase 3 names the *"prefer Uint8Array over Buffer"*
  SES-code migration convention.

## Concepts axis additions

One new concept page bridging hurl and htcs:

- **`permits-buckets`** — SES's three-bucket framework for
  vetted-shim placement: `universalPropertyNames` /
  `initialGlobalPropertyNames` / `sharedGlobalPropertyNames`. Aliases
  include the bare names and prose phrases (`vetted shim`,
  `powered vs powerless intrinsics`, `start compartment vs shared
  compartment`). Sections that touch it: 2 from htcs + 1 from hurl
  (the latter was previously the *only* source for this idea — the
  concept page now collects both worked examples in one place).

Plus ~15 new keyword entries pointing at `permits-buckets`,
including `TextEncoder` and `TextDecoder` as code symbols.

The concept page is **the first cycle-51 instance** of the *"two
sources, one concept"* shape — `permits-buckets` is the unit a reader
actually looks up; the two sections that touch it (hurl-shared-vs-start
and htcs-problem-and-permits) live in different sources but converge
here. This is exactly the case the concepts axis exists for: an agent
designing a third shim (CSS? Streams? Web Crypto?) can land on
`permits-buckets` and see how both prior designs handled the
placement.

## Topic refreshes (3 pages)

- `hardened-javascript.md` — 3 new rows (all 3 sections); 84 → 87.
- `compartments.md` — 3 new rows (all 3 sections); 22 → 25. **First
  endo-but-for-bots rows** on this topic page.
- `tooling.md` — 1 new row (phases-tests-and-design-decisions for the
  migration sweep convention); 59 → 60.

`topics/README.md` counts updated.

## Master indexes

- `sources/README.md` — 1 new row.
- `sections/README.md` — new "cycle 51" group added; total **448 →
  451**.
- `concepts/README.md` — 1 new row for `permits-buckets`.

## Consolidation / cross-reference work this cycle

The new concept page does double duty as the cycle's consolidation
work: it **collects two sources under one concept**, which is the
point of the concepts axis. The hurl-side section
(`hurl/integration-shared-vs-start`) was previously the only place
the three-bucket framework was explained; the concept page now
surfaces both that section and the htcs counterpart on one query.

The two `dcp` ↔ `dcpg` ↔ `dlt` cross-reference loops the prior
cycle started are unchanged this cycle; the daemon-cluster review
remains pending.

## Inbox state

Not advanced.

## Library state

- Sources: 99 → **100** (library crosses the round number).
- Sections: 448 → **451**.
- Topics: 25 (unchanged); 3 topic pages refreshed.
- Concepts: 17 → **18** (new: `permits-buckets`).
- Keywords: ~125 → ~140 (~15 new entries).

## Notes for the next cycle

- **`base64-native-fallthrough.md`** is the third "tame and dispatch
  to native intrinsics inside SES" design (htcs names it as a
  family-member); an obvious next pick that would round out the
  hardened-javascript shim cluster and likely add a third source to
  the `permits-buckets` concept page.
- **First writeback exercise** still pending — no designer / builder /
  juror has invoked `library-lookup` yet (this cycle was scholar
  ingest, which uses the normal writes-section-files pipeline, not
  the indexing-on-the-fly writeback discipline). The first
  library-lookup call from a downstream role will be the first
  exercise of the writeback procedure.
- **Cluster review for the daemon cluster** continues to be deferred;
  the cycle-50 result entry suggests it as cycle-52 or -53 work. With
  the corpus now 100 sources, the cluster review could productively
  walk *both* the daemon cluster (9 sources, 50+ sections) and the
  hardened-javascript shim cluster (hurl + htcs + future
  base64-native-fallthrough) at once.
