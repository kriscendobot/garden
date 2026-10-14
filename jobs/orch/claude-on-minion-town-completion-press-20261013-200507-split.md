---
order: serial
children: claude-on-minion-town-completion-press-20261013-200507-expanded-window
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-10-14T00:05:48Z
---

Expanded-window retry for the Claude-on-minion.town completion press after one
deterministic 2400-second handler overrun.

split-indivisible-reason: The authoritative snapshot, exception interpretation, single journal entry, and conditional once-only alert must use one report window; splitting them would race schedule stamps and duplicate or contradict the press output.
split-indivisible-handler-timeout: 7200
