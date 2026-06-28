---
source_kind: web
source_url: http://erights.org/elang/grammar/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/index.html
source_fetched_via: mirror
source_content_sha256: ee71fa888d3243274321e5e7caf58661d8e041dd90f48419235073f04a79baae
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  The E grammar chapter landing page. Captures the two-layer specification method
  (E surface grammar defined by canonical expansion to a small Kernel-E core) and
  the per-construct child-page map. The per-construct grammar tables and the
  Kernel-E manual itself are queued in scholar-ingest-erights-3.
---

The **Grammar and Expansions** chapter: E is specified in two layers — the full
LALR(1) surface grammar, and a canonical **expansion** of every surface construct
into **Kernel-E**, a small lambda-calculus-like core suitable for automatic
program analysis. The expansion to Kernel-E *is* the precise meaning of each
surface construct (surface E is sugar; Kernel-E is semantics). This is the same
"small trusted core + sugar by translation" discipline Hardened JavaScript uses
for the SES intrinsics vs the surface language.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [grammar-and-kernel-e-expansion](../sections/erights--elang-grammar--grammar-and-kernel-e-expansion.md) | e-language | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/grammar/index.html`.
- Content SHA-256 `ee71fa888d3243274321e5e7caf58661d8e041dd90f48419235073f04a79baae`, 8818 bytes, last modified 1998-10-03.
