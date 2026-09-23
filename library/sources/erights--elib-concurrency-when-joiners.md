---
source_kind: web
source_url: http://erights.org/elib/concurrency/when/joiners.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/when/joiners.html
source_fetched_via: mirror
source_content_sha256: 73d5b78c479529f72b63692948c3ae7a608cafffd70d9591c84e4fa056b3d2c9
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Layer 4 child chapter of the Four Layers of When sub-hub
  (erights--elib-concurrency-when-index). The upstream page is an unwritten stub
  ("*** To be written"); one section records its place in the four-layer map
  (joining several resolutions at once, the asynchAnd-style join) and its Endo
  lineage (Promise.all and the eventual-send combinators). source_date is an era
  approximation matching the sibling concurrency chapters.
---

**Joining Multiple Resolutions** (Layer 4 of the Four Layers of When, the highest)
under ELib — the construct that waits on **several** eventual references at once and
reacts when all have settled (the `asynchAnd`-style join), composing the when-catch
shorthand (Layer 3) across a collection. It is the direct ancestor of JavaScript's
`Promise.all` (and the `allSettled` / `race` family) and of the eventual-send
combinators that fan out several sends and rejoin their answers, all without
blocking the vat. The upstream chapter is an unwritten stub; this source records the
layer's position and its Endo lineage.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [joining-multiple-resolutions](../sections/erights--elib-concurrency-when-joiners--joining-multiple-resolutions.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/when/joiners.html`.
- Content SHA-256 `73d5b78c479529f72b63692948c3ae7a608cafffd70d9591c84e4fa056b3d2c9`, 6531 bytes. The page is an unwritten stub ("\*\*\* To be written").
