---
source_kind: web
source_url: http://erights.org/elang/quick-ref.html
source_effective_url: https://erights.github.io/erights-org-website/elang/quick-ref.html
source_fetched_via: mirror
source_content_sha256: 4fa42ec7a75e5c4db869a18bedb9fbcfbb5dd84f7b2a3607b3309ae45f3cb6a4
source_authors: [Marc Stiegler, Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  The E Idioms Quick Reference Card (mostly by Marc Stiegler). Consolidated into a
  single grep-friendly section per conventions.md § Sectioning shapes (reference
  docs aggregate to 1-3 sections preserving H2 anchors inline). Idempotency anchor
  is source_content_sha256.
---

The **E Idioms Quick Reference Card** — a one-page cheat sheet of E's
frequently-used syntax: simple statements, expression-based control flow, object
makers and delegation, the four collection types (ConstList/ConstMap/FlexList/
FlexMap with `diverge()`/`snapshot()`), the Java-interface bridge, and the
eventual-send + remote-comm idioms (`<-`, `when (…) -> {…}`, `Ref.promise()`,
`introducer.sturdyToURI`) that became Endo's `E()` and OCapN. Explicitly omits
quasi-literals, regexes, pattern matching, parse trees, and Kernel-E.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [idioms-quick-reference](../sections/erights--elang-quick-ref--idioms-quick-reference.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/quick-ref.html`.
- Content SHA-256 `4fa42ec7a75e5c4db869a18bedb9fbcfbb5dd84f7b2a3607b3309ae45f3cb6a4`, 23491 bytes, last modified 1998-10-03.
