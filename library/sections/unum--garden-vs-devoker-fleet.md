---
title: Garden systemd lanes vs devoker invokers — a fleet-architecture comparison
source: LORE/garden_lanes_vs_pivoker_invokers.md
source_repo: jcorbin.tngl.sh/unum
source_commit: cb83f9a9f16fe5a2bb015699c45382abc1590c69
source_date: 2026-07-05
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [agent-fleet-orchestration]
status: current
notes: |
  unum's own dimension-by-dimension comparison of THIS garden's fleet against
  devoker, written from the vendored ref/kris_garden/ snapshot (upstream main2 @
  4772ddbfaf, annotated for the garden's v2). A rare artifact: an independent sibling
  reading the garden's architecture back to it. Kept because the self-view is
  itself the transferable content.
---

## Abstract

unum keeps a LORE entry that reads **this garden's** fleet architecture against its own,
dimension by dimension — a rare artifact in the library: an independent sibling
implementation studying the garden and naming both the convergences and the honest
divergences. Both systems drain a git-backed task board with autonomous agents, but the
**core fork** is lifecycle: the **garden scales by persistent systemd lanes reconciled to a
declared count**, while **devoker scales by transient occupancy-aware burst workers
materialized to match runnable demand**. The comparison was written from unum's vendored
`ref/kris_garden/` snapshot (garden `main2 @ 4772ddbfaf`) and is annotated for the garden's
v2 (job-board gardener fleet). The dimension verdicts below are unum's, lightly cleaned.

## The dimensions

- **Unit of work** — *equivalent granularity* (one claimed work item per cycle). The garden's
  job is a typed state-machine record; devoker's is a free-form task file.
- **Concurrency model** — *the key difference.* Garden = **persistent lanes reconciled to a
  declared count** (`garden-gardener@N`, a `garden-gardener-scaler` timer reconciling the pool
  to a human-declared `gardeners: N`, k8s-replicas-style); devoker = **auto-sized ephemeral
  burst** (`RunnableCount → spawn want − occupied`, torn down after each turn). Both give
  per-role concurrency caps; the fork sharpens to **garden = declarative desired-count
  reconcile; devoker = demand-driven materialization.**
- **Job discovery / claiming** — *equivalent.* Both use **git as the serialization point** for a
  filesystem board (the garden's `git push origin HEAD:journal2` CAS; devoker's atomic
  `git mv TODO/→DOIN/`, presence-in-DOIN *is* the claim), and both self-heal stranded claims.
- **Dispatch mechanism** — *key difference.* The garden wraps a **deterministic loop** that calls
  Claude only at judgment substeps; devoker **makes the agent the whole turn** (the loop body *is*
  the agent).
- **Result / output path** — *equivalent intent* (durable journal + forensic transcript). The
  garden keeps a separate orphan `journal2` branch; devoker commits into the working branch and
  archives transcripts to `evoke/sessions/<uuid>.jsonl`.
- **Restart / crash semantics** — *equivalent robustness.* The garden resumes the *same* lane via
  a state file; devoker re-readies for *any* worker plus a `WIP(agent) interrupted` resume
  checkpoint.
- **Role of the orchestrator** — *key difference.* Garden orchestration is **distributed producers +
  racing consumers** (watchers, foreman, scheduler, orchestrator — all deterministic services, "not
  one agent that could forget"); devoker centralizes the kick decision in one shared
  `invokerctl.KickoffAndBurst` primitive. v2 narrows the gap (both now hold deterministic
  kick/supply/sequencing logic in code) but the garden's is the *more* structured — per-role dispatch
  + orchestration policy devoker still lacks.
- **Burst vs steady-state** — *key difference.* Garden absorbs burst with **pre-provisioned lanes**;
  devoker **materializes workers to match runnable work, then reclaims them.**

## The gaps unum names in itself (and what the garden has that it doesn't)

Read as a mirror, the comparison is most useful for the gaps unum finds in *devoker* by contrast
with the garden — a checklist of what a mature fleet grows:

- **No idle work-supply** (garden has the **foreman**: on sustained idle, promote a parked job or
  post the next unblocked milestone step; devoker supplies no work on idle — every task is
  human-authored).
- **No activity-feed watcher** (the garden's inbound machinery — comment/repo/CI watchers,
  issue-inbox, mention-watcher, upgrade-monitor — turns upstream events into jobs; devoker's notify
  socket only pushes *outward*).
- **No separate triage/authoring role** (the garden split out `triager`, `mentor`, `watchman`;
  devoker folds triage into the steward/liaison personas + the operator).
- **Persistent-lane vs ephemeral-worker** is the real, standing fork — worth a note on whether
  long-lived typed workers would benefit context-heavy roles.

The takeaway for the garden: an outside implementation independently judged the garden's *distributed
deterministic-producer* orchestration and *declarative desired-count* scaling to be the more
structured of the two designs, while flagging that devoker's single-primitive kick is simpler to
reason about — a fair trade to keep in view when the garden's orchestration surface grows.

Source: [LORE/garden_lanes_vs_pivoker_invokers.md](https://tangled.org/jcorbin.tngl.sh/unum) at commit `cb83f9a`.
