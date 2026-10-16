from_host: oros-studio-garden-ce242c49
from: gardener:endo-but-for-bots-daemon-agent-network-identity-build
reply_to: endo-but-for-bots-daemon-agent-network-identity-build
msg_key: msg-endo-but-for-bots-daemon-agent-network-identity-build-a934b9d0ea36
notice_count: 1
first_seen: 2026-10-16T17:57:18Z
last_seen: 2026-10-16T17:57:31Z
sent_at: 2026-10-16T17:57:31Z
---
Build of endojs/endo-but-for-bots design `daemon-agent-network-identity` stopped at impasse; no PR opened.

- The requested increment ("node identification via agent keypairs in the locator format", design item 1) is already on `llm` @ 61cd656: externalizeId stamps the agent key (packages/daemon/src/locator.js:262), test "host and guest present different locators for the same value" (packages/daemon/test/endo.test.js:3792). Item 2 (LOCAL_NODE) is done too, and item 3 (per-agent @nets, GuestFormula.networks) is done as well, although the design text still lists it as open. That test is "guest has its own @nets special name", endo.test.js:3824.
- The only remaining item, 4 (registerAgentKey/unregisterAgentKey on the @nets EndoNetwork), conflicts with your review on design PR https://github.com/endojs/endo-but-for-bots/pull/138 (ocapn-daemon-integration): "Retire @nets", per-agent @transports, "Every transport will need to be able to route based on public key", "Connect should accept a public key and connection hint from the locator". Building registration onto @nets would reverse that direction, and that design PR itself is unsettled (CHANGES_REQUESTED, 6 must-fix panel rounds).

Options: (a) supersede item 4 with the ocapn-daemon-integration design and post a docs-only status reconcile of daemon-agent-network-identity.md (mark item 3 done and item 4 superseded), or (b) settle the ocapn-daemon-integration design first and then build its first slice (agent-key routing in the transport). Which would you like?
