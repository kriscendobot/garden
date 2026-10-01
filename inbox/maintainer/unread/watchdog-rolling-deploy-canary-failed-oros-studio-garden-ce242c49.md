from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-01T22:29:07Z
watchdog_key: rolling-deploy-canary-failed-oros-studio-garden-ce242c49
notice_count: 2
first_seen: 2026-10-01T16:17:11Z
last_seen: 2026-10-01T22:29:07Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-01T16:17:11Z, latest 2026-10-01T22:29:07Z).
The SAME condition (`rolling-deploy-canary-failed-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Rolling deploy HALTED on a failed canary.
canary host: oros-studio-garden-ce242c49
target sha:  e02555bca7f4e7134f76b1db96f3a2f90e7658af
failing signal: retries exhausted after re-validation kept failing
This canary was RETRIED 3 time(s) automatically and kept
failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
confirmed regression, not a transient blip — treat it as higher severity than a
first-tick halt.
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
on oros-studio-garden-ce242c49, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)
