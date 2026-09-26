Both defects fixed, tests green, landed on main2.

## Completion report

**Landed main2 revision:** `9a16e2a6ef8e87fa5bae8349a5b11446d4e50c2f` (pushed after one rebase CAS retry).

### What changed (`scripts/jobs/orchestrate.sh` + `scripts/jobs/test/orchestrate-test.sh`)

**DEFECT A — requeue read as failure, ignoring the existing progress signal.**
`child_state()` declared a child `failed` on *any* rise of its reap count above the promotion baseline, so the `GARDEN_ORCH_STALL_REQUEUE_LIMIT` tunable never applied and a long-running child on the normal reap-and-resume path was torn down on its first requeue. Fixed by consulting the same predicate the reaper already honors, `has_productive_cycle_hint` (common.sh):
- A requeued child that advanced a per-job worktree HEAD → new `progressing` state: never failed on requeue count, and the caller (`advance_serial`/`advance_parallel`) advances the stored `child-<c>-reap-count` baseline to the new floor.
- A requeued child with **no** hint counts toward `GARDEN_ORCH_STALL_REQUEUE_LIMIT` and fails only once it *exceeds* it.
- `child_failure_detail()` was updated to mirror this exactly (dropped the old "rose above baseline" clause), so the two can never disagree.

**DEFECT B — root cause found: SERIAL runs promoted children concurrently.** The serial gate relied *solely* on the ordered loop returning at the first non-terminal child. It had no independent "no sibling in flight" check, so a single child **misclassified as failed by Defect A** (a live child in `doin` with a risen reap count) under `policy=continue` let the loop's `continue` fall through to the next parked child and promote it — putting multiple children in flight against one shared PR branch (the 2026-08-08 `ironhorse-test262` five-live-children collision, #970 branch churn, the js-02 skipped→failing regression). The leader-only gate (`is-main-host.sh` ExecCondition) was verified intact, ruling out the two-host race. Closed with a defense-in-depth gate: before promoting a parked child in a serial run, `serial_sibling_in_flight()` asserts no *other* child occupies `todo`/`doin`; if one does, it waits. This holds even if a child is momentarily misclassified.

**Productive-cycle predicate is now shared, not duplicated:** both `reaper.sh:740` and the orchestrator (`orchestrate.sh:184,227`) call the single `has_productive_cycle_hint` in `common.sh`. No second signal was invented; the reaper's and gardener's halves were left untouched. The watcher remains deterministic, LLM-free, and leader-only-gated.

### Verify
- `bash -n` clean on both edited scripts (shellcheck warnings present are all pre-existing on origin/main2).
- `orchestrate-test.sh`: **30/30 pass**, including the three required hermetic cases — (1) requeued child *with* hint stays active and advances the baseline; (2) requeued child *without* hint stays active until it exceeds `GARDEN_ORCH_STALL_REQUEUE_LIMIT`, then fails; (3) a serial run never promotes N+1 while N is in `todo`/`doin`. Rewrote the old STALL subtest (which asserted the now-incorrect "requeue 0→1 = halt") and added the PRODUCTIVE and SERIAL-GATE subtests.

### Follow-ups (out of scope, per the job)
- The 5 halted orchestrations listed in the directive (e.g. `ironhorse-test262-…-completion`) still need to be recovered/re-posted — deliberately not done here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-orchestrate-watcher-progress-and-serial.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 61 tokens (3626694 cached reads)
- Output: 57112 tokens
- Cost: $4.563083000000001
- Wall-clock: 785s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
