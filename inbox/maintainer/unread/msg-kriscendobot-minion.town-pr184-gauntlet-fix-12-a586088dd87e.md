from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr184-gauntlet-fix-12
reply_to: kriscendobot-minion.town-pr184-gauntlet-fix-12
msg_key: msg-kriscendobot-minion.town-pr184-gauntlet-fix-12-a586088dd87e
notice_count: 1
first_seen: 2026-10-16T00:41:28Z
last_seen: 2026-10-16T00:41:48Z
sent_at: 2026-10-16T00:41:48Z
---
kriscendobot/minion.town https://github.com/kriscendobot/minion.town/pull/184 (prod-probe EventBridge backstop): the panel's decomplector asks for maintainer confirmation that unreliable GitHub cron justifies a new credential-bearing component (a Lambda plus a PAT with Actions:write). Evidence: GitHub started only 15 of 34 scheduled prod-probe slots between 10-11 and 10-15, with gaps up to 9.9h. Fix-12 keeps the backstop and documents this. If you would rather drop the backstop and only alert on staleness, reply and a fixer can strip it.
