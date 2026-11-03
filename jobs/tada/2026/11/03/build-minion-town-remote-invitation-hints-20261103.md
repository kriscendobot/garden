## Completion report: build-minion-town-remote-invitation-hints-20261103

I opened two draft PRs that together make a remote invitation carry a dialable connection hint. A second daemon accepting one of these invitations has **not** been shown yet: my two-daemon test died mid-dial in this sandbox. Nothing was deployed, and no routing, Caddy, port or firewall changes were made.

**Draft PRs**
- **Endo:** https://github.com/endojs/endo-but-for-bots/pull/1647, based on the frozen snapshot `llm-48d6f3e`. It adds an `advertiseHost` option to the TCP transport. The daemon's OCapN network now reads an optional `ocapn-advertise-addr` (`host` or `host:port`) and puts that host in its connection hint instead of the bind address. The port is always the bound port. A malformed value, or a port that differs from `ocapn-listen-addr`, is rejected rather than falling back to an undialable address.
- **minion.town:** https://github.com/kriscendobot/minion.town/pull/236, based on the frozen snapshot `main-9196892`. When federation routes are configured, a remote invitation keeps only hints that match `ENDO_FEDERATION_ROUTES` and name the daemon that minted it. This is the same rule the guest locator already uses. If no hint survives, the invitation is cancelled and the route answers 503. Without federation, behavior is unchanged. `DEPLOYMENT.md` now links #1647, and there is a changeset.
- **Garden `main2` (`23de5f385e9`):** `context/operations/minion-town-mcp.md` § Remote invitations now explains the cause and links both PRs.

**Where the hints come from (step 1)**
- `EndoGuest.invite` mints the invitation, and its `locate()` builds the locator from `getPeerInfo().addresses`.
- Those addresses come from every ready network in the **root host's** `@nets`, not the guest's.
- The account daemon has only `loop`, which advertises nothing, so the locator has no hints.

**Cheapest real network (step 2)**
- It is Endo's stock OCapN-Noise TCP network on :8940, which is merged on `llm`. minion.town's `endo-federation-box.sh enable` already installs it as `@nets/ocapn`.
- What was missing is the setting this PR adds: on current `llm` (and at the pin `1706e632`) the network advertises its bind host, so a public listener would advertise `0.0.0.0`. The federation script already stores `ocapn-advertise-addr` and refuses to enable until Endo honors it.
- The WebSocket route at `/.well-known/ocapn-cbor-np` serves the demo containers, not the account daemon. The WS+Noise netlayer (#684) is not needed.

**Locator before and after (local scratch daemon on the #1647 branch)**
- **Before:** `endo://<node>/<number>?type=invitation&from=…&fromNode=…`, a single path component.
- **After** (`ocapn-advertise-addr=localhost:18940`, invitation minted as a guest): a second path component, the hint.
- **Hint format:** `ocapn+noise+tcp://<advertised-host>:<bound-port>/?node=<daemon node>&loc=<URI-encoded OCapN location JSON>`. In the location, `hints` holds `tcp:host` (the advertised host) and `tcp:port`. In production it would be `ocapn+noise+tcp://minion.town:8940/?node=…&loc=…`.

**Tests**
- minion.town: 43 passed across `endo-guest-locator` and `guest-self-endpoint`, including 4 new invitation cases; `tsc` is clean.
- Endo `networks-ocapn.test.js`: 11 passed. The new test has a peer dial the advertised address and complete the handshake and a gateway round trip.
- Endo `ocapn-noise/test/network-tcp.test.js`: did not start locally. It fails the same way on unmodified `llm` (an `@endo/errors` start-up error), so CI is the check there.
- **Two-daemon accept: not shown.** A second daemon running `endo accept` failed with "Connection stream ended": both daemons' worker processes died between and during my shell calls. Re-run it on a normal host before relying on cross-daemon acceptance.

**What a production deploy would need (requests to the maintainer, in #236)**
1. Merge #1647. Federation also stays blocked on the separate hard blocker in `DEPLOYMENT.md`: binding the peer gateway to the session (endo-but-for-bots#1335, still draft).
2. Bump `ENDO_COMMIT` and `PINNED_ENDO_COMMIT` together to a merged `llm` commit containing both.
3. Run `deploy-endo-federation.sh preflight`, then `enable`. That stores the listen and advertise addresses, installs `@nets/ocapn`, sets `ENDO_FEDERATION_ROUTES`, and opens tcp/8940.
4. Restarts in steps 2 and 3 cancel all pending invitations, because they are held only in process memory. Mint fresh links after the deploy.

**Open questions (also in #236)**
1. Should a remote invitation answer 503 when federation is off, instead of today's hintless locator?
2. Should the advertised host be `minion.town` or a dedicated name such as `ocapn.minion.town`? Every locator embeds it permanently.
3. Federation `status`/`enable` also require #1333's `makeWellKnownLocatorForSession`, which is not on `llm`. Should invitation hints get a lighter gate that needs only #1647 and #1335?
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-remote-invitation-hints-20261103.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 162 tokens (8250639 cached reads)
- Output: 42926 tokens
- Cost: $3.5874238000000007
- Wall-clock: 575s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
