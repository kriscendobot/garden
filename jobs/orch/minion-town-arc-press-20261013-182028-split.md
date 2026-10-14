---
child-minion-town-arc-press-20261013-182028-checklist-reap-count: 0
order: serial
children: minion-town-arc-press-20261013-182028-checklist minion-town-arc-press-20261013-182028-triage minion-town-arc-press-20261013-182028-carry
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-10-14T00:17:53Z
---

# Decomposed minion.town arc supervision tick

The original supervisor tick is divisible into three serial, independently bounded decisions: reconcile objective and production-validation evidence; triage the complete PR portfolio and remove stale work; then use those durable findings to post no more than a couple of highest-value carry/validation actions. Serial order prevents the action slice from acting on stale classifications, while each child revalidates mutable GitHub state before writing.

The watcher should halt on a failed child so downstream work is not released from incomplete or stale evidence. This is one execution of the standing minion.town arc press; it does not retire the recurring schedule.
