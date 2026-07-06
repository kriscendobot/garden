---
source: README.md
source_repo: gutentags/blick
source_commit: a8b700480d23d311171f87cca3ea5efcae8f3d7a
source_date: 2015-05-31
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

The README of Blick (`gutentags/blick`), Guten Tag's component animation controller. Blick sits over the low-level animation-frame handler and batches document reads and writes across a five-phase draw cycle (measure, transition, animate, draw, redraw), giving each component a reusable per-component controller so there is no frame-to-frame GC churn. It is typically shared across a Guten Tag scope by dependency injection (`scope.animator = new Blick()`). The document covers the controller overview and cooperative scenarios, the request/cancel API and per-phase semantics, and a three-level design rationale (perceptual throttling, avoiding forced reflow by coordinating reads apart from writes, and the CSS-transition two-frame problem).

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/blick--readme--overview.md) | animation-coordination, html-modules | current |
| [draw-cycle-phases](../sections/blick--readme--draw-cycle-phases.md) | animation-coordination | current |
| [design-rationale](../sections/blick--readme--design-rationale.md) | animation-coordination | current |
