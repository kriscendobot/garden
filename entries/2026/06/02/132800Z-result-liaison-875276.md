---
host: endolin
role: liaison
dispatch_id: 875276
date: 2026-06-02
kind: result
---

# result(librarian, cycle 111): familiar-gateway-migration — gateway moved from Chat's Vite plugin into the daemon (1 section)

**Cycle**: 111 (pivoted from chat-lane (exhausted) continuing the familiar-design-lane pattern).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/familiar-gateway-migration.md` (127 lines), last touched 2026-02-26 by Kris Kowal (prompted).

## What

Ingested the **Complete** (*Implemented*) `familiar-gateway-migration` design — the first of cycle 109's three named dependencies for the Familiar Electron Shell. The 127-line design documents the gateway-from-Chat-into-daemon migration. Single-section cohesion-honest ingest.

### Section drafted

1. **Gateway moved from Chat's Vite plugin into daemon** (full file, lines 1-128) — single cohesive ingest. The §Status block enumerates five concrete shipped facts (`@apps` formula launches `web-server-node.js` as unconfined guest with @endo powers; gateway listens on `ENDO_ADDR` default `127.0.0.1:8920`; serves both HTTP weblet virtual hosts AND WebSocket CapTP sessions; `packages/chat/scripts/gateway-server.js` retained as standalone for Vite dev plugin; Familiar reads `ENDO_ADDR`). The §opening Problem frames the gap — the gateway was in Chat's Vite plugin, needing to move for production / Familiar. The §canonical rationale: *the gateway is the entry point for all browser-based CapTP connections. If it remains in Chat, then every application that wants to connect to the daemon from a browser must either depend on Chat or reimplement the gateway. The daemon should own this concern.* The §dual-purpose listener — WebSocket at `/` for CapTP + HTTP for weblet virtual hosts. The §`E(gatewayBootstrap).fetch(token)` capability handshake preserved. The §self-connect-via-internal-CapTP discipline (reuses `endoBootstrap.gateway()` via internal CapTP). The §CLI additions (`endo gateway` + `endo start --gateway-port`). The §Security: localhost-only restriction preserved; `fetch(token)` formula-identifier-derived unguessable token; *Moving the gateway into the daemon reduces the attack surface: one fewer process with access to the Unix socket*.

### Library state after this cycle

- **612 sections** (was 611) / **156 sources** (was 155) / **44 concepts** (unchanged).
- Topic page updated: `daemon.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~25 gateway-migration keywords (familiar gateway migration / @apps formula / ENDO_ADDR / dual-purpose listener / E(gatewayBootstrap).fetch(token) / self-connect-via-internal-CapTP / cross-cutting-service-belongs-in-substrate / attack-surface-reduction-with-named-metric / protocol-preservation-across-migration / named-upgrade-path-with-detected-fallback).

## Notes

- The §*daemon-must-own-this-concern* rationale is the canonical *cross-cutting-service-belongs-in-the-shared-substrate* discipline. If multiple consumers need a service, put it in the substrate they all already share. Reusable for any *cross-cutting-service-in-the-wrong-process* situation.
- The §*attack-surface-reduction with named metric* — *one fewer process with access to the Unix socket* — is a worked example of *security-improvement-with-quantified-claim*. The number is named explicitly; the improvement is not just qualitative. Reusable for any *consolidation-as-security-improvement* shape.
- The §*protocol-preservation-across-migration* invariant — *The WebSocket protocol is unchanged. Existing browser clients work without modification* — captures the *function-migration-with-API-stability* discipline. The hosting process moved; the wire protocol didn't.
- The §dual-purpose HTTP+WebSocket listener on one port is the canonical *multi-protocol-single-port* shape. WebSocket is defined as an HTTP upgrade; serving both on the same port is standard.
- The §`self-connect-via-internal-CapTP` discipline (gateway uses `endoBootstrap.gateway()` via internal CapTP rather than the Unix socket) is the *prefer-reusing-internal-capability-protocols-for-self-references* idiom.
- The §Status block's five-fact enumeration is the file-level implementation-tracking discipline applied more concretely than usual — each fact names a specific code path that a maintainer can verify.

## Familiar dependency triangle progress

Cycle 109's `familiar-electron-shell` named three required dependencies. Progress:

- **Cycle 111** `familiar-gateway-migration` (this ingest, Complete) — gateway in-daemon. ✓
- **Pending** `familiar-unified-weblet-server` (In Progress, 259 lines) — single-port weblet serving for the custom protocol handler.
- **Pending** `familiar-daemon-bundling` (Complete, 161 lines) — daemon bundled into a single artifact.

Future cycles can ingest the remaining two to complete the Familiar dependency triangle.

## Next

- Cycle 112 (papers-lane): the eight-cycle papers-lane block continues. Consider whether to pivot or attempt a fresh source.
- Cycle 113 (chat-lane → familiar-design-lane): the remaining cycle 109 dependencies — `familiar-daemon-bundling` (Complete; 161 lines) or `familiar-unified-weblet-server` (In Progress; 259 lines).
- Cycle 114 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/exo/src/exo-tools.js` (513 lines); `packages/patterns/src/keys/copyBag.js` (the bag-sibling to copySet.js — the cycle 110 ingest's brother file).

ScheduleWakeup 1500s for cycle 112.
