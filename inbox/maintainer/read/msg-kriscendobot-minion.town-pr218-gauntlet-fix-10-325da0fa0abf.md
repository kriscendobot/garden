from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr218-gauntlet-fix-10
reply_to: kriscendobot-minion.town-pr218-gauntlet-fix-10
msg_key: msg-kriscendobot-minion.town-pr218-gauntlet-fix-10-325da0fa0abf
notice_count: 1
first_seen: 2026-10-24T03:29:30Z
last_seen: 2026-10-24T03:29:47Z
sent_at: 2026-10-24T03:29:47Z
---
kriscendobot/minion.town#218 (guest bond ledger, draft): the panel's decomplector wants you to confirm the IAM widening before this lands. The app role used to have only GetItem and PutItem. It would now also get two attribute-restricted UpdateItem grants, plus Query and DeleteItem on the ledger partition. A compromised serving process could then rebind or strip bonds and edit ledgers. Design § 2 now says why a GSI or Scan would not serve instead. Please confirm or reject it on https://github.com/kriscendobot/minion.town/pull/218. The PR stays draft until you do.
