---
ts: 2026-05-14T18:45:55Z
kind: result
role: scholar
project: endo-but-for-bots
---

# Forty-fifth scholar cycle — daemon triad (content-store-gc + retention-paths + gateway-bearer-token-auth, 11 sections)

Strategic triage of the cycle-38 meta-catalog's remaining ~106 designs. Picked three daemon-flavored designs that bridge to library-known concepts and address round-1 A/B test gaps (daemon internals previously thin).

## Cycle work

| Source | Lines | Status (per upstream) | Sections |
|--------|-------|----------------------|----------|
| designs/daemon-content-store-gc.md | 131 | **Complete** (PR #99) | 3 |
| designs/daemon-retention-paths.md | 454 | Not Started | 5 |
| designs/gateway-bearer-token-auth.md | 157 | **Implemented** | 3 |

**11 new sections** + 3 new source-index files.

### Notable findings

- **`daemon-content-store-gc`** establishes the daemon's sweep-time reference-counting discipline: scan collected formulas → scan surviving formulas → delete orphaned hashes. Avoids durable refcount-table complexity by re-deriving liveness from the formula graph each sweep. Same pattern generalizes to any 1-to-many storage where the "many" side is in formulas.
- **`daemon-retention-paths`** is the **sibling** of cycle-42's `retention-path-notation` — same `RetentionPath` shape, but this design covers the per-target subscription + chat-UI affordances; RPN covered the bulk method + CLI string notation. Note the API name collision: both have `listRetentionPaths` but with different signatures. The `pet:<name>` label-prefix decision is principled (keeps `RetentionPathSegment` flat; unambiguous because pet names never start with `:`).
- **`gateway-bearer-token-auth`** establishes the "agent ID as bearer token" pattern — reuses the existing 256-bit formula identifier rather than introducing a separate credential; URL-fragment-not-query-param is the load-bearing secrecy detail (RFC 3986 fragments are never sent to the server in HTTP requests); "no JSON auth handshake on top of CapTP" because CapTP already provides the authenticated channel. Five canonical capability-discipline design decisions all worth surfacing in conventions for future cap-auth designs.

### Daemon topic-page jump

**Daemon coverage**: 10 → 21 sections this cycle. Combined with cycle-42's RPN ingest, the daemon's GC subsystem and gateway auth are now substantively covered. Remaining daemon gaps: formula-graph internals, mailbox machinery, host/persona, the daemon-mount filesystem confinement, the formula-inspector, the workers-panel architecture. The round-1 A/B test's Q7 (daemon policy storage), Q10 (formula graph), Q11 (reverseLookup) gap is partially closed.

### Cross-references baked in

- daemon-content-store-gc ↔ daemon-cross-peer-gc (Complete; not yet ingested) ↔ retention-path-notation (cycle 42).
- daemon-retention-paths ↔ retention-path-notation (cycle 42) — explicit sibling-design relationship in notes:.
- gateway-bearer-token-auth ↔ TOFB (cycle 40) — both use capability-based auth without a JSON auth handshake.

## Index work

- `sources/README.md`: +3 rows.
- `sections/README.md`: +1 subsection (cycle 45), total 406 → 417.
- `topics/README.md`: capability-security 87→92, daemon 10→21, tooling 57→59, eventual-send 47→48.
- Topic pages refreshed for 4 affected topics via cycle-33 generator.

Post-refresh drift = 0 across all 23 topic pages.

## Library state

- **417 sections** from **93 source documents** across **4 repos**:
  - endojs/endo: 49 sources
  - kriscendobot/ocapn: 7 sources
  - agoric/agoric-sdk: 25 sources
  - endojs/endo-but-for-bots (llm): 12 sources (was 9; +3 this cycle)
- 23 topics; topic-page drift: 0.

## Inbox state

Empty. Idle-mode wakeup next.

## Self-improvement

- Strategic triage of large source pools (the cycle-38 meta-catalog's ~106 remaining designs) works well when guided by both (a) bridging to existing library material AND (b) addressing round-1 A/B test gaps. This cycle picked daemon-content-store-gc + daemon-retention-paths + gateway-bearer-token-auth for exactly those reasons.
- **Daemon coverage is now substantive enough** (21 sections) that round-2 A/B test Q10 ("daemon formula graph retention edges") and Q11 ("daemon reverseLookup") may have meaningful library answers — but the round-2 confound from cycles 39-43 already noted in entry `175822Z-result-liaison-35ecd8.md` applies even more strongly after this cycle. Round 3 (questions derived from designs not yet ingested) is a useful alternative to keep on the table.
- The "Implemented" status on gateway-bearer-token-auth and "Complete" on daemon-content-store-gc means these designs describe **work already done** — they're effectively after-the-fact documentation of landed PRs. Useful as ground truth and stable reference; library doesn't need to track them for change-detection.
