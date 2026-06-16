---
title: §No ambient DNS or socket access — the named non-exposure discipline at substrate root
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

Lines 57-59 (one of the most structurally-interesting paragraphs in the file):

> **No ambient DNS or socket access.** The agent has no `net.connect` or `dns.resolve` — only the `fetch` method on its granted `HttpClient`. Protocols other than HTTP/HTTPS are not supported.

§The-named-non-exposure-discipline:

- §**three-named-non-exposures-on-the-network-substrate**: §no-`net.connect` + §no-`dns.resolve` + §no-protocols-other-than-HTTP/HTTPS; sibling pattern to cycle 259's three-named-non-exposures-on-Page-interface (cookies + localStorage + network requests).
- §**confinement-by-omission named at the substrate root**: §the-fetch-method-IS-the-only-network-API + §the-omission-IS-the-defense; §four-cycles-with-explicit-confinement-by-omission (234 + 238 + 259 + 261 substrate); §five-cycles when counting the substrate alongside its three derivatives.
- §**protocol-restriction as named-omission** — HTTPS-and-HTTP-only; §no-FTP-no-WebSocket-no-WebRTC; §the-substrate-IS-the-only-route-out + §the-route-IS-the-protocol-restriction.
- §**named-Node.js-API-non-exposures** — `net.connect` and `dns.resolve` are the §canonical-Node-network-primitives-the-agent-MUST-NOT-receive; §naming-the-thing-NOT-exposed makes the §threat-model-explicit; §first-explicit-observation in library of §named-platform-API-non-exposures-as-evidence-of-confinement-by-omission.
