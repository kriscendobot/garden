---
title: §Structural origin confinement
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

§The-Endo-Idiom: *The agent cannot navigate to `https://evil.example.com` to exfiltrate data because the `Browser` exo rejects URLs outside the allowed origins. This is structural — no URL the agent can construct will reach a disallowed origin.*

§Structural-origin-confinement as named discipline. §The-confinement-is-structural-not-policy — §the-Browser-exo-validates-every-URL-before-navigating + §rejection-is-not-best-effort-it-is-by-construction.

§Three-cycles-with-structural-confinement-discipline (234 path-restrictions + 238 origin-allowlist + 259 origin-confinement). §Each-cycle-applies-the-discipline-to-a-different-substrate: §cycle-234-OAuth-path-restrictions + §cycle-238-CLI-HTTP-origin-allowlist + §cycle-259-Browser-origin-confinement.

§Sibling-pattern-to-cycle-238's-the-allowlist-IS-the-strict-by-default-mode — §two-cycles-with-origin-allowlist-as-strict-by-default-substrate-policy (238 + 259).
