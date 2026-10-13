---
order: serial
children: claude-on-minion-town-press-audit-20261013 claude-on-minion-town-press-carry-20261013 claude-on-minion-town-press-unblocks-20261013
on-child-failure: halt
state: pending
created_by: orchestrator
created_at: 2026-10-13T11:06:47Z
---

# Claude-on-minion.town press split after handler overrun

The recurring press genuinely separates into three ordered, independently claimable responsibilities: first reconcile issue 89's source-of-truth checklist against external evidence; then carry current PR/review state using that corrected agenda; finally scan the resulting state for newly admitted work and post only deduplicated jobs. Serial order prevents later children from acting on stale checklist or board state. The orchestration halts on failure so a partial audit cannot silently admit downstream actions.
