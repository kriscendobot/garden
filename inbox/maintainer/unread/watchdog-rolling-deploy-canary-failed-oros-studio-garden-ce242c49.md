from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-11-07T22:14:10Z
watchdog_key: rolling-deploy-canary-failed-oros-studio-garden-ce242c49
notice_count: 3
first_seen: 2026-11-07T11:35:09Z
last_seen: 2026-11-07T22:14:10Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-07T11:35:09Z, latest 2026-11-07T22:14:10Z).
The SAME condition (`rolling-deploy-canary-failed-oros-studio-garden-ce242c49`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Rolling deploy HALTED on a failed canary.
canary host: oros-studio-garden-ce242c49
target sha:  3c7f9ce045e9fc9b5bace542c877cc6b909a03c3
failing signal: probe 'canary-probe-oros-studio-garden-ce242c49-3c7f9ce045e9-r3' did not reach tada within 600s (claim/spine broken on new code)
This canary was RETRIED 3 time(s) automatically and kept
failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
confirmed regression, not a transient blip — treat it as higher severity than a
first-tick halt.
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
on oros-studio-garden-ce242c49, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)
