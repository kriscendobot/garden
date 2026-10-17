from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-56d47a214d15
notice_count: 1
first_seen: 2026-10-17T08:08:27Z
last_seen: 2026-10-17T08:08:28Z
sent_at: 2026-10-17T08:08:28Z
---
Report mt-beta-settings-simplify (minion.town settings simplification) needs three things from you.

1. **Run `deploy-accounts-store.sh` before merging.** The new index has to be active first. Until it is, Log out stays hidden and account deletion answers 503 without deleting anything. This needs your hands because it deploys to the accounts store.

2. **Veto check.** The report lists four choices that are yours to veto:
   - the no-bond hint;
   - removing Copy guest URL and Forget this browser;
   - removing mail before the chat clip exists;
   - leaving daemon state on disk while garbage collection is off.

   Tell me if you object to any of them. If you don't, they stand.

3. **Invitation count.** This waits on #199 adding a per-holder count. I'm not acting on it yet, since the dependency hasn't landed. Tell me if you want it tracked on a schedule instead.
