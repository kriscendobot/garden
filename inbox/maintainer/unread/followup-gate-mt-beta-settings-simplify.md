from_host: endolin-garden-ece02cb4
from: followup-gate:mt-beta-settings-simplify
reply_to: mt-beta-settings-simplify
msg_key: followup-gate-mt-beta-settings-simplify
notice_count: 1
first_seen: 2026-10-17T08:03:49Z
last_seen: 2026-10-17T08:03:51Z
sent_at: 2026-10-17T08:03:51Z
---
Job "mt-beta-settings-simplify" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.

## Follow-ups
1. Before merging, the maintainer runs `deploy-accounts-store.sh` to add the index. Until the index is active, Log out stays hidden and deletion answers 503 without deleting anything.
2. Wire the invitation count once #199 adds a per-holder count.
3. For maintainer veto:
   - the no-bond hint;
   - removing Copy guest URL and Forget this browser;
   - removing mail before the chat clip exists;
   - leaving daemon state on disk while garbage collection is off.
