---
ts: 2026-05-21T23:50:25Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: designer
---

# Dispatch: designer drafts an overarching design for `@endo/gateway`

Dispatch root: `dispatches/designer--600eb4/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

## Maintainer directive (verbatim)

> Please dispatch a designer to read in the existing design documents pertaining to an Endo gateway and then propose an overarching design document for the Gateway. This would be a package `@endo/gateway` that stands up a local HTTP server on 0.0.0.0:3469 by default (ENDO_HTTP_ADDR). That is, it is a public web service.
>
> The gateway will, in the fullness of its design:
>
> 1. Host the Chat application, potentially with Gateway-specific enhancements like payment processing to purchase compute/storage/network tokens.
> 2. Virtual host weblets. That is, mapping the Host header to a Weblet formula. The Weblet formula would designate the content address for static content to host. The gateway would reveal the capability to govern this mapping as an `@apps` special name on host agents. The Weblet formula might also designate other configuration as the system evolves, like the mapping from extension to content type, and server-side rendering routes.
> 3. Host Git over HTTP for push and pull, authenticated by formula identifier as bearer token.
> 4. Listens on a local UNIX domain socket with a bootstrap object with implicit authority to register CapTP relays for local users, when configured as a system service.
> 5. Can also be bundled with the Familiar to listen on an OS assigned port on behalf of exactly one user, in the event that a system Gateway cannot be installed or is otherwise unavailable. The Familiar would configure its own custom protocol handler to proxy the OS-assigned port instead of the system service.
> 6. Relay CapTP on behalf of customers or the public, if configured to do so.
> 7. Serve generally as a daemon on behalf of the local system administrator, for purposes of management.
> 8. Host WebSocket at /ocapn-cbor-np that uses the Noise Protocol network and CBOR codec for OCapN.
> 9. Potentially served behind an HTTPS terminating proxy if public to the internet.
> 10. Deployable in a variety of configurations, but ultimately as rpm, deb, pkgbuild on a base Linux distribution, rolled up to Dockerfile for some cases.

## Existing design corpus (read all of these first)

These documents already exist on `llm` and describe pieces of what the new overarching design integrates. Read them, then synthesize:

- `designs/endo-gateway.md` — the closest prior art. It already frames the Gateway as a system-service Daemon configuration that virtual-hosts OCapN to many users, no TLS, Noise netlayer on a `/ocapn` WS, `@apps` special name, defer key rotation and daemon-hosting variant. The new design either **supersedes** this or **extends** it; the designer chooses and sets the `Supersedes:` / `Superseded by:` cross-link cleanly. Note the maintainer's directive specifies `/ocapn-cbor-np` rather than `/ocapn` and a default bind of `0.0.0.0:3469` with `ENDO_HTTP_ADDR` — both are new specifics to integrate.
- `designs/daemon-web-gateway.md` — the in-daemon HTTP+WS server that today serves the Chat application and `@apps`. The new `@endo/gateway` package extracts and generalizes this.
- `designs/daemon-weblet-application.md` — weblet application model.
- `designs/weblet-next.md` — the next-generation weblet design.
- `designs/familiar-unified-weblet-server.md` — single-port unified web server inside the daemon; notes multi-user/per-session-confidentiality problems.
- `designs/familiar-gateway-migration.md` — Chat dev server → daemon gateway migration.
- `designs/familiar-chat-weblet-hosting.md` — Chat-as-weblet hosting shape.
- `designs/familiar-localhttp-protocol.md` — Familiar Electron's `localhttp://` scheme. Relevant to feature #5 (Familiar-bundled fallback) and the custom protocol handler.
- `designs/familiar-bundled-agents.md` and `designs/familiar-daemon-bundling.md` — bundling shapes.
- `designs/familiar-electron-shell.md` — Familiar shell context.
- `designs/gateway-bearer-token-auth.md` — existing bearer-token scheme. Reconcile with feature #3 ("authenticated by formula identifier as bearer token"): is the formula identifier *the* bearer token, or is it derivable from it, or does this design propose a new scheme alongside?
- `designs/ocapn-noise-network.md` — Noise Protocol netlayer for OCapN.
- `designs/ocapn-noise-cryptographic-review.md` — cryptographic review of the Noise netlayer.
- `designs/ocapn-network-transport-separation.md` — separation of OCapN's transport from its semantics; this is what justifies "no TLS, Noise in-band."
- `designs/daemon-256-bit-identifiers.md` — Ed25519-keypair-doubles-as-OCapN-node-identifier; the basis for formula identifiers as bearer tokens (feature #3).
- The OCapN-syrups and OCapN-TCP companion designs (`ocapn-tcp-syrups-framing.md`, `ocapn-tcp-for-test-extraction.md`) — the CBOR codec on `/ocapn-cbor-np` (feature #8) is a sibling to syrups-on-TCP; cite the framing as analogous.

Also read `designs/README.md` for the summary table, dependency graph, and milestone layout; the new design needs to land cleanly in there (new row, milestone assignment, dependency edges to the existing cluster, size/duration estimate).

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/designer/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md` (the prompt mentions Chat, weblet, CapTP relay, OCapN, Noise, Familiar, formula identifier, content address, NameHub, `@apps`, Git-over-HTTP, UDS bootstrap, payment tokens, HTTPS terminating proxy, rpm/deb/pkgbuild — each of these is a known domain term in the corpus; the designer indexes them before drafting so the new design uses the existing vocabulary).
3. Read `garden/skills/prompt-section-discovery/SKILL.md` and `garden/skills/em-dash-style/SKILL.md` (style is normative).
4. Read `project/designs/CLAUDE.md` (already shown to you; the metadata table + Status fields are normative).
5. Read **every** design in the corpus list above. Take notes; they will become the new document's `## Dependencies` table.
6. Draft `designs/<slug>.md` in the project worktree. Suggested slug: **`gateway-package`** (the document is about the `@endo/gateway` package and its overarching shape) or **`endo-gateway`** (if you choose to supersede the existing file in place; in that case the file path stays the same and you rewrite). If you create a sibling, add a `**Supersedes**: designs/endo-gateway.md` row to your metadata table and append a `**Superseded by**: designs/<slug>.md` row to the old one in the same PR.

The design should cover, in roughly this order:

1. **Problem framing** — why a package `@endo/gateway` (versus continuing to fold this into `@endo/daemon` as `daemon-web-gateway.md` and `endo-gateway.md` have done so far). Name the multi-user, public-internet, and "deployable as a system service" forcing functions. Cite the maintainer directive verbatim under a `## Prompt` heading at the bottom per `designs/CLAUDE.md` § Capturing the prompt.
2. **Package shape** — `@endo/gateway` as a new package in the monorepo. Public surface: a `make({ ... })` factory that returns the gateway as a hardened exo (per project conventions in `project/CLAUDE.md` § makeExo). Inputs: powers (filesystem, net, crypto), configuration (the address to bind, the UDS path, whether to enable each of the ten features). Outputs: an exo that the daemon (or the Familiar) starts.
3. **Bind shape** — default `0.0.0.0:3469`, env override `ENDO_HTTP_ADDR`. State the port choice rationale (3469 is a deliberate maintainer pick; cite the directive). Cover the IPv4-vs-IPv6 question, the localhost-only fallback, and how the bind interacts with the Familiar-bundled variant (feature #5).
4. **Feature decomposition** — one subsection per maintainer-listed feature (1 through 10). Each subsection: what it is, how it composes with the existing design corpus, and whether it lands in the first iteration of the package or is gated behind a phased follow-up. Be especially careful on:
   - **Feature 1 (Chat-hosting + payment processing)** — what does the gateway *itself* know about payment, vs. what does the Chat weblet know? The gateway probably exposes the resource-accounting surface (compute, storage, network counters) and the Chat weblet renders the purchase UI; the design names the split.
   - **Feature 2 (Virtual hosting)** — Host header → Weblet formula mapping. The `@apps` NameHub on host agents is already in `endo-gateway.md`. The new specifics are (a) the Weblet formula designates a content-address for static content, (b) the formula may carry MIME-type maps and SSR-route maps as it evolves. The design proposes a Weblet formula shape (suggest a TypeScript-ish `@typedef` block).
   - **Feature 3 (Git-over-HTTP)** — the design names the wire protocol (smart HTTP per Git's `info/refs?service=git-upload-pack` shape), the URL prefix the gateway reserves (`/git/<repo-id>/...` or `/<host>/<repo>/...`?), and how the formula-identifier-as-bearer-token interacts with Git's HTTP auth (Authorization: Bearer <formula-id>). Reconcile with `gateway-bearer-token-auth.md`'s existing scheme.
   - **Feature 4 (UDS bootstrap)** — the bootstrap object's capability set. Per the directive: "implicit authority to register CapTP relays for local users." Specify the path (e.g., `/run/endo/gateway.sock` for the system-service variant; `$XDG_RUNTIME_DIR/endo-gateway.sock` for the user-bundled variant). Name the access mode (0700, owner-only).
   - **Feature 5 (Familiar-bundled fallback)** — when the system service isn't available, the Familiar starts the gateway on an OS-assigned port (port 0). The Familiar's `localhttp://` protocol handler then proxies through. Cite `familiar-localhttp-protocol.md` and `familiar-unified-weblet-server.md`. Cover the dual-binary-vs-shared-package question: is `@endo/gateway` the same code in both configurations (with config branches) or two separate entry points?
   - **Feature 6 (CapTP relay as a service)** — the public-relay configuration. Cover the abuse-prevention, rate-limit, and registration model. Cite `ocapn-noise-network.md` for the per-peer authentication.
   - **Feature 7 (Admin daemon)** — what does "daemon on behalf of the local system administrator" mean as a capability surface? Probably the UDS bootstrap (feature #4) is the admin's handle.
   - **Feature 8 (`/ocapn-cbor-np` WebSocket)** — the WebSocket subprotocol path explicitly names CBOR (codec) and Noise (network). State the framing (one Noise message per WS message; CBOR-encoded OCapN payload inside Noise). Cite `ocapn-noise-network.md`. Note that the existing `endo-gateway.md` uses `/ocapn` as the path — explain the rename: the new path encodes the codec/transport pair so future siblings (`/ocapn-syrups-tcp`, `/ocapn-cbor-tls`?) can coexist.
   - **Feature 9 (HTTPS terminating proxy)** — the gateway itself does no TLS; an external reverse proxy (nginx, Caddy, Cloudflare) terminates if exposed to the public Internet. Cover the X-Forwarded-* header trust model and the `trust proxy` configuration. Note that OCapN's confidentiality is provided by Noise in-band, so HTTPS is for HTTP-API confidentiality only (the Chat weblet, the Git endpoint, the @apps virtual hosts).
   - **Feature 10 (OS packaging)** — rpm, deb, Arch's PKGBUILD, and Dockerfile rollup. Sketch the systemd unit (or runit/openrc) shape, the user/group the service runs as (`endo:endo`?), the data directories (`/var/lib/endo-gateway/`?), and the configuration-file shape. This is the implementation-vs-design boundary — the design names the deployment shape; the builder lands the actual packaging files.
5. **Capability surface** — the design lays out what the gateway exposes as a CapTP-reachable exo on the UDS bootstrap, what the @apps NameHub looks like, and what the Familiar's bundled-variant variant exposes differently.
6. **Configuration model** — env vars, config-file, and per-feature toggles. State which features are mandatory vs. optional, and which depend on others (e.g., feature #6 depends on feature #8; feature #1 depends on feature #2).
7. **Dependencies table** — every corpus design above, with one-line "this design depends on / supersedes / generalizes" annotations.
8. **Phased implementation** — sketch the milestones. Suggested order (the designer adjusts): phase 1: package skeleton + virtual-hosting (#2) + `@apps` + `/ocapn-cbor-np` (#8); phase 2: Chat hosting (#1) + UDS bootstrap (#4); phase 3: Familiar-bundled variant (#5) + bearer-token Git (#3); phase 4: relay-as-service (#6) + packaging (#10). HTTPS terminating proxy (#9) is documentation-only.
9. **Design decisions** — numbered list with rationale for the non-obvious choices: package extraction from daemon, port 3469, env var name, `/ocapn-cbor-np` path, formula-identifier-as-bearer-token, no-TLS-in-gateway.
10. **Open questions** — anything the directive leaves under-specified that the designer surfaces rather than picks. Likely candidates: the payment-token mechanism (#1), the abuse-prevention model for the public relay (#6), the registry of weblet-content-address-to-Host-header (whether it's per-user or per-host-agent), the rotation story for formula-identifier bearer tokens, and the multi-tenant filesystem isolation when the gateway hosts many users' weblets.

Then **sync the design into `designs/README.md`** per `designs/CLAUDE.md` § Cross-document: new row in the Summary table, milestone assignment, dependency-graph edges to the listed corpus designs, per-design size estimate (this one is L — overarching and integrating).

Then **open as DRAFT PR** against `endojs/endo-but-for-bots@llm`. Branch: `design/gateway-package` (or `design/endo-gateway-v2` if you choose to supersede in place — name it cleanly). Title: `design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster`. Body cites the maintainer directive, summarizes the 10 features, names which existing designs the new doc depends on / supersedes, and flags the open questions surfaced rather than answered.

## Per-action authorization

Standing on `endojs/endo-but-for-bots`: push to `design/<slug>` branch, open draft PR against `llm`. No comment authority on anything outside the new PR's body. READ-ONLY on `endojs/endo`.

## Out of scope

- No implementation. This is a design dispatch; the design surfaces what to build, the builder lands it later.
- No edits to existing `packages/daemon/` source.
- No upstream ferry (boatman handles when the design is approved and a builder dispatch produces the implementation PR).
- No un-draft of the design PR — design PRs stay draft until the maintainer green-lights.
- Resist scope creep on the OS-packaging section (#10): name the shape, not the exact spec files.

## Report

≤ 500 words. PR URL + head SHA. Design path on `llm`. Whether the existing `endo-gateway.md` was superseded (with note added) or extended in place. The phased-rollout shape. The list of open questions surfaced rather than answered. One-line `Self-improvement: ...`. The liaison adds a bulletin row.
