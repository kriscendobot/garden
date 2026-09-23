---
title: §Structural origin allowlist — the discipline named here at the substrate
source-slug: endo-but-for-bots--llm-designs-endoclaw-network-fetch
section-slug: HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-network-fetch.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endoclaw-network-fetch.md
source-author: Kris Kowal (prompted)
total-lines: 69
ingest-cycle: 261
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth
---

Lines 46-51 carry the canonical statement:

> **Origin allowlist is structural.** The agent cannot construct a URL that reaches an origin not in the allowlist. There is no wildcard or bypass — the exo parses the URL and checks the origin before making any network call.

§The-structural-confinement-discipline-IS-named-explicitly-here-at-the-substrate:

- §**structural-not-policy** — the rejection happens at the URL-parse step, not at a runtime policy hook; §no-wildcard-no-bypass; the helper does the parsing-and-checking itself.
- §**the-exo-parses-the-URL-and-checks-the-origin-before-making-any-network-call** — §parse-first-act-second; §canonical-sequencing-discipline.
- §**three-cycles-with-structural-confinement-discipline at the substrate root** (234 path-restrictions + 238 origin-allowlist + 259 origin-confinement + 261 = the **substrate** for all three derivatives); §four-cycles-with-structural-confinement-discipline counting cycle 261 itself; §first-explicit-observation that the *substrate* is also where the discipline is *named*.
