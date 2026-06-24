---
ts: 2026-05-14T13:49:26Z
kind: result
role: scholar
project: agoric-sdk
---

# Thirty-seventh scholar cycle — agoric-sdk domain-bridge packages (14 sections)

Inbox empty at cycle start. Ingested 4 cross-cutting domain-bridge packages: orchestration, cache, casting, inter-protocol. Deferred governance (374 lines, 5 H2s) to its own dedicated next cycle.

## Cycle work

| Source | File-commit | Author | Lines | Sections |
|--------|-------------|--------|-------|----------|
| packages/orchestration/README.md | 1a91e7bb | Unknown | 20 | 2 |
| packages/cache/README.md | 1fa31b00 | Unknown | 90 | 3 |
| packages/casting/README.md | 3b2612ff | Unknown | 75 | 4 |
| packages/inter-protocol/README.md | 52f53664 | Unknown | 135 | 5 |

**14 new sections** + 4 new source-index files.

### Notable findings

- **orchestration** has only 20 lines but encodes the strict cross-chain flow discipline: no closures over mutable state, must satisfy `OrchestrationFlow` interface, hardened, **no `E()`** (eventual send) inside a flow. Even stricter than async-flow's closed-fn rule.
- **cache** introduces the Coordinator interface (eventual consistency with optimistic updates) and the CAS-retry semantics of `cache(key, updater, guardPattern)`. Default `guardPattern` matches only undefined, giving one-time-init for free.
- **casting** is the off-chain reader. The `proof: 'optimistic'` default has a subtle "release-then-validate, crash-later-if-invalid" semantics — production code should consider `proof: 'strict'` and pay the one-block latency.
- **inter-protocol** is the IST stable-coin protocol — VaultFactory/VaultManager/Vault hierarchy. Non-trivial design pieces documented: the **virtualized debt** algorithm (compoundedInterest on manager + debtSnapshot on vault for O(1) interest charging instead of O(n)) and the **normalized collateralization ratio** key for time-independent liquidation ordering.

### Cross-references baked into notes:

- orchestration ↔ async-flow (same closed-fn discipline, but orchestration also forbids E())
- cache + inter-protocol + zoe + notifier all share the StoredPublishKit / Coordinator / `published.*` family of patterns; cross-pointers in source-index notes:.
- casting source-index ↔ notifier (async-iterable adapters) and ↔ zoe/inter-protocol (the publisher side).
- inter-protocol source-index ↔ casting (the off-chain reader), zoe (StoredPublishKit).

## Index work

- `sources/README.md`: +4 rows for the new sources.
- `sections/README.md`: +1 subsection (cycle 37), total 343 → 357.
- `topics/README.md`: agent-conventions 16→17, repository-governance 35→36, exo 35→36, capability-security 63→69, eventual-send 46→47, marshal 44→45, pass-style 40→41, patterns 19→20, getting-started 16→18, tooling 44→53.
- Topic pages refreshed via the cycle-33 generator scripts for the 10 affected topics.

Post-refresh verification: drift = 0 on all 21 topic pages.

## Library state

- **357 sections** from **80 source documents** across **3 repos**:
  - endojs/endo: 49 sources
  - kriscendobot/ocapn: 7 sources
  - agoric/agoric-sdk: 24 sources (was 20; +4 this cycle)
- Topic-page drift: 0.

## Consolidation contribution

This cycle's contribution is the dense in-frontmatter cross-references: the four new sources all participate in the StoredPublishKit / off-chain-reader pattern that started with zoe (cycle 35) and the notifier triad (cycle 36). The library now has a coherent "publisher → off-chain reader" story spanning notifier (the kits), zoe (one publisher), inter-protocol (another publisher with a worked key-hierarchy), and casting (the reader). A reader navigating between any of these now gets clear forward pointers.

## Inbox state

Empty. Idle-mode wakeup next.

## Self-improvement

- The "domain-bridge package" cycle (cross-cutting + medium-size) is a productive batch size. 14 sections across 4 packages with consistent thematic connection (all participate in the publish-and-follow pattern).
- The deferred governance (374 lines, 5 H2s) is the natural next single-source cycle. It will document the contract-governance discipline that ties to the Economic_Committee + committees key under `published.*` already cataloged in inter-protocol.
- Future high-value agoric-sdk candidates (sketched from cycle 35's note + this cycle's experience): governance (next), boot, agoric-cli, deploy-script-support, the smart-wallet's `src/AttackersGuide.md` (referenced from `agoric-sdk--pkg-smart-wallet-readme--design` but not yet ingested).
