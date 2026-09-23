---
title: "daemon-web-gateway — Single HTTP+WebSocket server multiplexing four roles for the Endo daemon"
source-slug: endo-but-for-bots--llm-designs-daemon-web-gateway
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-web-gateway.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-web-gateway.md
total-lines: 185
status: Complete (2026-03-11; Implemented; Design deviations: None significant)
ingest-cycle: 224
ingest-date: 2026-06-08
lane: designs
---

# daemon-web-gateway.md

A 185-line **Complete** design (2026-03-11). The single-HTTP+WebSocket server on `ENDO_ADDR` (default `127.0.0.1:8920`) that multiplexes four distinct roles. Solves the §browsers-cannot-open-UNIX-sockets problem for Chat, Familiar's renderer, and weblets.

## Key design moves

- **§Status-Complete-with-explicit-Design-deviations-None-significant** + named implementation files; §the-empty-deviation-marker-is-load-bearing.
- **§Single-server-four-roles architecture** (CapTP-bridge-for-Chat + Familiar-UNIX-socket-alternative + designated-port-weblet-hosting + virtual-host-weblet-hosting).
- **§GatewayBootstrap as narrow-interface** — single `fetch(agentId)` method.
- **§Bearer-token-as-formula-ID** — the 256-bit identifier doubles as the auth token; §the-identifier-IS-the-capability discipline (five cycles now: 200 + 210 + 211 + 220 + 224).
- **§Per-IP-rate-limiter with three-named-properties** — failed-attempts-penalized + successful-fetches-don't-affect-limit + stale-entries-removed-after-10-seconds.
- **§Two-modes-of-weblet-hosting** — designated-port (browser) + virtual-host (Familiar `localhttp://`).
- **§Caveat-emptor-disclosure** for the conventional-browser mode (no origin isolation between weblets).
- **§Three-mode-address-filtering** (Localhost-only default + Remote + CIDR-allowlist) with §unsafe-mode-logs-a-named-warning.
- **§IPv4-mapped-IPv6-normalization** as prerequisite for allowlist matching.
- **§Virtual-host-dispatch for both HTTP and WebSocket** — same `Host` header dispatch across protocols.
- **§Two-framings-for-the-same-CapTP-protocol** — WebSocket-binary-frame vs netstring; §isolate-the-framing-from-the-payload.
- **§makeWeblet registration API** — mode-dependent URL returned via `getLocation()`.
- **§Dependencies-table with Relationship-column** (vs bullet-list-with-named-reason from cycles 218/220/222).
- **§The-Prompt-section** capturing the original solicitation (sibling to cycle 198).

## Section files

- [§single-server-four-roles + §bearer-token-as-formula-ID + §per-IP-rate-limiter + §virtual-host-dispatch with caveat-emptor](../sections/endo-but-for-bots--llm-designs-daemon-web-gateway--single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor.md) — full design ingest.

## Ingest scope

Cycle 224 (designs-lane): full 185-line ingest. §Eighth-member of the Familiar cluster (174/176/182/184/208/218/220/224) now with three different status values (shipped + Not Started + Partially implemented + Complete).
