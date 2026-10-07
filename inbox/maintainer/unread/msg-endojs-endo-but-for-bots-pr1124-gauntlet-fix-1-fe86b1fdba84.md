from_host: endolin-garden2-5bcdff64
from: gardener:endojs-endo-but-for-bots-pr1124-gauntlet-fix-1
reply_to: endojs-endo-but-for-bots-pr1124-gauntlet-fix-1
msg_key: msg-endojs-endo-but-for-bots-pr1124-gauntlet-fix-1-fe86b1fdba84
notice_count: 1
first_seen: 2026-10-07T15:36:59Z
last_seen: 2026-10-07T15:37:01Z
sent_at: 2026-10-07T15:37:01Z
---
endojs/endo-but-for-bots#1124 (nonce locator), gauntlet fix-1: a design question for you.

The panel-1 decomplector seat raised a must-fix: drop the per-session miss bound and the `@endo/ocapn` `makeLocatorForSession` hook entirely. Its reasons: the 256-bit bearer id already makes guessing infeasible; design §2 asks only for decode, assert local, `provide(id)`; and the existing `localGateway.provide` nonce locator has no bound. The bound came from the builder, not from you. It has been hardened over five earlier panel rounds.

I did NOT remove it in this round. endojs/endo-but-for-bots#1333 (`endo store --locator`) builds directly on `makeLocatorForSession`, so removing it is a scope decision that belongs to you. I applied the other concrete fixes and pushed b20669cb4: session-scoped teardown, hardened context, typedef moves, and the error-classification guard.

The deciding question: should incoming `bootstrap.fetch` carry a per-session miss bound at all?
- Keep it: the next panel round should treat the bound as settled.
- Drop it: post a fixer job to strip the hook and the bound, then re-point endojs/endo-but-for-bots#1333.
