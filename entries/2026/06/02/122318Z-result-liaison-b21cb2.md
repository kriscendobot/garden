---
host: endolin
role: liaison
dispatch_id: b21cb2
date: 2026-06-02
kind: result
---

# result(librarian, cycle 109): familiar-electron-shell — Electron shell + daemon-outlives-app + localhttp:// custom protocol (1 section); **first familiar-* design ingest**

**Cycle**: 109 (pivoted from chat-lane (exhausted) to familiar-design-lane).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/familiar-electron-shell.md` (267 lines), last touched 2026-02-26 by Kris Kowal (prompted).

## What

Ingested the **Complete** (*Mostly implemented*) `familiar-electron-shell` design — the native desktop application that packages the Endo stack (daemon + Chat UI + Node.js runtime) for non-developer users. First familiar-* design ingest in the library, diversifying from the daemon-design-lane (cycles 101 / 103 / 105 / 107) and the SES-comments-lane (cycles 106 / 108).

### Section drafted

1. **Electron-shell-with-daemon-outlives-app-and-localhttp-protocol** (full file, lines 1-268) — single cohesive ingest. The §Status block enumerates *nine shipped modules by filename* + *three Design deviations* (src/ not resources/; Electron Forge not electron-builder; URL fragment not query params). The §opening Problem frames Endo's developer-oriented CLI workflow gap. The §six Familiar requirements (carry platform-Node + daemon / manage daemon lifecycle / serve Chat / proxy HTTP+WebSocket / register localhttp:// custom protocol / play well with already-running daemon). The §daemon lifecycle — probe Unix socket; if running connect; if not spawn with `detached: true` + `daemon.unref()` so *the daemon outlives the Familiar* (matches CLI `endo start` behavior). The §`localhttp://` custom protocol gives each weblet a unique origin with full browser security isolation *without requiring DNS resolution of `*.localhost`* (the intercept-before-DNS pattern). The §WebSocket proxy fallback because *Electron's `protocol.handle` does not support WebSocket upgrade*. The §five-scenario *Play well with existing daemons* table (no daemon / CLI-started / older version / Familiar-started / crashed) with `E(bootstrap).ping()` as the alive-and-compatible probe. The §three named dependencies — `familiar-gateway-migration` + `familiar-unified-weblet-server` + `familiar-daemon-bundling`. The §Security/Scaling/Test/Compatibility/Upgrade considerations.

### Library state after this cycle

- **610 sections** (was 609) / **154 sources** (was 153) / **44 concepts** (unchanged).
- Topic page updated: `daemon.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~37 familiar-electron-shell keywords (Familiar Electron Shell / native desktop app packaging Endo / daemon outlives the Familiar / detached:true daemon.unref / localhttp:// custom protocol / intercept-before-DNS / per-weblet unique origin / E(bootstrap).ping() two-layer compat check / nine shipped modules file-level enumeration / three Design deviations).

## Notes

- The §*daemon outlives the Familiar* discipline (via `detached: true` + `daemon.unref()`) is structurally important: the Familiar is *just-another-client* of the persistent daemon, not the daemon's container. This matches CLI `endo start` behavior so multiple Familiar sessions, CLI commands, and other clients all see *the same daemon* across time.
- The §`localhttp://` custom protocol is a clever solution to the *per-weblet-origin-without-DNS* problem. The naïve approach (`*.localhost` subdomain) requires OS-specific DNS configuration; the custom protocol bypasses DNS entirely by intercepting requests in Electron's protocol-handler before they hit the network. Each weblet's URL has a distinct hostname; browser same-origin policy gives separate cookie jars + localStorage per weblet.
- The §Status block's *file-level enumeration* + *Design deviations* footnote is the §design-doc-as-implementation-tracker discipline at its most concrete. Every shipped module gets a line; deviations are documented at the top. A future maintainer can verify the design against the actual `packages/familiar/` directory.
- The §five-scenario *Play well with existing daemons* table encodes the adaptive-behavior matrix. The §`E(bootstrap).ping()` two-layer compatibility check (socket-connection + CapTP-protocol-response) is the canonical *named-detection-with-version-check* pattern.
- The §three named dependencies (`familiar-gateway-migration` Complete / `familiar-unified-weblet-server` In Progress / `familiar-daemon-bundling` Complete) are precondition designs the Familiar requires. The §design-graph reading is *this design sits on top of three predecessors*; later cycles could ingest those for completeness.
- The implementation evolved beyond the design: the §Design deviations note that `proxy.js` *was replaced by `src/protocol-handler.js` (for HTTP) and the MessagePort bridge design (for WebSocket, not yet implemented in Chat)*. The §design-doc-with-forward-pointers discipline keeps the documentation honest about incomplete work.

## Next

- Cycle 110 (papers-lane): the persistent seven-cycle papers-lane block (97/100/102/104/106/108) continues to suggest structural infrastructure is missing for this lane. Pivot likely.
- Cycle 111 (chat-lane): chat-cluster exhausted. Continue with broader endo-but-for-bots designs. Candidates: daemon-form-request (Implemented; 435 lines — likely 2 sections); daemon-mount (In Progress; 718 lines — 3+ sections); daemon-capability-bus (In Progress; 526 lines — 2 sections); familiar-* candidates (familiar-gateway-migration / familiar-daemon-bundling / familiar-unified-weblet-server — the three named dependencies of this cycle's ingest); endopi-* (12 designs); ocapn-* (7 designs).
- Cycle 112 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/patterns/src/keys/copySet.js` (109 lines); `packages/exo/src/exo-tools.js` (513 lines — the file `exo-makers.js` imports `defendPrototype` from).

ScheduleWakeup 1500s for cycle 110.
