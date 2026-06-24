---
title: See also
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

- [[daemon]] (topic) — the endo daemon architecture; this design's host process and bundled daemon are central.
- `endo-but-for-bots--llm-designs-daemon-capability-bank--*` (cycle 105) — meta-framework for OS-level capabilities; the Familiar's bundled daemon hosts agents that use these.
- `endo-but-for-bots--llm-designs-daemon-agent-tools--*` (cycle 107) — Dir/Shell/Git capabilities for Claw-like AI agents; runs in the Familiar's daemon.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — agent tool invocations become commands; the Familiar provides the UI surface that displays them.
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — the reply-primitive that agent-tool results flow through.
- `endo-but-for-bots--llm-designs-familiar-gateway-migration` (named dependency, Complete) — gateway moved into the daemon process so the Familiar can connect to it.
- `endo-but-for-bots--llm-designs-familiar-unified-weblet-server` (named dependency, In Progress) — single-port weblet serving so the custom protocol handler can proxy.
- `endo-but-for-bots--llm-designs-familiar-daemon-bundling` (named dependency, Complete) — daemon bundled into a single artifact for Electron packaging.
- `endo-but-for-bots--llm-designs-familiar-localhttp-protocol` (sibling design) — the protocol handler's CSP injection and routing details.
