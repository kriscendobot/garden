---
source_kind: web
source_url: http://erights.org/elib/concurrency/partial-order.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/partial-order.html
source_fetched_via: mirror
source_content_sha256: 340e9bbfb33e67b414b84d2ec1dc48f9bf422a8e5ef75df27d285a72702fd70a
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Partially-Ordered Message Delivery — child chapter of the ELib Event Loop
  Concurrency hub (erights--elib-concurrency-index). One consolidated section: the
  delivery-ordering spec the queuing chapter says the FIFO queue over-specifies —
  two-party single-reference = full order, three-party Granovetter (forked reference)
  = tree order, four-party grant-matching = partial order; topology is in the spec
  only. The "just enough distributed sequentiality" guarantee `@endo/eventual-send`
  and CapTP inherit. source_date is an era approximation matching the sibling
  concurrency chapters.
---

**Partial Ordering** chapter under ELib — "just enough distributed sequentiality."
Two parties on one reference get full order; three parties (the Granovetter case)
get tree order via reference forking; four-party grant-matching gets a genuine partial
order. The message topology is in the specification only, so an implementation may
collapse it to any consistent full order (Bill Frantz's "spec more expensive than the
implementation"). The spec is tightened for security so even a malicious vat cannot
deliver a message ahead of one already sent. This is the ordering discipline
`@endo/eventual-send` and CapTP preserve; the queuing chapter's FIFO picture is a
deliberate over-specification of it.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [partial-order-on-references](../sections/erights--elib-concurrency-partial-order--partial-order-on-references.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/partial-order.html`.
- Content SHA-256 `340e9bbfb33e67b414b84d2ec1dc48f9bf422a8e5ef75df27d285a72702fd70a`, 13155 bytes.
