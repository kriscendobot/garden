---
title: §Three-problems-being-solved (numbered)
source-slug: endo-but-for-bots--llm-designs-familiar-localhttp-protocol
section-id: six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-localhttp-protocol.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-localhttp-protocol.md
total-lines: 636
status: Partially implemented (Familiar-side Ready; Chat-side Not Yet)
ingest-cycle: 220
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-localhttp-protocol--six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
---

The §What-is-the-Problem-Being-Solved section names §three-numbered-problems:

1. **Origin isolation.** §Every-weblet-needs-a-unique-origin so same-origin-policy + cookie jars + localStorage isolate weblets from each other and from Chat.
2. **Network confinement.** §Guest-page-cannot-send-HTTP-requests + open-WebSockets + trigger-DNS-lookups to external hosts.
3. **Navigation confinement.** §Hyperlinks-must-not-silently-navigate the Electron window away.

§Borrowable-pattern: §enumerate-the-distinct-attacker-capabilities-the-design-defends-against. §Different-from cycle 218's §three-named-properties (which named goals); §this-design-names-attacks. §Threat-modeling-as-design-driver.
