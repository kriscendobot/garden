Work is complete. Writing the report.

## Completion report

**Job:** `garden-orchestration-halt-record-accuracy` — an orchestration halt record contradicting what actually happened.

### Root cause (settled by journal2 history — case (a), not (b))
Reconstructed the ordering from claim/tada/promote commits against the orchestration's own record timestamp:

- **Halt record written** `2026-08-16T07:04:06Z` (commit `c7b5dacaf2`). At that moment child 1 (`pin-rebase-reconcile`) had genuinely stalled after its requeue limit, and children 2 & 3 were still parked in `plan/` under their orchestrated gate. **The record was accurate when written, and the gate held.**
- **~18.7h later**, `2026-08-17T01:46–01:47Z`, both downstream children were moved off `plan/` by a **manual `promote-plan.sh`** on host `endolin-garden-ece02cb4` (commits `3e1e5f93`/`b024d412`, `cleared=none`) — *not* by this orchestration, whose orch record was already gone. They then completed (`fixture-parity` tada `02:06:50Z`; `registry-default-followup` tada `01:52:56Z`).

So this is **(a)**: the halt policy did not fail — the record is simply never superseded, and a reader can't distinguish a stale halt from a live one. Not the more serious (b) halt-gate correctness bug.

### Fix (main2)
Commit `37a9ffcac5` (`scripts/jobs/orchestrate.sh`):
- The serial halt writer now emits a machine-readable `halt-parked-remainder:` field.
- New `supersede_stale_halts` pass runs each tick: for every `tada/` record still marked `orchestration-status: halted`, it re-reads that remainder against the fresh board and, if any child has progressed beyond its held gate, flips the status to `halted-superseded` and appends a dated addendum naming the new disposition. It stays a `halt*` status, so `tada_failed`/the unblock watcher keep treating the orchestration as halted (a child completing on another path doesn't retroactively make the campaign a success) — only the human narrative is corrected. Idempotent + CAS-safe.

Commit `1f3dab3bbb` (`scripts/jobs/test/orchestrate-test.sh`): new subtest **3b** models the pr282 incident (parked children promoted+completed post-halt) and asserts the flip, the addendum, the retained halt status, and idempotency. **49/49 pass**, no regressions.

### Record correction (journal2)
Commit `efd39362b3` rewrote `jobs/tada/pr282-flag-gated-reconciliation.md` in the same superseded format the machinery now produces: status flipped to `halted-superseded`, `halt-parked-remainder:` added, and a dated addendum recording that both children were promoted manually ~18h later and completed (with tada timestamps and the `86745db2b0` commit), and that only child 1 never ran. It no longer misleads. (Done via an isolated clone outside the deployed root; the deployed `journal/` worktree picks it up on next sync.)

### Notes
- Checked `garden-requeue-rediscover-prior-work` (the flagged related work): it concerns duplicate-PR convergence via a `gh pr create` job marker — a different area, no overlap.
- No follow-ups required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-orchestration-halt-record-accuracy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3169556 cached reads)
- Output: 33136 tokens
- Cost: $3.304956
- Wall-clock: 615s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
