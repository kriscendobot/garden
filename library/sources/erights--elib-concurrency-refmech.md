---
source_kind: web
source_url: http://erights.org/elib/concurrency/refmech.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/refmech.html
source_fetched_via: mirror
source_content_sha256: e21219868359f16f811c7d20fd9a07e7df505eacee14b6378e905b934c0f25d6
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Reference Mechanics — child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). One consolidated section: the reference-kind
  taxonomy (horizontal Near/Eventual/Broken, vertical Promise/Resolved, Far =
  Resolved Eventual, LocalPromise/RemotePromise, SturdyRef), the diagram legend, and
  the PassByProxy/PassByCopy split. Ancestor of `@endo/eventual-send`'s
  present/promise/rejected/remote-presence kinds and marshal pass-style.
  source_date is an era approximation matching the sibling concurrency chapters.
---

**Reference Mechanics** chapter under ELib — "how do I designate thee? Let me count
the ways." It enumerates the kinds of live reference so message delivery and partial
failure can be reasoned about precisely, and orients the reader on how the
distinctions affect reference equality (a Settled reference supports `==` and may key
a hashtable). Two orthogonal axes: horizontal (Near / Eventual / Broken) and vertical
(Promise / Resolved); a Resolved Eventual reference is a Far reference; SturdyRefs are
the only references that survive a partition. This is the taxonomy `@endo/eventual-send`
collapsed into present / promise / rejected / remote presence, and the
PassByProxy-vs-PassByConstruction split marshal calls pass-style.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [reference-kinds-near-eventual-broken-promise-far-sturdyref](../sections/erights--elib-concurrency-refmech--reference-kinds-near-eventual-broken-promise-far-sturdyref.md) | e-language, eventual-send, pass-style, capability-security | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/refmech.html`.
- Content SHA-256 `e21219868359f16f811c7d20fd9a07e7df505eacee14b6378e905b934c0f25d6`, 19309 bytes.
