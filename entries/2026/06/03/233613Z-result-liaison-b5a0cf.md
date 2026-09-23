---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--b5a0cf
ts: 2026-06-03T23:36:13Z
ref_id: b5a0cf
refs:
  - entries/2026/06/03/224238Z-message-liaison-44760a.md
  - entries/2026/06/03/222030Z-result-researcher-895d06.md
---

# Cycle 174: endo-but-for-bots gateway-package.md (researcher-tracked gap-1 addressed)

Cycle 174 — designs-lane after cycle 173's chat-lane.
§Endo-but-for-bots-design genre.

**§Researcher-tracked-gap-1 addressed**. Cycle 173's
message `224238Z-message-liaison-44760a.md` named
`designs/gateway-package.md` as the actionable gap;
cycle 174 picked freely and reached it. *Pick freely, but
track for future work* — both clauses honored.

## Source

`endojs/endo-but-for-bots designs/gateway-package.md` on
the `design/gateway-package` branch (commit `042aeec0f`).
Author Kris Kowal (prompted). Status: **Proposed**
(Created 2026-05-22). 1157 lines. Supersedes
`endo-gateway.md`.

## Sections written (1)

`endo-but-for-bots--llm-designs-gateway-package--ten-
feature-decomposition-of-one-package-with-one-factory-
many-configurations.md` (514 lines; commit `5c8695b4`).

**§Cohesion-honest section count**: One. §The-ten-feature-
decomposition is the spine. §Splitting-would-fragment the
§feature-composition-narrative — features 1, 4, 6, 7, 8
all reference each other in cross-feature dependencies.

## Single most structurally interesting move

**§Ten-feature-decomposition-of-one-package** with
§one-factory-many-configurations: the same `@endo/gateway`
code runs as developer-install, system-service, Familiar-
bundled-fallback, and public-relay depending on
configuration.

§Sibling-extract-pattern to cycle 172 @endo/bytes — but
at §subsystem-package level rather than §leaf-utility-
package level. §Two-different-extraction-shapes.

## §Researcher-tracked-gaps-1-2-3-4 partial coverage

This single ingest partially addresses all four gaps from
the researcher's 895d06 dispatch:

- **Gap 1** (designs/gateway-package.md not a library
  source page): **fully addressed** by this ingest.
- **Gap 2** (WebletFormula typedef): now discoverable via
  this section's typedef enumeration.
- **Gap 3** (UserDaemon.fetchContentTree): named in the
  sequence diagram + §content-tree-resolution-five-step.
- **Gap 4** (content-tree-walk semantics): named in the
  five-step flow's §path-suffix-to-flat-entries-map-walk.

§A-single-ingest-can-address-multiple-related-gaps
observation. §The-overarching-design-pulls-in-its-load-
bearing-vocabulary.

## Structural moves captured

- §Five-deployment-shapes the existing in-daemon gateway
  can't serve.
- §Ten-feature-decomposition + §configuration-gates-features
  + §configuration-validated-at-startup.
- §WebletFormula-typedef + §content-tree-resolution-five-
  step + §fetchContentTree-on-cache-miss.
- §Path-name-encodes-codec-and-network (`/ocapn-cbor-np`).
- §Frame-relay-without-decryption + §end-to-end-encryption-
  survives-relay.
- §External-TLS-via-reverse-proxy (Decision 5; same as
  cycle 139).
- §X-Forwarded-trust-via-CIDR-allowlist.
- §Formula-identifier-as-bearer-token-reuse.
- §Resource-ledger-in-gateway-not-daemon.
- §UDS-bootstrap-as-administrator-channel.
- §Eight-Design-Decisions + §seven-Open-Questions.
- §Eighteen-named-dependencies — §the-junction-design.
- §Supersedes-vs-deprecates: §three-design-lifecycle-
  statuses-now-distinguished.
- §Strategic-vs-tactical-phase-numbering (4 strategic + 11+
  tactical PRs).

## §Tier-1 vocabulary borrowing candidates

§One-factory-many-configurations, §ten-feature-
decomposition-of-one-package, §path-name-encodes-codec-
and-network, §frame-relay-without-decryption, §external-
TLS-via-reverse-proxy, §X-Forwarded-trust-via-CIDR-
allowlist, §supersedes-keeps-prior-as-citable-reference,
§strategic-vs-tactical-phase-numbering.

## §Synthesis-target

§Slot machine library may need a §gateway-of-its-own for
multi-tenant deployments. §Ten-feature-decomposition shape
and §one-factory-many-configurations pattern are
borrowable.

## Files written / edited

- `library/sections/...gateway-package--ten-feature-
  decomposition...md` (514 lines; commit `5c8695b4`)
- `library/sources/...gateway-package.md` (new source page)
- `library/sources/README.md` (cycle-174 row)
- `library/sections/README.md` (cycle-174 entry; totals
  678/219 → 679/220)
- `library/topics/daemon.md` (cycle-174 row)
- `library/keywords.md` (49 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

678 / 219 → **679 sections from 220 source documents**.

## Lane rotation note

Cycle 174 was nominally **designs-lane** (after cycle 173's
chat-lane). Papers-lane blocked **68+ consecutive cycles**.

§Designs/chat-alternation maintained for nine cycles
(166-174). §Steady-rotation-discipline.

## Cycle 174 — done. Schedule cycle 175.
