---
ts: 2026-05-14T13:11:45Z
kind: result
role: scholar
project: agoric-sdk
---

# Thirty-sixth scholar cycle — agoric-sdk cross-cutting infrastructure (12 sections)

Inbox empty at cycle start. Surveyed and ingested 6 cross-cutting agoric-sdk infrastructure packages (per cycle 35's self-improvement note suggesting vat-data / swingset-liveslots / store / base-zone / notifier / internal as the high-value second batch).

## Cycle work

| Source | File-commit | Author | Lines | Sections |
|--------|-------------|--------|-------|----------|
| packages/vat-data/README.md | 31d74ec8 | Unknown | 35 | 2 |
| packages/swingset-liveslots/README.md | 37e98551 | Unknown | 2 | 1 (stub, status: stale) |
| packages/store/README.md | 7d472973 | Unknown | 27 | 1 |
| packages/base-zone/README.md | 7d472973 | Unknown | 13 | 1 |
| packages/notifier/README.md | eaef5bfd | Unknown | 307 | 6 |
| packages/internal/README.md | 059a66a1 | Unknown | 22 | 1 |

**12 new sections** + 6 new source-index files.

### Notable findings

- **swingset-liveslots** is a one-line stub README; ingested with `status: stale` and a redirect note to `agoric-sdk--pkg-swingset-readme--vat-sources-and-liveslots` where the substantive material lives. First section in the library with `status: stale` at creation time.
- **store** opens with `# TODO REWRITE` — the author flagged the doc as incomplete. Ingested as-is with the marker preserved.
- **base-zone** and **store** both carry explicit "destined to migrate to endo" footers; flagged in source-index `notes:` for re-ingestion after the migration lands.
- **notifier** is the largest source this cycle (307 lines, 6 sections). PublishKit / NotifierKit / SubscriptionKit triad with three lossiness modes (fully lossless / forward-lossless / lossy). PublishKit is recommended; the others are deprecated but kept for compat.
- **internal** has the deliberately-perpetual-0.y.z policy and a strict "may not depend on other repo packages except base-zone/store/cosmic-proto" rule.
- **vat-data** defines the load-bearing turn/crank vocabulary used across SwingSet + async-flow + zoe, and the "kinds-must-be-defined-in-first-crank" invariant.

### Cross-references (in-section notes:)

This cycle continues the cycle-35 pattern: dense cross-references baked into each new section's `notes:` field:

- vat-data → endo--pkg-exo-docs-exo-taxonomy--* (the make/define/prepare distinction).
- vat-data turn/crank vocabulary → agoric-sdk--pkg-zoe-readme--upgrade (same invariant).
- swingset-liveslots stub → agoric-sdk--pkg-swingset-readme--vat-sources-and-liveslots (where the real material lives).
- store / base-zone → flagged for re-ingestion after @endo/store and @endo/zone migration.
- notifier Distributed Operation → endo--pkg-pass-style-readme--* (Passable requirement) and endo--docs-message-passing--digital-purse-example (same capability-bearing-observer pattern).
- notifier source-index → agoric-sdk--pkg-zoe-readme--reading-data-off-chain (StoredPublishKit builds on PublishKit).

## Index work

- `sources/README.md`: +6 rows for the new sources.
- `sections/README.md`: +1 subsection (cycle 36), total 331 → 343.
- `topics/README.md`: exo 30→35, capability-security 56→63, eventual-send 40→46, pass-style 39→40, repository-governance 34→35.
- Topic pages refreshed via the cycle-33 generator scripts for the 5 affected topics. Post-refresh drift = 0.

## Library state

- **343 sections** from **76 source documents** across **3 repos**:
  - endojs/endo: 49 sources
  - kriscendobot/ocapn: 7 sources
  - agoric/agoric-sdk: 20 sources (was 14; +6 this cycle)
- Topic-page drift: 0.

## Inbox state

Empty. Idle-mode wakeup next.

## Self-improvement

- Cross-cutting infrastructure packages (vat-data, store, base-zone, internal) tend to be small (15-35 lines) and document a single discipline each. They cluster well in a single cycle.
- The "destined to migrate" annotations on base-zone and store are a notable cross-repo signal that the library should re-encounter once the migration lands; the per-source-index `notes:` flag is the right place to surface this for future contradiction-check sweeps.
- 5 of 6 sources in this batch have `source_authors: [Unknown]` because git log shows only commit dates, not consistent authorship. The pattern: the README was authored by one person, then touched by many for mechanical reasons. Worth a future norms revision: capture `source_authors` from the README's text when present, falling back to git log only when not.
- The "next agoric-sdk batch" candidates per cycle 35's self-improvement note are now partially-drained: vat-data + swingset-liveslots + store + base-zone done; notifier done; internal done. Remaining cross-cutting: eventual-send (if different from endo's — check), governance, inter-protocol, orchestration. Pure-domain packages (fast-usdc, vaults, ...) can wait.
