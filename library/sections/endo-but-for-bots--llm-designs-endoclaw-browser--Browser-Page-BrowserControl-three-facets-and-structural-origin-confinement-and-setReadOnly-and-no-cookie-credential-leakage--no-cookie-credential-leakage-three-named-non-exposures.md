---
title: §No cookie/credential leakage — three named non-exposures
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

§The-Endo-Idiom: *The `Page` interface does not expose cookies, localStorage, or network requests. The agent interacts with page content through DOM methods only.*

§Three-named-non-exposures (cookies + localStorage + network requests). §The-agent-interacts-with-page-content-through-DOM-methods-only.

§First-explicit-observation in library of §three-named-non-exposures-on-Page-interface as named confinement-by-omission. §When-a-browsing-capability-could-leak-credentials-via-Cookie-or-localStorage-or-Network-introspection, §omit-those-APIs-from-the-use-facet + §the-omission-IS-the-defense.

§Sibling-pattern-to-cycle-234's-the-agent-never-sees-the-token + cycle-238's-the-controller-and-client-cap-split — §three-cycles-with-explicit-confinement-by-omission (234 token-not-exposed + 238 controller-not-exposed-to-guest + 259 cookies-localStorage-network-not-exposed-to-agent).
