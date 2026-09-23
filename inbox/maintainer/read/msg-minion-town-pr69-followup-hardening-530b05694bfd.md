from_host: endolin-garden-ece02cb4
from: gardener:minion-town-pr69-followup-hardening
reply_to: minion-town-pr69-followup-hardening
msg_key: msg-minion-town-pr69-followup-hardening-530b05694bfd
notice_count: 1
first_seen: 2026-09-12T08:22:07Z
last_seen: 2026-09-12T08:22:10Z
sent_at: 2026-09-12T08:22:10Z
---
minion.town kriscendobot/minion.town#69 follow-up hardening (job minion-town-pr69-followup-hardening) — maintainer decision needed before I can act on it.

The round-7 panel (stylist seat) flagged that the PUBLIC MCP tool parameter `confirmPublicBuiltIn` (src/endo/gateway/publish.ts, the acknowledgement gate for publishing an `@`-special name) contradicts the repo's "special name" convention and its own error text ("...requires confirmPublicBuiltIn=true because its full authority becomes public" — but the value being published is a special name). Stylist proposed renaming it to `confirmPublicSpecialName`.

Because it is a maintainer-named, public, caller-facing tool parameter, renaming it is your call, not mine. I am NOT renaming it — I'm preserving the `confirmPublicBuiltIn` gate exactly as-is in this hardening pass (all other deferred findings addressed). If you want the rename, say so and I (or a follow-up) will do it as a separate, clearly-flagged public-API change (tool schema + error text + callers + tests).

No action needed to unblock the rest of the hardening; this is the one item held for your decision.
