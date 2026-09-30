---
child-fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-expanded-window-reap-count: 0
order: serial
children: fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-expanded-window
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-09-30T04:31:50Z
---

split-indivisible-reason: single atomic scan-remediate-rescan of one live SSM-reached store (/var/lib/endo-gateway/store/vhosts); remediation must be proven by a rescan in the same run, so no part stands alone; the overrun came from hand-scanning, now scripted by scripts/jobs/containment-gateway-record-check.sh (main2 2a5c1991779)
split-indivisible-handler-timeout: 3600

Indivisible overrun split of `fu-minion-town-containment-gateway-endo-sock-1-20260930-015006`: one child, `fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-expanded-window`, runs the
scripted containment record check with a 3600s handler window.
