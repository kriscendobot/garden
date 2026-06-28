---
source_kind: web
source_url: http://erights.org/elang/kernel/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/kernel/index.html
source_fetched_via: mirror
source_content_sha256: 2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 4
status: current
notes: >
  The Kernel-E reference chapter — the special-forms manual the E grammar chapter's
  expansions point at, and the highest-value remaining erights.org E-language page
  (~40 KB, ingested as its own cycle per scholar-ingest-erights-3). Captures the
  layered-specification framing, the full expression and pattern form catalogs (kept
  inline as pseudo-BNF for grep), and the meta-circular interpreter (name spaces,
  the four indirections, eval's outcome model, testMatch/mustMatch, object state-
  nouns). Grounds the `kernel-e` concept.
---

The **Kernel-E** reference chapter (the manual the E grammar chapter's canonical
expansions point at). E is specified in layers: at the bottom is Kernel-E, a small
lambda-calculus-like subset of E in which every program is also a valid E program
of the same meaning, and all of E's surface sugar is defined by canonical
expansion into it during parsing (the virtual machine executes only Kernel-E parse
nodes). The chapter specifies Kernel-E's semantics by exhibiting an executable
meta-circular interpreter (written in full E) that **reifies `eval`** while
**absorbing `apply`** (the `callExpr` / `sendExpr` constructs) and capability
security, staged so that upgrade and debugging can be layered on as enhanced
meta-interpreters without losing the base security. This is the same "small
trusted core, sugar by translation" discipline Hardened JavaScript reuses for the
SES intrinsics versus the surface language.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/erights--elang-kernel--overview.md) | e-language, capability-security | current |
| [expression-forms](../sections/erights--elang-kernel--expression-forms.md) | e-language, eventual-send | current |
| [pattern-forms-and-helpers](../sections/erights--elang-kernel--pattern-forms-and-helpers.md) | e-language | current |
| [meta-interpreter-semantics](../sections/erights--elang-kernel--meta-interpreter-semantics.md) | e-language, capability-security, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/kernel/index.html`.
- Content SHA-256 `2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4`, 40734 bytes, last modified 1998-10-03.
