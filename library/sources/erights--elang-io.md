---
source_kind: web
source_url: http://erights.org/elang/io/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/io/index.html
source_fetched_via: mirror
source_content_sha256: 03ec2863fc0a2fd82d98b96b2e1ea1e0ab3a36a7fbc41d3ddd3a8fdd811ee85e
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Third of the three *Primitive Data Types* chapters ingested as one cycle by
  scholar-ingest-erights-4. A thin hub page mapping to two child chapters (The URI
  Expression, Text File IO), captured as one map section. The library value is the
  conceptual point that E IO is capability-mediated (a granted `File`-object, not
  an ambient open-by-path) — the E-language root of Endo's no-ambient-authority
  IO. The child chapters (uri-exprs.html, text-file-io.html) remain navigable from
  the page and are queued only if a reader needs the file-capability / URI detail.
---

The landing page of E's **IO** chapter (the third and last Primitive-Data-Types
chapter, between Collections and Concurrency). The page itself is a two-entry map
to its child chapters — The URI Expression (`uri-exprs.html`) and Text File IO
(`text-file-io.html`). Its library value is conceptual: E's IO is
capability-mediated. A program reads or writes a file only by holding a granted
`File`-object (a directory `File`-object indexes by name to child `File`-objects,
the collection behavior the Collections chapter cross-references), and a URI
expression names an external resource as a capability rather than as an ambient
path lookup. This is the direct E-language ancestor of the no-ambient-authority
discipline Endo enforces by removing global IO primitives and injecting file /
network / clock access as objects through the powerbox or the daemon capability
bank.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [io-map-uri-and-text-file](../sections/erights--elang-io--io-map-uri-and-text-file.md) | e-language, capability-security | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/io/index.html`.
- Content SHA-256 `03ec2863fc0a2fd82d98b96b2e1ea1e0ab3a36a7fbc41d3ddd3a8fdd811ee85e`, 6784 bytes, last modified 1998-10-03.
