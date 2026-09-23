---
title: §Caretaker revocation propagates to derived caps
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

§The-Endo-Idiom: *The host can revoke the browser capability at any time, closing the Playwright context and invalidating all `Page` references.*

§Revocation-propagates-to-derived-caps. §When-the-Browser-is-revoked, §all-Page-references-derived-from-`Browser.goto()`-are-invalidated-too + §the-Playwright-context-IS-closed-at-revocation-time.

§First-explicit-observation in library of §revocation-propagates-to-derived-caps as named cleanup discipline. §When-a-use-facet-derives-further-capabilities-from-its-API, §revocation-of-the-use-facet-MUST-invalidate-the-derived-caps + §the-substrate-cleanup-IS-part-of-revocation.

§Five-cycles-with-revocation-as-named-permanent-state (238 + 244 + 246 + 253 + 259). §Cycle-259-adds-derived-cap-invalidation as a new dimension.
