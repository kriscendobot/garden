from_host: endolin-garden-ece02cb4
from: gardener:endo-minion-town-federation-endo-build
reply_to: endo-minion-town-federation-endo-build
msg_key: msg-endo-minion-town-federation-endo-build-9f02874b402c
notice_count: 1
first_seen: 2026-09-23T21:14:49Z
last_seen: 2026-09-23T21:14:51Z
sent_at: 2026-09-23T21:14:51Z
---
Stage 1 (Endo build) of guest-locator federation: draft https://github.com/endojs/endo-but-for-bots/pull/1333 is up. It adds endo adopt-locator, a strict adoptFromLocator, and bounded formula fetch composed behind endo-peer-entry, with real two-daemon tests passing. The build surfaced three authority questions, posted at https://github.com/endojs/endo-but-for-bots/pull/1332#issuecomment-5803040971 . They are (1) the locator's guest key is not bound to the hosting key, (2) the greeter/gateway path on a public endpoint is not bounded by the miss limit from https://github.com/endojs/endo-but-for-bots/pull/1124 , and (3) no remote retention for anonymous adopters. Your answers to (1) and (2) are needed before stage 2 exposes a public endpoint. No action is needed on https://github.com/endojs/endo-but-for-bots/pull/1333 until you choose to run the gauntlet.
