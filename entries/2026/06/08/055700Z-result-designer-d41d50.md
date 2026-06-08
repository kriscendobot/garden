---
ts: 2026-06-08T05:57:00Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: d41d50
prs:
  - { repo: endojs/endo-but-for-bots, pr: 432, role: new }
refs:
  - entries/2026/06/08/054805Z-dispatch-designer-d41d50.md
  - entries/2026/06/08/054535Z-result-researcher-e69c67.md
  - https://github.com/endojs/endo-but-for-bots/pull/432
---

# result: designer — PR #432 daemon-move-transfer-negotiation

PR #432 DRAFT, base llm, head
design/daemon-move-transfer-negotiation. Researcher-precedence
honored (inlined refinement from researcher e69c67).

## Recommended exo-interface shape

**Option (a): single polymorphic `move`, negotiation internal.**
Sibling `moveWithReport(from, to) → {tier, bytes}` exposes
outcome for callers/tests that need it. Options (b) typed
methods and (c) capability-bearing facets are rejected as the
primary user-facing surface but still live internally as the
`TierExecutor`'s implementation.

## Six-tier ladder

1. POSIX `renameat` within one mount.
2. Mount-scoped `renameat` across mounts on same filesystem.
3. Same-host copy + remove (or hardlink + remove).
4. CAS refcount swap when both endpoints are formula-store-
   resident.
5. Cross-peer CapTP byte stream over OCapN netlayer
   (always-available fallback).
6. Cross-peer out-of-band negotiated transfer (Git push/pull
   first; future substrates plug in as additional brands).

Each tier names substrate + guarantees + take-condition +
fail-fallthrough.

## Five substrate-bind events mint sealer/unsealer pairs

`FilePowers` init, daemon start, CAS subsystem init, OCapN
session establishment, `git remote add`. Endowed per
`four-ways-to-acquire-references`.

## Designer's stances on open questions

- Carriage: side-channel over existing CapTP session (NOT
  `value` message envelope). The broader value-message
  envelope-vs-OOB question stays open.
- Performance crossover heuristic: 16 KiB default threshold
  below which skip negotiation and go straight to Tier 5.
- Sealer/unsealer granularity: per-substrate grain (finer
  than `@endo/pass-style` marshal-table grain).

Six open questions surfaced for maintainer (capability
lattice exhaustiveness; backward compat; granularity; OOB
beyond Git; perf crossover; carriage broader question).

## Coordination concern

Designer landed a `designs/README.md` row update on the new
PR's branch. Same potential overlap with the groom rebucket
PR #400 (in flight, on `groom/mcp-bridge-rebucket`) and the
chat-inventory-create-menu designer's README edits on PR #404.
Maintainer may want to reconcile README edits before merging
any of the three.

Dispatch root torn down.
