---
title: §Eleven-method Page — the largest use-facet yet in the cluster
source-slug: endo-but-for-bots--llm-designs-endoclaw-browser
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-browser.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-browser.md
total-lines: 93
ingest-cycle: 259
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage
---

§Eleven-method-Page is the largest use-facet of any endoclaw-cluster ingest:

| Cycle | Capability | Use-facet methods | Control-facet methods |
|---|---|---|---|
| 234 | OAuth | 4 | 6 |
| 238 | CLI HTTP | 3 | 7 |
| 244 | Timer (Interval) | 3 (+ 6 on derived Interval) | 6 |
| 246 | Webhook | 5 | 4 |
| 253 | Notify | 2 | 3 |
| 259 | Browser | 2 + 11 (derived Page) | 4 |

§Cycle-259-introduces-the-largest-use-facet-via-the-derived-Page. §When-the-substrate-is-the-DOM-and-the-DOM-has-many-relevant-operations, §the-use-facet-grows-to-match + §the-control-facet-stays-compact (still 4 methods).

§First-explicit-observation in library of §use-facet-size-correlates-with-substrate-API-size as named-design-axis.
