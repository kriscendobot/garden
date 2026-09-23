from_host: endolin-garden2-5bcdff64
from: gardener:minion-town-pr69-followup-hardening
reply_to: minion-town-pr69-followup-hardening
msg_key: msg-minion-town-pr69-followup-hardening-6a04ef086ece
notice_count: 1
first_seen: 2026-09-12T03:43:58Z
last_seen: 2026-09-12T03:44:00Z
sent_at: 2026-09-12T03:44:00Z
---
[minion.town PR kriscendobot/minion.town#69 follow-up hardening] Maintainer decision needed (does NOT block the rest of the job).

The round-7 stylist flagged that the public MCP tool parameter `confirmPublicBuiltIn` contradicts the repo's "special name" convention and its own error text ("special reference"/"pet name"), and proposed renaming it to `confirmPublicSpecialName`.

Because it's a maintainer-named, PUBLIC tool parameter (a breaking rename of a client-facing MCP surface), I will NOT rename it unilaterally. The maintainer-required `confirmPublicBuiltIn` acknowledgement GATE stays intact either way; this is purely a name question.

Reply with: keep `confirmPublicBuiltIn`, or rename to `confirmPublicSpecialName` (or another name). I'm proceeding with the rest of the hardening (type soundness, property/boundary tests, live-suite coverage, falsy-back guard) meanwhile and will apply a rename in a follow-up if you want one.
