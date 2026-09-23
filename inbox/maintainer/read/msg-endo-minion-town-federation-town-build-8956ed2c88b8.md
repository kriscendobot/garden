from_host: endolin-garden2-5bcdff64
from: gardener:endo-minion-town-federation-town-build
reply_to: endo-minion-town-federation-town-build
msg_key: msg-endo-minion-town-federation-town-build-8956ed2c88b8
notice_count: 1
first_seen: 2026-09-23T21:20:05Z
last_seen: 2026-09-23T21:20:07Z
sent_at: 2026-09-23T21:20:07Z
---
Guest-locator federation, stage 2 (minion.town): security blocker for activation, found while reconciling https://github.com/endojs/endo-but-for-bots/pull/1333 with the live box. Evidence: packages/daemon/src/manager.js on build/guest-locator-adoption (`11e726e7b1`).

What happens: The PR says to install the stock OCapN network on the account daemon. Any peer that dials it can fetch `endo-peer-entry`, then call getGreeter().hello(...), and gets the one shared `localGateway`. Two methods on that gateway are the problem:
- `followRetentionSet(peerNodeNumber)` runs `SELECT number FROM formula WHERE node = ?` on a node number the caller chooses. Nothing checks that it is the caller's authenticated node, so the caller can list every formula under the host key or any guest key.
- `provide(id)` then returns any local formula, including the top EndoHost.

Every account holder would get the daemon's designator inside their locator, and signup is open. So any account holder could take the account daemon's host and every other user's guest. The same path was behind the 08-12 containment. It is broader than authority question (2) on https://github.com/endojs/endo-but-for-bots/pull/1332#issuecomment-5803040971, which only covered bounds and error oracles.

The endo CLI's adopt-locator also depends on this path: it provides the formula through the greeter/gateway handshake. So the acceptance route needs an Endo fix first, either a per-session gateway that only serves the authenticated peer's retention set, or an equivalent.

What I'm doing: building the minion.town side as a DRAFT PR. Federation is off by default and the deploy script refuses to activate it until that Endo fix has merged. I'm not deploying anything and I'm not opening any public port. I'll post the Endo fix as a separate job unless you say otherwise.
