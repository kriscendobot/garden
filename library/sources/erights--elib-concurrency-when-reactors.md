---
source_kind: web
source_url: http://erights.org/elib/concurrency/when/when-reactors.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/when/when-reactors.html
source_fetched_via: mirror
source_content_sha256: b39e64ddb55a2d08b3db8a3cb20875c0988283d216e654de4e01397c9d400766
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Layer 2 child chapter of the Four Layers of When sub-hub
  (erights--elib-concurrency-when-index). The upstream page is an unwritten stub
  ("*** To be written"); one section records its place in the four-layer map (the
  reactor objects that fire on the settlement Layer 1 exposes) and its Endo lineage.
  source_date is an era approximation matching the sibling concurrency chapters.
---

**The When\* Reactors** (Layer 2 of the Four Layers of When) under ELib — the
reactor objects (`whenResolved` / `whenBroken` family) that fire a reaction when an
eventual reference settles, built on Layer 1's reference-as-observable primitive.
The reactor fires in a later turn, never synchronously, so registering it never
blocks the vat. Layer 3's when-catch syntax is sugar over registering these
reactors. The upstream chapter is an unwritten stub; this source records the layer's
position and its lineage to the resolved-callback jobs a `HandledPromise` schedules.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [the-when-reactors](../sections/erights--elib-concurrency-when-reactors--the-when-reactors.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/when/when-reactors.html`.
- Content SHA-256 `b39e64ddb55a2d08b3db8a3cb20875c0988283d216e654de4e01397c9d400766`, 6714 bytes. The page is an unwritten stub ("\*\*\* To be written").
