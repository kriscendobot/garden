---
title: "Cordis / spatiotemporal composability: applicability to the garden"
source: README.md
source_repo: cordiverse/cordis
source_commit: 270f9e85186b71f18476af08036f1a68fa6044bd
source_date: 2026-08-13
source_authors: [cordiverse]
ingested: 2026-08-14
ingested_by: scholar
topics: [change-propagation]
status: current
notes: "Implementation-grounded applicability reading, companion to the applicability verdict the base paper ingest (cordiverse/paper) writes. This section supplies the 'does the working implementation change the verdict?' half the job scholar-ingest-cordiverse-paper-readme was posted to answer; defer to the base entry for the paper's own metatheory."
---

Abstract: **Headline verdict — a useful conceptual lens, not a drop-in dependency.** The paper's paradigm names, precisely, two properties the garden already engineers by hand: *temporal composability* (completely reverting a component's side effects on removal) and *spatial composability* (declaring and reactively managing inter-component dependencies). Discovering that the paradigm is backed by a mature, 3353-star, actively-developed TypeScript implementation (Cordis) **strengthens** the "worth borrowing the vocabulary" reading — the ideas are load-bearing enough to run a real application stack — but it does **not** turn Cordis into something the garden should adopt: Cordis composes *in-process JavaScript objects*, whereas the garden composes *OS processes, git worktrees, systemd units, and journal messages across hosts*. The value to the garden is the framing and the discipline, not the code.

## Where the garden already does this by hand

The paper's two dimensions are recognizable in existing garden mechanisms — which is the strongest evidence the vocabulary is apt:

- **Revertible effects ≈ the garden's teardown discipline.** A gardener's per-job worktree is created and then *completely removed* on completion or death ("torn down when you finish and garbage-collected if your run dies"). `drain` / `lift` is a reversible moratorium. The root-repo guard *losslessly repairs* drift back to an invariant. Each is a side effect paired with an inverse — Cordis's `ctx.effect(setup → teardown)` with LIFO reversal ([cordis--revertible-effects](cordis--revertible-effects.md)) is the same shape formalized. The garden's inverses are ad hoc per mechanism; the paper's claim is that a *uniform* effect-with-inverse primitive makes whole-system reversion sound by construction.
- **Reactive coeffects ≈ `blocked_on` + the orchestrate/unblock watchers.** A parked child job promoted only when its predecessor reaches `tada/`, an orchestration job that watches each child and drives the next, `Service.init`-style gating so a dependent does not run until its dependency is ready — these are the same "activate a component only when its declared dependencies are satisfied, react when they change" pattern as `ctx.inject([...])` ([cordis--reactive-coeffects-and-services](cordis--reactive-coeffects-and-services.md)). The garden expresses it as deterministic board-state predicates in shell; Cordis expresses it as a reactive dependency graph in one process.

## Why it is not a drop-in

- **Granularity and substrate mismatch.** Cordis's unit of composition is a JS plugin sharing one `Context` object in one Node process; its reversion is calling a closure, its reactivity is in-memory notification. The garden's unit of composition is a *job* run by a *worker process* in an *isolated git worktree*, coordinated through *commits to an orphan branch* and *systemd timers* across *multiple hosts*. The garden's "effects" (a pushed commit, a rendered systemd unit, an upstream PR) are durable and distributed; you cannot revert them by popping a closure stack, and the garden deliberately keeps some of them irreversible (an append-only journal, a ferried commit under the maintainer's identity).
- **The paradigm's hard part is the part the garden already can't cheat.** The paper's soundness rests on *every* transformation carrying a tracked inverse. The garden's most consequential effects are exactly the ones with no clean inverse (a merged PR, a published comment, a deleted branch), which is why the garden gates them behind confirmation and identity checks rather than a revert stack.

## What is worth borrowing (the actionable read)

1. **Vocabulary for design docs.** "Temporal composability" / "revertible effect" and "spatial composability" / "reactive coeffect" are crisp names for properties the garden already argues about informally (drain reversibility, `blocked_on` dependency gating). Adopting the terms would sharpen orchestration-design discussions — this is the low-cost, high-value takeaway.
2. **The LIFO-reversion invariant as a checklist.** Cordis's guarantee that inverses run in reverse registration order is a concrete correctness property to hold garden teardown paths (worktree cleanup, drain markers, deploy rollback) against: does each teardown undo later effects before earlier ones?
3. **A model for the in-process parts, if any.** If the garden ever grows a long-lived in-process supervisor with dynamically loaded plugins (not the current shell-and-systemd fleet), Cordis is a directly relevant reference implementation for its lifecycle/dependency core. Today it is out of scope for the fleet substrate.

## Net

Not out of scope, but not a dependency: **ingest for the framing, borrow the vocabulary, treat the code as a reference for a hypothetical in-process supervisor — do not restructure the job/orchestration model around it.** For the paper's own formal contribution and the base applicability verdict, see the paper source entry (`cordiverse/paper`).

Source: [README.md](https://github.com/cordiverse/cordis/blob/270f9e85186b71f18476af08036f1a68fa6044bd/README.md) at commit `270f9e85`; paper: [cordiverse/paper](https://github.com/cordiverse/paper).
