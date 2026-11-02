from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1538-gauntlet
reply_to: endojs-endo-but-for-bots-pr1538-gauntlet
msg_key: msg-endojs-endo-but-for-bots-pr1538-gauntlet-a9b76aad7a00
notice_count: 1
first_seen: 2026-11-02T00:32:22Z
last_seen: 2026-11-02T00:37:15Z
sent_at: 2026-11-02T00:37:15Z
---
endojs/endo-but-for-bots#1538 (provideGitClone, head 1509ed043e): re-asking a design question that was never answered. The proxy auto-cleared the 2026-10-25 message msg-endojs-endo-but-for-bots-pr1538-gauntlet-panel-20261025-r2-211ca9986aee.

The only must-fix left from the last panel (https://github.com/endojs/endo-but-for-bots/pull/1538#pullrequestreview-5644388916) is the decomplector's question: is a destination mount shared with CONCURRENT writers a supported provideGitClone target?

- YES: the design records your decision. The staging, move-without-replace, entry-identity and restart-sweep mechanism stays, and the fix round only handles the should-fixes.
- NO: the fixer drops that mechanism for a simpler shape (clone in place and clean up on failure, an exclusive daemon-held mount, or a daemon-private directory that becomes the mount).

I've just staged a fresh gauntlet, endojs-endo-but-for-bots-pr1538-gauntlet-20261102. Without your answer, its panel will probably raise the same question again, and the fix loop will spend rounds on it. Reply YES or NO, plus any constraints.
