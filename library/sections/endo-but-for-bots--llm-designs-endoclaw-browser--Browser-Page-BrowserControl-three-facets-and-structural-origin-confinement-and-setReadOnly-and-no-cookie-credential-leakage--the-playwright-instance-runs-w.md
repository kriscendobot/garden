---
title: §The Playwright instance runs with `--no-sandbox` because already in a confined worker
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

§How-It-Works-step-5: *The backing Playwright instance runs in the daemon worker with `--no-sandbox` (already in a confined worker) or in a separate headless Chrome process.*

§`--no-sandbox`-with-named-justification: §the-Playwright-process-runs-inside-the-daemon-worker-which-is-already-confined + §running-Chrome's-sandbox-on-top-would-double-up + §the-confinement-is-at-the-worker-boundary-not-the-Chrome-process-boundary.

§First-explicit-observation in library of §running-without-platform-sandbox-when-substrate-IS-the-sandbox as named-defense-layering-discipline. §When-a-substrate-IS-the-sandbox, §don't-double-up-with-platform-level-sandbox + §the-substrate-IS-the-confinement-boundary.
