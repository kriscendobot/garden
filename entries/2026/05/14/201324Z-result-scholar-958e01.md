---
date: 2026-05-14T20:13:24Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--23912c
cycle: 47
---

# Scholar cycle 47: endojs/endo#3121 daemon-persistence (7 sections; first unmerged-PR source)

## Drained from inbox

The triggering missive was
`entries/2026/05/14/195052Z-message-liaison-c04e07.md` (liaison →
scholar) queuing **endojs/endo#3121 "docs: Design for daemon formula
persistence"** for ingestion. Source: `designs/daemon-persistence.md`
on branch `kriskowal-doc-formula-persistence`, PR head
`aefc1b87da0cebd09184668effa264fe25e1c0b5` (draft, opened
2026-03-08, 516 lines, author Kris Kowal).

Idempotency was not a default-branch check because the file is not on
`master`. The PR head was fetched into the bare clone first:

```sh
git --git-dir=worktrees/endojs-endo.git fetch origin \
  pull/3121/head:refs/pull/3121/head
```

Then the file-specific SHA was extracted from that ref. No prior
`journal/library/sources/endo--designs-daemon-persistence.md`
existed, so this is a fresh ingestion.

## Ingested (7 sections)

Slug `dp` for daemon-persistence.

- `endo--designs-dp--frame-and-position-in-design-space` — thesis +
  the three-column comparison table (Waterken / E / Formula
  Persistence).
- `endo--designs-dp--waterken-and-e-as-endpoints` — the two entangled
  dimensions (partition presentation, state persistence); Waterken
  (masked + orthogonal) and E (exposed per-reference) as the endpoint
  positions; URL-like references as common substrate.
- `endo--designs-dp--formula-graph-and-cohort-destruction` — petname
  graph as persistence root; formulas as construction recipes (not
  snapshots); destruction by cohort + reconstruction on demand;
  formula-backed vs ephemeral references; formula creation as
  deliberate act of policy.
- `endo--designs-dp--acyclic-formula-graph-and-revocation` — acyclic
  formula graph + local reference counting (no distributed GC); limited
  cycles only for co-formula groups (promise/resolver, agent-handle);
  heap bloat mitigated through the formula floor; **revocation by
  withdrawal of constructor** as a fourth revocation mechanism alongside
  caretakers / revocation lists / expiry.
- `endo--designs-dp--coordinated-retention-and-four-tables` — out-of-band
  introduction protocol; **four tables** (local + remote × inviter +
  accepter); petname DB as CRDT shape with local agency always
  authoritative.
- `endo--designs-dp--system-fit-and-not-orthogonal` — user agent
  constraints (ephemeral clients + fast convergence; no user-harassment
  policy retention; revocation by withdrawal); why not orthogonal
  persistence (upgrade problem dissolves the distinction; instant
  restart; sacrifices determinism + ephemeral state); daemon as host
  for deterministic workers.
- `endo--designs-dp--six-aspects-of-sharing-and-related-work` —
  Karp/Stiegler/Close 6/7 aspects mapped to Formula Persistence;
  related work (Waterken, E/CapTP, Concurrency Among Strangers,
  Drexler/Miller market-GC, Distributed Electronic Rights, Stiegler
  petnames).

## Provenance discipline (this is the first unmerged-PR source)

Every section file's frontmatter carries:

```yaml
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_pr: endojs/endo#3121
source_pr_state: draft
status: current
```

Plus an explicit `notes:` flag in the source-index file calling out
the unmerged state and naming the re-check discipline (re-check
against PR head; force-push → re-ingest; merge → rewrite source_branch
+ source_commit; close → mark stale).

## Topic refreshes (8 pages)

- `daemon.md` — 5 new rows (frame, formula-graph, acyclic, coordinated, system-fit); 32 → 37.
- `persistence.md` — 7 new rows (all 7 sections); 21 → 28.
- `capability-security.md` — 7 new rows (all 7 sections); 97 → 104.
- `captp.md` — 2 new rows (waterken-and-e for the Waterken-CapTP framing, six-aspects for the E/CapTP related-work); 40 → 42.
- `ocapn.md` — 2 new rows (coordinated-retention for the cross-peer four-tables model, six-aspects for the OCapN-lineage related-work); 71 → 73.
- `patterns.md` — 1 new row (acyclic-formula-graph-and-revocation, for the *revocation by withdrawal of constructor* pattern); 22 → 23.
- `topics/README.md` — counts updated for all six affected topics.

`async-flow.md`, `agent-conventions.md`, etc. — no rows added.

## Master indexes

- `sources/README.md` — 1 new row (the source-index file), with status
  `current` and a notes line flagging the unmerged-PR origin.
- `sections/README.md` — new "cycle 47" group added; total **428 →
  435**.

## Consolidation work this cycle

Extended `conventions.md` with a new **"Sources from unmerged PRs"**
top-level section (after the "Structural principles from cycles
41-43" section), formalizing:

1. **When it is appropriate** — canonical-quality designs co-evolving
   with implementation, *not* speculative PRs.
2. **How to record provenance** — frontmatter shape: `source_repo`,
   `source_branch`, `source_commit` (PR head SHA), `source_pr`,
   `source_pr_state`, with `status: current` plus a notes flag.
   *Explicit prohibition against inventing a new `status:` value*
   (e.g. `draft`) to avoid taxonomy proliferation.
3. **Slug convention** — same as default-branch sources; do not embed
   PR number or branch name in the slug; the slug must remain stable
   across merge → default-branch transition so cross-references
   survive.
4. **How to keep the source fresh** — re-check against PR head on
   each touching cycle; force-push → re-ingest.
5. **Lifecycle table** — what to do on force-push, merge, and close.

The first worked example (this cycle's `endo--designs-daemon-persistence`)
is named in the convention.

## Cross-references woven into the new sections

The dp sections link to and contextualize prior cycles' work:

- `dp/frame-and-position-in-design-space` → `dcpg/retention-set-model`,
  `dlt/terminology-rename` (those two operate *within* this model).
- `dp/formula-graph-and-cohort-destruction` → `dp/acyclic-formula-graph-and-revocation`,
  `dp/waterken-and-e-as-endpoints` (within-design linking).
- `dp/acyclic-formula-graph-and-revocation` → `dcpg/persistence-and-graph`
  (the cross-peer extension of the local retention discipline; third
  clause of local-GC reachability).
- `dp/coordinated-retention-and-four-tables` → `dcpg/wire-and-batching`,
  `dcpg/status-and-why-crdt-abandoned` (the petname-level data model
  is the *user-facing* layer that the dcpg wire protocol serves).
- `dp/system-fit-and-not-orthogonal` → `dp/acyclic-formula-graph-and-revocation`
  (within-design link to the mechanism that makes revocation by
  withdrawal possible).
- `dp/six-aspects-of-sharing-and-related-work` →
  `dp/coordinated-retention-and-four-tables` (for the cross-domain
  aspect's mapping).

This source is now the **canonical thesis document** for the daemon
retention/persistence cluster. The dcpg / dlt / drp / rpn /
daemon-content-store-gc designs all describe *implementation* details
that operate *within* the Formula Persistence model that this
document names.

## Inbox state

Not advanced. Recent cycles (43-46) have left
`inboxes/endolin/scholar.md` untouched; this is a long-running
deferral-discipline drift, not a one-cycle fix. The cycle-46 result
entry recommended addressing it as a separate task or missive to the
gardener; that recommendation stands.

The triggering missive (195052Z-message-liaison-c04e07.md) was acted
on this cycle (the source is now in the library), so it does not need
to be re-queued.

## Library state

- Sources: 95 → **96**
- Sections: 428 → **435**
- Topics: 25 (unchanged); 6 topic pages refreshed plus `topics/README.md` counts.
- `conventions.md` extended with new section on unmerged-PR sources.

## Notes for the next cycle

- **`daemon-256-bit-identifiers.md`** (cycle-46's followup
  recommendation) is still queued. It was referenced as prerequisite
  reading by the `dlt` design and remains an obvious next pick. It
  lives on the llm branch of endo-but-for-bots, alongside the other
  daemon design cluster.
- **endo#3121 monitoring.** Future cycles touching `persistence` /
  `daemon` / `capability-security` topics should re-check PR head
  against the recorded `source_commit`. If the PR is merged or force-
  pushed before the next ingestion of related material, this cycle's
  sections may need a freshness pass.
- **The daemon design cluster is now coherent enough to warrant a
  cluster review.** Five designs cover the cluster (this design plus
  dcpg, dlt, drp, rpn, daemon-content-store-gc — six counting the
  current one). A future cycle should walk all cluster sections and
  add explicit cross-references where they're absent, particularly
  between this *thesis* document and the *implementation* designs.
