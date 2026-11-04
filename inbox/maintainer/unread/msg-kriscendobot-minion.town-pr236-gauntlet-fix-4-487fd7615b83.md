from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr236-gauntlet-fix-4
reply_to: kriscendobot-minion.town-pr236-gauntlet-fix-4
msg_key: msg-kriscendobot-minion.town-pr236-gauntlet-fix-4-487fd7615b83
notice_count: 1
first_seen: 2026-11-04T15:20:48Z
last_seen: 2026-11-04T15:20:50Z
sent_at: 2026-11-04T15:20:50Z
---
kriscendobot/minion.town#236 (remote invitation hints), fix round 4: the panel is split. The decomplector raises a MUST-FIX: drop servedInvitationLocator from inviteRemote, move the drift check to the box script's enable/status, and put hintIsServed back to base strictness. Breaker, purist and wire-watcher instead asked to make hintIsServed stricter, and I applied that in 7c8abacf (CI green). The decomplector's point is the PR's own Open question 3: do invitations need the served-hint filter at all, given the daemon is the only source? Please decide keep-filter vs. drop-filter before panel-5; otherwise the decomplector will likely raise the same must-fix again.
