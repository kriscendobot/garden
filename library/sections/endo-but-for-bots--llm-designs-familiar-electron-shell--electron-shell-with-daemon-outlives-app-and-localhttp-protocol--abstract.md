---
title: Abstract
source: designs/familiar-electron-shell.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-02-26
source_authors: [Kris Kowal (prompted)]
source_lines: "1-268 (full file)"
topics: [daemon]
status: current
notes: |
  Twenty-sixth endo-but-for-bots design ingest. **Status: Complete**
  (*Mostly implemented*). The 267-line design defines the Familiar
  Electron Shell — the native desktop application that packages
  the Endo stack (daemon + Chat + Node.js runtime) for non-
  developer users. Three structurally interesting moves: (1) the
  *daemon outlives the Familiar* discipline — `detached: true` +
  `daemon.unref()` ensures the daemon process survives Familiar
  window close, matching CLI `endo start` behavior so a Familiar
  session is *just-another-client* of the persistent daemon;
  (2) the *localhttp:// custom protocol* — each weblet gets a
  unique origin `localhttp://<weblet-id>` with browser security
  isolation (separate cookie jars, localStorage, etc.) *without
  requiring DNS resolution of `*.localhost`*; (3) the *five-
  scenario play-well-with-existing-daemons table* — the Familiar
  must handle (no daemon / CLI-started / older version / Familiar-
  started / crashed) gracefully, using `E(bootstrap).ping()` as
  the alive-and-compatible probe.
  
  First familiar-* ingest in the library (cycle 105's daemon-
  capability-bank named related designs but didn't include
  familiar-*). Pairs structurally with the §three named
  dependencies (familiar-gateway-migration, familiar-unified-
  weblet-server, familiar-daemon-bundling) which together describe
  the Familiar's full architecture. Single-section cohesion-
  honest ingest.
  
  Cycle 109 pivoted from chat-lane (exhausted) to familiar-design-
  lane within endo-but-for-bots — diversifying from daemon-design-
  lane (cycles 101, 103, 105, 107) and SES-comments-lane (cycles
  106, 108).
parent: endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol
---

The §Status block (lines 10-38) names *Mostly implemented* and enumerates nine shipped modules: `packages/familiar/electron-main.js` (daemon lifecycle, window creation, menu, IPC handlers, localhttp:// protocol, navigation guard, exfiltration defenses); `packages/familiar/src/daemon-manager.js`; `gateway-manager.js`; `resource-paths.js`; `protocol-handler.js` (localhttp:// scheme + CSP injection); `navigation-guard.js`; `exfiltration-defense.js` (DNS poisoning, request interception, WebRTC, permission handler, runtime verification); `preload.js`; `forge.config.cjs`. The §Design deviations note three departures from the original design: *source modules live in `src/`* (not `resources/`); *Electron Forge* (not electron-builder); *Config is passed via URL fragment* (`#gateway=...&agent=...`, not query params or `window.ENDO_PORT`); and the §`proxy.js` module *was replaced by `src/protocol-handler.js` (for HTTP) and the MessagePort bridge design (for WebSocket, not yet implemented in Chat)*. The §opening Problem block (lines 40-56) frames the gap: *Endo currently requires users to install Node.js, clone the monorepo, and use the CLI to interact with the daemon. This is a developer-oriented workflow. The Familiar is an Electron application that packages the entire Endo stack — daemon, Chat UI, and Node.js runtime — into a native desktop application that non-developer users can install and run.* The §six Familiar requirements: (1) carry platform-specific Node.js + bundled daemon; (2) manage daemon lifecycle (start/restart/purge); (3) serve Chat as primary UI in Electron window; (4) proxy HTTP+WebSocket to daemon's unified server; (5) register `localhttp://` custom protocol for routing weblet traffic; (6) play well with already-running daemon. The §package structure (lines 60-76) shows the `packages/familiar/` layout. The §daemon lifecycle (lines 78-110) defines start (probe Unix socket; if running connect, if not spawn with `detached:true` + `unref()`); restart (connect + shutdown + spawn); purge (stop + delete state directory + optional restart, with confirmation dialog). The §key property: *the daemon outlives the Familiar* (lines 99-102). The §Electron main process (lines 112-121) sets up BrowserWindow + custom protocol handler + application menu + optional tray icon. The §`localhttp://` custom protocol handler (lines 123-153) uses Electron's `protocol.handle('localhttp', ...)` to parse `localhttp://<weblet-id>/path`, proxy to the daemon's unified server with a `Host: <weblet-id>.localhost` header, and return the response — *giving each weblet a unique origin with full browser security isolation without requiring DNS resolution of `*.localhost`*. The §WebSocket proxy (lines 155-168) — *Electron's `protocol.handle` does not support WebSocket upgrade* — runs a minimal local proxy that bridges `localhttp://<weblet-id>/` WebSocket to `ws://127.0.0.1:<gateway-port>/` with the appropriate Host header. The §Chat-as-primary-UI (lines 170-180) — no changes to Chat's connection logic; Familiar provides endoPort + endoId via query parameters or preload-injected globals. The §*Play well with existing daemons* table (lines 184-195) enumerates five scenarios with adaptive behavior. The §Electron packaging (lines 197-205) names electron-forge producing platform installers. The §three §Dependencies (lines 216-220): `familiar-gateway-migration` (gateway in-daemon), `familiar-unified-weblet-server` (single-port weblet serving), `familiar-daemon-bundling` (daemon bundled for Electron packaging). The §Security Considerations (lines 222-233) name the privileged-scheme discipline + per-weblet origin isolation + minimal preload-IPC + user-level daemon permissions + Purge confirmation. The §Scaling: ~200MB total distribution. The §Test Plan: smoke + lifecycle + protocol + restart + cross-platform. The §Compatibility: new package, CLI-daemon compatible via shared socket path + CapTP protocol. The §Upgrade: `electron-updater` auto-update + daemon-side migration with progress indicator.
