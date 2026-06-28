---
source_kind: web
source_url: http://erights.org/elang/guarding/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/guarding/index.html
source_fetched_via: mirror
source_content_sha256: 74a0c3241c12796e66013238ae027f6d5baaddb95ef2ab4559d57cc90acf2c2b
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  A thin navigation HUB for E's guard mechanism (Soft Type Checking). Captured as
  a single map section (no prose body of its own — only a child-chapter list). The
  child chapters (Guarding Asynchrony, Guard Expression Style) are queued in
  scholar-ingest-erights-3. E guards are the direct ancestor of Endo /
  @endo/patterns guards and M.interface method guards.
---

The **Soft Type Checking** hub — E's guards entry point. A **guard** is a
coerce-or-reject object applied at runtime on a definition pattern (`def x :Guard
:= expr`) or a method/function return; guards are first-class composable values.
This is *soft* (runtime, not static) type checking, the direct ancestor of Endo's
`@endo/patterns` guards and exo-class `M.interface(...)` method guards. The hub is
a reading map (Guarding Asynchrony, Guard Expression Style); the section captures
that map plus the one-paragraph guard model and the Endo lineage.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [soft-type-checking-map](../sections/erights--elang-guarding--soft-type-checking-map.md) | e-language, pass-style | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/guarding/index.html`.
- Content SHA-256 `74a0c3241c12796e66013238ae027f6d5baaddb95ef2ab4559d57cc90acf2c2b`, 6681 bytes, last modified 1998-10-03.
