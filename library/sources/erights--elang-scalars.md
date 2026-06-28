---
source_kind: web
source_url: http://erights.org/elang/scalars/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/scalars/index.html
source_fetched_via: mirror
source_content_sha256: fb0919915d6638c86e0e671d329e982d85f2f9b80b52d23266ec3bccebf2f86b
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  First of the three *Primitive Data Types* chapters (scalars, collections, IO)
  ingested as one cycle by scholar-ingest-erights-4. The landing page of E's
  Scalars chapter: the four scalar types plus null, their immutability, and their
  pass-by-copy-across-the-network property. The per-type child chapters
  (integer-ref, float64-ref, boolean-ref, char-ref) remain navigable from the page
  and are queued only if a reader needs per-type method detail.
---

The landing page of E's **Scalar Data Types** chapter (the first of the three
Primitive-Data-Types chapters: Scalars, Collections, IO). It names E's four
scalar types — `integer` (arbitrary-precision bignum), `float64` (IEEE double),
`boolean`, `char` — plus the special value `null`, states that all scalars are
immutable, and states that all scalars are pass-by-copy across the network (a
scalar argument to a cross-vat message arrives as a local copy). The page also
records the JVM-era Java class each scalar was implemented over, which is
historical implementation detail. This is the primitive floor of E's selfless /
pass-by-copy model and the ancestor of Endo marshal's primitive pass-styles.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [scalar-data-types](../sections/erights--elang-scalars--scalar-data-types.md) | e-language, pass-style | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/scalars/index.html`.
- Content SHA-256 `fb0919915d6638c86e0e671d329e982d85f2f9b80b52d23266ec3bccebf2f86b`, 8402 bytes, last modified 1998-10-03.
