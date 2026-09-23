---
id: claim-state-triple
aliases: [claim state triple, board ledger worktree, claim atomicity, releaseClaimIfStranded, ReapStrandedClaims, false-stranded claim, occupancy blindness, admission lock, claimlocks flock, branch-landed not task-done, BranchLandedInRealm, claimed_host breadcrumb, dead-claimer]
topics: [agent-fleet-durability, agent-fleet-orchestration]
---

# claim-state-triple

In a file-backed agent task board, a task's claim state is tracked redundantly in three places — the **board** file (its state directory), a **ledger** row, and the agent's **worktree** — and correctness demands they move *atomically*: any clean claim transition (claimable→in-flight, in-flight→done) must update all three, or the task wedges (board says claimable, ledger says running, worktree still occupied) and the next claimant skips it. Two liveness corollaries follow. First, **death must be verified from durable state, never inferred**: a held `flock(2)` admission lock (`.claimlocks/<base>.lock`) *is* a live claimant — the kernel drops it on process death — so probe the lock, never a worker-occupancy census, before declaring a claim stranded (an occupancy-blind false-stranded diagnosis + manual re-ready cascades into duplicate dispatch and a live worktree reaped mid-work). Second, **branch-landed ≠ task-done**: a landed branch proves the *content* is safe, but the *board* stays the source of truth for task state, so a re-ready over provably-landed content is non-destructive continuation, not a stall. jcorbin's unum LORE is the canonical corpus; the pattern maps one-to-one onto the garden's own `jobs/{todo,doin,tada}` board, `.claimlocks/` flock, and stale-claim reaper.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [unum--lore-claim-lifecycle](../sections/unum--lore-claim-lifecycle.md) | The full cluster: board+ledger+worktree atomicity, flock-verified liveness over occupancy inference, branch-landed≠done, and missing-breadcrumb deadlock. |
| [unum--garden-vs-devoker-fleet](../sections/unum--garden-vs-devoker-fleet.md) | Both fleets use git as the claim serialization point and self-heal stranded claims — the garden's push-CAS + reaper, devoker's atomic git-mv + ReapStrandedClaims. |

## See also

- [[design-out-the-hazard]] — the claim race is best *designed out* (per-worktree isolation, push-CAS), not coordinated around with a lock.
- [[journal-ref-rmw-cas]] — the ledger leg of the triple is itself a concurrently-written file needing RMW-CAS.
- [[value-based-cas]] — the compare-and-swap idea at the record level, a different layer.
