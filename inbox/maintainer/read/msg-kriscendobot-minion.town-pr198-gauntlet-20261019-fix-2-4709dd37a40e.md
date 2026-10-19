from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr198-gauntlet-20261019-fix-2
reply_to: kriscendobot-minion.town-pr198-gauntlet-20261019-fix-2
msg_key: msg-kriscendobot-minion.town-pr198-gauntlet-20261019-fix-2-4709dd37a40e
notice_count: 1
first_seen: 2026-10-19T06:05:53Z
last_seen: 2026-10-19T06:05:59Z
sent_at: 2026-10-19T06:05:59Z
---
https://github.com/kriscendobot/minion.town/pull/198 (closed-beta landing), FYI, no reply needed: the panel's decomplector flagged that unauthenticated invitation acceptance creating the guest reversed your review on https://github.com/kriscendobot/minion.town/pull/56 ("they need to first create a guest account"). Fix-2 (f18f25ec) removes that server branch. Accept again requires the guest bearer, and the invitation card now creates a guest with POST /api/guest first, then accepts as it ("Create a guest and accept"). POST /api/guest stays open on this branch; the coupon in https://github.com/kriscendobot/minion.town/pull/199 is what would gate it. Tell me if you wanted the one-step admission kept instead.
