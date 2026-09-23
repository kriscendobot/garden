---
title: §Structural-confinement
source-slug: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster
section-id: two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
total-lines: 439 (69 + 55 + 74 + 79 + 69 + 93)
status: Not Started (all six; created and updated 2026-03-03; Parent: endoclaw)
ingest-cycle: 226
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster--two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent
---

§The-load-bearing-discipline named in §every-cluster-design with a §Capability-Shape:

- **network-fetch**: §origin-allowlist-is-structural — *The agent cannot construct a URL that reaches an origin not in the allowlist. There is no wildcard or bypass — the exo parses the URL and checks the origin before making any network call*.
- **browser**: §structural-origin-confinement — *The agent cannot navigate to evil.example.com to exfiltrate data because the Browser exo rejects URLs outside the allowed origins. This is structural — no URL the agent can construct will reach a disallowed origin*.
- **webhooks**: §HMAC-verification — *The gateway verifies signatures before delivery, preventing spoofed events*.
- **notifications**: §rate-limiting-enforced-in-the-Notify-exo + §the-agent-cannot-discover-or-influence-the-control-facet.

§The-pattern: §the-confinement-is-checked-inside-the-exo-before-the-operation; §no-bypass-because-the-allowlist-is-enforced-at-the-only-call-site.

§Borrowable-pattern: §structural-confinement-via-allowlist-checked-inside-the-exo. §The-confinement-is-a-structural-property-of-the-capability + §not-a-policy-enforced-at-multiple-call-sites.

§Sibling to cycle 220 familiar-localhttp-protocol's §six-layer-defense-in-depth — but cycle-220 layers defenses; cycle-226 cluster says §one-defense-checked-at-the-only-call-site-is-enough. §Two-different-confinement-philosophies: §defense-in-depth-across-substrates (cycle 220) vs §a-single-narrow-API-where-the-check-can't-be-bypassed (cycle 226).
