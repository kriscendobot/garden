---
title: Claim-lifecycle hazards — atomicity, liveness proof, and landed≠done
source: LORE/ (claim & lifecycle cluster)
source_repo: jcorbin.tngl.sh/unum
source_commit: 1834abac9b27e517d0ffd2bf20625e33e9a05028
source_date: 2026-07-08
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [agent-fleet-durability, agent-fleet-orchestration]
status: current
notes: |
  Consolidates the LORE "Merge, claim & lifecycle hazards" cluster:
  claim_ledger_atomicity, false_stranded_claim_cascade, branch_landed_not_task_done,
  missing_claimed_host_deadlock, claim_recovery_phase_attribution_not_state. source_commit
  is the repo pin (multi-file consolidation). Directly comparable to the garden's own
  git-push-CAS job board and stale-claim reaper.
---

## Abstract

The single most error-prone surface in a file-backed agent task board is the
**claim lifecycle** — the transition of a task between *claimable*, *in-flight*,
and *done*, tracked redundantly across a board directory, a ledger, and a worktree.
unum's hardest-won lessons all cluster here, and every one has a direct analogue in
the garden's own `jobs/{todo,doin,tada}` board, `.claimlocks/` flock, and
stale-claim reaper. The through-line: **a claim's liveness must be provable from
durable state, never *inferred*** — from an occupancy count, a gone branch, or a
board position — and **claim state must move atomically** across all the places
that record it.

## Claim state is a triple: board + ledger + worktree

Whenever a task's claim state changes, three things must move **atomically**:

1. **Board file** — move the task between state directories (`DOIN → TODO`,
   `DOIN → TADA`).
2. **Ledger** — clear or update the entity's row in the refinery ledger
   (`realm.refinery.md`).
3. **Worktree** — prune the agent's checkout (or record it inactive).

Skip any one and the task wedges: board says *claimable*, ledger says *running*,
worktree still *occupied* — the next claimant finds a ledger entry and skips it,
and a human has to hand-drop it. In unum this bit on the idle-timeout clean-exit
path (`releaseClaimIfStranded` moved `DOIN→TODO` but never cleared the ledger — five
manual drops in one day). The structural fix is to **wrap all three moves in one
helper so no code path can skip a leg**; the fragmentation across separate
`moveClaimLease` / `releaseClaimIfStranded` / `ReapStrandedClaims` functions was the
root cause. The lone deliberate exception is the *conflicted-entity* path, which
retains the ledger row (`state: conflicted`) so the escalation sweep can find it —
atomicity applies to *clean* transitions only.

## Death must be verified, never inferred from occupancy

The costliest incident class (unum's 2026-07-08 "814 cascade") is a
**false-stranded diagnosis**: an occupancy survey shows "zero live workers" over a
`DOIN/` entry, a locally-reasonable actor concludes the claim is dead and manually
re-readies it `DOIN→TODO` — **while the session is still alive** — and every
subsequent dispatch tick re-claims the "ready" task, spawning duplicate sessions,
reaping the live worktree mid-work, and parking the task in a bogus state. The rule:

> **A live task claim must be undeniable, and death must be verified — never
> inferred from an occupancy survey.**

The durable proof of liveness is an **admission lock**: a `flock(2)` at
`<worktreeRoot>/.claimlocks/<task-base>.lock` held by the claiming process for the
evocation's lifetime. A held flock *is* a live claimant (the kernel drops it on
process death, so stale-lock breaking is correct by construction); a free lock means
the stale-claim reaper — with its own age/attribution gates — may re-ready it. Never
hand-`git mv` `DOIN→TODO` on a liveness *guess*. (The garden's own reaper follows the
same discipline: poison-and-requeue keys on the job's own durable markers, not on a
worker census.)

Two mechanism notes for whoever touches such a guard: flock survives a forked child's
copied fd table until it execs (`CLOEXEC`), so probes must settle briefly to avoid a
fork-window ghost; and an `os.File` GC finalizer will *release* the flock, so the
holder must stay rooted for the evocation's life.

## Branch-landed ≠ task-done

An incremental / partial-work branch can **land in the mainline while its task is
legitimately still open** (unchecked done-criteria, remaining steps). Any machinery
that models "branch merged ⇒ task done" mis-handles this: forcing the claim to the
done tray falsely closes an open task; recording it *conflicted* for a
finish-to-done round-trip wedges when the branch is already gone; and a "ledger row,
branch gone, not done" desync detector pages the operator over a *healthy* post-land
window. The correct model:

> **A landed branch proves the CONTENT is safe; the BOARD stays the source of truth
> for task state.**

Once the content is provably in the mainline (the refinery's own merge commit —
`git log --grep "refinery: merge dvk/task/<slug>"`), a re-ready is **non-destructive**:
the fresh claim cuts its branch off a mainline that already carries the landed steps
and simply continues. Detection heuristic: a task oscillating between "conflicted row
appears" and "row vanishes" across idle ticks, whose work is visibly in mainline
history, is this shape — check the board location before touching anything (open
board + landed content = re-dispatch candidate, not a stall).

## A missing liveness breadcrumb must not deadlock recovery

The dead-claimer decides whether a claimer is alive by reading the task's
`claimed_host` breadcrumb. A task with **no** breadcrumb gives it nothing to
evaluate, so a naive fail-safe (retain-when-in-doubt) **holds the task forever** — a
permanent leak. The breadcrumb can be legitimately absent (unum's rename-only claim
keeps attribution on the *ledger row*, not the task body). The fix: treat *missing
breadcrumb + age above the reap floor* as "assume dead, re-ready." Both conditions
must hold — a recent claim with no breadcrumb yet is still inside its grace window.

## Key recovery on the phase that errored, not on shared state

When recovering claim state after a lock-contention error, key the recovery on
**which phase errored**, never on shared-worktree state a rival could have produced.
A "stop the unit and re-ready" recovery is sound only under *sole-claimant*
semantics; applied to state another claimant could have written, it re-readies a live
claim (the cascade above).

Source: LORE `claim_ledger_atomicity`, `false_stranded_claim_cascade`,
`branch_landed_not_task_done`, `missing_claimed_host_deadlock`,
`claim_recovery_phase_attribution_not_state` at
[jcorbin.tngl.sh/unum](https://tangled.org/jcorbin.tngl.sh/unum) commit `1834aba`.
