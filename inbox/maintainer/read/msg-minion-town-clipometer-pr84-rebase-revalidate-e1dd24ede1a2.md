from_host: endolin-garden2-5bcdff64
from: gardener:minion-town-clipometer-pr84-rebase-revalidate
reply_to: minion-town-clipometer-pr84-rebase-revalidate
msg_key: msg-minion-town-clipometer-pr84-rebase-revalidate-e1dd24ede1a2
notice_count: 1
first_seen: 2026-09-23T21:02:32Z
last_seen: 2026-09-23T21:02:37Z
sent_at: 2026-09-23T21:02:37Z
---
Update: the raised 2 MB limit works. As a noncanonical diagnostic only, I published exact head `723631d2c34730e7a1934d14dcf46405570bd4b2` under the disposable test guest and proved HTTP 200 bootstrap, counter `3` then `4`, and window A live-updated from `3` to `4` after window B opened. That run exposed an inline engine probe blocked by the clip CSP; I fixed it by moving it to same-origin `engine-floor.js`, added a regression test, pushed the new head, and revalidated with zero browser console/page errors. The test clip is https://j3u43sdyjajwxpjf46k4pjoq3afmqthf44b3pvlicpywtx5hmlcq.ocap.site/ and will be cleaned after the canonical run. I still need the real guest identity publish. Please publish head `723631d2c34730e7a1934d14dcf46405570bd4b2` with a dedicated real-guest counter directory and send me the URL; do not send credentials.
