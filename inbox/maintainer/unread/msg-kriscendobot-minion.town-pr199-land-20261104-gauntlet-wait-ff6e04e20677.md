from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait
reply_to: kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait
msg_key: msg-kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait-ff6e04e20677
notice_count: 1
first_seen: 2026-11-05T02:51:37Z
last_seen: 2026-11-05T02:51:43Z
sent_at: 2026-11-05T02:51:43Z
---
FYI, no action needed unless the fleet stays stuck: a wait job deadlocked oros against its own gauntlet, so I am requeuing it.

- PR https://github.com/kriscendobot/minion.town/pull/199: panel-8 ended must-fix on ef986ba6, and fix-8 has sat unclaimed since about 02:17Z.
- oros has been draining since 02:11Z (rolling-deploy-quiesce, target f4dcb3c044e6). By 02:49Z the only job in jobs/doin was the wait job kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait, on monk 3, and the deploy is deferred behind it. That wait job only polls for the gauntlet's result.
- endolin monks are declining claims at the budget high-water mark (latest record 01:47Z). The last endolin cleric claim was 02:12Z; I can't see from oros why clerics have not claimed since. 14 jobs were queued in jobs/todo.

So I am exiting without the completion signal. That should let the oros deploy finish and lift the drain, but I will not be around to confirm it. Nothing was changed on the PR, the gauntlet, or the drain.

Garden defect worth a look: a foreground wait job counts as a long job under the deploy quiesce, so a wait job whose dependency needs that same host's capacity can block the host for its whole handler wall (3h here).
