---
title: Connection to the wider library
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

This section is the **canonical *desktop-shell-as-client-of-daemon* worked example**. Four threads:

1. **The daemon-outlives-the-Familiar discipline** (`detached: true` + `unref()`) — reusable for any *separately-lifecycle-managed-process-launched-from-a-UI* shape. The UI is the client; the daemon is the persistent service; their lifecycles are decoupled.

2. **The `localhttp://` custom protocol for per-weblet origin** — reusable for any *origin-segregation-in-a-single-host* shape. Intercept-before-DNS via Electron's `protocol.handle`; per-tenant Host header forwarding to a unified backend; browser-security-guaranteed per-tenant isolation.

3. **The Play-well-with-existing-daemons five-scenario table** — reusable for any *adaptive-behavior-matrix* shape. Each row is a state the system must detect and handle. The §`E(bootstrap).ping()` two-layer compatibility check (socket + protocol) is the canonical *named-detection-with-version-check* pattern.

4. **The Status-block-with-file-level-enumeration + Design-deviations footnote** — extends cycle 99's chat-reply-chain Phases ✅ shape to file-granularity. The §design-doc-as-implementation-tracker discipline at its most concrete.

The §design-graph context (cycles ingested so far in the library):

- **Cycle 105** `daemon-capability-bank` — meta-framework for OS-level capabilities. The Familiar is a *consumer* of the capability framework via its bundled daemon.
- **Cycle 107** `daemon-agent-tools` — Dir/Shell/Git capabilities for Claw-like AI agents. The Familiar's bundled daemon hosts agents that use these capabilities.
- **Cycle 109** `familiar-electron-shell` (this ingest) — the desktop shell that hosts the daemon + Chat UI for non-developer users.

Together cycles 105+107+109 describe the *user-facing-AI-agent-stack*: capability framework + agent tools + desktop shell.
