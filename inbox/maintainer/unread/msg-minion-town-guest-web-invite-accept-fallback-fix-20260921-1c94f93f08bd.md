from_host: endolin-garden2-5bcdff64
from: gardener:minion-town-guest-web-invite-accept-fallback-fix-20260921
reply_to: minion-town-guest-web-invite-accept-fallback-fix-20260921
msg_key: msg-minion-town-guest-web-invite-accept-fallback-fix-20260921-1c94f93f08bd
notice_count: 1
first_seen: 2026-09-21T22:34:37Z
last_seen: 2026-09-21T22:34:39Z
sent_at: 2026-09-21T22:34:39Z
---
Re-parked: minion.town guest-web real invite/accept fix is BLOCKED on the pin refresh actually reaching main.

The predecessor pin-refresh job (minion-town-endo-daemon-pin-refresh-20260921) COMPLETED, but under the manual-gauntlet regime it stopped at an unmerged DRAFT: kriscendobot/minion.town#104 (branch endo-daemon-pin-89481580, base main-45e43bb frozen snapshot, MERGEABLE). main STILL pins the stale daemon f66505034... which lacks EndoGuest.accept. kriscendobot/minion.town#81's whole fix (replacing the storeIdentifier host-authority fallback with real guest invite/accept) cannot be verified against a real daemon until main carries the refreshed pin 89481580... (the endojs/endo-but-for-bots#1310 merge).

Per this job's own spec ("if [the pin refresh] is not yet [merged into main], re-park yourself blocked on it rather than proceeding against the stale pin") I did NOT proceed. I made no edits to kriscendobot/minion.town#81.

ACTION NEEDED (maintainer): run the gauntlet on kriscendobot/minion.town#104 and merge it so main carries 89481580..., then the parked successor auto-promotes.

I posted the successor job (full spec preserved) parked in plan/, blocked on kriscendobot/minion.town#104:
  minion-town-guest-web-invite-accept-fallback-fix-post104
The unblock watcher promotes it to todo/ when that PR merges/closes; its step 2 re-checks that main truly carries the refreshed pin and re-parks again if it merged only to its frozen base rather than main. Note that PR's base is the frozen main-45e43bb, so please ensure the merge actually lands the pin on main (retarget to main if needed).
