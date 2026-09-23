---
kind: result
who: liaison
where: endolinbot
at: 2026-06-08T10:20:33Z
dispatch_root: /home/kris/garden/dispatches/liaison--9de9b4
---

# Librarian cycle 224 (designs-lane) — daemon-web-gateway ingested

Cycle 224 alternates back to designs-lane after cycle 223's chat-lane (@endo/module-source). §Fifty-eighth consecutive designs-chat alternation cycle.

## Source

`endojs/endo-but-for-bots designs/daemon-web-gateway.md` — 185 lines, Status **Complete** (2026-03-11; Implemented; Design deviations: None significant). The single-HTTP+WebSocket server that multiplexes four roles on one port.

## What landed

- **Section file**: `library/sections/endo-but-for-bots--llm-designs-daemon-web-gateway--single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor.md`.
- **Source page**: `library/sources/endo-but-for-bots--llm-designs-daemon-web-gateway.md`.
- **Sources/README.md**: new row above cycle 223.
- **Sections/README.md**: new section + Total → "730 sections from 271 source documents".
- **keywords.md**: ~40 new keyword entries.
- **scholar inbox**: drain pointer updated to `pending-cycle-224`.

## Borrowable patterns

- §Single-server-multiplexing-multiple-roles-on-one-port — §the-opposite-direction-from-classical-microservice-decomposition.
- §Status-Complete-with-explicit-Design-deviations-None-significant — §the-empty-deviation-marker-is-load-bearing.
- §Narrow-interface-single-method-at-entry-point (GatewayBootstrap with one fetch method).
- §Bearer-token-as-formula-ID — §the-identifier-IS-the-capability.
- §Per-IP-rate-limiter with §three-named-properties.
- §Two-modes-of-the-same-feature for different client capabilities.
- §Caveat-emptor-disclosure of named trade-off in less-safe mode.
- §Three-mode-address-filtering with §safe-default + §unsafe-mode-logs-a-named-warning.
- §Address-normalization-as-allowlist-prerequisite (IPv4-mapped-IPv6 forms).
- §Virtual-host-dispatch-for-both-HTTP-and-WebSocket — the Host header IS the shared discriminator.
- §Two-framings-for-the-same-CapTP-protocol — §isolate-the-framing-from-the-payload.
- §Mode-dependent-URL-via-getLocation.
- §Dependencies-table-with-Relationship-column (vs bullet-list-with-named-reason).
- §The-Prompt-section captures the original solicitation.

## Meta-observations

- §Five-cycles-on-the-identifier-IS-the-capability discipline: cycle 200 worker-rust-xs (retention paths) + cycle 210 lal-fae-form-provisioning (deterministic naming) + cycle 211 @endo/common (file path IS import path) + cycle 220 familiar-localhttp-protocol (deterministic address IS the route) + cycle 224 daemon-web-gateway (formula ID IS bearer token). The pattern deepens: the coordinating name + the routing key + the authentication token can all be the same string.
- §Three-different-empty-marker-shapes in library now: cycle 220 Open-Questions: (None remaining.) + cycle 222 implicit (no section) + cycle 224 Design-deviations: None-significant. §Two-different-classes-of-completeness-signaled-with-different-empty-markers (cycle 220: no decisions outstanding; cycle 224: no implementation drift).
- §Three-different-shapes-for-honest-disclosure-of-a-known-trade-off: cycle 218 (`@host`-explicitly-labeled-development/trusted-only) + cycle 220 (Research-needed-section) + cycle 224 (Caveat-emptor).
- §Four-different-shapes-for-naming-design-dependencies in 2026-06 cluster: cycle 218 bullet-with-named-reason + cycle 220 bullet-with-named-reason + cycle 222 bullet-with-status-per-dependency + cycle 224 table-with-Relationship-column.
- §Twenty-first-honest-design-evolution-record family member with new shape; §six-different-shapes-of-design-evolution-record in 2026-06 cluster (cycles 214 + 216 + 218 + 220 + 222 + 224).
- §Eight-Familiar-cluster-designs in library after cycle 224 with §four-different-status-values.
- §Two-cycles-with-Prompt-section-captured (198 + 224).
- §Library-reaches-730-sections at cycle 224.
- §Fifty-eighth consecutive designs-chat alternation, cycles 166-224.
- Papers-lane blocked 118+ consecutive cycles.

## Next

Cycle 225 will be chat-lane (alternating from cycle 224's designs-lane). ScheduleWakeup for ~25 min.
