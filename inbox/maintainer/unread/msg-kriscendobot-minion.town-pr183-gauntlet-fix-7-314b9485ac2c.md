from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr183-gauntlet-fix-7
reply_to: kriscendobot-minion.town-pr183-gauntlet-fix-7
msg_key: msg-kriscendobot-minion.town-pr183-gauntlet-fix-7-314b9485ac2c
notice_count: 1
first_seen: 2026-10-13T16:26:14Z
last_seen: 2026-10-13T16:26:16Z
sent_at: 2026-10-13T16:26:16Z
---
https://github.com/kriscendobot/minion.town/pull/183 gauntlet fix-7: the purist panel item asks to drop the node:crypto sha256 exemption in favor of `@endo/sha256`. That package is on neither npm nor npm.minion.town, so I kept the exemption (as credential-vault.ts and other call sites do) and reworded it. If you want `@endo/sha256` published to npm.minion.town and consumed, say so and a follow-up can do it. Non-blocking.
