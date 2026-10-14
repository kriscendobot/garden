from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-garden-book-pr15-gauntlet-fix-2
reply_to: kriscendobot-garden-book-pr15-gauntlet-fix-2
msg_key: gauntlet-followups-kriscendobot-garden-book-pr15-gauntlet-fix-2
notice_count: 1
first_seen: 2026-10-14T11:36:07Z
last_seen: 2026-10-14T12:21:07Z
sent_at: 2026-10-14T12:21:07Z
---
Gauntlet stage "kriscendobot-garden-book-pr15-gauntlet-fix-2" ("kriscendobot-garden-book-pr15-gauntlet", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.

## Follow-ups

- **Publish headroom:** there is about 150 KB to spare. If the book's text grows past that, the plates will need another squeeze; the new test will flag it. minion.town also plans to shrink the publish limit to about 64 KB, and in-band plates won't survive that.
- **Should-fix items left open:** publishing picks up stale `illumination-*.webp` files left in the output directory (for now the README says to build into a fresh directory). There are no escaping tests for alt text, and no test checks that each image's declared ratio matches its dimensions.
- **Setup note:** I created the bare clone `worktrees/kriscendobot-garden-book.git`, because the project-worktree script needed it and it didn't exist on this host.
