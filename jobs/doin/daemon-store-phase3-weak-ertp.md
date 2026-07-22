---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-22T04:16:08Z -->

role: builder

# Build Phase 3: weak variants (WeakMapStore / WeakSetStore) + ERTP integration test (design Phase 3)

Repo: endojs/endo-but-for-bots. Implement **Phase 3**: the two weak collection
kinds and the reverse weak-key index, on top of the Phase 1/2 substrate.

Concrete surface (see design § Storage model weak-key handling, § Phased Phase 3):
- add `kind: 'weakMap'` / `kind: 'weakSet'`, `makeWeakMapStore(petName)` /
  `makeWeakSetStore(petName)`;
- WeakMapStore: has/get/init/set/delete; WeakSetStore: has/add/delete (both
  non-enumerable, no snapshot);
- the reverse weak-key index so formula collection of a key atomically removes
  the entry and releases the weak map's retained value; a weak entry must create
  NO retention edge to its key.

## Tests
Prove: an entry does NOT retain its remotable key; collecting the key removes the
entry and releases a weak map's retained value; restart reconstructs the weak
index before serving. Include restart-persistence (key still live) plus
formula-collection tests for entry removal.

## The family's ERTP integration test (per kriskowal/garden#59)
This phase carries the ERTP end-to-end test. Drive a MINIMAL ERTP issuer kit
(mint -> purse -> deposit/withdraw/transfer) whose ledger is a daemon
`WeakMapStore` mapping each purse/payment remotable to its `AmountMath` balance.
Assert conservation of `Amount` across a create -> mint -> transfer -> **restart**
-> balances-intact sequence: keys held weakly by remotable identity, entries
surviving a daemon restart while purse/payment remotables remain live, ledger
entries dropping when a payment is collected. Make ERTP a first-class acceptance
target, not a synthetic micro-test.

## Base / stacking (stacked-PR build)

Use skills/stacked-pr-build: because each phase depends on the code the prior
phase adds, do NOT branch off a bare `llm` for phases 2+. Branch off the PRIOR
phase's head branch so your worktree already contains its store substrate, and
open your DRAFT PR with that prior branch as the base (a stacked PR). Phase 1
branches off `llm`. If a prior phase has already merged to `llm` by the time you
start, rebase onto `llm` instead and base the PR on `llm`. Always
`git fetch` + rebase before you begin (skills/rebase-before-followup).

Open a DRAFT PR; the build auto-runs the gauntlet (clean -> panel -> fix-loop ->
un-draft). Keep the PR scoped to THIS phase only. Do NOT add an `@agoric/*`
dependency; reuse `@endo/patterns` / `@endo/exo` / the daemon's own marshal
substrate. Run `yarn lint` and the daemon package tests locally before pushing
(garden memory "Endo local test bin shims" for the PATH shims). If the design
proves insufficient for this phase, STOP and surface to the maintainer rather
than guessing — the orchestration halts on a child failure.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-59
issue_url: https://github.com/kriskowal/garden/issues/59
submitter: dckc
----- END ISSUE NOTE -----

Design authority for the full detail and file:line grounding:
`packages/daemon/designs/daemon-persistent-stores.md` (merged from PR #809).
READ THE RELEVANT PHASE SECTION FIRST. When the PR is green and un-drafted,
comment the outcome (link the PR) on https://github.com/kriskowal/garden/issues/59.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  claimed_at: 2026-07-22T04:43:09Z
