---
source_kind: web
source_url: http://erights.org/elib/concurrency/index.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/index.html
source_fetched_via: mirror
source_content_sha256: a116bef33730f9b86bfd29814c1d63c49dc13ace30f0982198ad7460dea5fe57
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Event Loop Concurrency (ELib) — the reference-level concurrency hub the elang
  tutorial's See-Also points at. A navigation hub (chapter map, no prose body);
  one map section captures the child-chapter list and the vat/turn/eventual-send
  model. The first five child chapters were ingested as their own sources in
  scholar-ingest-erights-8 (Concurrency Overview / Why threads are evil; Event Loop
  Philosophy; Semi-Transparency; The Vat; Distributed Queuing). The mechanics
  chapters (Reference Mechanics, Message Passing, Vat Turns, Partial Ordering) and
  the two sub-hubs (the Four Layers of When, EIO) remain queued in
  scholar-ingest-erights-9. source_date is an era approximation matching the
  sibling concurrency chapters.
---

The **Event Loop Concurrency** chapter under ELib — the reference-level (not
tutorial-level) treatment of E's concurrency model and the fullest informal
statement of the vat / turn / pending-delivery-queue model that became
`@endo/eventual-send` and Agoric's vat model. This hub page is a child-chapter map
(no prose body); the single section captures that map (Why threads are evil, Event
Loop Philosophy, Semi-Transparency, The Vat, Distributed Queuing, Reference
Mechanics, Message Passing, Vat Turns, Partial Ordering, the Four Layers of When,
EIO) plus the E-to-Endo translation.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [event-loop-reference-map](../sections/erights--elib-concurrency-index--event-loop-reference-map.md) | eventual-send, e-language | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/index.html`.
- Content SHA-256 `a116bef33730f9b86bfd29814c1d63c49dc13ace30f0982198ad7460dea5fe57`, 9254 bytes.
