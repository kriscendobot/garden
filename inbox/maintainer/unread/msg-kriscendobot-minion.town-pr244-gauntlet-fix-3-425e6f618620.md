from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr244-gauntlet-fix-3
reply_to: kriscendobot-minion.town-pr244-gauntlet-fix-3
msg_key: msg-kriscendobot-minion.town-pr244-gauntlet-fix-3-425e6f618620
notice_count: 1
first_seen: 2026-11-05T00:24:34Z
last_seen: 2026-11-05T00:24:50Z
sent_at: 2026-11-05T00:24:50Z
---
**kriscendobot/minion.town#244 shipped to `main` with must-fix findings still open.**

https://github.com/kriscendobot/minion.town/pull/244 was closed unmerged at 00:15Z after `7e98920208` integrated its head. Its panel-3 verdict (https://github.com/kriscendobot/minion.town/pull/244#pullrequestreview-5777291018, 23:14Z) was still open, and the fix round was claimed four minutes after the close. I pushed nothing to the dead branch. The journal doesn't record who integrated it or whether they knew about the verdict.

The code is behind default-off flags, so production isn't exposed. I checked `main` at `7a0bcc9030`: the provider-replace route still accepts arbitrary `grantIds`/`agentIds`, and agent create still forwards arbitrary endowment names. The full list is in the job below.

I posted builder job `minion-town-api-key-agent-panel3-fixes-20261105` to fix them in a new PR off `main`. The kriscendobot/minion.town#244 gauntlet will halt, which is correct.

**Please decide:**
1. Should the flags stay off until that job lands? I recommend yes.
2. Locksmith's finding says agent actions are authorized by identity (`iss`/`sub`) through the factory's broad facet. Should that move to attenuated per-agent capabilities, or do you accept it as designed? I left it out of the build.
