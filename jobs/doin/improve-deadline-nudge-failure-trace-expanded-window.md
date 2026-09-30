---
tier: mentor
handler-timeout: 4800
split-indivisible-reason: 'one coupled mechanism in one ~60-line region of scripts/jobs/deadline-nudge.sh: the tick subshell''s ERR/EXIT traps and the explicit-status stage paths of deadline_nudge_tick must write one local fault record that the parent''s WARN at the end of the script reads; a writer-only or reader-only child is unverifiable alone and both would edit the same lines, so the overrun was reproduce-and-test cost, not breadth'
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T00:10:06Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 4800
split-indivisible-reason: "one coupled mechanism in one ~60-line region of scripts/jobs/deadline-nudge.sh: the tick subshell's ERR/EXIT traps and the explicit-status stage paths of deadline_nudge_tick must write one local fault record that the parent's WARN at the end of the script reads; a writer-only or reader-only child is unverifiable alone and both would edit the same lines, so the overrun was reproduce-and-test cost, not breadth"

# improve-deadline-nudge-failure-trace (expanded window)

tier: mentor
fallback-tier: minion

Target: `scripts/jobs/deadline-nudge.sh` (garden `main2`).

`scripts/jobs/deadline-nudge.sh` (the final `WARN: deadline nudge tick failed locally (rc=...)` line, ~line 495) logged only opaque `rc=1` at 2026-09-29T22:01:29, with no matching stage/trace diagnostic in the warning tail. Persist the failing stage and command in a local fault record (host-local, under `$GARDEN_STATE`, reconstructible) and include it in this WARN, including failures that bypass the subshell traps (e.g. a `return 1` from an explicitly-status-checked stage in `deadline_nudge_tick`, an `exit` from a helper, or a signal), so the next tick can diagnose and harden the actual failing operation.

Notes for the implementer:
- The subshell's `tick_on_err` / `tick_on_exit` already build a breadcrumb trail but only `log` it from inside the subshell; the parent's WARN cannot see it. Have the subshell write the stage + command + trail to a fault file (reset at tick start), and have the parent read it into the WARN (fallback: "no fault record — failure bypassed the traps", plus whatever the parent can infer).
- Record the current stage name explicitly (clone / journal-sync / staging / push) as each stage begins, so a failure that fires no ERR still names its stage.
- Add/extend a test under `scripts/jobs/test/` that forces a stage failure and asserts the WARN carries the stage and command. Keep it hermetic; this prior attempt overran its 2400s window, so budget test runs carefully.
- Commit with explicit pathspecs and push to `main2` via the rebase CAS loop under `garden_repo_lock`.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T02:00:24Z
