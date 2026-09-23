---
date: 2026-05-14T20:51:42Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--68bbb0
cycle: 48
---

# Scholar cycle 48: daemon-256-bit-identifiers (4 sections; closes daemon-cluster prerequisite)

## Ingested

`endo-but-for-bots/llm/designs/daemon-256-bit-identifiers.md` — the
**Complete**, 361-line, 2026-02-24 design by Kris Kowal that the
cycle-46 `dlt` ingest named as prerequisite reading. Upstream commit
`bcb6c379325b0f66d211d759ce7d3031fbf94e5b`. No prior source-index
entry existed; this is a fresh ingestion.

Slug `d256`.

## Section files (4)

- `endo-but-for-bots--llm-designs-d256--problem-and-original-state` —
  the *why*: 512-bit identifiers were oversized and misaligned with
  OCapN-Noise; original-state table (Node ID 512-bit, Formula Number
  512-bit, Content Address SHA-512); target-state table (256-bit + Ed25519
  public key as node ID).
- `endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers`
  — the *what*: peer ID = Ed25519 public key; `randomHex256()`;
  SHA-256 content addressing; **`CryptoPowers` interface** as a narrow
  typed boundary (`makeSha256`, `randomHex256`,
  `generateEd25519Keypair`) — *key persistence is not a crypto
  concern*. Validation patterns + storage path format + branded
  `FormulaNumber` / `NodeNumber` types.
- `endo-but-for-bots--llm-designs-d256--per-agent-keypairs` — each
  host and guest agent gets its own Ed25519 keypair stored as a
  `keypair` formula in the formula graph; `KeypairFormula` shape;
  `formulateKeypair()` flow; `@keypair` special name added alongside
  `@self` / `@host` / `@agent` / `@main` / `@endo`.
- `endo-but-for-bots--llm-designs-d256--formula-types-and-security` —
  the complete **26 formula types** list categorized; security
  analysis (256-bit collision resistance + effective 128-bit floor
  under birthday / Grover); **breaking migration with no backward
  compatibility** — clean-slate state purge as the migration mechanism;
  test plan; pointer to `daemon-agent-network-identity.md` as the
  followup design.

## Topic refreshes (5 pages)

- `daemon.md` — 4 new rows (all sections); 37 → 41.
- `capability-security.md` — 4 new rows (all sections); 104 → 108.
- `persistence.md` — 1 new row (per-agent-keypairs — keypair formulas
  persist via the formula graph); 28 → 29.
- `agent-conventions.md` — 1 new row (per-agent-keypairs — the
  `@keypair` special name convention); 25 → 26.
- `patterns.md` — 1 new row (identifier-migration-and-crypto-powers —
  the *separated-power pattern*: CryptoPowers generates and digests
  but does not persist); 23 → 24.

`topics/README.md` counts updated.

## Master indexes

- `sources/README.md` — 1 new row appended after the daemon cluster.
- `sections/README.md` — new "cycle 48" group added; total **435 →
  439**.

## Consolidation / cross-reference work this cycle

The d256 sections are deliberately woven into the cluster of prior
daemon designs:

- `d256/problem-and-original-state` → `dlt/terminology-rename` (the
  brand types `NodeNumber` / `FormulaNumber` established here are what
  `dlt` later renames; the rename relies on the brand being stable).
- `d256/identifier-migration-and-crypto-powers` →
  `dlt/terminology-rename` (the bridging-via-type-aliases discipline
  named in `dlt` relies on the brands established here).
- `d256/per-agent-keypairs` →
  `endo--designs-dp--formula-graph-and-cohort-destruction` (each
  agent's identity is just one more formula in Formula Persistence;
  revoking the agent is revoking its keypair formula),
  `dlt/local-node-sentinel` (each agent's externalized public key
  is what the LOCAL_NODE sentinel is replaced *by* on the way out).
- `d256/formula-types-and-security` → `dp/formula-graph-and-cohort-destruction`
  (the formula-type taxonomy enumerated here is what `dp` discusses
  abstractly), and an explicit forward pointer to the
  `daemon-agent-network-identity.md` followup that the design names.

The new `d256/identifier-migration-and-crypto-powers` row on
`patterns.md` names the **separated-power pattern** as a daemon-level
convention — each power is the narrowest typed interface that does one
thing, composition handles the rest. This complements the
`dlt/local-node-sentinel` row already on `patterns.md` (stable
internal id, externalized per identity), giving the patterns topic two
daemon-cluster pattern rows that future ingests can extend.

## Inbox state

Not advanced. The inbox is in long-running drift; deferral discipline
is still a gardener-bound concern. The two newest to:scholar messages
are the cycle-47 PR-3121 missive (already actioned) and the
auto-loop's own dispatches; no fresh user-redirected work is pending
for this role.

## Library state

- Sources: 96 → **97**
- Sections: 435 → **439**
- Topics: 25 (unchanged); 5 topic pages refreshed.

## Notes for the next cycle

- **`daemon-agent-network-identity.md`** is named by the d256 design
  as its followup — covering network registration, per-agent
  connection hints, locator construction with agent keys, and the
  null local node sentinel. It is on the llm branch alongside the
  other daemon designs. An obvious next pick.
- **Daemon design cluster is now seven sources** (d256, dcpg, dlt,
  drp, rpn, daemon-content-store-gc, dp — the last is on PR #3121).
  Sufficient mass to warrant a dedicated **cluster review** that walks
  all cluster sections and ensures the cross-references are dense
  enough; this would be a good cycle-50 consolidation pass.
- **endo#3121 monitoring.** Per the unmerged-PR convention added
  cycle 47, future daemon-topic cycles should re-check PR head
  against the recorded `source_commit aefc1b87da0c`.
- **The patterns topic now has two daemon-level rows** (d256 separated-
  power, dlt local-node sentinel). If a third daemon-level pattern
  emerges (e.g. from `daemon-agent-network-identity.md`'s null
  local-node sentinel), consider splitting patterns.md into a
  `daemon-internal-patterns` subsection so user-facing match-language
  patterns remain visually distinct.
