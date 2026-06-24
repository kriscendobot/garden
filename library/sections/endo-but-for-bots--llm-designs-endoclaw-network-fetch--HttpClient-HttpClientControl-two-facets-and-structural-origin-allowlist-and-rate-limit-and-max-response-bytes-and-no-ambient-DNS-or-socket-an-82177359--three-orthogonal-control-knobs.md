---
title: §Three orthogonal control knobs on the control facet
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

Lines 28-30:
- §**`setAllowedOrigins`** — data-exfiltration-defense.
- §**`setMaxRequestsPerMinute`** — DoS-against-allowed-origin-defense and §agent-spam-defense.
- §**`setMaxResponseBytes`** — large-file-DoS-defense + §the-agent-environment-resource-exhaustion-defense.

§Three-orthogonal-attack-classes-each-with-its-own-named-knob:

- §each-knob-addresses-one-attack-class — §the-knob-is-named-after-the-attack-it-defends-against (not "setRateLimit" or "setSizeLimit" but the specific knob).
- §**rate-limit-and-size-limit-as-named-discipline** at lines 53-55 → §named-host-knobs-for-DoS-defense; §the-substrate-names-the-knobs + §the-derivatives-can-extend-or-narrow-them; sibling pattern to cycle 234's setReadOnly + setScopes + setAllowedPaths (four-named-control-knobs).
- §the-substrate-establishes-three-named-knobs + §each-derivative-design-extends-with-its-own-knob (cycle 234 adds setScopes + setAllowedPaths + setReadOnly + refresh; cycle 259 adds setReadOnly + setAllowedOrigins + revoke); §first-explicit-observation of §each-endoclaw-design-extends-the-control-facet-with-its-own-specific-knobs.
