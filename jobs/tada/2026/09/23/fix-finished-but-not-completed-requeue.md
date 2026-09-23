---
handed-off: fix-e2e-fixtures-budget-pool-admission
deliverable-complete: false
---
# Completion report: fix-finished-but-not-completed-requeue

Both halves are fixed and pushed to `main2` as `44ed0aa2243`. All the gardener, reaper and gauntlet suites I touched pass. Seven older end-to-end suites still fail exactly as they did before my change; I posted a follow-up job for them.

## Root causes (both reproduced with a real `claude -p`)

**(a) Why the work finished but completion was never written.** In headless `claude -p`, ending the turn ends the process. The sessions put a CI wait or a Monitor in the background and ended their turn to "wait for the notification", which never arrives headless. I reproduced it: the process exited in 9s with the background task abandoned. The live `ebfb-exo-stream-pr1100-gauntlet-20260923-clean` transcript shows the same thing ("CI wait is running in the background… A monitor is watching…" then end of turn). The marker parsing and its placement were correct; the prompt never said that ending the turn is final.

**(b) Why the resume died in seconds.** When a session that left a background task running is resumed, it first emits an extra zero-turn `result` event for the old task's "stopped" notification (`origin.kind: task-notification`), then the real result. `claude_stream_result` required exactly one result, so it rejected the stream. That was recorded as `transient-failure` with no turns (`stream_valid:false` in the usage records). The resumed session may well have been fine.

**A third cause of the budget burn.** A first claim creates its worktree inside the handler, so that worktree had no "before" HEAD to compare against. Commits from a first session therefore never counted as productive, and each requeue used up doom or stage-retry budget.

## Changes
- **`common.sh`**
  - `claude_stream_result` ignores `task-notification` results. It still rejects two real results, a missing result, or a truncated stream.
  - New `record_worktree_start_head` / `worktree_start_head`. `job_cycle_productive` now measures a newly created worktree against the HEAD it was created at.
- **`handlers/worker-common.sh`**
  - Every prompt mode, for all backends, now includes a **HEADLESS SESSION** note: ending the turn ends the session, so wait in the foreground and put the marker in the final message.
  - New `continue` prompt mode: "you stopped without completing (you were not interrupted); verify the deliverable and complete now".
  - `worker_ensure_worktree` records the start HEAD. `ensure-project-worktree.sh` does the same.
- **`handlers/monk-claude.sh`**, refactored into `claude_call` / `claude_parse` / `claude_map_rc`:
  - **Nudge in the same process:** when a call ends cleanly without the marker, the handler resumes the same session once with the `continue` prompt. It is limited by `GARDEN_COMPLETION_NUDGES` (default 1; 0 turns it off) and by the budget left under the call's ceiling (skipped below `GARDEN_COMPLETION_NUDGE_MIN_USD`, default 0.50). The first call's process tree is cleaned up before the nudge starts, and usage from both calls is summed into one record (`completion_nudges`).
  - A marker file kept in the worktree's git admin directory records "stopped, not interrupted". The next claim on the same host then gets the `continue` prompt instead of a plain resume.
- **`roles/gardener/AGENT.md`:** added the headless norm.
- **Reaper:** no change needed. A productive gauntlet stage is already spared through `job_progress_verdict`, which reads the productive marker as "advancing". I added a test for it instead.

## Tests
- **claude-stream-signal:** 15/15 (+3). A notification result is excluded; a stream with only a notification, or with two real results, is rejected.
- **gardener-worktree:** 64/64 (+15):
  - the headless note is in the prompt
  - one nudge, with `--resume` and the continuation prompt; it completes and usage is summed
  - `NUDGES=0` gives a requeue plus the marker file
  - the next claim gets the CONTINUE prompt, never the bare resume, and still completes despite the old notification result
  - the start HEAD is recorded
- **productive-cycle:** 14/14 (+4):
  - first-cycle commits count as productive; a new worktree still at its start HEAD does not
  - a productive gauntlet stage is requeued without a stage retry, while a non-productive one is still handed to the driver
  - the end-to-end fixture now seeds a budget pool; it had been failing before my change
- **Also green:** reaper-gauntlet-handoff 5/5, reaper-doom-park 10/10, reaper-requeue-cap 5/5, gauntlet-resume 8/8, worker-ensure-worktree 6/6, project-worktree-isolation 53/53.
- **Still failing, unchanged:** completion-signal, handler-budget, worker-spine-kinds, deadline-nudge, mystic-kimi-harness, worker-health-gate and gauntlet-test. Their FAIL lines match a clean copy of `main2` apart from temp paths. Their test fixtures never set up a budget pool, so the claim gate refuses every claim; the cause is confirmed for all but gauntlet-test.

## Follow-ups
- Posted `fix-e2e-fixtures-budget-pool-admission` to seed a budget pool in those fixtures. It says not to add a test-only bypass to the production gate.
- Hosts only pick up this fix on the next deploy. The live ebfb#1100 clean stage is still running the old code.
- The other handlers (`cleric-codex`, `opencode`, `mystic-kimi`) now get the headless note, but not the nudge or the `continue` mode, which are Claude-only.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-finished-but-not-completed-requeue.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 148 tokens (9593045 cached reads)
- Output: 52105 tokens
- Cost: $4.443116999999999
- Wall-clock: 891s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
