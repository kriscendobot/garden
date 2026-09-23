---
title: Common confusions
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

- **"`Mostly implemented` Status means the design is half-done."** It means *the design has shipped with a few documented design-deviations*. The §Status block enumerates nine shipped modules + three deviations. The implementation is *substantially complete*; the deviations are *honest documented variances* between original design and shipped code.
- **"`detached: true` would cause the daemon to become a zombie when the Familiar exits."** It would *not* — *detached* means *not in Familiar's process group*; the daemon becomes a session leader and won't receive SIGHUP when the Familiar exits. The daemon continues as a normal background process; the OS reaps it when it exits.
- **"The Familiar should kill the daemon when it closes — otherwise it leaks state."** This is *intentionally not the case*. The §daemon-outlives-the-Familiar discipline is *deliberate* — multiple Familiar sessions, CLI commands, and other clients should all see *the same daemon* across time. Killing the daemon on Familiar exit would break this invariant.
- **"`localhttp://` is just `http://localhost:port/` with a hostname rewrite."** It's *more* — Electron's custom protocol handler intercepts the request *before* it reaches the network. There's no actual TCP connection to `127.0.0.1:port`; the protocol handler is a pure-in-process bridge. This avoids DNS resolution, avoids port-binding, and lets the Familiar route the request via *any* mechanism (currently `fetch()` to the daemon's unified server).
- **"Per-weblet origins via `localhttp://` could leak across weblets if Electron's protocol handler is buggy."** It *could* in principle, but the §security model relies on Electron treating the protocol handler's responses as same-origin to the URL that produced them. The browser engine's same-origin enforcement is what produces the isolation; the protocol handler just provides the URL.
- **"The WebSocket proxy is unnecessary if weblets can connect directly to `ws://127.0.0.1:<port>/`."** It's necessary because *direct connect requires CORS configuration*. The proxy approach works without CORS — the WebSocket appears to the weblet as same-origin (it's `localhttp://<weblet-id>/`). The §design-deviations note says the actual implementation chose a *third* option (MessagePort bridge) that the doc didn't anticipate; the design captures the trade-offs but the implementation evolved.
- **"`E(bootstrap).ping()` is wasteful — why not just check the socket?"** Checking only the socket would falsely report *alive* for a stale socket from a crashed daemon. The two-layer check (socket + CapTP ping) ensures the daemon is *both running and protocol-compatible*. The cost is one extra round-trip at startup; the benefit is *not connecting to a broken daemon*.
- **"`Purge` deletes all data — that's destructive."** It is — and the §design names this explicitly: *the `Purge` action is destructive (deletes all state). It must require explicit user confirmation*. The menu action is gated by a confirmation dialog. Reusable for any *destructive-action-requires-explicit-confirmation* shape.
- **"The 200MB distribution is too large."** It is *typical* for Electron apps. The §Scaling section acknowledges this honestly: *Electron adds ~150MB to the distribution (Chromium + Node.js). The bundled Endo daemon + second Node.js adds another ~50MB. Total: ~200MB.* The trade-off is *user-installable-vs-disk-space*; the design accepts disk space to gain installability.
- **"The Familiar should use the user's installed Node.js, not a bundled one."** It cannot — *non-developer users may not have Node.js installed*. The §design requirement #1 names this: *carry a platform-specific Node.js executable*. Bundled Node.js is the trade-off that makes the Familiar self-contained.
- **"`MessagePort bridge` in the deviations note isn't documented anywhere."** The §design-deviations note names it as *not yet implemented in Chat*. The full MessagePort design is in a separate doc (or pending). The §design-doc-with-forward-pointers discipline lets the doc acknowledge incomplete work without losing track of it.
