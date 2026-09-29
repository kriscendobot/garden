from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-29T12:44:07Z
watchdog_key: rolling-deploy-canary-failed-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-29T12:44:07Z
last_seen: 2026-09-29T12:44:07Z
---
Rolling deploy HALTED on a failed canary.
canary host: endolin-garden2-5bcdff64
target sha:  c9bfa87823ea43a10b393fc6cf359ddd9ba15984
failing signal: probe 'canary-probe-endolin-garden2-5bcdff64-c9bfa87823ea-r3' did not reach tada within 600s (claim/spine broken on new code)
This canary was RETRIED 3 time(s) automatically and kept
failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
confirmed regression, not a transient blip — treat it as higher severity than a
first-tick halt.
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
on endolin-garden2-5bcdff64, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)
