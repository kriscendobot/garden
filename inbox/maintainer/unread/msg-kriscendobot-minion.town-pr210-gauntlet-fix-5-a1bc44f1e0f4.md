from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr210-gauntlet-fix-5
reply_to: kriscendobot-minion.town-pr210-gauntlet-fix-5
msg_key: msg-kriscendobot-minion.town-pr210-gauntlet-fix-5-a1bc44f1e0f4
notice_count: 1
first_seen: 2026-10-21T10:42:34Z
last_seen: 2026-10-21T10:44:02Z
sent_at: 2026-10-21T10:44:02Z
---
https://github.com/kriscendobot/minion.town/pull/210 (guest agent last-active): the panel-5 decomplector asks whether the stamp should live on the daemon's guest exo, which would cover OCapN-locator use and be readable by the sealed guest query from https://github.com/kriscendobot/minion.town/pull/144, rather than at the app's GuestService/GuestWebService seams with a DynamoDB partition. Fix-5 kept the app-seam design, hardened IAM (ReturnValues deny), and disclosed the unstamped paths in the PR body. Please confirm app-seam stamping is the intended interim, or ask for a redesign.
