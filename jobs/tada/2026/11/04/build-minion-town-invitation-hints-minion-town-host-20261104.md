**Completion report: `build-minion-town-invitation-hints-minion-town-host-20261104`**

Remote invitations now advertise host `minion.town`, but over TCP (`minion.town:8940`), not the WS path. A second scratch daemon accepted one, which is the step that did not complete last time. The WS route needs unmerged Endo work and a Caddy change, so TCP stays as the fallback and WS is an explicit request to the maintainer.

**Transport findings (Endo `llm` at `48d6f3e08b`)**
- **Listening:** the daemon's `networks/ocapn.js` registers only the TCP transport, so the account daemon can't listen on WS.
- **Public URL:** `makeWebSocketTransport` advertises its bind address and can't name a public URL.
- **Dialing:** a stock daemon's `supports` accepts only `ocapn+noise+tcp`, so a network module in minion.town alone wouldn't help acceptors.
- **Routing:** `/.well-known/ocapn-cbor-np` currently proxies to the demo container on 8931, not the account daemon.
- **Endo PR 684:** still a draft, with the maintainer's changes-requested review asking to return after the multi-transport refactor.

**Changes**
- **https://github.com/kriscendobot/minion.town/pull/236** (still draft, head `6cc65039`):
  - `DEPLOYMENT.md` records the `minion.town` decision and lists what the WS route needs, including the exact Caddy change.
  - Two new tests pin the daemon-minted `minion.town:8940` hint and show a WS hint is dropped.
  - The description is rewritten as an outcome report with both locators, the Caddy change and the scratch WS diff.
- **Endo PR 1647:** no change; it is still required for the TCP fallback.

**Proof (scratch daemons, each in its own `systemd-run --user --scope`)**
- **Locator:** before, it had no hints; after, its hint is `ocapn+noise+tcp://minion.town:8940/?node=…&loc=…`, with both locators in the PR.
- **Two-daemon accept:** it completed, with messages delivered both ways.
- **Single use:** a second accept of the same invitation was refused.
- **Served-hint filter:** a locator passed through `servedInvitationLocator` came back unchanged and was accepted.
- **Undialable acceptor:** an acceptor advertising an undialable host also accepted, sent and got a reply.
- **WS trial:** a scratch patch of about 50 lines, not committed, accepted through `wss://minion.town/.well-known/ocapn-cbor-np`. A stock daemon refused the same kind of invitation with `Cannot connect to peer: no supported addresses`.

**Limits of the proof**
- It ran on one host, with `minion.town` mapped to loopback in a private mount namespace; nothing crossed the internet.
- The WS trial used a small Node TLS stand-in, not Caddy.
- Invitations came from `endo invite --as <guest>`, not through `POST /api/guest/invitations`.

**Checks:** the three affected test files pass (56 tests), the pre-push gate passes, and CI (`test (typecheck + vitest)`) is green at `6cc65039`. The gate gave one non-blocking comment-length warning on existing code in `src/endo/guest-locator.ts`. There was no deploy and no routing, port or firewall change, and all scratch daemons and proof files are removed.

**Follow-ups (maintainer)**
- **Decision sent:** should the Endo WS work start now as a fresh PR replacing Endo PR 684? I recommended yes, landing it before federation is enabled, because locators embed their hints permanently; the catch is that acceptors then need an Endo release with the WS transport.
- **Still open on PR 236:** two earlier questions remain, on returning 503 when federation is off and on whether the Endo PR 1333 gate is still needed.
- **Blocker:** Endo PR 1335 (still draft) blocks enabling federation on either transport.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-invitation-hints-minion-town-host-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (2697096 cached reads)
- Output: 40443 tokens
- Cost: $2.5054232
- Wall-clock: 1522s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
