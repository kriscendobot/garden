---
source_kind: web
source_url: http://erights.org/elang/guarding/async.html
source_effective_url: https://erights.github.io/erights-org-website/elang/guarding/async.html
source_fetched_via: mirror
source_content_sha256: 3ab057a0dfc208dc0ce48f76d7cb20f77a288a5c1a8b2af5f517073395583ce7
source_authors: [Mark S. Miller, Terry Stanley]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Guarding Asynchrony — the one extant child chapter of the elang Soft-Type-Checking
  guards hub. Upstream-flagged "Stale, needs rewrite". One section captures E's
  reference-state guards (:near, :pbc, :vow, :rcvr, :any) and the proposed
  static-checking lint ruleset (the near <= vow <= rcvr subtype lattice). The
  hub's other promised child chapter, "Guard Expression Style" (guarding/style.html),
  was never written (404 on both the mirror and the Internet Archive). source_date
  is an era approximation matching the sibling guarding/concurrency chapters.
---

The E tutorial's **Guarding Asynchrony** chapter: E's **reference-state guards**,
guard annotations expressing whether a reference supports immediate (synchronous)
calls or only eventual sends. `:near` (resolved-and-local), `:pbc` (a near
reference to a PassByConstruction object), `:vow`/`:vow[valueGuard]` (a
possibly-unresolved reference whose successful resolution must be near — the
eventual analog of `:near`), `:rcvr`/`:rcvr[valueGuard]` (may be eventual and may
resolve far, so eventual-send only), and `:any` (no constraint). The page also
sketches a lint-style static-checking advisor over the `near <= vow <= rcvr`
subtype lattice. The `:vow`/`:rcvr` guards were advisory-only (operationally
`:any`) at the time of writing, pending PassByCopy support; the intended
enforcement sends the value-guard to the specimen's host to preserve promise
pipelining. The E ancestor of Endo's near/far/promise distinction in
`@endo/eventual-send` and the coerce-or-reject guard model in `@endo/patterns` /
`M.interface`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [reference-state-guards-for-asynchrony](../sections/erights--elang-guarding-async--reference-state-guards-for-asynchrony.md) | e-language, eventual-send, pass-style | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/guarding/async.html`.
- Content SHA-256 `3ab057a0dfc208dc0ce48f76d7cb20f77a288a5c1a8b2af5f517073395583ce7`, 15126 bytes, last modified 1998-10-03.
