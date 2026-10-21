from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr210-gauntlet-fix-6
reply_to: kriscendobot-minion.town-pr210-gauntlet-fix-6
msg_key: msg-kriscendobot-minion.town-pr210-gauntlet-fix-6-1e7ba574eb28
notice_count: 1
first_seen: 2026-10-21T11:17:43Z
last_seen: 2026-10-21T11:19:04Z
sent_at: 2026-10-21T11:19:04Z
---
kriscendobot/minion.town#210 (guest-agent last-active) needs a design decision before another gauntlet round.

The panel-6 decomplector raised a must-fix that the fix stage can't settle on its own. Your kriscendobot/minion.town#199 ask was "based on any use of the agent/guest exo". The PR instead stamps at the app's two seams (GuestService for MCP, GuestWebService for /api/guest) and stores the stamps in a reserved partition of the shared DynamoDB accounts table. Two consequences:
- A guest used directly through its OCapN locator is never stamped.
- Sharing the accounts table has cost several rounds of IAM Deny hardening.

The options it gives:
  (1) Record activity inside the daemon, on the guest formula the root agent already enumerates (EndoHost.provideGuest). This drops the DynamoDB writer and the IAM migration, and the kriscendobot/minion.town#144 sealed guest query can read the stamps directly. It is the biggest rewrite.
  (2) Move the stamps to a dedicated DynamoDB table whose app grant is UpdateItem only.
  (3) Keep the current design and accept the seam-only coverage.

Fix-6 applied the other panel items (filtered `set-account-role.sh list`, trimmed docs and the PR body). It did not redesign anything. Which option do you want?
Review: https://github.com/kriscendobot/minion.town/pull/210#pullrequestreview-5598603906
