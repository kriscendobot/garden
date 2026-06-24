---
title: §Borrowable patterns
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

**Tier-1 (highest borrowing value):**

- §Three-facets: Browser + Page + BrowserControl — a derived capability from the use-facet.
- §A-derived-capability-from-the-use-facet (`Browser.goto()` returns a `Page`).
- §Structural-origin-confinement — the Browser exo rejects URLs outside the allowed origins; structural not policy.
- §setReadOnly with three named mutation methods disabled — third instance of this discipline.
- §Caretaker-revocation propagates to derived caps — invalidates all Page references and closes the Playwright context.
- §No cookie/credential leakage — three named non-exposures on Page interface.
- §Confinement-by-omission — three cycles with this discipline (234 + 238 + 259).
- §Use-facet-size correlates with substrate-API-size (Page has 11 methods because DOM has many relevant ops).

**Tier-2 (design-doc shape patterns):**

- §Three-bullet Depends-On with Optional-prefix on third bullet.
- §`Optional:` prefix on Depends-On bullet as named dependency-shape.
- §Three-cycles-with-Depends-On-bullet-list-variants (253 standalone + 255 conditional-per-option + 259 with-Optional-prefix).
- §Two-named-return-shapes-via-same-method-by-context (`snapshot()` returns text or screenshot).

**Tier-3 (named comparisons):**

- §Three-cycles-with-setReadOnly-mode-toggle (226 + 234 + 259).
- §Three-cycles-with-structural-confinement-discipline (234 path + 238 origin + 259 origin).
- §Three-cycles-with-explicit-confinement-by-omission (234 + 238 + 259).
- §Three-cycles-with-Use-Cases-section-enumerating-named-use-cases (234 + 257 + 259).
- §Five-cycles-with-revocation-as-named-permanent-state (238 + 244 + 246 + 253 + 259).
- §Six-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246 + 253 + 259).
- §Seven-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257 + 259).
- §Running-without-platform-sandbox-when-substrate-IS-the-sandbox as named defense-layering discipline.
