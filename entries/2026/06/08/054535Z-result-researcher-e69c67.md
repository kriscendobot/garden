---
ts: 2026-06-08T05:45:35Z
kind: result
role: researcher
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - dispatches/researcher--e69c67
---

# Result: researcher refinement for proposed designer dispatch on daemon-move-transfer-negotiation

The proposed designer prompt asks for a design at
`designs/daemon-move-transfer-negotiation.md` (on the `llm` branch of
`endojs/endo-but-for-bots`) that generalizes the daemon's `move` command into a
negotiated transfer-mechanism family with a capability ladder from POSIX
atomic rename through cross-peer out-of-band data-plane transfers. The
refinement below grounds each load-bearing term in the existing library:
`move` is the EndoMount mutation method per daemon-mount; CAS-internal moves
and atomic-rename-after-write live in daemon-cas-management and
daemon-content-store-gc; the sealer/unsealer / grant-matching idiom maps onto
the library's brand-and-trademark concept; out-of-band data-plane carriage
appears in daemon-value-message (envelope vs out-of-band) and the
ocapn-network-transport-separation refactor. Cross-design coordination
citations are concrete.

The orchestrator should inline the fenced block below verbatim into the
designer dispatch prompt (typically before the *Acceptance* / *Report*
sections, after the task statement).

```markdown
## Library and project references

The garden's library carries substantial prior material on each load-bearing
term in this prompt. Consult these references early; the design must read,
cite, and cross-link these where the cited material is load-bearing.

### Library concepts and sections

- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement.md)
  is the canonical reference for the current `move` shape: it is one of the
  five method groupings on `MountInterface` (reads + mutation + attenuation +
  snapshot + help) sharing the same exo across `mount` (host-managed) and
  `scratch-mount` (daemon-managed). The current design is path-based not
  inode-based and names `POSIX *at family` (`openat`, `renameat`, `fstatat`,
  `mkdirat`) explicitly as the future-hardening target on supervisors that
  support it. The new design's ladder builds on top of this section.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md)
  is the CAS verb surface (`cas-store`, `cas-fetch`, `cas-has`,
  `cas-retain`, `cas-release`, `cas-store-tree`, `cas-gc`) plus the
  streaming variants `cas-store-stream` / `cas-content-stream`. CAS-internal
  moves between two CAS-pinned formulas collapse to retain/release on the
  same hash; the design must name this tier explicitly. Also see the
  flushed-to-meta atomic write-rename pattern (sidecar JSON).
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension.md)
  defines sweep-time refcount semantics for `readable-blob` / `readable-tree`
  content. A move whose source and target are both formula-store-resident
  reduces to refcount changes, not byte motion; the design must align with
  the sweep-time refcount discipline rather than introduce a parallel
  durable counter.
- [`journal/library/sources/endo-but-for-bots--llm-designs-daemon-256-bit-identifiers.md`](../../../journal/library/sources/endo-but-for-bots--llm-designs-daemon-256-bit-identifiers.md)
  is the canonical reference for the grant-matching equality primitive at
  the daemon level: peer ID *is* the Ed25519 public key, formula numbers
  are 256-bit. Two endpoints establishing "we refer to the same thing"
  hinges on the formula-address brand defined here. The library's
  [`brand-and-trademark`](../../../journal/library/concepts/brand-and-trademark.md)
  concept page covers the sealer/unsealer primitive itself; the daemon's
  256-bit address equality is the concrete realization.
- [`journal/library/sources/endo-but-for-bots--llm-designs-ocapn-network-transport-separation.md`](../../../journal/library/sources/endo-but-for-bots--llm-designs-ocapn-network-transport-separation.md)
  is the OCapN substrate the cross-peer fallback rides on. The design's
  `OcapnNetwork.connect(location)` returns a session, not a raw connection;
  the netlayer is where "data plane capabilities" become observable to the
  negotiation. Specifically the `design-conceptual-model` section.
- [`journal/library/concepts/brand-and-trademark.md`](../../../journal/library/concepts/brand-and-trademark.md)
  is the canonical sealer/unsealer primitive page. The maintainer's hint
  "grant matching equality, with a sealer or unsealer" maps directly to
  this concept: a sealer/unsealer pair lets two endpoints prove a shared
  substrate (same filesystem, same mount, same host, same git remote)
  without leaking the substrate's identity to non-holders. The page
  enumerates the rights-amplification framing and the "types-by-fiat"
  property — both load-bearing for the negotiation protocol.
- [`journal/library/concepts/four-ways-to-acquire-references.md`](../../../journal/library/concepts/four-ways-to-acquire-references.md)
  grounds the negotiation in ocap formal terms: every transfer mechanism the
  ladder names must collapse to one of Introduction / Parenthood /
  Endowment / Initial Conditions. The cross-peer out-of-band tier
  (Git push/pull) is Introduction via a side channel; the negotiation
  protocol's grant-matching is the structural verification that the
  introduction does not leak authority outside the pair.
- [`journal/library/sections/endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface.md)
  carries the cap-not-string-mounts discipline: the transfer mechanism the
  ladder picks must be capability-resolved (a `Mount` capability), never a
  string host path. This rule applies as a *constraint* on the negotiation:
  the design must not introduce a back door whereby the negotiation surfaces
  a host path to either endpoint.
- [`journal/library/sections/endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design.md`](../../../journal/library/sections/endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design.md)
  carries the existing *envelope-vs-out-of-band carriage* open question in
  the library. The new design's negotiation must take an explicit stance on
  whether the negotiation token rides the message envelope or is exchanged
  via a side channel — the value-message page is the prior art on the
  trade-off.

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../../journal/projects/endo-but-for-bots/README.md)
  carries the project's standing rules: designs land DRAFT against the `llm`
  branch (§ Rules of engagement), the standing relaxation lets the designer
  PR open without per-action authorization (§ Standing authorizations), and
  every commenter on the repo is maintainer-equivalent for routing purposes
  (§ Authority structure). The designer can post the PR and reply on inline
  threads without additional authorization.
- Related designs on the `llm` branch the designer should cite by relative
  path from the new `designs/daemon-move-transfer-negotiation.md`:
  - `designs/daemon-mount.md` (the current `move` method's home; the design
    extends or supersedes mutation semantics on `MountInterface`).
  - `designs/daemon-cas-management.md` (CAS verbs the in-band tier uses;
    the design names which verbs the negotiation traffics in).
  - `designs/daemon-content-store-gc.md` (refcount semantics; the design
    must align with sweep-time refcount, not introduce a parallel counter).
  - `designs/daemon-256-bit-identifiers.md` (the address-equality primitive
    grant matching builds on).
  - `designs/daemon-capability-filesystem.md` (the wider vision; mount is
    its concrete subset; the negotiation may extend the vision's surface).
  - `designs/daemon-checkin-checkout.md` (the snapshot/restore round-trip;
    cross-host transfer via snapshot-then-restore is one ladder tier).
  - `designs/ocapn-network-transport-separation.md` (the netlayer substrate
    that carries the cross-peer in-band CapTP fallback; the design names
    which network capabilities expose data-plane affordances).
  - `designs/ocapn-noise-network.md` (the Ed25519 peer-identification
    substrate; the design names how the grant-matching token is bound to
    the peer key).
  - `designs/daemon-locator-terminology.md` (the Peer Key / Formula
    Address brand types the negotiation references).
  - `designs/daemon-value-message.md` (the prior envelope-vs-out-of-band
    open question; the design must take a stance).
  - `designs/endo-posix-sandbox.md` (the cap-not-string-mounts discipline
    the negotiation must honor).

### Why each reference is relevant

- daemon-mount: defines today's `move`; the new design extends or
  supersedes its mutation surface.
- daemon-cas-management: the in-band CAS-internal tier collapses to verb
  calls; the streaming variants cover the same-host file-too-large case.
- daemon-content-store-gc: refcount semantics for CAS-internal moves; the
  design must not introduce a parallel counter.
- daemon-256-bit-identifiers: the address-equality primitive grant-matching
  rests on; peer ID *is* the Ed25519 public key.
- ocapn-network-transport-separation: the netlayer substrate the cross-peer
  fallback rides on; the *network* layer is where data-plane affordances
  surface.
- brand-and-trademark: canonical sealer/unsealer page; the negotiation's
  grant-matching is rights-amplification at the daemon layer.
- four-ways-to-acquire-references: the formal frame; every ladder tier
  must collapse to one of the four mechanisms.
- endo-posix-sandbox cap-not-string-mounts: a *constraint* on the
  negotiation; the design must not surface a host path to either endpoint.
- daemon-value-message envelope-vs-out-of-band: the prior open question on
  envelope vs side-channel carriage; the new design must take a stance.
- endo-but-for-bots project README: standing authorization for the
  designer to post the DRAFT PR and reply on inline threads.

### Open questions for the design

- The library does not carry a prior `transfer-mechanism negotiation`
  concept page; the design is breaking new ground on the *protocol* shape.
  The maintainer's hints (grant matching equality + sealer/unsealer) map
  the substrate to brand-and-trademark, but the *exchange shape* is a
  fresh design contribution. The librarian or gardener should consider
  drafting a `transfer-mechanism-negotiation` concept page once the design
  settles.
- The `daemon-capability-filesystem.md` design (the wider vision) is named
  in daemon-mount's dependency table but is not ingested in the library.
  The designer should check whether that vision document already names a
  transfer-negotiation primitive; if so, the new design is the concrete
  mergeable slice rather than a new direction.
- Out-of-band protocols beyond Git: the library has no prior material on
  rsync, BitTorrent, or IPFS-style content-addressable swarm transfer in
  the daemon's context. The design should treat these as *future
  extensibility* with the negotiation surface defined to permit them
  rather than enumerating today.
```

## Library writeback

Added keyword shortcuts to `journal/library/keywords.md` for the prompt's
load-bearing terms that were previously unindexed:

- `` `move` (daemon mount mutation method) `` → daemon-mount section.
- `move on mount`, `mount move`, `mutation suite (write/remove/move/makeDirectory)` → daemon-mount section.
- `POSIX rename atomicity`, ``POSIX `*at` family (openat/renameat/fstatat/mkdirat)``, `atomic rename` → daemon-mount section.
- `atomic-rename-after-write CAS` → daemon-cas-management section.
- `out-of-band transfer` → daemon-value-message section.
- `data-plane capabilities` → ocapn-network-transport-separation source.
- `grant matching equality` → brand-and-trademark concept.
- `CAS-internal move (refcount swap, no byte copy)` → daemon-content-store-gc design section.
- `streaming CAS variants (cas-store-stream / cas-content-stream)` → daemon-cas-management section.
- `cap-not-string mounts` → endo-posix-sandbox section.
- `transfer-mechanism negotiation` → flagged as no concept page yet (open).

No concept page was drafted; the `transfer-mechanism negotiation` term is
load-bearing enough that the librarian or gardener may want to draft a
concept page once the design settles and the protocol shape stabilizes.

## Open questions

- `daemon-capability-filesystem.md` (the wider vision design daemon-mount
  cites as a dependency) is not ingested in the library. If the scholar
  ingests it, the new transfer-negotiation design's relationship to the
  wider vision becomes legible. Flagged as a structural gap rather than a
  blocker.
- The library has no prior section on out-of-band transfer protocols
  (Git push/pull, rsync, IPFS) in the daemon's context. The new design is
  breaking new ground here; the scholar may want to ingest the design once
  merged so the next caller's search succeeds.

Self-improvement: nothing this time. The researcher role's procedure and
output shape fit this engagement cleanly; the keyword writeback discipline
caught all the load-bearing terms that needed shortcuts.
