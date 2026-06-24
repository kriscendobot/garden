---
title: §Synthesis target — slot machine library
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

§The-foundational-network-substrate-pattern instantiated for game engine:

- §**§game-engine-credential-substrate** with two-facet shape (GameClient/GameClientControl).
- §Three-orthogonal-knobs at substrate root: §setAllowedGameOperations + §setMaxBetsPerMinute + §setMaxPayoutBytes; §each-knob-addresses-one-attack-class (cheating + DoS-against-game + payout-resource-exhaustion).
- §**No ambient game-network-access** — the agent has no §game.connect or §game.broadcast — only the §bet method on its granted §GameClient; §named-platform-API-non-exposures-as-evidence-of-confinement-by-omission for the §canonical-game-API-the-agent-MUST-NOT-receive.
- §**Composable with payment** — the substrate names its principal extension point (§PaymentClient-wraps-GameClient with credential injection and stake restrictions); §the-substrate-design-names-the-derivative-design-by-link.
- §**`help()` and `allowedGameOperations()`** — §the-help-method-IS-a-named-convention + §a-named-introspection-method-on-the-use-facet so the agent can read its own confinement policy.
- §**No Use-Cases section at the substrate** — §the-substrate's-Use-Cases-omission-IS-the-signal-that-this-IS-the-substrate.
- §**Endo-Idiom section** as the §pattern-catalog-for-derivative-designs-to-borrow.
