---
title: Body
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
