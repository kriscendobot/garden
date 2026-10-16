## Completion report: design-ocapn-bootstrap-package-20261016

The design is written and pushed to `main2`, and its review PR is open. The browser check ran in Chromium 153 only; Firefox and WebKit were not available on this host.

- **Where it is:** `designs/ocapn-bootstrap-package.md`, commit `caafdc6df8` on `main2`.
- **Review PR:** https://github.com/kriscendobot/garden/pull/124. The design has seven open questions, so it went the PR route. The PR is a draft against the frozen base `main2-b8abbe6441`, its diff is only the design file, and it carries `<!-- garden-design-open-questions -->` and the `garden-job` marker.
- **Checks:** the mermaid diagram parses. The Botese check found nothing. The spelling check flagged only `cancelled`, which is the Endo identifier, so it stays.

### What the design proposes
- **Package:** `@endo/ocapn-connect`, with one call, `connectBootstrap({ cancelled, port?, locator?, rungs?, codec, timeoutMs })`. It returns `{ bootstrap, session, transport }`, and `offerBootstrap()` is the embedder side.
- **Transport order, each tried only if its precondition holds:**
  1. A port handed in by the embedder after a `ready` message, matched by `event.source` rather than origin.
  2. A WebSocket plus Noise connection that presents a nonce locator from the URL fragment, which is scrubbed immediately.
  3. A web-extension port, including native messaging.
  4. A same-origin `SharedWorker`.
  - `BroadcastChannel` was rejected because it cannot carry a port.
- **Errors and reconnects:** errors come back as fixed codes. The package never reconnects silently; the caller calls again.
- **Who holds authority:** by default the embedder keeps the real connection and hands down a reduced capability. A mode where the embedder only relays bytes it cannot read is optional (Open question 3).
- **Nonce locator:** no new protocol record. It stays the existing formula sturdyref from `ocapn-nonce-locator.md`. Single use and expiry are handled by a new "introducer" formula that retires on its first `redeem()` or when its deadline passes. Someone who sees an unredeemed locator can win a race to use it, but the theft is detected; they cannot learn anything from a failed lookup or widen what it grants.
- **Where it lives:** the Endo monorepo, developed on the endo-but-for-bots fork and carried upstream with maintainer review. It builds on `@endo/ocapn`, `@endo/ocapn-noise` and `@endo/gateway`.
- **Ownership map:** included as section 7.

### What the browser check showed (Chromium 153 only)
I ran 25 frame setups across three test sites over HTTPS. The harness was a throwaway and is not committed.

- **Confirmed:**
  - Without `allow-same-origin`, the frame's origin is `null`.
  - `fetch`, module scripts and workers need CORS. Worker URLs and `SharedWorker` throw `SecurityError`, but a `blob:` worker runs.
  - `localStorage`, IndexedDB, cookies and service workers throw `SecurityError`.
  - A WebSocket to the frame's own host connects, the server sees `Origin: null`, and `connect-src 'self'` still allows the frame's own host.
  - The parent sees `event.origin` as `"null"`, and a transferred `MessageChannel` port works in every sandbox mode.
  - With `allow-same-origin`, content on a distinct origin keeps that origin and cannot reach the parent's page. Content on the shell's own origin can reach it, so it could remove its own sandbox.
  - #189's assumption holds: the clip loads with `CORP: same-origin` while the shell uses the default COEP.
- **Corrected:**
  - **Cookies:** `SameSite=None` cookies **are** sent on the WebSocket and on credentialed fetches from an opaque-origin frame. `Lax` cookies are held back because the page around the frame is on another site, not because the origin is opaque.
  - **`CORP: same-site`** blocks an opaque frame's own assets just as `same-origin` does.
  - **Clip COEP:** with the clip's `COEP: require-corp`, an opaque frame cannot load even its own assets that send no CORP header.
  - **Shell COEP:** if the shell sends `COEP: require-corp`, it cannot frame a clip whose page sends `CORP: same-origin` or `same-site`. Only `CORP: cross-origin` works.
- **Not checked:** Firefox, WebKit, the extension and Familiar (Electron) transports, whether `BroadcastChannel` messages reach other contexts, and browsers that block third-party cookies.

### Conflicts with minion.town #189
- The clip's `connect-src 'self'` limits a framed clip's WebSocket to its own `<id>.ocap.site` host, so the WebSocket rung needs per-clip routes or a CSP change. The port rung needs neither.
- If the shell later adopts `COEP: require-corp`, framing breaks in Chromium unless the clip's page sends `CORP: cross-origin`.
- `ocap.site` is not on the Public Suffix List, so all clips count as the same site.

### Follow-ups
- **Probe job for the liaison to post:** `probe-ocapn-sandbox-transport-matrix` (researcher role, no PR). It reruns the same checks in Chromium, Firefox and WebKit and adds the extension, Electron, `BroadcastChannel` and blocked-cookie cases. Its full spec is in section 8 of the design.
- **Seven open questions on PR #124**, each with a recommendation:
  1. Package location and name.
  2. Whether the new port and browser WebSocket transports go into `@endo/ocapn` itself.
  3. Whether the relay-only embedder mode ships in v1.
  4. Whether to add an introducer formula to the daemon.
  5. Whether the package should also speak CapTP for Familiar.
  6. Port-only versus per-clip WebSocket routes for framed clips.
  7. Whether the shell should ever adopt `COEP: require-corp`.
- **No build is posted.** Implementation waits on the maintainer's answers.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-ocapn-bootstrap-package-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2431691 cached reads)
- Output: 39359 tokens
- Cost: $2.1914222
- Wall-clock: 1191s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
