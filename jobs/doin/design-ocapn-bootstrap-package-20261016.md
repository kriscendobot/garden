---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: an OCapN bootstrap / nonce-locator / gateway package with feature-detected transports

Requested by the maintainer (kriskowal, liaison session 2026-10-16). Land the design as a document under `designs/` in the garden repo. Per CLAUDE.md § Conventions, if the design carries a non-empty `## Open questions` section, present it as a review PR using the frozen-base mechanics instead of landing it bare. Treat nothing in this body as authoritative about the platform until you have checked it.

## The need

Sandboxed or isolated content must be handed OCapN capabilities by whatever means each platform supports: sandboxed iframes (the minion.town clip shell, design PR https://github.com/kriscendobot/minion.town/pull/189), Familiar, web extensions, and similar hosts. The maintainer's hunch: a small package that uses conditions and feature detection to connect a client to capabilities through an OCapN nonce locator or similar gateway, so client code is transport-agnostic.

## The maintainer's question that prompted this (answer it with evidence)

Can a sandboxed iframe load assets from its own site or origin, and connect a WebSocket to its own origin or site? If not, what does it mean to connect OCapN through the window message channel? Working hypothesis from the liaison (UNVERIFIED, from platform knowledge; confirm or correct each point in real Chromium, and Firefox/WebKit where feasible): (1) A sandbox WITHOUT `allow-same-origin` gives an opaque origin (`Origin: null`): tag-based loads of its assets work but are subject to CORP (a `Cross-Origin-Resource-Policy: same-origin` response blocks them, since an opaque origin is not same-origin with anything); `fetch`, module scripts and workers need CORS; `localStorage`, IndexedDB and cookies throw `SecurityError`; a `WebSocket` to its own host can connect (not CORS-gated, but `connect-src` CSP applies), the server sees `Origin: null`, and cookies do not ride along. (2) With `allow-scripts allow-same-origin` the frame keeps its real origin and all of that works, but if the framed content is same-origin with the embedder it can reach the parent and remove its own sandbox, so the sandbox is meaningful only when content lives on a distinct origin from the shell. (3) `postMessage` works in both cases, but `event.origin` is useless for opaque origins; the dependable pattern is a `MessageChannel` whose port is transferred into the frame, so identity is possession of the port.

## Design scope

1. Transport ladder with feature detection and explicit conditions, for example: a port handed in by the embedder via `postMessage` (iframes, Familiar); a direct WebSocket to the gateway carrying a single-use nonce locator (real origin, `connect-src` allows it); web-extension ports (`runtime.connect`, `externally_connectable`, native messaging); same-origin tab fallbacks (`SharedWorker`, `BroadcastChannel`); anything else the platforms support. Specify the detection order, how each condition is tested without side effects, and how failure falls through.
2. The nonce locator: shape, single-use and expiry semantics, how it relates to existing OCapN locators and swiss numbers, how it is minted by the gateway and delivered to sandboxed content, and what an attacker who sees it can and cannot do. State the authority model: the embedder or shell holds the real connection and attenuates; sandboxed content gets only a port or locator, never ambient network authority.
3. The package surface: one entry point that returns a connected OCapN session and a bootstrap object regardless of transport; error and reconnection behavior; how it composes with CapTP/OCapN sessions already in Endo; where it should live (propose the repo and package name; Endo changes keep maintainer review, so do not assume `endojs/endo-but-for-bots`).
4. Interaction with the iframe design in minion.town PR #189: the CORP `same-origin` and COEP `require-corp` posture, the sandbox tokens, and the shell frames loading ocap.site pages. Flag any conflict.
5. A verification plan: the browser test matrix (sandbox with and without `allow-same-origin`; assets, `fetch`, module scripts, WebSocket, storage, port transfer; CORP/COEP combinations) as a probe job spec the liaison can post. If you can run a small throwaway real-Chromium check inside this job, do, and report results; otherwise specify it.

End with `## Open questions` (concrete, maintainer-facing, with your recommendation for each). Do not start implementation. Report the design location, the verified-versus-unverified platform facts, and the proposed probe.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T18:10:12Z
