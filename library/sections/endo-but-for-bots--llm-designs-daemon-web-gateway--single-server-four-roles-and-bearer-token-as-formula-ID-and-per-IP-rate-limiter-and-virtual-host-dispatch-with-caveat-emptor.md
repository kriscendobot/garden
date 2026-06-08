---
title: "daemon-web-gateway — §single-server-four-roles + §bearer-token-as-formula-ID + §per-IP-rate-limiter + §virtual-host-dispatch + §caveat-emptor-disclosure + §two-framings-for-the-same-CapTP-protocol + §status-Complete-with-explicit-design-deviations-none"
source-slug: endo-but-for-bots--llm-designs-daemon-web-gateway
section-id: single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-web-gateway.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-web-gateway.md
total-lines: 185
status: Complete (2026-03-11)
ingest-cycle: 224
ingest-date: 2026-06-08
lane: designs
---

# daemon-web-gateway — Single HTTP+WebSocket server, four roles

A 185-line **Complete** design (created 2026-03-11). Status section: §**Implemented** + §**Design deviations: None significant**. The gateway is the §single-HTTP+WebSocket-server that multiplexes four distinct roles on one port — solving the §browsers-cannot-open-UNIX-sockets problem for Chat, the Familiar's renderer, and weblets.

## §The-Status-section names §two-states-with-explicit-completeness-markers

```
**Implemented.** The gateway is a built-in daemon service in
`packages/daemon/src/web-server-node.js` ...

**Design deviations:** None significant — the implementation matches the
design described below.
```

§Implementation-status + §Design-deviations-explicitly-marked-as-(None). §Sibling to cycle 220's §Open-Questions: (None remaining.) — §the-empty-marker-is-load-bearing.

§Three-different-empty-marker-shapes in library:
- Cycle 220 familiar-localhttp-protocol: §Open-Questions: (None remaining.).
- Cycle 222 endoclaw-skill-registry: implicitly empty (no Design Deviations or Open Questions section at all).
- Cycle 224 daemon-web-gateway: §Design deviations: None significant.

§The-completeness-signal differs: cycle 220 says "no decisions outstanding"; cycle 224 says "no implementation drift". §Two-different-classes-of-completeness-signaled-with-different-empty-markers.

## §Single-server-four-roles architecture

The gateway listens on `ENDO_ADDR` (default `127.0.0.1:8920`) and serves §four-named-roles:

1. **§CapTP-bridge-for-Chat** — WebSocket connections from Chat UI.
2. **§Alternative-to-UNIX-socket-for-Familiar** — same path for Electron renderer.
3. **§Designated-port-weblet-hosting-for-browsers** — per-weblet HTTP servers on dedicated ports.
4. **§Virtual-host-weblet-hosting-for-Familiar** — all weblets share gateway port, routed by `Host` header.

§Borrowable-pattern: §one-port-multiplexing-multiple-protocols-with-named-roles. §Different-from-classical-microservice-decomposition (one role per port); §this-is-the-other-direction (one port + N protocols dispatched by request shape).

§Sibling to cycle 184 familiar-unified-weblet-server's §unified-weblet-server (cycle 220 mentions this as a dependency). §Cycle-224-is-the-supergraph that names how all four roles live on one port.

## §GatewayBootstrap as §narrow-interface

```js
const GatewayBootstrapI = M.interface('GatewayBootstrap', {
  fetch: M.call(M.string()).returns(M.promise(M.remotable())),
});
```

§Single-method-interface — `fetch(agentId)` returns the agent's powers. §Borrowable-pattern: §the-entry-point-to-a-protocol-should-be-as-narrow-as-possible. §A-one-method-interface-is-easy-to-audit + §every-additional-method-widens-the-attack-surface.

§Sibling to cycle 154 @endo/captp trap.js's §narrowed-API-for-narrower-semantics + cycle 217 @endo/errors' §the-Rejector-typedef as one-line-API.

## §Bearer-token-as-formula-ID (256-bit identifier doubles as auth)

> Chat calls `E(gatewayBootstrap).fetch(agentId)` with the agent's 256-bit hex formula identifier — which doubles as the bearer token — to obtain the agent's powers over CapTP.

§The-formula-ID-IS-the-bearer-token. §No-separate-token-table-needed — §knowing-the-formula-ID-is-the-authentication. §Borrowable-pattern: §when-an-opaque-identifier-is-already-256-bit-uniformly-random, §it-can-serve-as-its-own-bearer-token. §Sibling to cycle 200 worker-rust-xs's §retention-path-notation and cycle 220 familiar-localhttp-protocol's §the-deterministic-address-IS-the-coordination-primitive. §The-identifier-IS-the-capability discipline appears in three different layers.

§Five-cycles-on-the-identifier-IS-the-capability discipline:
- Cycle 200 worker-rust-xs (retention paths).
- Cycle 210 lal-fae-form-provisioning (deterministic naming as coordination).
- Cycle 211 @endo/common (file path IS the import path).
- Cycle 220 familiar-localhttp-protocol (deterministic address IS the route).
- Cycle 224 daemon-web-gateway (formula ID IS the bearer token).

§The-pattern-deepens: §the-coordinating-name + §the-routing-key + §the-authentication-token can all be the same string. §Don't-store-it-twice; §let-the-shape-itself-carry-the-meaning.

## §Per-IP-rate-limiter with §three-named-properties

```
A per-IP rate limiter penalizes failed `fetch()` attempts by 1 second each.
Successful fetches do not affect the rate limit. Stale entries are removed
after 10 seconds.
```

§Three-named-properties:
1. §Failed-attempts-penalized (1-second penalty per failed fetch).
2. §Successful-fetches-do-not-affect-the-rate-limit (a known user doesn't get throttled).
3. §Stale-entries-removed-after-10-seconds (the table doesn't grow unboundedly).

§Borrowable-pattern: §rate-limiter-with-explicit-rules-named-for-each-traffic-class. §Most-rate-limiters-have-one-rule (e.g., "10 requests per second"); §this-one-has-three-rules-each-targeting-a-different-attack-or-cost.

§Sibling to cycle 220 familiar-localhttp-protocol's §three-named-mitigations-per-defense-layer. §Both-designs-name-multiple-rules-per-control instead of one generic limit.

## §Two-modes-of-weblet-hosting (designated-port + virtual-host)

§Two-different-modes-for-two-different-clients:

| Mode | Client | URL form |
|------|--------|----------|
| Designated-port | Conventional browser | `http://127.0.0.1:<port>/<accessToken>/` |
| Virtual-host | Familiar's `localhttp://` | `localhttp://<accessToken>/path` |

§Borrowable-pattern: §the-same-content-served-two-different-ways for §two-different-client-capabilities. §The-Familiar-can-receive-`localhttp://` + §a-regular-browser-cannot. §Two-clients-with-different-URL-handling-each-get-the-URL-form-they-support.

### §Caveat-emptor-disclosure for the conventional-browser mode

> This gives conventional browsers a navigable URL. Caveat emptor — there is no `localhttp://` origin isolation in a regular browser. The access token (first 32 characters of the weblet's formula ID) provides URL-level access control but not same-origin isolation between weblets.

§Honest-disclosure-named-`Caveat-emptor`. §Borrowable-pattern: §when-a-feature-has-a-known-trade-off + §the-trade-off-can-be-acceptable-for-some-users + §but-cannot-be-removed, §the-design-document-names-it-`Caveat-emptor` and §discloses-the-specific-limitation.

§Sibling to cycle 218's §`@host`-explicitly-labeled-development/trusted-only (similar shape — §named-warning-on-a-less-safe-mode).

§Three-different-shapes-for-honest-disclosure-of-a-known-trade-off in library:
- Cycle 218 (familiar-chat-weblet-hosting): §`@host`-explicitly-labeled-development/trusted-only.
- Cycle 220 (familiar-localhttp-protocol): §Research-needed-section as honest-acknowledgment-of-incomplete-verification.
- Cycle 224 (daemon-web-gateway): §Caveat-emptor-disclosure for the less-safe mode.

§Three-different-rhetorical-shapes for §the-same-underlying-discipline: §be-honest-about-the-limits.

## §Three-mode-address-filtering with §CIDR-allowlist

| Mode | Configuration | Allowed clients |
|------|--------------|----------------|
| Localhost only (default) | `ENDO_GATEWAY` unset or `''` | `127.0.0.1`, `::1`, `::ffff:127.0.0.1` |
| Remote | `ENDO_GATEWAY=remote` | All IPs (logs TLS warning) |
| CIDR allowlist | `ENDO_GATEWAY_ALLOWED_CIDRS='10.0.0.0/8,fd00::/8'` | Localhost + listed ranges |

§Three-mode-configuration with §default-is-the-safe-mode (Localhost only). §The-Remote-mode-logs-a-TLS-warning — §the-user-is-told-the-trade-off-they're-making.

§Borrowable-pattern: §three-named-modes-with-safe-default + §unsafe-mode-logs-a-named-warning. §Sibling to cycle 218 power-levels-as-selectable-options (four-named-levels). §Different-from-cycle-218: cycle-218 grants per-application; cycle-224 governs the listener.

§IPv4-mapped-IPv6-normalization handled in `cidr.js` — §the-`::ffff:127.0.0.1`-form-must-match-the-`127.0.0.1`-rule. §Borrowable-pattern: §address-normalization-as-a-prerequisite-for-allowlist-matching.

## §Virtual-host-dispatch for both HTTP and WebSocket

§Same-dispatch-mechanism-for-two-different-protocols:
- HTTP requests: matched by `Host` header to a weblet's request handler.
- WebSocket upgrade requests: matched by `Host` header to a weblet's `connect` handler.

§Borrowable-pattern: §unified-virtual-host-dispatch-across-protocol-types. §The-Host-header-IS-the-shared-discriminator across HTTP and WebSocket flows.

§When-a-WebSocket-upgrade-arrives-with-a-Host-header-matching-a-registered-weblet, §the-gateway-delegates-to-that-weblet's-connect-handler-instead-of-creating-a-GatewayBootstrap. §Borrowable-pattern: §the-default-handler-vs-the-registered-weblet-handler-distinction.

## §Two-framings-for-the-same-CapTP-protocol

```
For WebSocket connections (gateway and weblet):
  messageToBytes: JSON.stringify → TextEncoder → Uint8Array
  bytesToMessage: Uint8Array → TextDecoder → JSON.parse
  Sent as binary WebSocket frames.

For the UNIX domain socket (CLI):
  same CapTP protocol, framed with netstrings instead of WebSocket frames.
```

§Two-framings-for-the-same-CapTP-protocol. §The-message-payload-format-is-the-same; §the-framing-(WebSocket-binary-frame-vs-netstring)-differs-by-transport.

§Borrowable-pattern: §when-the-same-protocol-runs-over-two-transports, §isolate-the-framing-from-the-payload. §The-CapTP-payload-is-portable; §the-framing-is-transport-specific. §The-design-says-this-explicitly + §implementation-shares-`makeMessageCapTP`-across-both-paths.

§Sibling to cycle 154 trap.js's §narrowed-API-for-narrower-semantics — both designs §parameterize-the-protocol-by-transport-or-call-shape.

## §makeWeblet registration API

```js
makeWeblet(webletBundle, webletPowers, requestedPort, webletId, webletCancelled)
// Returns: Far('Weblet', { getLocation, stopped })
```

§Five-named-parameters + §two-named-return-fields. §getLocation-returns-mode-dependent-URL (localhttp:// in unified mode; http://...:port/... in dedicated-port mode).

§Borrowable-pattern: §the-registration-API-doesn't-prescribe-the-mode + §the-implementation-returns-the-URL-form-that-applies. §The-caller-doesn't-need-to-care-which-mode-it-got.

## §Dependencies-table with §Relationship-column

```
| Design | Relationship |
|--------|-------------|
| familiar-gateway-migration | Moved gateway into daemon as built-in service |
| familiar-unified-weblet-server | Virtual-host routing for weblets on shared port |
| familiar-electron-shell | Familiar's localhttp:// protocol handler and daemon lifecycle |
| gateway-bearer-token-auth | Agent ID as bearer token, rate limiting, CIDR filtering |
| daemon-256-bit-identifiers | 256-bit formula IDs used as access tokens |
```

§Five-named-dependencies each with §a-named-relationship. §Borrowable-pattern: §Dependencies-table-with-Relationship-column (vs cycle 222's bullet list with named-reason; vs cycle 218's three-line bullet list).

§Three-different-shapes-for-naming-dependencies in 2026-06 cluster:
- Cycle 218 familiar-chat-weblet-hosting: bullet list with §named-reason-per-dependency.
- Cycle 220 familiar-localhttp-protocol: bullet list with §named-reason-per-dependency.
- Cycle 222 endoclaw-skill-registry: bullet list with §status-per-dependency.
- Cycle 224 daemon-web-gateway: table with §Relationship-column.

§Four-different-shapes-for-naming-design-dependencies. §The-table-form (cycle 224) §makes-the-relationship-readable-at-a-glance + §the-bullet-form (cycles 218/220/222) §names-the-reason-prose-style.

## §The-Prompt-section (original solicitation captured)

> Please summarize the design of the daemon's web gateway feature, which provides a mechanism for Chat to communicate with the Daemon (since it can't use a UNIX domain socket), an alternative to using the UNIX domain socket for the Familiar, hosting HTTP servers for each weblet with a designated port for conventional web browsers (caveat emptor), and virtual hosting HTTP servers for other weblets for Familiar.

§The-original-prompt-captured-in-the-design-document. §Sibling to cycle 198 patterns-diagnostic-feedback's §three-revision-pivots-visible-in-Prompt-section. §Two-cycles-with-Prompt-section-captured (198 + 224); §the-Prompt-section-IS-the-original-design-brief.

§Borrowable-pattern: §preserve-the-original-prompt-or-brief-in-the-design-document. §The-future-reader-can-see-what-the-design-was-asked-to-do + §compare-it-to-what-the-design-actually-says.

§The-prompt-uses-caveat-emptor — §the-design-honors-this-exact-disclosure-language. §Two-instances-of-the-phrase: §in-the-prompt + §in-the-Designated-port-mode-section.

## §Twenty-first-honest-design-evolution-record family member

§A-new-shape: §status-Complete-with-explicit-Design-deviations-None-significant + §implementation-files-named-in-Status-section. §The-design-tracks-its-implementation-state-with-named-file-locations.

§Six-different-shapes-of-design-evolution-record in 2026-06 cluster now:
| Cycle | Shape |
|-------|-------|
| 214 | §within-document self-correcting prose |
| 216 | §parent-Complete + §child-Not-Started extraction via Predecessor section |
| 218 | §sibling-Ready + §this-Not-Started via two-part Status |
| 220 | §three-state-Status + §design-deviations-section |
| 222 | §Parent-pointer-as-explicit-frontmatter-field |
| 224 | §status-Complete-with-explicit-Design-deviations-None-significant + named-implementation-files |

§Six-different-shapes for naming-the-design-implementation-relationship.

## Related material in the library

- **cycle 218 familiar-chat-weblet-hosting** (Not Started): §Chat-side of this gateway.
- **cycle 220 familiar-localhttp-protocol** (Partially implemented): §Familiar-side of the localhttp protocol that this gateway serves.
- **cycle 184 familiar-unified-weblet-server**: §the-unified-server-design this design implements.
- **cycle 182 familiar-gateway-migration**: §the-design-that-moved-the-gateway-into-the-daemon.
- **cycle 222 endoclaw-skill-registry**: §pet-name-storage sibling (capability stores).
- **cycle 200 worker-rust-xs + cycle 210 lal-fae-form-provisioning + cycle 211 @endo/common + cycle 220 familiar-localhttp-protocol + cycle 224**: §the-identifier-IS-the-capability discipline (five cycles).
- **cycle 154 @endo/captp trap.js**: §narrowed-API-for-narrower-semantics sibling.
- **cycle 217 @endo/errors**: §the-Rejector-typedef as one-line-API sibling.
- **cycle 198 patterns-diagnostic-feedback**: §Prompt-section-captured sibling.

## §Eight-Familiar-cluster-designs in library after cycle 224

| Cycle | Design | Status |
|-------|--------|--------|
| 174 | familiar-electron-shell | shipped |
| 176 | familiar-daemon-bundling | shipped |
| 182 | familiar-gateway-migration | shipped |
| 184 | familiar-unified-weblet-server | shipped |
| 208 | familiar-bundled-agents | shipped |
| 218 | familiar-chat-weblet-hosting | Not Started |
| 220 | familiar-localhttp-protocol | Partially implemented |
| 224 | daemon-web-gateway | Complete |

§Eight-design-cluster for §the-Familiar-feature.

## §Library-reaches-730-sections at cycle 224 (designs-lane daemon-web-gateway).

## §Fifty-eighth consecutive designs-chat alternation cycles 166-224.
