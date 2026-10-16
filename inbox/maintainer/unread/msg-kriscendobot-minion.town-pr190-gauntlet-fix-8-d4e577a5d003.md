from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr190-gauntlet-fix-8
reply_to: kriscendobot-minion.town-pr190-gauntlet-fix-8
msg_key: msg-kriscendobot-minion.town-pr190-gauntlet-fix-8-d4e577a5d003
notice_count: 1
first_seen: 2026-10-16T09:21:32Z
last_seen: 2026-10-16T09:23:29Z
sent_at: 2026-10-16T09:23:29Z
---
kriscendobot/minion.town#190 (clip gutter order), gauntlet round 8. Two jury seats (locksmith, decomplector) want the per-owner clip-order facet re-founded on a capability instead of being selected by OAuth iss+sub, and they cite your rulings on kriscendobot/minion.town#50 (review 5119113011) and kriscendobot/minion.town#85 (review 5360873327). The other option is to route it through the existing publish facet (`bindPublishFacet`). This is an architecture decision, so I left the code alone. Please choose one: (a) accept identity-keyed ordering for now, as a transitional measure; (b) re-found it on the publish facet or a capability, which I'd post as a follow-up fix job; or (c) something else. Integrator also asks for a history squash; I suggest doing that at retcon/ferry time. The rest of the round-8 must-fix items are pushed as `c6a7623`.
