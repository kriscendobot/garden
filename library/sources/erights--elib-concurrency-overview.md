---
source_kind: web
source_url: http://erights.org/elib/concurrency/overview.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/overview.html
source_fetched_via: mirror
source_content_sha256: 0c1fea572c8fc22cc42b474a2b7fde80d205280fffc40615874c9447efb47be1
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Concurrency Overview ("Why threads are evil") — the motivating child chapter of
  the ELib Event Loop Concurrency hub (erights--elib-concurrency-index). One
  consolidated section. source_date is an era approximation matching the sibling
  concurrency chapters.
---

The **Concurrency Overview** chapter under ELib — the motivating essay for E's
event-loop model. It argues that conventional preemptive shared-state threads are
an unexamined disaster (correct programs must preserve consistency *and* avoid
deadlock, which almost no one can do with threads), and that the already-familiar
event-loop model is the better alternative, elevated in E with linguistic support
borrowed from the massively-concurrent ancestor languages while retaining a
sequential subsystem they lack. The rationale chapter behind `@endo/eventual-send`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [why-threads-are-evil](../sections/erights--elib-concurrency-overview--why-threads-are-evil.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/overview.html`.
- Content SHA-256 `0c1fea572c8fc22cc42b474a2b7fde80d205280fffc40615874c9447efb47be1`, 9501 bytes.
