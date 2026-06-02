---
source: designs/familiar-electron-shell.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-02-26
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-sixth endo-but-for-bots design ingest. **Status: Complete**
  (*Mostly implemented*). First familiar-* design ingest in the
  library — diversifies from the daemon-design-lane (cycles 101,
  103, 105, 107) and the SES-comments-lane (cycles 106, 108).
  
  The 267-line design defines the Familiar Electron Shell — the
  native desktop application that packages the Endo stack (daemon
  + Chat + Node.js runtime) for non-developer users. Three
  structurally interesting moves: (1) the *daemon outlives the
  Familiar* discipline — `detached: true` + `daemon.unref()` so
  the daemon process survives Familiar window close, matching
  CLI behavior so the Familiar is *just-another-client* of the
  persistent daemon; (2) the *localhttp:// custom protocol* —
  each weblet gets a unique origin `localhttp://<weblet-id>` with
  full browser security isolation (separate cookie jars,
  localStorage, etc.) *without requiring DNS resolution of
  `*.localhost`*; (3) the *five-scenario play-well-with-existing-
  daemons table* — the Familiar handles (no daemon / CLI-started
  / older version / Familiar-started / crashed) gracefully, using
  `E(bootstrap).ping()` as the alive-and-compatible probe.
  
  The §Status block enumerates *nine shipped modules* by filename
  + *three Design deviations* documenting honest departures from
  the original design. The design-doc-as-implementation-tracker
  discipline at file-granularity — every shipped module gets a
  line; deviations are documented at the top.
  
  Cycle 109 pivoted from chat-lane (exhausted) to familiar-design-
  lane within endo-but-for-bots. Single-section cohesion-honest
  ingest — the 267-line file is one unified Electron-shell design.
---

> Abstract: `designs/familiar-electron-shell.md` defines the
> Familiar Electron Shell — the native desktop application that
> packages the Endo stack (daemon + Chat UI + Node.js runtime)
> into an installer for non-developer users. The §opening Status
> block names *Mostly implemented* with file-level enumeration
> of nine shipped modules + three Design deviations (src/ not
> resources/; Electron Forge not electron-builder; URL fragment
> not query params). The §Problem framing names Endo's developer-
> oriented CLI workflow gap; the Familiar's six requirements
> (carry platform-Node + daemon / manage daemon lifecycle / serve
> Chat / proxy HTTP+WebSocket / register localhttp:// custom
> protocol / play well with already-running daemon). The §daemon
> lifecycle — probe Unix socket; if running connect; if not,
> spawn with `detached: true` + `daemon.unref()` so *the daemon
> outlives the Familiar* (matches CLI `endo start` behavior).
> The §`localhttp://` custom protocol gives each weblet a unique
> origin `localhttp://<weblet-id>` with full browser security
> isolation *without DNS resolution of `*.localhost`* — the
> intercept-before-DNS pattern. The §WebSocket proxy fallback
> because *Electron's `protocol.handle` does not support
> WebSocket upgrade*. The §five-scenario *Play well with existing
> daemons* table (no daemon / CLI-started / older version /
> Familiar-started / crashed) with `E(bootstrap).ping()` as the
> alive-and-compatible probe. The §three named dependencies —
> `familiar-gateway-migration` (gateway in-daemon),
> `familiar-unified-weblet-server` (single-port weblet serving),
> `familiar-daemon-bundling` (daemon bundled for Electron). The
> §Security Considerations name localhttp:// as privileged
> scheme + per-weblet origin isolation + minimal preload-IPC +
> user-level daemon permissions + Purge confirmation. The
> §Scaling: ~200MB total distribution. The §Test Plan + §Cross-
> platform builds (macOS / Linux / Windows). The §Upgrade:
> `electron-updater` auto-update + daemon-side migration handles
> persistence-format changes.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [electron-shell-with-daemon-outlives-app-and-localhttp-protocol](../sections/endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol.md) | daemon | current |

The 267-line file is honestly one cohesive argument-cluster — *one unified Electron-shell design* with Status (with file-level enumeration), Problem framing, ten-subsection Description, and Security/Scaling/Test/Compatibility/Upgrade considerations. Single-section ingest preserves the unified structure; forcing a multi-section split would create artificial divisions within a single design proposal.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-02-26 by Kris Kowal (*prompted* — LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 267 lines.
- **Twenty-sixth endo-but-for-bots design ingest, first familiar-* ingest in the library**. Pairs structurally with cycles 105 + 107 (daemon-capability-bank + daemon-agent-tools) to describe the *user-facing-AI-agent-stack*: capability framework + agent tools + desktop shell.
- Cycle 109 was scheduled for chat-lane (exhausted) and pivoted to familiar-design-lane to diversify from the daemon-design-lane cycles (101 / 103 / 105 / 107) and SES-comments-lane (106 / 108).
- Single-section cohesion-honest count. The 267-line file is *one unified Electron-shell design*. Forcing a multi-section split would create artificial divisions within a single design proposal.
- The §three named dependencies (`familiar-gateway-migration`, `familiar-unified-weblet-server`, `familiar-daemon-bundling`) are candidates for future ingests; cycle 108's survey identified `familiar-gateway-migration` as 127 lines / Complete and `familiar-daemon-bundling` as 161 lines / Complete.
