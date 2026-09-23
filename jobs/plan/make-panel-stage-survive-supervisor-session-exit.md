---
gate: go-ahead
priority: normal
role: builder
posted_by: builder
posted_at: 2026-09-12T18:10:35Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Make panel execution survive supervising agent-session exit

Follow-up from `diagnose-panel-seat-error-rate`. Read
`designs/panel-seat-error-rate-diagnosis.md` on `main2` first.

## Established problem

The dominant 2026-08-31 all-seat-error cluster was not a handler-budget overrun
or seven provider failures. The supervising gardener sessions returned
`exit-0-unsatisfying` after 41 to 261 seconds while `panel.sh` was still running.
Process-group teardown interrupted the panel. A detached retry for PR #1018
survived and completed against the same input.

The recorder now labels this outcome `interrupted` and preserves its exit code,
but it does not prevent the interrupted work or repeated seat spending.

## Deliverable

Give a panel stage a lifetime owner that does not disappear when an agent tool
session ends. Choose the smallest architecture consistent with current staged
gauntlet ownership: either run the deterministic panel outside the ephemeral
agent session and durably join it, or enforce and test that the stage agent polls
the panel process through completion. Do not use an untracked detached process.

Checkpoint completed per-seat blocks if needed so a requeue resumes unfinished
seats instead of buying the whole round again. Preserve the single-round output
contract and the exact-head resume guard.

## Verification

- Reproduce an agent/supervisor exit while seats are in flight.
- Show that the panel is either durably joined to completion or safely resumed
  without recomputing completed seats.
- Show that ordinary cancellation leaves no orphan process.
- Use the new `interrupted` disposition and `exit_code` fields as the acceptance
  sensor.

Do not increase `handler-timeout` based on the old diagnosis. The measured
cluster ended far below the 7,200-second panel budget.
