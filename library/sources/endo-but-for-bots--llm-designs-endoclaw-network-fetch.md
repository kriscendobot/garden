---
title: "endoclaw-network-fetch.md — the foundational network-substrate of the endoclaw cluster"
source-slug: endo-but-for-bots--llm-designs-endoclaw-network-fetch
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-network-fetch.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-network-fetch.md
total-lines: 69
ingest-cycle: 261
ingest-date: 2026-06-10
lane: designs
---

# `endoclaw-network-fetch.md`

A 69-line **Not Started** design for the `HttpClient` capability — the §foundational-network-substrate that the endoclaw cluster's HTTP-touching derivatives (OAuth from cycle 234, Browser from cycle 259, proactive-messages from cycle 257) all build on. The library has been working "outside-in" through this cluster, knowing the derivatives before ingesting the substrate; cycle 261 closes that gap (a §reverse-ingestion-order).

## Key design moves

- **§Canonical two-facet pattern named here** — HttpClient (3 use methods: fetch + allowedOrigins + help) + HttpClientControl (5 control methods: setAllowedOrigins + setMaxRequestsPerMinute + setMaxResponseBytes + revoke + help). §the-control-facet-has-more-methods-than-the-use-facet established at the substrate.
- **§Three orthogonal control knobs** — setAllowedOrigins (data-exfiltration) + setMaxRequestsPerMinute (DoS) + setMaxResponseBytes (large-file DoS). Each knob addresses one named attack class.
- **§Structural origin allowlist** — *no wildcard or bypass — the exo parses the URL and checks the origin before making any network call*; §parse-first-act-second sequencing; §the-discipline-is-named-here-at-the-substrate-root.
- **§No ambient DNS or socket access** — *the agent has no `net.connect` or `dns.resolve` — only the `fetch` method on its granted `HttpClient`. Protocols other than HTTP/HTTPS are not supported*. §named-platform-API-non-exposures-as-evidence-of-confinement-by-omission.
- **§Composable with OAuth subsection** — the substrate names its principal derivative-extension-point by link; §the-substrate-design-names-the-derivative-design-by-link.
- **§`help()` on both facets** — the §help-method-IS-a-named-convention from the project's `@endo/exo` conventions (named in the CLAUDE.md `## Modules and exports` section).
- **§`allowedOrigins()` as introspection on the use-facet** — the agent can read its own confinement policy.
- **§No Use-Cases section at the substrate** — §the-substrate's-Use-Cases-omission-IS-the-signal-that-this-IS-the-substrate (because §the-substrate's-use-cases-ARE-its-derivatives).
- **§Endo-Idiom section names four patterns** — origin-allowlist + rate/size + no-ambient-DNS + composable-with-OAuth; §four-cycles-with-Endo-Idiom-section-as-recurring-design-doc-shape (232 + 246 + 257 + 261).
- **§Depends-On with explicit no-Endo-designs-required marker** — *No other Endo designs required; standalone capability*; §the-substrate-IS-standalone. §Node-22-as-the-LTS-floor for fetch + §undici-named-as-fallback.

## Section files

- [§HttpClient/HttpClientControl two facets + §structural-origin-allowlist + §rate-limit + §max-response-bytes + §no-ambient-DNS-or-socket + §substrate-for-OAuth](../sections/endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth.md) — full 69-line design ingest.

## Ingest scope

Cycle 261 (designs-lane after cycle 260's chat-lane). Full 69-line design ingested. **First-explicit-observations**: §reverse-ingestion-order-of-cluster-substrate + §the-help-method-IS-a-named-convention-of-`@endo/exo`-derived-capabilities + §a-named-introspection-method-on-the-use-facet + §each-endoclaw-design-extends-the-control-facet-with-its-own-specific-knobs + §named-platform-API-non-exposures-as-evidence-of-confinement-by-omission + §the-substrate-design-names-the-derivative-design-by-link + §Node-LTS-version-floor-named-in-Depends-On + §the-Use-Cases-omission-as-substrate-signal + §two-cycles-with-section-omission-as-design-kind-signal (257 + 261).
