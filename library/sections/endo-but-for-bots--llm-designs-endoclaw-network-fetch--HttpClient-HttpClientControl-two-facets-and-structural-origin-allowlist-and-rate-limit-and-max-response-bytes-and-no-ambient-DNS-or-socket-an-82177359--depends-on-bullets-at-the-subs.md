---
title: §Depends On bullets at the substrate root
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

Lines 66-69:

> - Node.js `fetch` (available in Node 22+) or `undici` for HTTP
> - No other Endo designs required; standalone capability

§Two-bullet Depends-On pattern with §explicit-no-other-Endo-designs-marker — §the-substrate-IS-standalone; §the-substrate-has-no-Endo-substrate-of-its-own; §sibling-pattern to cycle 259's §`Optional:` prefix and cycle 255's conditional-per-option Depends-On variant.

§Four-cycles-with-Depends-On-bullet-list-variants (253 standalone + 255 conditional + 259 Optional-prefix + 261 standalone-with-explicit-no-Endo-designs-required-marker); §each-variant-encodes-a-different-substrate-relationship: §standalone (253, 261) + §conditional-per-implementation-option (255) + §Optional-defense-in-depth (259).

§**Node-22-as-the-LTS-floor for fetch** — §named-platform-LTS-floor-as-Depends-On-bullet; §sibling-pattern to library's existing node-lts-window-watch skill; §first-explicit-observation in library of §Node-LTS-version-floor-named-in-a-Depends-On-bullet-of-a-design-doc.

§**`undici` named as fallback for HTTP** — §two-implementation-paths-named-in-Depends-On (Node 22's built-in fetch OR undici); §two-cycles-with-named-alternative-implementation-paths-in-Depends-On (255 named alternative API providers + 261 named alternative HTTP libraries); §the-substrate-names-its-implementation-degrees-of-freedom.
