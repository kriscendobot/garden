---
title: §Cycle 261's structural moves
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

§First-explicit-observations from cycle 261:

1. **§reverse-ingestion-order-of-cluster-substrate** — the library has been working "outside-in" through this cluster, knowing the OAuth wrapper (234), the Browser sibling (259), and the proactive-messages composer (257) before ingesting the substrate they all build on.
2. **§the-help-method-IS-a-named-convention-of-`@endo/exo`-derived-capabilities-named-in-the-project-CLAUDE.md** — the substrate exposes `help()` on both facets per the convention.
3. **§a-named-introspection-method-on-the-use-facet** (`allowedOrigins()`) — the agent can read its own confinement policy.
4. **§each-endoclaw-design-extends-the-control-facet-with-its-own-specific-knobs** — substrate has three knobs (origins + rate + size); OAuth adds three more (scopes + allowedPaths + readOnly + refresh); Browser adds two more (allowed-origins-of-its-own + readOnly).
5. **§named-platform-API-non-exposures-as-evidence-of-confinement-by-omission** (`net.connect` and `dns.resolve` named as the canonical Node primitives the agent MUST NOT receive).
6. **§the-substrate-design-names-the-derivative-design-by-link** (§Composable-with-OAuth subsection links to endoclaw-oauth) — rather than the derivative naming the substrate.
7. **§Node-LTS-version-floor-named-in-a-Depends-On-bullet-of-a-design-doc** (Node 22+).
8. **§the-Use-Cases-omission-as-substrate-signal** — substrates omit Use-Cases because their use-cases ARE their derivatives.
9. **§two-cycles-with-section-omission-as-design-kind-signal** (257 + 261).
