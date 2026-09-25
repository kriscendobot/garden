from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-25T10:20:14Z
watchdog_key: rolling-deploy-canary-failed-oros-studio-garden-ce242c49
notice_count: 1
first_seen: 2026-09-25T10:20:11Z
last_seen: 2026-09-25T10:20:14Z
---
Rolling deploy HALTED on a failed canary.
canary host: oros-studio-garden-ce242c49
target sha:  46e100b664191746d40639eb7bd438a695049657
failing signal: released 1621s ago, no deferral published for 1621s (budget 1500s), never advanced to the target sha (deploy stuck/failed on the canary)
This canary was RETRIED 3 time(s) automatically and kept
failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
confirmed regression, not a transient blip — treat it as higher severity than a
first-tick halt.
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
on oros-studio-garden-ce242c49, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)
