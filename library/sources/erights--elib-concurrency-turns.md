---
source_kind: web
source_url: http://erights.org/elib/concurrency/turns.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/turns.html
source_fetched_via: mirror
source_content_sha256: 27ef8ef7ad81d3a24ce7839f92e06bde9f2804b87517e6bbed4e874497af6df7
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Vat Turns as Micro-Transactions — child chapter of the ELib Event Loop Concurrency
  hub (erights--elib-concurrency-index). One consolidated section: a turn runs to
  completion with mutually-exclusive access to its vat's state, so turns are atomic
  serializable micro-transactions and E preserves consistency under concurrency
  without locks; the chronological-encapsulation principle isolates separate plans
  into separate turns. The invariant `@endo/eventual-send` enforces (turn = JS
  microtask). source_date is an era approximation matching the sibling concurrency
  chapters.
---

**Vat Turns** chapter under ELib ("Game Turns as Micro-Transactions") — E's atomicity
properties without explicit locking. A turn is the synchronous processing of one
pending delivery; each turn runs with mutually exclusive access to its vat's state and
to completion before the next, so E execution is indistinguishable from a one-vat-at-a-
time universe: turns are atomic serializable micro-transactions, and E is strongly
consistency-preserving without fine-grained locking. The companion principle of
chronological encapsulation uses the eventual send to isolate conceptually separate
plans into separate atomic turns.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [turns-as-micro-transactions](../sections/erights--elib-concurrency-turns--turns-as-micro-transactions.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/turns.html`.
- Content SHA-256 `27ef8ef7ad81d3a24ce7839f92e06bde9f2804b87517e6bbed4e874497af6df7`, 14037 bytes.
