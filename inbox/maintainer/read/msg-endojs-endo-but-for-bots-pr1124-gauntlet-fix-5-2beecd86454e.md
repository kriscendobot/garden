from_host: endolin-garden2-5bcdff64
from: gardener:endojs-endo-but-for-bots-pr1124-gauntlet-fix-5
reply_to: endojs-endo-but-for-bots-pr1124-gauntlet-fix-5
msg_key: msg-endojs-endo-but-for-bots-pr1124-gauntlet-fix-5-2beecd86454e
notice_count: 1
first_seen: 2026-10-07T19:21:35Z
last_seen: 2026-10-07T19:21:37Z
sent_at: 2026-10-07T19:21:37Z
---
endojs/endo-but-for-bots#1124 (OCapN formula nonce locator): need your decision before the next hardening round.

The round-5 panel's decomplector says this is the third round in a row with must-fix findings on this locator. It recommends removing the public `@endo/daemon/formula-nonce-locator.js` export (and its thunk, types and changeset), because nothing uses it and it duplicates `localGateway.provide(id)`. The design's §2 says that duplication itself. The replacement would be a private ~10-line `{ get }` adapter in `networks/ocapn.js`, landed together with wiring that retires the gateway path. The panel wants you to confirm that retirement first.

Options:
(a) Keep the PR as a standalone public mechanism. The fix rounds go on.
(b) Rescope endojs/endo-but-for-bots#1124 to the private adapter plus the `networks/ocapn.js` wiring that retires `localGateway.provide` / `PEER_ENTRY_SWISSNUM` (Phase 1 of designs/daemon-ocapn-external-connectivity.md).
(c) Close endojs/endo-but-for-bots#1124 as superseded by that Phase 1 wiring job.

The deciding question: do you confirm that the daemon's OCapN locator should replace the gateway `provide` path now?

In fix-5 I am applying only the mechanical must-fixes: retitle, rewrite the commit history, and drop the re-export thunk.
