---
source_kind: web
source_url: https://erights.org/elang/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/index.html
source_fetched_via: mirror
source_content_sha256: 77f5814bce5dbbd8b320205b9a6b706a9e15b321ef686ba33986ab3186d0d7fa
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  Primary erights.org E-language documentation index page. Fetched 2026-06-27
  from the erights.github.io GitHub Pages mirror via scripts/jobs/fetch-source.sh
  (`source_fetched_via=mirror`; erights.org refuses connections from the sandbox,
  so the mirror — which serves the original site paths verbatim — is the fetch
  substitute). Idempotency anchor is source_content_sha256, not a commit. This is
  Mark Miller's own table-of-contents for E's docs, materially distinct from the
  library's secondary-source market-history survey
  [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md); the two
  cross-reference each other.
---

The primary erights.org documentation index for **E**, Mark S. Miller's object-capability language for "Cryptographic Capabilities for Distributed Smart Contracting." A single navigational page (last modified 1998-10-03) that enumerates E's documentation tree: introductory material (E in a Walnut, the tutorial, the idioms quick-reference), the language specification (LALR(1) grammar expanding to Kernel-E, block/scope structure, Kernel-E special forms, Sameness as synchronous equality), primitive data types (scalars, collections, IO), the concurrency / soft-type-checking facilities, historical design notes, tooling (Updoc, Elmer, EBrowser), and the ENative project. The canonical primary artifact behind the library's E/CapDesk/Polaris survey, and the root of the vat / eventual-send / promise-pipelining lineage the Miller papers carry forward into Endo.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/erights--elang-index--overview.md) | capability-theory, capability-security | current |
