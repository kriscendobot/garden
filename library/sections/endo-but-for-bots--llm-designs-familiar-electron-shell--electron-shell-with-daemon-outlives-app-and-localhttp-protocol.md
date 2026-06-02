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
---

## Abstract

The §Status block (lines 10-38) names *Mostly implemented* and enumerates nine shipped modules: `packages/familiar/electron-main.js` (daemon lifecycle, window creation, menu, IPC handlers, localhttp:// protocol, navigation guard, exfiltration defenses); `packages/familiar/src/daemon-manager.js`; `gateway-manager.js`; `resource-paths.js`; `protocol-handler.js` (localhttp:// scheme + CSP injection); `navigation-guard.js`; `exfiltration-defense.js` (DNS poisoning, request interception, WebRTC, permission handler, runtime verification); `preload.js`; `forge.config.cjs`. The §Design deviations note three departures from the original design: *source modules live in `src/`* (not `resources/`); *Electron Forge* (not electron-builder); *Config is passed via URL fragment* (`#gateway=...&agent=...`, not query params or `window.ENDO_PORT`); and the §`proxy.js` module *was replaced by `src/protocol-handler.js` (for HTTP) and the MessagePort bridge design (for WebSocket, not yet implemented in Chat)*. The §opening Problem block (lines 40-56) frames the gap: *Endo currently requires users to install Node.js, clone the monorepo, and use the CLI to interact with the daemon. This is a developer-oriented workflow. The Familiar is an Electron application that packages the entire Endo stack — daemon, Chat UI, and Node.js runtime — into a native desktop application that non-developer users can install and run.* The §six Familiar requirements: (1) carry platform-specific Node.js + bundled daemon; (2) manage daemon lifecycle (start/restart/purge); (3) serve Chat as primary UI in Electron window; (4) proxy HTTP+WebSocket to daemon's unified server; (5) register `localhttp://` custom protocol for routing weblet traffic; (6) play well with already-running daemon. The §package structure (lines 60-76) shows the `packages/familiar/` layout. The §daemon lifecycle (lines 78-110) defines start (probe Unix socket; if running connect, if not spawn with `detached:true` + `unref()`); restart (connect + shutdown + spawn); purge (stop + delete state directory + optional restart, with confirmation dialog). The §key property: *the daemon outlives the Familiar* (lines 99-102). The §Electron main process (lines 112-121) sets up BrowserWindow + custom protocol handler + application menu + optional tray icon. The §`localhttp://` custom protocol handler (lines 123-153) uses Electron's `protocol.handle('localhttp', ...)` to parse `localhttp://<weblet-id>/path`, proxy to the daemon's unified server with a `Host: <weblet-id>.localhost` header, and return the response — *giving each weblet a unique origin with full browser security isolation without requiring DNS resolution of `*.localhost`*. The §WebSocket proxy (lines 155-168) — *Electron's `protocol.handle` does not support WebSocket upgrade* — runs a minimal local proxy that bridges `localhttp://<weblet-id>/` WebSocket to `ws://127.0.0.1:<gateway-port>/` with the appropriate Host header. The §Chat-as-primary-UI (lines 170-180) — no changes to Chat's connection logic; Familiar provides endoPort + endoId via query parameters or preload-injected globals. The §*Play well with existing daemons* table (lines 184-195) enumerates five scenarios with adaptive behavior. The §Electron packaging (lines 197-205) names electron-forge producing platform installers. The §three §Dependencies (lines 216-220): `familiar-gateway-migration` (gateway in-daemon), `familiar-unified-weblet-server` (single-port weblet serving), `familiar-daemon-bundling` (daemon bundled for Electron packaging). The §Security Considerations (lines 222-233) name the privileged-scheme discipline + per-weblet origin isolation + minimal preload-IPC + user-level daemon permissions + Purge confirmation. The §Scaling: ~200MB total distribution. The §Test Plan: smoke + lifecycle + protocol + restart + cross-platform. The §Compatibility: new package, CLI-daemon compatible via shared socket path + CapTP protocol. The §Upgrade: `electron-updater` auto-update + daemon-side migration with progress indicator.

## Body

### §The Status block — *Mostly implemented* with file-level enumeration

The §opening Status block (lines 10-38) is structurally distinctive — it enumerates *nine shipped modules* by filename with one-line descriptions of each. This is the §design-doc-as-implementation-tracker discipline (introduced in cycle 99's chat-reply-chain-visualization with Phases 1-5 ✅) applied at file-granularity:

- **`packages/familiar/electron-main.js`** — daemon lifecycle, window creation, menu, IPC handlers, localhttp:// protocol, navigation guard, exfiltration defenses.
- **`packages/familiar/src/daemon-manager.js`** — daemon start/restart/purge.
- **`packages/familiar/src/gateway-manager.js`** — gateway process management.
- **`packages/familiar/src/resource-paths.js`** — dev/packaged path resolution.
- **`packages/familiar/src/protocol-handler.js`** — `localhttp://` scheme and CSP injection.
- **`packages/familiar/src/navigation-guard.js`** — navigation interception.
- **`packages/familiar/src/exfiltration-defense.js`** — DNS poisoning, request interception, WebRTC, permission handler, runtime verification.
- **`packages/familiar/preload.js`** — IPC bridge with security warnings.
- **`packages/familiar/forge.config.cjs`** — Electron Forge packaging.
- **`packages/familiar/scripts/`** — build, bundle, download-node, packaging.

The §discipline: *every shipped module gets a line*. A maintainer or auditor reading the doc can immediately see *what code corresponds to which design responsibility*. The §file-level granularity makes the design verifiable — anyone can `ls packages/familiar/` and compare against this list.

The §three §Design deviations are *honest departures-from-original-design*:

> **Design deviations:**
>
> - The package structure diverges from the original design: source modules live in `src/` (not `resources/`), bundled artifacts go in `bundles/`, and Electron Forge (not electron-builder) handles packaging.
> - The `proxy.js` module described below was replaced by `src/protocol-handler.js` (for HTTP) and the MessagePort bridge design (for WebSocket, not yet implemented in Chat).
> - Config is passed via URL fragment (`#gateway=...&agent=...`), not query params or `window.ENDO_PORT`.

The §design-doc-with-deviations discipline: *the doc reflects reality, not initial intent*. The §post-implementation update keeps the design accurate; the deviations document *what changed during implementation and why*. A future maintainer can see both the original plan and the corrections.

### §The Familiar gap-naming and six requirements

The §opening Problem (lines 40-46):

> Endo currently requires users to install Node.js, clone the monorepo, and use the CLI to interact with the daemon. This is a developer-oriented workflow. The Familiar is an Electron application that packages the entire Endo stack — daemon, Chat UI, and Node.js runtime — into a native desktop application that non-developer users can install and run.

The §gap-naming: *Endo is currently developer-oriented*; the Familiar makes it *user-installable*. The §discipline names the audience expansion explicitly.

The §six requirements (lines 48-55) decompose the Familiar's job:

1. **Carry platform-specific Node.js + bundled daemon** — the Familiar ships its own Node.js + daemon so users don't need to install them.
2. **Manage daemon lifecycle** (start/restart/purge) — the daemon is a separate process from Electron.
3. **Serve Chat as primary UI** — the Electron window loads Chat.
4. **Proxy HTTP+WebSocket to daemon's unified server** — Electron renderer ↔ daemon traffic flows through the Familiar.
5. **Register `localhttp://` custom protocol** — for routing weblet traffic with per-weblet origin isolation.
6. **Play well with already-running daemon** — Familiar should not double-spawn if a daemon is already running.

The §six requirements are the *invariants the Familiar must satisfy*; the rest of the design describes *how each is met*.

### §The package structure

The §lines 60-76:

```
packages/familiar/
  package.json
  electron-main.js          # Electron main process
  preload.js                # Preload script for renderer security
  src/
    daemon-manager.js       # Daemon lifecycle management
    protocol-handler.js     # localhttp:// custom protocol
    proxy.js                # HTTP/WebSocket proxy to daemon
  resources/
    node-<platform>-<arch>  # Bundled Node.js (per-platform)
    endo-daemon.cjs         # Bundled daemon (from familiar-daemon-bundling)
    endo-worker.cjs         # Bundled worker entry point
  build/
    electron-builder.yml    # Electron packaging configuration
```

The §package-structure design names the layout the doc *anticipated*. The §Design deviations note above corrects this — actual layout has `src/` (matching), `bundles/` (replacing `resources/`), and Electron Forge config (replacing `electron-builder.yml`). The §design-vs-actual-divergence is documented at both ends — the deviation note at the Status block + the file-level enumeration matches actual shipped names.

### §The daemon-outlives-the-Familiar discipline

The §daemon lifecycle management (lines 80-102):

> **Start:**
> 1. Check if a daemon is already running by probing the Unix socket (`~/.local/state/endo/daemon.sock` or platform equivalent via `@endo/where`).
> 2. If a daemon is running, connect to it. Do not spawn a second daemon. The Familiar works with any compatible daemon, whether started by the CLI or a previous Familiar session.
> 3. If no daemon is running, spawn one using the bundled Node.js and daemon artifact:
>    ```js
>    const daemon = spawn(bundledNodePath, [bundledDaemonPath, sockPath, ...], {
>      detached: true,       // Survives Familiar exit
>      stdio: 'ignore',      // No console attachment
>    });
>    daemon.unref();         // Don't keep Familiar alive for the daemon
>    ```

The §key property:

> **Key property: the daemon outlives the Familiar.** Spawning with `detached: true` and `daemon.unref()` ensures the daemon continues running as a background process even if the Familiar window is closed. This matches the CLI behavior where `endo start` spawns a persistent daemon.

The §discipline operationalized:

- **`detached: true`** — the spawned process is *detached from the Familiar's process group*. Closing the Familiar doesn't send signals to the daemon.
- **`stdio: 'ignore'`** — no stdio pipes connect the Familiar to the daemon. Closing the Familiar doesn't close the daemon's stdin/stdout/stderr.
- **`daemon.unref()`** — Familiar's event loop doesn't wait for the daemon to exit. The Familiar can exit while the daemon keeps running.

The §design intent: *the Familiar is just another client of the daemon, not the daemon's container*. Multiple Familiar sessions can connect to the same daemon over its lifetime; the daemon's state persists across sessions; CLI commands continue to work alongside the Familiar.

The §matching-CLI-behavior observation is structurally significant — the Familiar doesn't introduce *new* daemon-lifecycle semantics; it adopts the existing CLI semantics for compatibility. Users running both CLI and Familiar see a *single shared daemon*.

### §The `localhttp://` custom protocol and per-weblet origin

The §custom protocol handler (lines 125-149):

```js
protocol.handle('localhttp', async (request) => {
  // Parse: localhttp://<weblet-id>/path
  const url = new URL(request.url);
  const webletId = url.hostname;
  const path = url.pathname + url.search;

  // Proxy to daemon's unified server with Host header
  const response = await fetch(`http://127.0.0.1:${gatewayPort}${path}`, {
    method: request.method,
    headers: {
      ...request.headers,
      Host: `${webletId}.localhost`,
    },
    body: request.body,
  });

  return new Response(response.body, {
    status: response.status,
    headers: response.headers,
  });
});
```

The §key benefit (lines 151-153):

> This gives each weblet a unique origin (`localhttp://<weblet-id>`) with full browser security isolation (separate cookie jars, localStorage, etc.) without requiring DNS resolution of `*.localhost`.

The §three-step request flow:

1. **Parse the `localhttp://` URL** to extract the weblet-id (hostname) and the path.
2. **Fetch from the daemon's unified server** with a `Host: <weblet-id>.localhost` header. The daemon dispatches to the named weblet based on the Host header.
3. **Return the response** — Electron treats it as an HTTP response from the `localhttp://<weblet-id>` origin.

The §origin-isolation property: each weblet's URL has a *distinct hostname* (`localhttp://weblet-a` vs `localhttp://weblet-b`). The browser's same-origin policy treats them as separate origins:

- **Cookies** — separate cookie jars; weblet-a can't read weblet-b's cookies.
- **localStorage / sessionStorage** — separate storage; no cross-weblet leakage.
- **CORS** — cross-weblet fetches are subject to CORS like cross-site fetches.
- **iframe boundaries** — weblet-a embedding weblet-b creates a cross-origin iframe.

The §without-DNS-resolution observation: the *naïve* approach to per-weblet origins would be to use `*.localhost` (e.g., `http://weblet-a.localhost:8080`) and rely on DNS resolution. But `*.localhost` is unreliable across operating systems and may require `/etc/hosts` entries. The `localhttp://` custom protocol *bypasses DNS entirely* — Electron's protocol handler intercepts the request before any DNS resolution happens.

The §discipline: *intercept-before-DNS for per-weblet origin without OS configuration*. Reusable for any *origin-segregation in a single host* shape.

### §The WebSocket proxy fallback

The §lines 155-168:

> Electron's `protocol.handle` does not support WebSocket upgrade. For weblet CapTP connections, the Familiar runs a minimal local proxy:
>
> 1. Weblets open a WebSocket to `localhttp://<weblet-id>/` which Electron intercepts.
> 2. The Familiar's main process opens a corresponding WebSocket to `ws://127.0.0.1:<gateway-port>/` with the appropriate `Host` header.
> 3. Messages are forwarded bidirectionally.
>
> Alternatively, weblets can connect directly to `ws://127.0.0.1:<gateway-port>/` with a `Host` header if the browser security model permits it from the `localhttp://` origin. This avoids the proxy but requires CORS configuration.

The §gap: *Electron's `protocol.handle` doesn't support WebSocket upgrade*. Electron's custom protocol handlers are HTTP-only; the WebSocket upgrade protocol isn't supported through them.

The §two solutions:

- **Local proxy** — Familiar's main process runs a WebSocket bridge: weblets connect to `localhttp://<weblet-id>/` (Electron intercepts the connect); Familiar opens a corresponding ws:// to the daemon's gateway; bidirectional forward.
- **Direct connect** — weblets connect to `ws://127.0.0.1:<gateway-port>/` directly with a Host header. Bypasses the proxy but requires CORS configuration to permit the cross-origin WebSocket.

The §design-deviations note above says the §`proxy.js` module *was replaced by `src/protocol-handler.js` (for HTTP) and the MessagePort bridge design (for WebSocket, not yet implemented in Chat)*. So the implementation took yet a third route: *MessagePort bridge* (not WebSocket proxy, not direct connect). This is the §design-evolves-after-shipping pattern — the doc captures the original options; the actual implementation picked a fourth option that the doc didn't anticipate.

### §The Play-well-with-existing-daemons scenario table

The §lines 186-194:

| Scenario | Behavior |
|---|---|
| No daemon running | Spawn bundled daemon |
| CLI-started daemon running | Connect to it (compatible) |
| Older daemon version running | Warn user, offer restart |
| Familiar-started daemon running | Connect to it |
| Daemon crashes while Familiar is open | Detect disconnect, offer restart |

The §five scenarios encode the *adaptive-behavior matrix* the Familiar must handle:

- **No daemon** — Familiar takes responsibility for starting one.
- **CLI-started daemon** — Familiar defers to the CLI's daemon; they share the same socket.
- **Older daemon version** — Familiar warns the user (version mismatch may cause issues) and offers to restart with the bundled daemon.
- **Familiar-started daemon** — Familiar reconnects to its previous daemon; the daemon survived the previous session.
- **Daemon crashes mid-session** — Familiar detects the disconnect (CapTP connection breaks) and offers user-initiated restart.

The §`E(bootstrap).ping()` probe (line 195):

> Detection: probe the Unix socket path. If a connection succeeds and `E(bootstrap).ping()` responds, the daemon is alive and compatible.

The §two-layer compatibility check:

1. **Socket connection succeeds** — daemon process is running.
2. **`E(bootstrap).ping()` responds** — daemon's CapTP protocol matches; the Familiar can speak to it.

The §discipline: *check both process-existence and protocol-compatibility*. A socket might be left behind from a crashed daemon; the ping ensures the daemon is actually responsive.

### §The three named dependencies

The §lines 216-220:

> - **familiar-gateway-migration** — gateway must be in the daemon for the Familiar to connect to it.
> - **familiar-unified-weblet-server** — weblets must be served through a single port for the custom protocol handler to proxy them.
> - **familiar-daemon-bundling** — daemon must be bundled for Electron packaging.

The §design-dependency-graph at the family-level. The Familiar Electron Shell *depends on* three sibling designs:

- **`familiar-gateway-migration`** (Complete per cycle 108's survey) — moves the gateway *into* the daemon process. Before this migration, the gateway was a separate process; the Familiar couldn't proxy to it from Electron's main process.
- **`familiar-unified-weblet-server`** (In Progress) — all weblets are served through a single port. The custom protocol handler proxies `localhttp://<weblet-id>` to *that single port* with a Host header; the daemon's unified server dispatches to the named weblet.
- **`familiar-daemon-bundling`** (Complete) — the daemon is bundled into a single artifact (`endo-daemon.cjs`) that the Familiar can ship.

The §design-graph reading: *this design sits on top of three precondition designs*. The §rendering is similar to cycle 107's daemon-agent-tools with its three §Revision-note successors — but here the three names are *predecessors* the design *depends on*, not successors that *refine*.

### §The Security Considerations

The §lines 224-233 name five security disciplines:

- **`localhttp://` as privileged scheme** — *Electron should not allow arbitrary web content to navigate to `localhttp://` URLs*. The protocol is internal to the Familiar; external web pages shouldn't be able to construct working `localhttp://` URLs.
- **Per-weblet origin** — *each weblet gets a unique origin via its `localhttp://<weblet-id>` URL, providing the same-origin isolation that separate ports provided before*. Browser security guarantees per-weblet boundaries.
- **Minimal preload-IPC** — *Chat should not have access to Node.js APIs directly*. The preload script exposes a curated bridge; arbitrary `require('fs')` from Chat is forbidden.
- **User-level daemon permissions** — *the daemon runs as the user's process with user-level permissions. No privilege escalation occurs*. The Familiar doesn't request admin/root.
- **Purge confirmation** — *the `Purge` action is destructive (deletes all state). It must require explicit user confirmation*. Two-step interaction prevents accidental data loss.

### §The Scaling/Test/Compatibility/Upgrade considerations

The §Scaling: ~200MB total distribution (Electron Chromium + Node.js ~150MB; bundled daemon + second Node.js ~50MB). Single-user; no multi-user concerns.

The §Test Plan: five test categories:
- Smoke (launch + Chat loads + connects).
- Lifecycle (no-daemon → spawn → close-Familiar → daemon-survives → reopen-Familiar → reconnect).
- Protocol (install-weblet + open-via-localhttp + render + CapTP connects).
- Restart (menu-trigger → daemon-stops-restarts → Chat-reconnects).
- Cross-platform (macOS + Linux build).

The §Compatibility: *new package, no backward-compat concerns*. The Familiar must be CLI-compatible (same socket path; same CapTP protocol).

The §Upgrade: *electron-updater auto-update*; *daemon's own migration logic handles persistence-format changes*; *Familiar displays migration progress indicator* during slow daemon-startup.

## Connection to the wider library

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

## Translation block (design idiom → contemporary practice)

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

## See also

- [[daemon]] (topic) — the endo daemon architecture; this design's host process and bundled daemon are central.
- `endo-but-for-bots--llm-designs-daemon-capability-bank--*` (cycle 105) — meta-framework for OS-level capabilities; the Familiar's bundled daemon hosts agents that use these.
- `endo-but-for-bots--llm-designs-daemon-agent-tools--*` (cycle 107) — Dir/Shell/Git capabilities for Claw-like AI agents; runs in the Familiar's daemon.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — agent tool invocations become commands; the Familiar provides the UI surface that displays them.
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — the reply-primitive that agent-tool results flow through.
- `endo-but-for-bots--llm-designs-familiar-gateway-migration` (named dependency, Complete) — gateway moved into the daemon process so the Familiar can connect to it.
- `endo-but-for-bots--llm-designs-familiar-unified-weblet-server` (named dependency, In Progress) — single-port weblet serving so the custom protocol handler can proxy.
- `endo-but-for-bots--llm-designs-familiar-daemon-bundling` (named dependency, Complete) — daemon bundled into a single artifact for Electron packaging.
- `endo-but-for-bots--llm-designs-familiar-localhttp-protocol` (sibling design) — the protocol handler's CSP injection and routing details.

## Common confusions

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
