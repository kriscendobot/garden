---
order: serial
children: claude-on-minion-town-completion-press-20261014-080513-expanded-window
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-10-14T12:08:18Z
---

# Expanded-window completion press

split-indivisible-reason: The press is one snapshot-bound reconciliation whose report, exception interpretation, journal entry, and alert decision must use the same authoritative window; splitting would risk inconsistent counts or duplicate/missed alerts.
split-indivisible-handler-timeout: 4800

Run the original Claude-on-minion.town completion press as one child with a larger claim-safe handler window. Halt if that single gated outcome fails.
