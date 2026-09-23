Everything checks out. The prior attempt fully completed this job and pushed it to `origin/main2`; only the completion signal was never emitted before its session was lost. I've verified the work is genuine and complete.

## Completion report: `fix-orchestrate-latched-child-failure`

**State on arrival:** A prior attempt had already committed and pushed the fix as `08d5206f5ee` ("fix(orchestrate): re-derive a child's final disposition; recover transient failures"), now the parent of `origin/main2` HEAD. My fresh worktree was clean. I re-derived and verified rather than redoing.

**What the landed fix does (all four asks satisfied):**

1. **Root cause + re-derivation.** The false failure came from `child_handler_timeout()` reading only the `handler-timeout:` header and falling back to the 2400s fleet default, so a live builder (7200s role budget) read as "stalled in flight" at 2520s. It now uses `applied_handler_budget` — the same per-role+header budget the gardener enforces and the reaper honors. `complete_done` now re-derives each blamed child from a fresh board read via `child_clean_tada_now`: a child sitting in `jobs/tada` without an `orchestration-failed: true` declaration is **recovered** ("recovered after transient failure"), and a run where every child ended done goes terminal as `complete`. Records carry `failed-children:`/`recovered-children:`.

2. **Close the stale page.** `note_child_recovered` + `close_orch_notice` close a previously-paged failure notice in place (`recovered: true`, unread-only, deliberately bypassing the 1h coalescing throttle so a within-the-hour recovery isn't swallowed). `reconcile_recovered_completions` (wired into the tick loop at line 1301, after `supersede_stale_halts`) also corrects *already-finished* `complete-with-failures` records — current and legacy prose shape — so the historical `minion-town-claude-inference-exploration-20260922` record self-heals on the leader.

3. **Real failures preserved.** Vanished-without-tada, `orchestration-failed: true`, doomed-and-still-parked, and stall limits have no clean tada and still fail.

4. **Tests.** `orchestrate-test.sh` SUBTEST 28 exercises: doomed→re-promoted→clean-tada gives terminal `complete` with the page closed; `orchestration-failed: true` and vanished children still fail; doomed-and-still-parked keeps `complete-with-failures`; the 2520s-into-7200s builder is not declared stalled; reconcile is idempotent. I ran the full suite: **76 passed, 0 failed** (exit 0).

**Follow-ups:** None. The historical minion-town record and its maintainer page are reconciled automatically by `reconcile_recovered_completions` once this lands on the leader's deployed root. Worktree clean; nothing left uncommitted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-orchestrate-latched-child-failure.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 94 tokens (4467145 cached reads)
- Output: 34957 tokens
- Cost: $3.307159500000001
- Wall-clock: 612s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
