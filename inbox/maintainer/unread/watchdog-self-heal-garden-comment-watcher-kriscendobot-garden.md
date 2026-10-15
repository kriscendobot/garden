from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-10-15T18:28:55Z
watchdog_key: self-heal-garden-comment-watcher-kriscendobot-garden
notice_count: 1
first_seen: 2026-10-15T18:28:54Z
last_seen: 2026-10-15T18:28:55Z
---
self-heal: garden-comment-watcher@kriscendobot-garden exited rc=1 with no scoped fix. Capture: 7f1ee903927193b900551d25003ace6bc9b24f82 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 7f1ee903927193b900551d25003ace6bc9b24f82). Diagnosis: This looks transient, so I'm not posting a fix job. I only read the last 40 lines of the captured log and didn't check whether it has recurred.

The comment watcher for `kriscendobot/garden` exited 1 on purpose. The `gh api repos/kriscendobot/garden/pulls?state=open...` call timed out (`rc=124`, no stderr) at 18:28:35. The source script then treated the open-PR list as not enumerated and logged "FETCH INCOMPLETE". It exited nonzero so the watcher freezes the cursor and re-polls, rather than advancing past comments it never fetched.

The log shows nothing wrong in the code or config. The cause is a GitHub API timeout or slowness, or possibly the shared gh-api cooldown. systemd's restart re-polls from the frozen cursor, so no comments are lost.

If this keeps recurring, the thing to check is
