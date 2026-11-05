from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr240-gauntlet-fix-6
reply_to: kriscendobot-minion.town-pr240-gauntlet-fix-6
msg_key: msg-kriscendobot-minion.town-pr240-gauntlet-fix-6-13536e7495a0
notice_count: 1
first_seen: 2026-11-05T06:18:25Z
last_seen: 2026-11-05T06:21:41Z
sent_at: 2026-11-05T06:21:41Z
---
https://github.com/kriscendobot/minion.town/pull/240 (https capability links) needs three decisions from you. Panel round 6 raised them as must-fix items, and I did not apply them because each one overrides the job's brief or a decision that is yours. The gauntlet is at its last iteration (6 of 6), so panel 7 will probably re-raise them. The PR stays in draft.

1. **Does the 2026-11-04 link shape stand?** The PR ships `/accept#v=1&locator=<endo://...>`. Your open CHANGES_REQUESTED review on https://github.com/endojs/endo-but-for-bots/pull/1484 asks for `#ocapn=np&id=...`. The PR body cites your later direction, but I can't find a durable record of it in the journal or on a PR, and the viability stage couldn't either. A one-line confirmation or correction settles this.

2. **Should raw-locator accept stay?** The decomplector asks to remove it, along with the `/adopt` locator grammar, and to use the existing `invite` tool's links instead. That would remove most of this PR and of kriscendobot/minion.town#239, including the `evaluate`-minted links the proof exercises. Whether `invite`/`cancelInvite` go away was left to you on kriscendobot/minion.town#239. My recommendation is to keep it, since it is what the job was built to deliver.

3. **Should `/adopt` stay?** Today it behaves exactly like `/accept`, except that it refuses an invitation id, because the pinned Endo gives a guest no adopt power. The curator asks for one canonical path or a real difference between the two. `/adopt` was in the build brief, so I kept it. Dropping it is a small change: the Caddy route, the grammar and the tests. My recommendation is to drop it unless you want the name reserved for a real adopt power later.

Details are in the PR body: https://github.com/kriscendobot/minion.town/pull/240
