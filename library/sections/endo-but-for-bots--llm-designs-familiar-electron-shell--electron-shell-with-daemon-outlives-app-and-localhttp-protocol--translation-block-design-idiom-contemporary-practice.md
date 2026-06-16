---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `developer-oriented workflow` vs `native desktop application` | The *expand-audience-via-packaging* discipline; package the developer-stack so non-developers can install. |
| `Mostly implemented` Status with file-level enumeration | The *design-doc-as-implementation-tracker* shape at file-granularity. |
| `Design deviations` documented at top | The *honest-departures-from-original-design* discipline; doc reflects reality. |
| `detached: true` + `daemon.unref()` | The *daemon-outlives-the-launcher* discipline; decouple process lifecycles. |
| `Matches CLI behavior` | The *consistent-with-existing-workflows* discipline; new UI adopts existing semantics. |
| `localhttp://<weblet-id>` per-weblet origin | The *origin-segregation-without-DNS* idiom; intercept-before-DNS. |
| `Electron's protocol.handle does not support WebSocket upgrade` | The *acknowledge-platform-limitation* discipline; design around it. |
| `Play well with existing daemons` 5-row scenario table | The *adaptive-behavior-matrix* shape; enumerate states + behaviors. |
| `E(bootstrap).ping()` for alive-and-compatible check | The *two-layer-compatibility-check* (process-existence + protocol-compatibility). |
| `localhttp:// as privileged scheme` | The *scheme-internal-to-app* discipline; external web shouldn't navigate to it. |
| `electron-updater` auto-update + daemon-side migration | The *layered-update-mechanism*; shell auto-updates, daemon handles persistence migration. |
