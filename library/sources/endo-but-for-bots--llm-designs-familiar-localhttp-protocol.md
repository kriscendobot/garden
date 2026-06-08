---
title: "familiar-localhttp-protocol — Six-layer defense-in-depth for in-Familiar weblet hosting via localhttp:// custom protocol"
source-slug: endo-but-for-bots--llm-designs-familiar-localhttp-protocol
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-localhttp-protocol.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-localhttp-protocol.md
total-lines: 636
status: Partially implemented (Familiar-side Ready in five named modules; Chat-side and Layer-6 Not Yet)
ingest-cycle: 220
ingest-date: 2026-06-08
lane: designs
---

# familiar-localhttp-protocol.md

A 636-line **Partially implemented** design defining the `localhttp://` custom protocol scheme that serves weblet content to iframe guests with §six-layer defense-in-depth. The §parent-with-ready-infrastructure that cycle 218 (familiar-chat-weblet-hosting) references via its §two-part-status.

## Key design moves

- **§Three-state-status** (Partially implemented + Not yet implemented + Design deviations from implementation) — §nineteenth honest-design-evolution-record family member with a new shape.
- **§Three-numbered-problems-being-solved** (origin isolation + network confinement + navigation confinement) — §threat-modeling-as-design-driver.
- **§Privileged-scheme-registration** with §four-named-privileges each documented with purpose.
- **§Content-Security-Policy** with §three-load-bearing-directives pulled out and explained (script-src 'unsafe-eval' / connect-src 'self' / form-action 'self').
- **§MessagePort-bridge** — §why-WebSocket-doesn't-work-from-localhttp with §two-named-reasons; §five-step bridge flow; §zero-copy-via-transfer-list (`[buffer]` transfer list).
- **§Six-layer-defense-in-depth** — each layer numbered + named + paired with the attack-class it blocks (CSP / request interception / DNS poisoning / navigation delegate / WebRTC disabled / iframe sandbox).
- **§Invalid-DoH-as-DNS-poisoning** — §intentionally-misconfigure-a-platform-API-to-deny-a-capability with §correctness-argument naming each traffic-pattern that still works.
- **§Belt-and-suspenders-flags** — three Chromium command-line flags as redundant DNS defense layered on top of the DoH misconfiguration.
- **§WebRTC-ICE-candidate-exfiltration** — §name-the-out-of-band-channel-that-bypasses-your-primary-defense.
- **§Runtime-verification** via §canary-DNS-resolution + §command-line-switch-presence-check; §the-test-that-it-fails-IS-the-verification.
- **§Non-blocking-yellow-banner** for security warnings — §detected-via-window.familiar-API (no banner in Vite dev mode).
- **§Research-needed-section** as honest-acknowledgment-of-incomplete-verification.
- **§Open-Questions: (None remaining.)** — §explicit-empty-section-as-completeness-signal.
- **§Implementation-status-per-affected-package** — the design doubles as a progress tracker.

## Section files

- [§six-layer-defense-in-depth + §invalid-DoH + §MessagePort-bridge + §runtime-verification + §non-blocking-banner](../sections/endo-but-for-bots--llm-designs-familiar-localhttp-protocol--six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner.md) — full 636-line design ingested as one section.

## Ingest scope

Cycle 220 (designs-lane): full ingest of the 636-line design as one section. §Seventh-member of the Familiar cluster (cycles 174 + 176 + 182 + 184 + 208 + 218 + 220). §Closes the cycle 218 parent-child design pair.
