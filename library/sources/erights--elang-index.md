---
source_kind: web
source_url: http://erights.org/elang/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/index.html
source_fetched_via: mirror
source_content_sha256: 77f5814bce5dbbd8b320205b9a6b706a9e15b321ef686ba33986ab3186d0d7fa
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Primary-source HTML fetched via the erights.org GitHub Pages mirror
  (erights.org refuses connections from the bot sandbox). The first
  erights.org HTML primary source in the library; prior E-language coverage
  came only from the Miller papers and the synthesized survey
  ocap-history--e-capdesk-polaris (same URL, reconstructed from secondary
  sources). Idempotency anchor is source_content_sha256.
---

The landing / navigation page for Mark Miller's documentation of **E**, the
capability-secure distributed programming language that is the direct ancestor of
Hardened JavaScript / Endo. The page is a doc-tree map rather than substantive
content: it organizes the E corpus into Introductory Material (tutorial, Walnut
book, quick reference), Language Specification (grammar, Block & Scope, Kernel-E,
Sameness), Primitive Data Types (scalars, collections, IO), Concurrency / Soft
Type Checking, and Historical / Tools. The single ingested section captures this
map plus E's self-description ("Cryptographic Capabilities for Distributed Smart
Contracting") and the E-to-Endo translation. The substantive subpages are
ingested separately as they are reached: *Sameness* is already in the library
(`erights--elang-same-ref`); the tutorial chapters and the grammar / Kernel-E
specification remain queued (see the `scholar-ingest-erights-2` follow-on).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/erights--elang-index--overview.md) | e-language, capability-security | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/index.html`.
- Content SHA-256 `77f5814bce5dbbd8b320205b9a6b706a9e15b321ef686ba33986ab3186d0d7fa`, 10724 bytes, last modified 1998-10-03.
