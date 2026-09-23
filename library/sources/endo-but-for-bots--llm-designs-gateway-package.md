---
source: designs/gateway-package.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/design/gateway-package/designs/gateway-package.md
source_branch: design/gateway-package
source_commit: 042aeec0f
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 174. Designs-lane after cycle 173's chat-lane.
  §Endo-but-for-bots-design genre.

  **§Researcher-tracked-gap-1 addressed**. The 1157-line
  overarching design driving the entire gateway-package
  phase stack (Phases 1–11+ landing as stacked PRs against
  master). Lives on the `design/gateway-package` branch
  (not master or llm yet).

  Status: **Proposed** (Created 2026-05-22). Supersedes
  `endo-gateway.md`.

  **Single most structurally interesting move**: §ten-
  feature-decomposition-of-one-package with §one-factory-
  many-configurations. The same `@endo/gateway` code runs
  as developer-install, system-service, Familiar-bundled-
  fallback, and public-relay depending on configuration.

  §Sibling-extract-pattern to cycle 172 @endo/bytes — but
  at the §subsystem-package level rather than §leaf-
  utility-package level. §Two-different-extraction-shapes:
  per-helper-surface (cycle 172) vs single-factory-many-
  feature-toggles (this).

  §Five-deployment-shapes the existing in-daemon gateway
  can't serve: per-host system service / public web service
  / Familiar-bundled-fallback / CapTP-relay-as-a-service /
  administrator handle.

  §Ten-feature-decomposition: Chat hosting + virtual
  hosting + Git HTTP + UDS bootstrap + Familiar fallback +
  public relay + admin daemon + /ocapn-cbor-np WS + HTTPS
  terminating-proxy + OS packaging. §Configuration-gates-
  features; §configuration-validated-at-startup
  (dependency graph; misconfiguration = startup error).

  §WebletFormula typedef (researcher's gap 2): `{type:
  'weblet', contentRoot, mimeTypes?, ssrHandler?,
  virtualHosts?}`. §Daemon-side-formula-type-the-gateway-
  consumes.

  §Content-tree-resolution-five-step (researcher's gaps
  3+4): Gateway lookup → virtual-host table → fetchContent-
  Tree (researcher's gap 3) → CAS resolve → bytes. §Path-
  suffix-maps-to-flat-entries-map-of-readable-tree.

  §Path-name-encodes-codec-and-network: `/ocapn-cbor-np`
  (ocapn + cbor + Noise Protocol). §Future-extensibility-
  via-naming; §bare-/ocapn-becomes-compatibility-alias.

  §Frame-relay-without-decryption: §gateway-is-a-frame-
  relay-and-never-decrypts. §Noise-handshake's-intended-
  responder-prefix tells gateway which target before
  handshake completes. §End-to-end-encryption-survives-
  relay.

  §External-TLS-via-reverse-proxy (Decision 5): §gateway-
  has-no-certificate-management. Same as cycle 139's
  daemon-docker-selfhost decision at gateway layer.

  §X-Forwarded-trust-via-CIDR-allowlist: §the-trust-
  boundary-is-the-TCP-peer-not-the-header-contents.

  §Formula-identifier-as-bearer-token-reuse (Decision 4):
  same 256-bit hex used for Chat fetch + Git HTTP auth.
  §Cycle-49 daemon-256-bit-identifiers anchors.

  §Resource-ledger-in-gateway-not-daemon (Decision 8):
  §the-gateway-is-the-layer-where-traffic-accrues.
  §Per-account-counters (compute / storage / network).
  §Payment-processor-is-out-of-scope (operator-supplied
  external exo).

  §UDS-bootstrap-as-administrator-channel (Decision 7):
  §admin-authority-is-not-on-the-network-surface. §Two-
  gates: filesystem permissions + proof-of-possession.

  §Eight-Design-Decisions + §Seven-Open-Questions
  (honest-deferral parallel to cycles 149/170/172).

  §Eighteen-named-dependencies — largest dependency table
  in the design corpus. §The-junction-design where daemon,
  Familiar, and OCapN stacks meet.

  §Supersedes-vs-deprecates: §three-design-lifecycle-
  statuses-now-distinguished — Deprecated (cycle 99 chat-
  reply-chain), Supersedes-but-keeps-decisions (this),
  Revision-note-refined-not-deprecated (cycle 107 daemon-
  agent-tools). §Each-has-different-archival-shape.

  §Four-phase-strategic-rollout vs §sub-phase-explosion at
  builder level (Phases 7, 10, 11a, 11b are §tactical-PRs
  within strategic Phase 1+2). §Strategic-vs-tactical-
  phase-numbering observation.

  §Researcher-tracked-gaps-1-2-3-4 partially addressed by
  this single ingest. §A-single-ingest-can-address-
  multiple-related-gaps.

  §Tier-1 vocabulary borrowing: §one-factory-many-
  configurations + §ten-feature-decomposition-of-one-
  package + §path-name-encodes-codec-and-network + §frame-
  relay-without-decryption + §external-TLS-via-reverse-
  proxy + §X-Forwarded-trust-via-CIDR-allowlist +
  §supersedes-keeps-prior-as-citable-reference + §strategic-
  vs-tactical-phase-numbering.

  §Synthesis-target: §slot-machine-library may need a
  §gateway-of-its-own; the §ten-feature-decomposition shape
  is borrowable.

  Cycle 174 was nominally designs-lane. Papers-lane blocked
  68+ consecutive cycles.
---

> Abstract: `designs/gateway-package.md` (1157 lines) is
> the **§overarching-design-driving-the-entire-gateway-
> package-phase-stack**. Status: **Proposed**; supersedes
> `endo-gateway.md`.
>
> **§Researcher-tracked-gap-1 addressed** (cycle 173's
> message `224238Z`). Cycle 174 picked freely; this design
> aligned with the natural designs-lane slot.
>
> **Single most structurally interesting move**: §ten-
> feature-decomposition-of-one-package with §one-factory-
> many-configurations. Same `@endo/gateway` code runs as
> developer-install, system-service, Familiar-bundled, and
> public-relay via configuration.
>
> §Sibling-extract-pattern to cycle 172 @endo/bytes — but
> at §subsystem-package level rather than §leaf-utility-
> package level.
>
> §WebletFormula typedef + §fetchContentTree + §content-
> tree-walk semantics — researcher's gaps 2/3/4 partially
> addressed alongside.
>
> §Frame-relay-without-decryption; §end-to-end-encryption-
> survives-relay. §External-TLS-via-reverse-proxy.
> §X-Forwarded-trust-via-CIDR-allowlist.
>
> §Supersedes-vs-deprecates: §three-design-lifecycle-
> statuses-now-distinguished.
>
> §Strategic-vs-tactical-phase-numbering (4 strategic
> phases; 11+ tactical builder PRs).
>
> §Tier-1 borrowing: §one-factory-many-configurations,
> §ten-feature-decomposition-of-one-package, §path-name-
> encodes-codec-and-network, §frame-relay-without-
> decryption, §external-TLS-via-reverse-proxy,
> §supersedes-keeps-prior-as-citable-reference,
> §strategic-vs-tactical-phase-numbering.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [ten-feature-decomposition-of-one-package-with-one-factory-many-configurations](../sections/endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations.md) | daemon, tooling, capability-security | current |

One cohesion-honest section. §The-ten-feature-decomposition
is the spine.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@design/
  gateway-package` (commit `042aeec0f`).
- Author: Kris Kowal (prompted).
- §Researcher-tracked-gap-1 addressed by this ingest.
- Cycle 174 was nominally **designs-lane**.
- One cohesion-honest section.
