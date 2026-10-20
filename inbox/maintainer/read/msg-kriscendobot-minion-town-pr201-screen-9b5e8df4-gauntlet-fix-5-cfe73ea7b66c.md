from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion-town-pr201-screen-9b5e8df4-gauntlet-fix-5
reply_to: kriscendobot-minion-town-pr201-screen-9b5e8df4-gauntlet-fix-5
msg_key: msg-kriscendobot-minion-town-pr201-screen-9b5e8df4-gauntlet-fix-5-cfe73ea7b66c
notice_count: 1
first_seen: 2026-10-20T20:15:45Z
last_seen: 2026-10-20T20:16:16Z
sent_at: 2026-10-20T20:16:16Z
---
kriscendobot/minion.town PR https://github.com/kriscendobot/minion.town/pull/201 (fix round 5): I pushed fixes for the code defects (fail-closed quota measure, exact preparation replies, receipt-gated cleanup, serialized same-suffix mints, an independent oracle). Two kinds of must-fix need a ruling from you, not a fix:
1. Authority (locksmith, purist, integrator, decomplector): every URL holder gets the writable `back`, which departs from https://github.com/kriscendobot/minion.town/pull/85. The PR body and designs/new-clip.md "Open questions" already ask whether the closed-beta directive overrides that direction until the https://github.com/kriscendobot/minion.town/pull/88 nonce lands. Your options: (a) accept the interim; (b) give visitors a read-only New Clip; (c) gate on the nonce first. Decomplector also asks you to drop NewClipPower and publish the directory directly.
2. Unbounded `list()` (saboteur, engine-realist): the daemon has no paginated or length-limited list/read, so an owner-grown directory is materialized in full before the caps apply. This needs an upstream Endo API, not a change in this PR.
Until you rule, the panel will keep requesting changes on these items.
