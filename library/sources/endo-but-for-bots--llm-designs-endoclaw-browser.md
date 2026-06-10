---
title: "endoclaw-browser — A Playwright-backed confined browsing capability with origin allowlist"
source-slug: endo-but-for-bots--llm-designs-endoclaw-browser
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-browser.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-browser.md
total-lines: 93
status: Not Started (2026-03-03)
ingest-cycle: 259
ingest-date: 2026-06-10
lane: designs
---

# endoclaw-browser.md

A 93-line **Not Started** design for a `Browser` capability backed by Playwright that gives an agent a confined browsing context with origin allowlist + read-only toggle. Parent: [endoclaw](endoclaw.md). Three-facet shape: Browser + Page (derived from `Browser.goto()`) + BrowserControl.

## Key design moves

- **§Three facets** — Browser + Page + BrowserControl; Page is derived from `Browser.goto()`.
- **§A derived capability from the use-facet** — first named instance.
- **§Structural origin confinement** — the Browser exo rejects URLs outside the allowed origins.
- **§setReadOnly with three named mutation methods disabled** (fill + click + submit) — third instance of this discipline.
- **§Caretaker revocation propagates to derived caps** — invalidates all Page references and closes the Playwright context.
- **§No cookie/credential leakage** — three named non-exposures on Page interface (cookies + localStorage + network requests).
- **§Confinement by omission** — the omission IS the defense.
- **§Use-facet size correlates with substrate-API size** — Page has 11 methods because DOM has many relevant ops.
- **§`Optional:` prefix on Depends-On bullet** — for defense-in-depth dependencies.
- **§Running without platform sandbox when substrate IS the sandbox** — `--no-sandbox` because already in confined worker.
- **§Two named return shapes via same method by context** — `snapshot()` returns text or screenshot.

## Section files

- [§Browser/Page/BrowserControl three facets + §structural-origin-confinement + §setReadOnly + §no-cookie-credential-leakage](../sections/endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage.md) — full 93-line design ingest.

## Ingest scope

Cycle 259 (designs-lane after cycle 258's chat-lane): full 93-line design ingest. §First-explicit-observation of six patterns: §a-derived-capability-from-the-use-facet + §revocation-propagates-to-derived-caps + §three-named-non-exposures-on-Page-interface (confinement-by-omission) + §use-facet-size-correlates-with-substrate-API-size + §`Optional:` prefix on Depends-On bullet + §running-without-platform-sandbox-when-substrate-IS-the-sandbox + §two-named-return-shapes-via-same-method-by-context.
