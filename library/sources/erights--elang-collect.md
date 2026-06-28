---
source_kind: web
source_url: http://erights.org/elang/collect/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/collect/index.html
source_fetched_via: mirror
source_content_sha256: 63352d3dba12d6ec7c40b0a01e31457744b1add626383fcc7971369bbf6b36ae
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Second of the three *Primitive Data Types* chapters ingested as one cycle by
  scholar-ingest-erights-4. The landing page of E's Collections chapter: the
  constant/flexible by list/map Tables two-by-two (ConstList/ConstMap/FlexList/
  FlexMap over EList/EMap), Coordinate Spaces, directory-as-collection, and the
  shared `for` loop. The per-type child chapters (String-ref, tables.html, coord/)
  remain navigable from the page and are not separately ingested.
---

The landing page of E's **Collections** chapter (the second Primitive-Data-Types
chapter). It organizes E's aggregate types around the **Tables**: a
constant-versus-flexible by list-versus-map two-by-two over the `EList` and `EMap`
interfaces — `ConstList` / `ConstMap` (immutable, selfless, pass-by-copy) and
`FlexList` / `FlexMap` (mutable, selfish), with `String` being a `ConstList` of
`char`. Beyond Tables it names Coordinate Spaces (symbolic geometry) and the open
category of objects that merely act like collections (a directory `File`-object is
a name-to-file map). The one operation E collections share is the `for` loop, in
its iterate-over-values and iterate-over-key-value-pairs forms. This is the
ancestor of the four-collection vocabulary on the E quick-reference card and,
downstream, of Endo's pass-by-copy aggregates (`CopyArray` / `CopyRecord`) versus
the mutable stores.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [collections-tables-spaces-and-the-for-loop](../sections/erights--elang-collect--collections-tables-spaces-and-the-for-loop.md) | e-language, pass-style | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/collect/index.html`.
- Content SHA-256 `63352d3dba12d6ec7c40b0a01e31457744b1add626383fcc7971369bbf6b36ae`, 9747 bytes, last modified 1998-10-03.
