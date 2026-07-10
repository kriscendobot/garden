# Topic: agent-fleet-durability

> Abstract: The **durability and crash-safety** layer beneath an autonomous agent fleet — how a fleet keeps its coordination state correct across concurrent writers, process death, reboots, and self-restart, when no human is in the loop to notice a wedged claim or a bricked killswitch. Distinct from `agent-fleet-orchestration` (the *coordination* layer — who claims what, the poll–dispatch–supervise loop): this topic is the *state-integrity* layer under it. Recurring concerns: a task claim as a multi-place triple (board + ledger + worktree) that must move atomically; proving a claim's liveness from durable state (a held `flock`) rather than *inferring* death from an occupancy survey; "branch-landed ≠ task-done" (content safety vs board truth); read-modify-write CAS over a git ref for concurrent writers vs a write-once primitive for archives; migrating a file off a branch journal-then-untrack atomically so a re-clone never sees neither copy; crash-safe durable-write ordering (recovery breadcrumb *before* the killswitch); source-gated automated clears that never undo a human's deliberate pause; model-guarded session resume; and context-exhaustion roll-forward (keep claimed + recap, never re-ready into a re-claim loop). The canonical corpus is jcorbin's **unum** LORE, whose lessons map almost one-to-one onto the garden's own `journal2`-branch CAS job board, `.claimlocks/` flock, stale-claim reaper, and producer-clone landers.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [Claim-lifecycle hazards — atomicity, liveness proof, landed≠done](../sections/unum--lore-claim-lifecycle.md) | unum LORE | A claim's liveness must be provable from durable state (a held flock), never inferred from occupancy; claim state moves atomically across board+ledger+worktree; a landed branch proves content, the board stays task-state truth. |
| [Git-ref journal durability — RMW-CAS, primitive selection, cutover](../sections/unum--lore-journal-durability.md) | unum LORE | Concurrent git-ref writers need read-modify-write CAS (re-read + re-run the mutate) not a blind overlay; pick the primitive by file lifecycle; migrate journal-then-untrack atomically so a re-clone never sees neither copy. |
| [Crash-safe automated-lifecycle guards](../sections/unum--lore-crash-safe-guards.md) | unum LORE | Write the recovery breadcrumb before the killswitch; a source-gated auto-clear never undoes a human's deliberate pause; guard session resume on the recorded model; at context exhaustion recap-and-keep-claimed, never re-ready. |

## See also

- [[agent-fleet-orchestration]] — the coordination layer this topic underpins.
- [[persistence]] — durable-state survival across process/incarnation boundaries.
- [[coding-agent-economics]] — the spend/resource-budget axis of bounding a fleet.
