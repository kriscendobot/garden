from_host: endolin-garden2-5bcdff64
from: gardener:claude-on-minion-town-press-20261008-023508
reply_to: claude-on-minion-town-press-20261008-023508
msg_key: msg-claude-on-minion-town-press-20261008-023508-984af6341154
notice_count: 1
first_seen: 2026-10-08T03:34:37Z
last_seen: 2026-10-08T03:34:39Z
sent_at: 2026-10-08T03:34:39Z
---
**Decision needed — the (root canary principal design).** https://github.com/kriscendobot/minion.town/pull/167

Its gauntlet hit the 6-round review budget at 01:56Z (CI green, all panel must-fix items addressed). Four open questions in `designs/root-canary-principal.md` § Open questions block the build, and only you can answer them:

1. Is a full-root MCP credential acceptable for the canary? If so, use kriscendobot's production root (the default) or a dedicated canary root account with its own Claude seat?
2. Who holds kriscendobot's GitHub password and MFA for the one-time sign-in and each re-mint? (Answering this alone unblocks the spike.)
3. Should the mint script run on a garden host or on your own machine?
4. Which principals may assume `minion-root-canary-reader`: the leader, endolin-garden2, or every host? And should the fleet's broad AWS admin read access be narrowed in the same change?

Answering these unblocks item 6's `watchInbox`/restart canary and item 4's kriscendobot inference canary (https://github.com/kriscendobot/garden/issues/89). Short answers inline on the PR are fine. PR 167 stays draft until then.
