---
title: "Endo Gateway — same binary in two configurations + host-scope vs user-scope + outbound registration to a public-key-keyed table + Noise-not-TLS + content-addressed cache served direct from the relay"
section-slug: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
source-slug: endo-but-for-bots--llm-designs-endo-gateway
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-gateway.md
authors: [Kris Kowal (prompted)]
status: Proposed
created: 2026-05-10
updated: 2026-05-10
ingest-cycle: 283
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 997
---

# `endo-gateway.md` (full design)

A 997-line Proposed design (Source: extracted from issue #173, which itself was extracted from PR #134 review at 2026-05-10T06:14:41Z). Splits the existing per-user Endo Daemon into a **host-scope Gateway + N per-user Daemons**, both as **two modes of the same binary**, with a public-key-keyed registration table, frame-level HTTP/WebSocket relay, and an OCapN endpoint where session confidentiality comes from the Noise netlayer rather than TLS.

## The shape

**One binary, two modes selected at startup by `--mode=gateway` vs `--mode=user`** (`user` is the default for backward compatibility). A given host runs **at most one Gateway** and **zero or more User Daemons**:

- **Endo Gateway** (system service, one per host, **one TCP port**): listens for HTTP and a WebSocket `/ocapn` endpoint, holds the public-key → User-Daemon-connection routing table, and relays weblet traffic.
- **User Daemon** (one per OS user account): registers outbound with the Gateway over a local-only IPC channel, publishes weblets, handles dynamic-fallback HTTP and WebSocket frames.
- **Weblets** (M per User Daemon): one virtual host per weblet, addressed by the first 32 hex characters of the weblet's formula ID (preserves today's convention).

**The Gateway carries no formula store of its own beyond what it needs to represent its registration table and operator policy.** Everything else — formulas, agents, weblet code, content — stays in the per-user Daemon.

## §the-same-binary-two-configurations pattern (first-explicit-observation)

The Gateway and the per-user Daemon **are two modes of the same generic Daemon binary**, selected at startup by a configuration flag. **Reusing one binary keeps the formula machinery, content store, worker plumbing, and OCapN client common between modes**. The Gateway's "mode" is largely a startup configuration that *disables the formula-execution side*, *enables the registration table and the proxying handlers*, and *selects a different unconfined-guest formula at boot in place of the user-side `@apps` formula*.

**Three named subtractions and one named substitution** between the two modes (from the same shared binary):

- Subtracts: formula-execution side.
- Adds: registration table + proxying handlers.
- Substitutes: a different unconfined-guest boot formula in place of `@apps`.

This is **§binary-reuse-as-mode-not-fork** as a named architectural shape — the same compiled artifact serves both host-level and user-level postures.

## §the-host-scope-vs-user-scope split as named architectural distinction (first-explicit-observation)

The design explicitly names **three reasons the per-user Daemon is the wrong place for multi-user virtual-host service**:

1. **OS-user privilege boundary**: it runs as one OS user and would have to be granted privileges that crossed user boundaries to relay another user's traffic.
2. **Per-host singleton vs per-user implicit-multiplicity**: two daemons on the same host would race for the same port; the service is implicitly a per-host singleton, but the daemon is implicitly per-user.
3. **Policy domain**: hosting policy (which users may register weblets, which public keys are allowed at the local virtual-host hierarchy, whether to expose to the public internet) is host-administrator policy, not user policy.

**§three-named-policy-domains as named separation criteria** (first-explicit-observation): OS-user-privilege + per-host-vs-per-user-cardinality + host-administrator-vs-user-policy. This is **the-policy-domain-IS-the-decomposition-axis** rather than convenience or DRY.

## §outbound-registration-from-many-to-one as named direction (first-explicit-observation)

User Daemons **make their presence known to the Gateway by opening an outbound CapTP connection** over a local-only IPC channel and presenting their Ed25519 public key. **The direction is many-to-one outbound**, not one-to-many discovery: the Gateway does **not** scan for User Daemons; the User Daemons converge on a well-known rendezvous (`/run/endo-gateway/registrar.sock` on Linux; named pipe `\\.\pipe\endo-gateway` on Windows).

**§the-rendezvous-shape as named architectural pattern** (first-explicit-observation): a single, well-known local IPC path where every User Daemon on the host converges to find the Gateway. The Gateway holds the well-known address; the User Daemons hold the dialing logic; **the registration is a connect, not a discover**.

## §public-key-keyed-routing-table as named indirection (first-explicit-observation)

The Gateway maintains a `publicKey -> User Daemon connection` table keyed by the registrant's public key. **The routing key is cryptographic, not OS-level**: the Ed25519 public key (the same per-agent key material that doubles as OCapN node identifier in `daemon-256-bit-identifiers`) is the join key across two paths — the local IPC registration path and the remote OCapN endpoint at `/ocapn`. A single lookup serves both paths.

**§the-single-lookup-serves-both-paths shape** (first-explicit-observation): the same key type is the join key for the local registration path AND the OCapN session demultiplex path on remote ingress, so **the Gateway's lookup table is shape-shared across two distinct entry surfaces**.

## §the-local-IPC-socket-IS-the-local-attestation, not-a-separate-check (first-explicit-observation)

**Decision: a local-only IPC channel is the local-attestation mechanism**, not a credential check on top of a TCP socket. The IPC channel is local-by-construction: a registration that arrives over the local IPC socket is, by construction, from a process on this host; **"local" is then a property of the channel rather than of any kernel-credential check or attested secret**.

**§the-channel-IS-the-property shape as named design move** (first-explicit-observation): instead of "open a generic transport + check the credential", the design uses "use a transport whose presence-of-traffic is the credential". This is `the-shape-of-the-pipe-IS-the-attestation` — a pattern with very low complexity surface.

**§three-named-rejected-alternatives section** (first-explicit-observation in design pattern terms): the design explicitly names two rejected alternatives **with the reason for rejection**:

1. **Loopback TCP plus a kernel credential check** (`SO_PEERCRED` on Linux, `LOCAL_PEERCRED` on macOS, `GetNamedPipeClientProcessId` on Windows) — *works, but requires per-OS kernel-API plumbing for what is otherwise the same property the IPC channel gives us by construction*.
2. **Cryptographic attestation backed by a host-only secret** (TPM-sealed key, file readable only by the local daemon at boot) — *heaviest infrastructure, gains nothing over the IPC channel on a cooperative host*.

The accepted choice is named alongside its rejected alternatives, with the rejection rationale that names what the alternatives **would gain** and **what they would cost**.

## §the-proof-of-possession-step-IS-distinct-from-local-attestation (first-explicit-observation)

The handshake also includes a **proof-of-possession** step: the User Daemon signs a fresh nonce returned by an immediately preceding `E(registrar).challenge()` call with its Ed25519 private key. **This is explicitly not the local-attestation step**: "The proof-of-possession step in the registration handshake is **not** about local-vs-remote (the socket is local-by-construction); it is about distinguishing one local user from another so that a malicious local user cannot register another local user's public key." Two named concerns at one handshake, with each step doing exactly one thing.

**§one-handshake-two-distinct-concerns pattern** (first-explicit-observation): the registration handshake interleaves two security questions — *is the registrant on this host?* (channel-attested) and *does the registrant control the private key for the public key it claims?* (proof-of-possession-attested). The design names the two concerns and the two mechanisms separately so a future reader does not collapse them.

## §the-domain-separation-prefix-on-the-nonce as named protocol-cross-use defense (first-explicit-observation)

The Gateway hashes the nonce with a **domain-separation prefix** (suggested literal `endo-gateway:registrar:nonce`) before checking the signature; this prevents a captured registration signature from being misused as a signature in another OCapN protocol step. **§the-domain-separation-literal as named-string-tag** (first-explicit-observation): a literal protocol-and-step namespace `endo-gateway:registrar:nonce` that prevents signature cross-replay between protocol steps that share the same long-lived key material. The signature is bound to the protocol context, not just the bytes signed.

## §the-Noise-not-TLS decision, with three named consequences (first-explicit-observation)

The Gateway does **not** terminate TLS at any layer. **Session-level confidentiality and peer authentication for OCapN are provided by the Noise Protocol netlayer** described in `ocapn-network-transport-separation`: once the WebSocket handshake at `/ocapn` completes, the OCapN session begins with a Noise handshake whose static keys are the Ed25519 keys that double as OCapN node identifiers. After the handshake, OCapN frames are encrypted and authenticated end-to-end between the remote peer and the User Daemon; **the Gateway, sitting in the middle, sees only ciphertext**.

**Three named consequences worth pinning**:

1. **No certificate management.** The Gateway has no key/cert files, no ACME client, no rotation tooling, and no configuration knobs for cipher suites or SNI.
2. **Authentication is by Ed25519 public key, not by hostname.** The Gateway never claims to be a particular host on a CA-signed certificate; the remote peer authenticates the destination User Daemon by its public key during the Noise handshake.
3. **Browsers are out of scope for the OCapN endpoint.** The OCapN endpoint at `ws://<host>/ocapn` is for OCapN clients (other Endo daemons, the CLI, peer hosts), not for browsers. The browser-facing path is per-weblet HTTP/WebSocket on the weblet's virtual host, which is plain HTTP.

**§three-named-consequences-of-cryptographic-protocol-choice pattern** (first-explicit-observation): the design pre-empts the reader's "but how do you handle TLS / certs / browser-TLS" by enumerating the three named consequences before the reader can object.

## §the-ciphertext-passing-relay as named role (first-explicit-observation)

The Gateway is, on the OCapN endpoint, a **ciphertext-passing relay**: it terminates the TCP and WebSocket framing but the OCapN frames riding inside the WebSocket are encrypted end-to-end Noise-secured between the remote peer and the destination User Daemon. **The Gateway in the middle sees only ciphertext** for OCapN traffic. This is true confined-by-construction: the Gateway cannot read or tamper with OCapN content even if compromised.

**§the-relay-IS-confined-by-encryption shape** (first-explicit-observation): a man-in-the-middle that is structurally unable to read what passes through it, because the cryptographic shell terminates at the endpoints rather than at the relay. This is **stronger than a-relay-that-promises-not-to-read** — the relay-IS-incapable-of-reading is the named guarantee.

## §the-frame-level-relay-without-CapTP-inspection (first-explicit-observation)

For per-weblet WebSocket traffic, the Gateway **proxies frame-for-frame** without parsing or understanding the application-level CapTP carried over the WebSocket. **The Gateway and User Daemon split on protocol responsibility**: the Gateway owns the HTTP and WebSocket framing; the User Daemon owns CapTP. **The protocol layers are split at named boundaries**, not entangled.

**§named-protocol-layer-ownership-split shape**: HTTP-and-WS-framing-IS-Gateway + CapTP-IS-User-Daemon + Noise-IS-User-Daemon. Each layer has one owner.

## §the-content-addressed-cache-served-direct-from-the-relay (first-explicit-observation)

**The Gateway's HTTP server is itself the static-asset server.** On a GET, the Gateway looks up the weblet formula in its sqlite store, reads the formula's tree-root content hash, and serves the requested path **directly out of the Gateway's content-addressed store**. **There is no per-request round-trip to the User Daemon for content-addressed (immutable) assets.** The User Daemon's only role in static-asset delivery is to publish the formula in advance and to make sure the Gateway has the underlying CAS objects.

**§the-publish-then-no-round-trip pattern** (first-explicit-observation): a relay that becomes a *content-addressed cache* for immutable assets, with the User Daemon only invoked for dynamic-path fallback. This is **read-path-IS-zero-RTT-to-User-Daemon** when the asset is in CAS; the User Daemon only enters the picture for dynamic fallback.

**§the-fall-through-routing-with-CAS-hit-then-User-Daemon-miss pattern**:

```
6. Resolve the request path against that tree root in the CAS.
   - Hit: serve the bytes directly out of the CAS.
   - Miss (path is dynamic, not in the static tree):
       E(userDaemon).handleHttp(webletId, requestRecord) → response.
```

**§the-three-tier-cache-then-relay-then-CapTP shape**: tier-1 Gateway CAS hit (no User Daemon RTT) + tier-2 dynamic-fallback relay (User Daemon HTTP handler, passable record) + tier-3 CapTP escalation for streaming uploads above the inline-body threshold.

## §the-rebuild-from-registrations-on-restart, not persisted (first-explicit-observation)

**A Gateway restart drops every connection (TCP closes), and clients reconnect.** User Daemons reconnect to the registration socket and re-publish their weblets; **the Gateway's registration table is rebuilt from those incoming registrations rather than persisted across restarts**. This keeps the Gateway's on-disk state minimal (operator policy files, the sqlite formula store, the CAS cache; no TLS key, no certificate, no Noise static key beyond what the OCapN netlayer manages itself) and avoids the Gateway's table going stale relative to the live User Daemons.

**§the-state-IS-rebuildable-from-clients shape** (first-explicit-observation): the relay's routing state is not its source of truth — the User Daemons are — so a restart that loses the routing table is **self-healing**: the User Daemons re-converge and re-register. This is similar to the way a DNS server doesn't persist client TTLs; the clients re-query when their cache expires.

## §the-404-not-503-for-absent-daemon as named privacy-and-cacheability decision (first-explicit-observation)

"A request for a Host whose User Daemon is down returns **404 (not 503)** so that **the response is cacheable and gives no signal about which users exist on the host**." Two named reasons in one decision:

1. **Cacheability** — 404 is a normal cacheable response; 503 advertises a transient condition that must not be cached.
2. **Privacy** — 404 means "no such Host on this server"; 503 means "this Host exists but is unavailable". The latter leaks which users have ever registered.

**§the-error-code-choice-IS-a-privacy-decision pattern** (first-explicit-observation): a status code as a side-channel, with the privacy implication called out explicitly. This is `the-404-not-503` as a *security-property-by-choice-of-error-code*.

## §the-fall-back-when-no-Gateway-detected behavior (first-explicit-observation)

"Familiar should detect at startup whether a Gateway is reachable on the local rendezvous socket; if so, the in-process User Daemon registers with it instead of binding a port; if not, Familiar falls back to today's behaviour (User Daemon binds a per-user port)." **The single-user developer flow is preserved as the fall-back path**: a standalone single-user developer install can still run a User Daemon with no Gateway in front of it, in which case the User Daemon binds its own port as it does now.

**§the-no-Gateway-fall-back as named legacy-compatibility shape** (first-explicit-observation): the new architecture is *opt-in via discovery*, with the legacy path remaining the default. This is **discovery-IS-the-feature-toggle** — no flag flip, no config file, no migration; whether you get the Gateway depends solely on whether one is reachable.

## §the-`Resolved by review` section as named acceptance-tracking-section in a design (first-explicit-observation)

The design includes a `## Resolved by review` section that **records previously-open questions that the first review pass closed**, "so that future readers do not re-litigate them". Six resolutions are pinned: separate config trees + no TLS + platform-service-manager-as-supervisor + canonical `/ocapn` path + static-asset-direct-from-CAS + proposed interfaces.

**§the-`Resolved by review`-section-as-named-design-document-shape** (first-explicit-observation): a design that **tracks its own review outcomes inline** rather than leaving them in PR comments. This is the first design ingested with this section name. It complements `## Open Questions` — they form a **pair of named sections** tracking what HAS been decided (`Resolved by review`) and what HASN'T (`Open Questions`).

**§two-named-design-tracking-sections-as-decision-pair** (first-explicit-observation): `Resolved by review` (closed) + `Open Questions` (still open) — a way for a design document to be its own changelog and its own to-do list at once.

## §the-multi-key-per-Daemon registration pattern (first-explicit-observation)

The `Registration` exo exposes `addPublicKey` so **one Daemon may host more than one agent**. The protocol allows a Daemon to register additional public keys and to retire old ones; the *operational* rotation path exists by composition. The named primitive is **one-Daemon-many-keys**, not the typical one-process-one-key shape.

**§one-process-many-keys as named multiplicity** (first-explicit-observation): the routing-table entry is the (key, daemon) tuple, not a one-to-one map from process to key; many tuples may share a daemon.

## §the-`Pass-Invariant-Eq` named-open-question (first-explicit-observation)

The design names a deferred concern: when a public key changes, anything that hard-coded the old key as part of a locator continues to point at the old entry, and the new key is, from the recipient's perspective, a fresh object even though the operator intended a continuation. **This breaks the Pass-Invariant Eq property from E** (object identity preserved across grants; two paths to the "same" object compare equal under `===`/`Eq`).

**§the-cryptographic-rotation-vs-object-identity-tension as named open question** (first-explicit-observation): a known capability-system property (Pass-Invariant Eq from E) cited by name as a constraint that the rotation story has to preserve. The design names this as `Open Question 1`, points at where it'll be addressed (`daemon-agent-network-identity`), and explicitly defers: "the Gateway only needs to accept multi-key registrations and let policy decide which keys to keep".

## §the-deferred-virtual-users-variant as named future-mode-extension (first-explicit-observation)

The design names a **second deferred variant**: a "daemon hosting service" config in which the Gateway manages **virtual users** rather than addressing system-level User Daemons. "In that variant the Gateway holds the formula stores and the agent powers directly (one logical User Daemon per virtual user, all in-process), instead of relaying to N OS processes." The interfaces above are written so that a virtual-users variant can implement the same `UserDaemon` exo internally. **The current design constrains its scope to one mode-pair while explicitly leaving the door open for a third mode.**

**§the-scope-cutoff-with-named-future-mode pattern** (first-explicit-observation): a design that names what it is **not** doing, with the interface shape that the future variant will reuse.

## §the-reverse-proxy-as-optional-operator-add for TLS, not Gateway-built-in (first-explicit-observation)

"Operators who want TLS in front of the browser path are free to put a reverse proxy in front of the Gateway, but the Gateway does not do TLS itself." Three named reverse proxies (Caddy + nginx + Traefik). The Gateway pushes TLS termination *outside the binary entirely*, treating it as **operator policy on the deployment**, not a built-in option.

**§named-out-of-scope-with-named-third-party-replacements shape** (first-explicit-observation): a design that explicitly delegates a function to named external software rather than carrying that function as a configurable knob.

## §five-distinct-platform-service-manager-targets (first-explicit-observation)

The design enumerates **five named platform-service-manager-targets** for the Gateway:

1. **Linux**: systemd unit (`endo-gateway.service`).
2. **macOS**: launchd `LaunchDaemon` plist under `/Library/LaunchDaemons/`.
3. **Windows**: Windows Service via `sc.exe` or SCM API.
4. **Container** (Docker / Podman / Kubernetes): no platform service manager inside the container; the **container runtime IS the service manager**.
5. **AppImage**: cannot install system services directly; offers Gateway only as a "save this unit file and `systemctl --user link` it" prompt, not a one-click install.

**§the-`Platform service management IS the supervisor`-principle as named architectural-decision** (first-explicit-observation): "The Gateway does not implement its own singleton enforcement beyond what the platform's service manager already provides. systemd on Linux, launchd on macOS, the Service Control Manager on Windows, the container runtime in containers; each enforces 'one instance' by being the thing that started it." This is **the-singleton-is-the-thing-that-started-the-process**, not a lock file, not a PID file, not a discovery dance — *whoever started me is the singleton enforcer*.

**§the-platform-singleton-by-supervisor pattern** (first-explicit-observation): instead of carrying singleton-enforcement code, the design points at five external supervisors and declares "one of these will be running; that's where the singleton-ness lives". **Pushes the responsibility outward to the platform**, keeping the binary state-light.

## §the-Affected-Designs-table as named cross-document-impact-shape (first-explicit-observation in this design's pattern)

A 15-row table at the end naming **each affected design + how it changes**. This is **§the-Affected-Designs-table-as-named-section**: every dependency or affecting relationship is enumerated, not implicit. Compare cycle 275's `Affected packages` list and cycle 281's `What changes in the existing library` — this is a third named shape for naming implementation blast radius.

**§three-named-shapes-for-naming-implementation-blast-radius** (extends cycle 281's two-shape pattern):

- cycle 275 `Affected packages` list (package-set granularity)
- cycle 281 `What changes in the existing library` (library-shape narrative)
- cycle 283 `Affected Designs` table (design-document granularity with per-design relationship)

This is the **third cycle** with explicit named blast-radius — the pattern is now `three-cycles-with-named-blast-radius-shapes`.

## §the-Source-field with-provenance-chain (first-explicit-observation in design-metadata)

The metadata table includes a **Source field**: "Issue [#173](...) (extracted from PR [#134](...) `feat(docker,daemon): docker self-hosting` review at 2026-05-10T06:14:41Z)". This is a **three-link provenance chain**: design extracted from issue extracted from PR-review-comment at a named timestamp.

**§the-provenance-chain-as-named-design-metadata-field** (first-explicit-observation): the Source field is itself a *trace of how this concern surfaced*, not just a pointer. This is **`design ← issue ← PR-review-comment(timestamp)`** as a named provenance shape — the design's existence is grounded in a specific review interaction at a specific instant.

## Patterns from prior cycles, reaffirmed

- **§five-cycles-now with explicit-capability-by-construction** — extends the canonical caretaker-two-facet-pattern. The Gateway is **the-relay-IS-incapable-of-reading-OCapN-frames-by-construction** (Noise terminates at the User Daemon, not the relay). Confined-by-construction sees one more cycle.
- **§the-`Status: Proposed`-vs-`Status: Not Started`-vs-other-statuses** — Cycle 283 is `Proposed` status, the same as 279 cli-edit-verb and 281 garden-driver-design. Three cycles with `Proposed` status. **§three-cycles-with-Proposed-Status (279 + 281 + 283).**
- **§the-document-acknowledges-its-own-evolution-within-the-document** — Updated field carries a parenthetical list of the review pass that the version reflects: "*Updated 2026-05-10 (review pass: no TLS, Noise netlayer, /ocapn WS, Host→CAS, separate config trees, defer key rotation, defer daemon-hosting variant)*". This is the **fourth** cycle with this shape (269 + 279 + 281 + 283).
- **§named-author-format `Name (prompted)`** — the canonical Endo design-doc author convention is honored (single author this time).

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-same-binary-two-configurations-pattern + §the-host-scope-vs-user-scope-split + §outbound-registration-from-many-to-one + §public-key-keyed-routing-table + §the-local-IPC-socket-IS-the-local-attestation + §the-proof-of-possession-step-IS-distinct-from-local-attestation + §the-domain-separation-prefix-on-the-nonce + §the-Noise-not-TLS-decision + §the-ciphertext-passing-relay + §the-frame-level-relay-without-CapTP-inspection + §the-content-addressed-cache-served-direct-from-the-relay + §the-rebuild-from-registrations-on-restart + §the-404-not-503-for-absent-daemon + §the-fall-back-when-no-Gateway-detected + §the-`Resolved by review`-section + §two-named-design-tracking-sections-as-decision-pair + §one-process-many-keys + §the-`Pass-Invariant-Eq`-named-open-question + §the-deferred-virtual-users-variant + §the-reverse-proxy-as-optional-operator-add + §five-distinct-platform-service-manager-targets + §the-platform-singleton-by-supervisor + §the-Affected-Designs-table + §the-provenance-chain-as-named-design-metadata-field — all twenty-four first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §three-named-rejected-alternatives-with-reasons + §three-named-consequences-of-cryptographic-protocol-choice + §the-three-tier-cache-then-relay-then-CapTP-shape + §three-named-policy-domains-as-named-separation-criteria + §named-protocol-layer-ownership-split + §three-cycles-with-Proposed-Status (279 + 281 + 283) + §three-cycles-with-named-blast-radius-shapes (275 + 281 + 283) + §four-cycles-with-design-acknowledging-its-own-evolution (269 + 279 + 281 + 283).
- **Tier 3 (multi-cycle pattern recognition)**: §two-cycles-with-meta-design-ingest from endo-but-for-bots/designs (cycles 265 + 283 on `designs/`, plus 281 from garden/designs; so really three cycles ingesting meta-designs from named `designs/` directories) + §the-Source-field-as-named-design-metadata + §the-channel-IS-the-property-shape generalizing prior §explicit-confinement-by-omission (234 + 238 + 259 + 283).

## Synthesis target

Slot machine library `@game/server` two-mode binary: same compiled artifact as `--mode=lobby` (host-scope front-door, one TCP port, routes player sessions by public key) vs `--mode=table` (per-table game logic, registers outbound with the lobby). The lobby holds **only** the public-key → table-connection routing table; the table owns the game state, the player-action handlers, and the deterministic-replay log. Session confidentiality between player and table is provided by Noise inside a WebSocket frame (so the lobby cannot tamper with player actions even if compromised); static asset delivery (rule sheets, sprite atlas) is served directly out of the lobby's content-addressed cache after the table publishes the tree-root hash. A standalone single-table developer install runs in `--mode=table` and binds its own port; in production, the table detects the lobby and registers outbound instead. The lobby's restart re-builds the table table from incoming registrations. Lobby + table service-manager targets: systemd + launchd + Windows Service + container + AppImage. Absent-table response is 404 (cacheable, no leak of which tables exist). The platform service manager IS the singleton enforcer.

## Single most structurally interesting move

**§the-same-binary-two-configurations** combined with **§the-platform-singleton-by-supervisor** — the design pushes singleton-enforcement entirely outside the binary (to whichever of five named platform service managers is running) AND keeps the host-scope and user-scope code paths fused into one compiled artifact. The result is **a binary that is mode-selectable at startup but state-light at runtime**: no PID files, no lock files, no internal singleton dance, no per-platform service-manager glue inside the daemon. The platform supervisor runs one Gateway; the user session runs one (or more) User Daemons; the daemon never has to enforce its own cardinality.

This is `the-cardinality-IS-the-supervisor's-job` — a named architectural delegation that simplifies both the binary's source and the per-platform integration story.
