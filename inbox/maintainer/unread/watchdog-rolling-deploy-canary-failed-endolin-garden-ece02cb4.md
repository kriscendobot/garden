from_host: endolin-garden2-5bcdff64
from: watchdog:rolling-deploy
sent_at: 2026-10-09T03:53:09Z
watchdog_key: rolling-deploy-canary-failed-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-10-09T03:53:09Z
last_seen: 2026-10-09T03:53:09Z
---
Rolling deploy HALTED on a failed canary.
canary host: endolin-garden-ece02cb4
target sha:  cf4e33b19a5f701b9f527423f3720ab198712993
failing signal: probe 'canary-probe-endolin-garden-ece02cb4-cf4e33b19a5f-r3' did not reach tada within 600s (claim/spine broken on new code)
This canary was RETRIED 3 time(s) automatically and kept
failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
confirmed regression, not a transient blip — treat it as higher severity than a
first-tick halt.
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
on endolin-garden-ece02cb4, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden2-5bcdff64)
