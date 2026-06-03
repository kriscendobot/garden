---
source: designs/gateway-package.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/design/gateway-package/designs/gateway-package.md
source_path: designs/gateway-package.md
source_branch: design/gateway-package
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 174
lane: designs
status: current
---

# Ten-feature decomposition of one package with one factory and many configurations

> §Endo-but-for-bots-design genre (designs-lane). §The-
> researcher-tracked-gap from cycle 173's message
> `224238Z-message-liaison-44760a.md` (gap 1 of 4). Picked
> freely on cycle 174's natural designs-lane slot per
> *Pick freely, but track for future work*.
>
> Status: **Proposed**. Created 2026-05-22. Supersedes
> [`endo-gateway`](endo-gateway.md). Lives on the
> `design/gateway-package` branch (not master or llm).

`designs/gateway-package.md` (1157 lines) is the
**§overarching-design-driving-the-entire-gateway-package-
phase-stack** (Phases 1–11+ landing as stacked PRs against
`master`). Every gateway-phase dispatch reads it; the
library previously proxied it through per-phase result
entries (Phase 7, 10, 11a builder results). Ingesting
compresses that chain.

The single most structurally interesting move is the
**§ten-feature-decomposition-of-one-package** with
§one-factory-many-configurations — the same `@endo/gateway`
code runs as developer-install, system-service, Familiar-
bundled-fallback, and public-relay depending on
configuration.

## §The-gateway-becomes-a-thing-in-its-own-right

> *The shorter framing: **the gateway is becoming a thing
> in its own right; give it a package.***

§Extract-pattern parallel to cycle 172's @endo/bytes (also
extract-into-own-package), but **at the full subsystem
level** rather than the utility-helper level.

§Five-deployment-shapes the existing in-daemon gateway
can't serve:

1. Per-host system service (virtual-host many users on one
   address; UNIX-domain bootstrap socket).
2. Public web service (internet-reachable; Chat + Git +
   OCapN-Noise WS + weblets).
3. Familiar-bundled fallback (OS-assigned port; single
   user; no UDS).
4. CapTP relay-as-a-service (customers or public).
5. Administrator handle (system admin, distinct from user
   daemon authority).

§A-single-binary-configuration-cannot-serve-all is the
forcing function. §Configuration-gates-features.

## §One-factory-many-configurations

```ts
import { make } from '@endo/gateway';

const gateway = await make({
  powers, config, hostAgent, trustedProxy,
});
await E(gateway).start();
```

§Single-entry-point. §The-config-record-decides-the-deployment-
shape. §Same-code-different-feature-set.

§Cycle-172-@endo/bytes had §per-helper-surface-no-barrel;
this design has §single-factory-many-feature-toggles. §Two-
different-extraction-shapes:

- §Leaf-utility (cycle 172): per-helper imports, no
  configuration; the user picks helpers à la carte.
- §Subsystem-package (this): single factory, runtime
  configuration; the user gets the whole subsystem with
  features gated.

§Both-are-valid-extraction-shapes; §the-choice-depends-on-
what-the-package-does.

## §Ten-feature-decomposition

| # | Feature | Phase |
|---|---------|-------|
| 1 | Chat hosting + payment-token enhancement | 2 (no payments) / 4 (reference adapter) |
| 2 | Virtual hosting (Host → Weblet formula) | 1 |
| 3 | Git over HTTP (formula-id bearer token) | 3 |
| 4 | UDS bootstrap for local CapTP relay registration | 2 |
| 5 | Familiar-bundled fallback on OS-assigned port | 3 |
| 6 | Public CapTP relay | 4 |
| 7 | Admin daemon | 2 (after UDS) |
| 8 | `/ocapn-cbor-np` WebSocket subprotocol | 1 |
| 9 | HTTPS terminating proxy compatibility | 4 |
| 10 | OS packaging (rpm/deb/PKGBUILD/Docker) | 4 |

§Each-feature-named-with-what-it-is + §how-it-composes-
with-existing-corpus + §which-questions-it-leaves-open.

§Feature-decomposition-encodes-the-maintainer-directive:
the design's "Problem" section reproduces the directive's
ten-feature list as the §scope-contract.

§Configuration-validated-at-startup: the `make({ ... })`
factory validates the dependency graph (relay needs
UDS+ocapn; admin needs UDS). §Misconfiguration-is-startup-
error not-runtime-discovery.

## §The-§WebletFormula-typedef (researcher's gap 2)

```ts
interface WebletFormula {
  type: 'weblet';
  contentRoot: FormulaIdentifier;       // readable-tree
  mimeTypes?: Record<string, string>;
  ssrHandler?: FormulaIdentifier;
  virtualHosts?: ReadonlyArray<string>;
}
```

§The-load-bearing-typedef-for-Phase-11b (which the
researcher's 895d06 dispatch refined a builder prompt
for). §Daemon-side-formula-type-the-gateway-consumes.

§Three-optional-fields encode §progressive-customization:
mimeTypes (per-extension MIME overrides), ssrHandler
(SSR-route handler called via CapTP), virtualHosts
(explicit bind names).

§§Researcher-gap-2-addressed: ingesting this section makes
the WebletFormula typedef discoverable in the library;
the Phase 7 builder result remains the canonical
implementation source, but the design's typedef is now
indexed.

## §The-§content-tree-resolution-five-step (researcher's gap 3+4)

```mermaid
Client → GW: GET /index.html, Host: chat.example.com
GW: lookup virtual host → webletFormulaId
GW → CAS: read contentRoot/index.html
  on miss: GW → UD: fetchContentTree(root)
GW → Client: 200 OK, bytes
```

§The-five-step-path:

1. Gateway receives request with Host header.
2. Gateway looks up Host in virtual-host table →
   webletFormulaId.
3. Gateway fetches weblet formula from user daemon (or
   cache).
4. Gateway resolves path-suffix against
   webletFormula.contentRoot (a `readable-tree`).
5. Gateway serves bytes directly from CAS with mimeTypes
   overrides.

§Researcher-gap-3-addressed: `fetchContentTree` named as
the daemon-side capability the gateway invokes on cache
miss. §The-exo-the-Phase-11a-result-entry-named-as-
contract-surface.

§Researcher-gap-4-addressed: the §content-tree-walk maps
path-suffix → flat-entries-map of the `readable-tree`.
§Cycle-141-daemon-cas-management section already pins the
mechanism; this design names the consumer-side shape.

## §`/ocapn-cbor-np`-WebSocket-subprotocol (Feature 8)

> *The path encodes the codec/network pair (CBOR + Noise
> Protocol) so future siblings (`/ocapn-syrups-tcp`,
> `/ocapn-cbor-tls`) can coexist without renaming the
> OCapN slot.*

§Path-name-encodes-codec-and-network:
- `ocapn`: protocol family
- `cbor`: payload codec
- `np`: Noise Protocol network identifier

§Future-extensibility-via-naming. §Bare-`/ocapn`-becomes-
compatibility-alias.

§Revises-endo-gateway's-`/ocapn`-decision. §Naming-as-
extension-point pattern; §don't-collide-on-the-bare-name.

§Cycle-167's-protocol-suffix-in-socket-names (captp0
default) is the §sibling-discipline at the socket-path
layer. §Both-name-the-protocol-version-in-the-resource-
name.

## §Frame-relay-without-decryption (Feature 6)

> *The gateway sees only Noise-encrypted ciphertext after
> the handshake; relay targets receive the same ciphertext
> and complete the handshake themselves.*

§Gateway-is-a-frame-relay-and-never-decrypts. §End-to-end-
encryption-survives-the-relay.

§Noise-handshake's-intended-responder-prefix tells gateway
which target to forward to **before handshake completes**.
§Routing-decided-from-cleartext-prefix; §encrypted-body-
passes-through.

§Cycle-162's-Ken-protocol-FIFO-via-TCP-not-receive-side-
reordering has the §borrow-property-from-lower-layer
sibling: there, FIFO comes from TCP; here, encryption +
peer-auth come from Noise.

§The-gateway-doesn't-need-to-be-a-trusted-third-party:
it routes ciphertext but cannot read it. §Confidentiality-
survives-relay.

## §External-TLS-via-reverse-proxy (Feature 9)

> *The gateway does **not** terminate TLS itself.*

§Gateway-has-no-certificate-management-no-ACME-client-no-
cipher-suite-configuration.

§External-TLS-via-reverse-proxy (nginx, Caddy, Cloudflare,
Traefik).

§Cycle-139-daemon-docker-selfhost named this at the daemon
layer (§design-as-deferral; TLS is a proxy concern); this
design extends it to the gateway. §Same-decision-different-
layer.

§Why-this-is-good: §avoids-bundling-certificate-management
(Let's Encrypt renewal, OCSP stapling, TLS suite selection
are non-trivial moving targets).

§Defense-in-depth: HTTPS on the OCapN endpoint is *only*
defense-in-depth; OCapN's confidentiality is provided by
Noise in-band per cycle 162's Ken / cycles 119/137 envelope
+ streaming.

## §X-Forwarded-trust-model

> *The gateway must trust them only when the immediate TCP
> peer is a configured proxy.*

§CIDR-allowlist-of-trusted-proxies. §Requests-from-outside-
allowlist-treated-as-direct-client (X-Forwarded ignored,
TCP peer IP is client IP, Host header at face value).

§The-trust-boundary-is-the-TCP-peer-not-the-X-Forwarded-
contents. §Forwarded-headers-are-trustable-only-from-
trusted-peers.

§Two-config-parameters: §CIDR-allowlist + §max-hops-to-
trust. §Both-named.

## §Formula-identifier-as-bearer-token-reuse (Decision 4)

> *The 256-bit hex identifier already represents authority
> over the formula it identifies; the Git endpoint and the
> Chat endpoint use the same tokens for the same authority
> semantics.*

§Reuse-existing-credential-not-new-credential. §Cycle-49's-
daemon-256-bit-identifiers + §gateway-bearer-token-auth
already establish this; the new gateway extends the use.

§Same-token-different-resource: Chat fetch and Git HTTP
both consume the 256-bit hex. §No-new-token-vocabulary.

§HTTP-Basic-with-empty-username-and-token-as-password is
the §de-facto-Git-convention; §HTTP-Bearer is the
alternative; §the-gateway-accepts-both.

## §Resource-ledger-in-gateway-not-daemon (Decision 8)

> *The gateway is the layer where HTTP/WS traffic accrues;
> it is the natural place to meter and gate.*

§Per-account-resource-counters (compute seconds, storage
bytes, network bytes). §getBalance + §chargeBalance +
§purchaseTokens.

§The-Chat-weblet-renders-purchase-UI-but-doesn't-own-
accounting-state; §the-gateway-does.

§Payment-processor-is-out-of-scope: the gateway holds an
abstract `PaymentProcessor` exo contract; the actual
processor (Stripe / Coinbase Commerce / Lightning) is
operator-supplied.

§Cycle-94's-OCPL paper's §principle-of-least-authority
informs the §payment-proof-validation-by-external-exo
split.

## §UDS-bootstrap-as-administrator-channel (Decision 7)

> *Admin authority is not on the network surface.*

§GatewayAdmin-exo-accessible-only-over-UDS. §Never-on-
public-HTTP-surface.

§The-administrator-handle-is-the-UDS-bootstrap-itself:
filesystem permissions on the socket gate who-may-connect;
proof-of-possession gates which-public-keys-may-register.

§Two-gates-with-different-roles: §filesystem-permissions
+ §cryptographic-proof-of-possession.

§Cycle-170's-§three-layer-architecture has a sibling
shape: §authority-is-which-capabilities-you-can-reach via
*which channel*. The UDS channel reaches more
capabilities than the public network channel does.

## §Eight-Design-Decisions enumerated

1. Extract-the-gateway-into-its-own-package.
2. `0.0.0.0:3469` default with `ENDO_HTTP_ADDR` override.
3. `/ocapn-cbor-np` rather than bare `/ocapn`.
4. Formula identifier as bearer token (reuse).
5. No TLS in the gateway.
6. Gateway and daemon are separate processes, not separate
   binaries (same package; different embeddings).
7. UDS bootstrap is the administrator's access channel.
8. Per-account resource ledger lives in the gateway.

## §Seven-Open-Questions enumerated

1. Payment-token mechanism (which processor).
2. Abuse-prevention model for the public relay.
3. Virtual-host name allocation across users (collision
   resolution).
4. Rotation story for formula-identifier bearer tokens
   (inherits Pass-Invariant-Eq follow-up).
5. Multi-tenant filesystem isolation for the per-user CAS.
6. `@endo/gateway` vs `@endo/web-gateway` (naming).
7. Migration of the existing in-daemon `web-server-node.
   js` (builder-level transition).

§Honest-deferral-discipline (parallel to cycle 170's seven
open questions, cycle 149's three).

## §Eighteen-named-dependencies

The largest dependency table in the design corpus so far
(18 entries):

§Internal-Endo: endo-gateway (superseded), daemon-web-
gateway, daemon-weblet-application, weblet-next.

§Familiar-stack: familiar-unified-weblet-server, familiar-
gateway-migration, familiar-chat-weblet-hosting, familiar-
localhttp-protocol, familiar-bundled-agents, familiar-
daemon-bundling, familiar-electron-shell.

§OCapN-stack: ocapn-noise-network, ocapn-noise-
cryptographic-review, ocapn-network-transport-separation,
daemon-256-bit-identifiers, ocapn-tcp-syrups-framing,
ocapn-tcp-for-test-extraction.

§Auth-stack: gateway-bearer-token-auth.

§This-is-the-junction-design where the daemon, Familiar,
and OCapN stacks meet. §The-dependency-table-tells-you-
that.

## §Supersedes-vs-deprecates

> *Supersedes [`endo-gateway`](endo-gateway.md).*

§Supersedes-≠-deprecates. The prior `endo-gateway` design
is **not** removed; its specific decisions carry forward
unless explicitly revised.

§Three-design-lifecycle-statuses-now-distinguished in the
library:
- **Deprecated** (cycle 99's chat-reply-chain): fully
  removed.
- **Supersedes-but-keeps-decisions** (this design): prior
  design is reference; new design extends.
- **Revision-note-refined-not-deprecated** (cycle 107's
  daemon-agent-tools): prior design carries forward with
  named successors that refine specific aspects.

§Each-has-a-different-archival-shape. §Supersedes-keeps-
the-prior-as-citable-reference.

## §Four-phase-rollout

| Phase | Content |
|-------|---------|
| 1 | Package skeleton + feature 2 (vhost) + feature 8 (OCapN-WS) |
| 2 | Feature 4 (UDS) + feature 7 (admin) + feature 1 (Chat + ledger) |
| 3 | Feature 5 (Familiar-bundled) + feature 3 (Git HTTP) |
| 4 | Feature 6 (relay) + feature 9 (HTTPS proxy) + feature 10 (OS packaging) + payment-processor adapter |

§Phases-are-sequential-on-critical-path (1+2 deliver
feature parity with existing in-daemon gateway). §Phases-
3-and-4-are-independently-order-able after Phase 2.

§Cycle-172's-decoupled-rollout has a sibling shape; the
gateway design is larger so the phase boundaries are §at-
the-subsystem-level not §at-the-helper-level.

## §The-Phase-11b-context (why this design matters now)

The researcher's 895d06 dispatch was refining a Phase 11b
builder prompt. Phase 11b is part of a §sub-phase-
explosion within Phase 1 — the high-level four-phase
breakdown above has been sub-divided into 11+ builder PRs
landing incrementally.

§Phase-numbering-asymmetry: the design's "Phase 1"
roadmap is the §strategic-level; the builder PR sequence
("Phase 7", "Phase 10", "Phase 11a", "Phase 11b") is the
§tactical-level. §The-strategic-design-and-tactical-
phasing-are-different-numberings.

§Synthesis-target: future overarching designs should
distinguish §design-phases (the strategic milestones) from
§PR-phases (the tactical landing chunks). §Two-different-
numberings-with-different-purposes.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 172 (@endo/bytes) | §Sibling-extract-into-own-package (leaf utility); this is the §subsystem-package shape |
| 170 (daemon-capability-filesystem) | §Wider-vision-document parallel (Reference status); this design is the §strategic-overarching-design for gateway |
| 168 (daemon-checkin-checkout) | §Pair-design discipline (this with daemon-weblet-application + endo-gateway) |
| 161 (filesystem-watchers) | §Sourced-from-Issue precedent; this design is §sourced-from-maintainer-directive |
| 137 (daemon-message-streaming) | §Stream-formula sibling; gateway's CAS-content-stream uses similar shape |
| 141 (daemon-cas-management) | §The-CAS-substrate the gateway dereferences |
| 139 (daemon-docker-selfhost) | §External-TLS-via-reverse-proxy decision shared |
| 49 (daemon-256-bit-identifiers) | §Formula-identifier-as-bearer-token reuse anchor |

## §Tier-1 vocabulary borrowing candidates

§One-factory-many-configurations (extract pattern at
subsystem level).

§Ten-feature-decomposition-of-one-package (configuration-
gates-features).

§Path-name-encodes-codec-and-network (extensibility via
naming).

§Frame-relay-without-decryption (gateway routes
ciphertext but cannot read it).

§External-TLS-via-reverse-proxy (avoid bundling certificate
management).

§X-Forwarded-trust-via-CIDR-allowlist (header trust gated
by TCP peer).

§Supersedes-keeps-prior-as-citable-reference (lifecycle
status distinct from deprecated).

§Strategic-vs-tactical-phase-numbering (design phases vs
PR phases as different planning layers).

§Tier-2: §formula-identifier-as-bearer-token (reuse
discipline), §resource-ledger-at-traffic-accrual-layer
(architectural decision about where to meter).

## §Synthesis-target

§Slot machine library may need a §gateway-of-its-own for
multi-tenant deployments. The §ten-feature-decomposition
shape and §one-factory-many-configurations pattern are
borrowable.

§Future-overarching-designs should follow §strategic-
phasing + §named-dependencies + §feature-gated-
configuration shape; this design demonstrates the form.

§Researcher-tracked-gaps-1-2-3-4 partially addressed by
this ingest: gap 1 (the design itself) fully ingested; gap
2 (WebletFormula typedef) now discoverable via this
section's enumeration; gap 3 (`fetchContentTree`) named in
the sequence diagram + content-tree-resolution-five-step;
gap 4 (content-tree-walk semantics) named in the five-step
flow. §A-single-ingest-can-address-multiple-related-gaps.

## §A-large-design-completely-ingested

1157 lines, one cohesion-honest section (the design's
§ten-feature-decomposition-of-one-package is the spine).
§Splitting-would-fragment the §feature-composition-
narrative — features 1, 4, 6, 7, 8 all reference each
other in cross-feature dependencies; §reading-the-whole-
in-one-place is the §load-bearing-shape.

§Sibling-to-cycle-170's-966-line-reference-vision: both
designs are §strategic-level documents. This is Proposed
(active); that is Reference (active alternatives queued).
§Different-statuses-different-archival-roles.
