---
title: §Tier-1 borrowing (substrate-level patterns)
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

- §canonical-two-facet-pattern named at the substrate (HttpClient + HttpClientControl).
- §three-use-facet-methods + §five-control-facet-methods (the control-has-more-than-use discipline established here).
- §structural-origin-allowlist with §parse-first-act-second sequencing.
- §three-orthogonal-control-knobs each addressing one attack class.
- §no-ambient-DNS-or-socket-access as §named-platform-API-non-exposures.
- §confinement-by-omission at substrate root.
- §composable-with-OAuth subsection as the substrate naming its principal extension point.
- §help-method-IS-a-named-convention on both facets.
- §`allowedOrigins()`-as-introspection-on-the-use-facet.
