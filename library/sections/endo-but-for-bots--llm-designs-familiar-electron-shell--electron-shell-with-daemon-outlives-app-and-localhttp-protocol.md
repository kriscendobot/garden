---
title: The §Status block that documents *Mostly implemented* with a 9-file enumeration of shipped modules (electron-main.js + daemon-manager + gateway-manager + resource-paths + protocol-handler + navigation-guard + exfiltration-defense + preload.js + forge.config.cjs + scripts) and three §Design deviations (src/ not resources/; Electron Forge not electron-builder; URL fragment not query params); the §problem framing that names Endo's *developer-oriented* CLI workflow gap and the Familiar's role as the *native desktop application that non-developer users can install and run*; the §six Familiar requirements (carry platform-specific Node.js + bundled daemon / manage daemon lifecycle / serve Chat as primary UI / proxy HTTP+WebSocket to the daemon's unified server / register localhttp:// custom protocol / play well with already-running daemon); the §package structure with `electron-main.js`/`preload.js` plus `src/daemon-manager.js`/`protocol-handler.js`/`proxy.js` plus `resources/node-<platform>-<arch>`/`endo-daemon.cjs`/`endo-worker.cjs`; the §daemon lifecycle management — *probe the Unix socket* to detect running daemon; if running connect (no double-spawn); if not running spawn with `detached: true` + `daemon.unref()` so *the daemon outlives the Familiar* (matches CLI behavior); restart and *Purge (dangerous; deletes state directory)* exposed as menu actions; the §Electron main process setup (BrowserWindow loading Chat + custom protocol handler + application menu + optional tray icon); the §custom protocol handler `localhttp://` that gives each weblet a unique origin (`localhttp://<weblet-id>`) with *full browser security isolation* (separate cookie jars, localStorage, etc.) without requiring DNS resolution of `*.localhost`; the §WebSocket proxy fallback because *Electron's `protocol.handle` does not support WebSocket upgrade* — the Familiar runs a minimal local proxy to bridge `localhttp://<weblet-id>/` WebSocket to `ws://127.0.0.1:<gateway-port>/`; the §Chat-as-primary-UI without changes to Chat's connection logic — Familiar provides endoPort + endoId via query params or preload-injected globals; the §five-scenario *Play well with existing daemons* table (no daemon / CLI-started / older version / Familiar-started / crashed) with `E(bootstrap).ping()` as the alive-and-compatible probe; the §Electron packaging via electron-forge producing platform installers (.dmg signed .app for macOS; .AppImage or .deb for Linux; .exe NSIS or .msi for Windows); the §three named dependencies (`familiar-gateway-migration` + `familiar-unified-weblet-server` + `familiar-daemon-bundling`); the §Security/Scaling/Test/Compatibility/Upgrade considerations (localhttp:// as *privileged scheme* not navigable from arbitrary web content; ~200MB total distribution; smoke + lifecycle + protocol + restart + cross-platform tests; new package so no backward-compat; `electron-updater` auto-update + daemon-side migration handles persistence-format changes)
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol--abstract.md)
- [Body](endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol--common-confusions.md)
