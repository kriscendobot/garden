---
posted_at: 2026-11-04T09:08:53Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
requires: host=endolin-garden-ece02cb4

# Post the review reply on endojs/endo-but-for-bots PR #1335

The code for review https://github.com/endojs/endo-but-for-bots/pull/1335#pullrequestreview-5764182424 is pushed as d2c0bf314e86dce4ab005e9ed6a16263ea0711ad on `build/ocapn-gateway-session-binding`. The original job's host gets a 403 on PR writes. Do not change code. Do these steps with the fleet `gh`, and write each block below to a file verbatim:

1. Reply on inline thread 4464366322: `gh api -X POST repos/endojs/endo-but-for-bots/pulls/1335/comments/4464366322/replies -F body=@<file>`. Skip it if a reply from kriscendobot already exists.
2. Post the top-level summary with `gh pr comment 1335 -R endojs/endo-but-for-bots --body-file <file>`. Skip it if it is already posted.
3. Replace the PR body with `gh pr edit 1335 -R endojs/endo-but-for-bots --body-file <file>`.
4. Check CI on the head through the Actions runs API, waiting in the foreground for up to 60 minutes while runs are in progress. If the head has moved past d2c0bf314e, say so in the report and do not re-request review. If every run on the head is green, re-request review: `echo '{"reviewers":["kriskowal"]}' | gh api repos/endojs/endo-but-for-bots/pulls/1335/requested_reviewers --input -`. If a run is red or still unfinished, do not re-request; post a shepherd job for #1335 and name it in your report.

## Inline reply

Done in d2c0bf314e: the session greeter, connection canceller, and network service in this file now use `makeExo` with interface guards, and so do the daemon's greeter and both gateways in `manager.js`. The fakes in the test fixtures remain `Far`. Transport-side `Far` calls in `tcp-netstring.js`, `iroh.js`, and `ws-relay.js` are outside this PR, so I left them.

## Top-level summary

@kriskowal Yes, partly. I simplified the OCapN path in d2c0bf314e. The daemon's crossed-hello settling was worse than redundant there, but it can't be removed entirely yet.

**What was wrong.** When two daemons dial each other at once, the OCapN session manager settles them onto one session. `RemoteControl` then settled the same crossing again and cancelled one side, which aborted that shared session. Both dials failed with `Session disconnected`. The new test `two daemons that dial each other at once keep their one OCapN session` fails that way on this PR's previous head and on its base, so the bug predates this PR.

**What changed**
- **Crossed hellos:** a hello that arrives while this daemon is dialing the same session key no longer competes with the dial (`EndoGreeter.acceptSession`). OCapN's settlement stands.
- **Session `hello`:** it no longer takes a canceller. This PR already ignored the peer's canceller, because each side enforces its own miss bound on its own session.
- **Static peer entry:** removed, since every session's locator shadowed it.
- **`makeExo`:** the session greeter, connection canceller, network service, daemon greeter, and both gateways now use it with interface guards (your inline comment). Test fakes stay `Far`.

**What can't go yet**
- **Restarted peers:** the session manager keys sessions by the ephemeral session key, and a restarted peer mints a new one. Only the daemon can tell that the new session and the stale one belong to the same agent, so `RemoteControl` still replaces a dial in that case. It also lets an outbound call reuse an inbound session when the stored address is out of date.
- **Other transports:** `tcp-netstring`, `iroh`, and `ws-relay` have no session layer, so they still need the state machine. `isAbandonError` and `resilientDial` stay for them too.

Deleting `remote-control.js`, as Phase 3 of `designs/daemon-ocapn-external-connectivity.md` plans, would need those transports retired and agent identity tied to OCapN sessions. That is your call and outside this PR, so I haven't started it.

**Known gap, not fixed here.** `ocapn.js` isn't told when a dialed session ends, so `RemoteControl` stays in `connected` after the loss. With this change, a hello under the same key during that time also no longer replaces the dial, though a rotated key still does. A session-end signal from `@endo/ocapn` would close this gap.

The session greeter also still runs a retention follower alongside the dial's own when hellos cross. They converge on the same set, and keeping both means retention tracking survives if the dial fails.

**Verification.** `@endo/daemon` typecheck passes, and ESLint reports no errors on the changed files. Pre-push probes pass; the repo-wide lint and format auto-fix was skipped because it outlasts tool limits on this host, so CI is the first full lint. The `networks-ocapn`, `locator-adoption-ocapn`, `invite-retention-ocapn`, and `invite-retention` suites passed on the final commit (34 tests). `remote-control`, `retention-accumulator`, and `ocapn-endpoint-locator` passed just before the final type-only cleanup. I have not run the full daemon suite locally.

## PR body

Refs: #1332
Refs: #1333

## Description

This draft stacks on #1333 and closes two gaps needed by the guest-locator federation work.

- Give every OCapN session its own peer entry and greeter. The greeter verifies that the claimed Endo node signed the Noise session key, then asks the manager for a gateway bound to that authenticated node.
- Leave crossed OCapN hellos to the session layer. A hello that shares the session of this daemon's own dial no longer competes with that dial, so two daemons dialing each other keep their one session instead of aborting it. `RemoteControl` still replaces a dial whose peer has restarted under a new session key.
- Make `followRetentionSet` ignore its wire argument and follow only the authenticated node's retention set. An empty set now produces an explicit empty snapshot.
- Treat an exact local formula identifier as a bearer capability, including for host/guest formulas, while making malformed, foreign, absent, collected, and failed-incarnation requests return the same error. Three misses terminate the authenticated session, and repeating `hello` cannot reset that budget.
- Add the optional `ocapn-advertise-addr` pet value. It replaces the advertised TCP host/port in both the connection hint authority and encoded OCapN location without changing the listener's bind address.

The most important review points are `packages/daemon/src/networks/ocapn.js`, where the Noise-session/agent binding is enforced, and `packages/daemon/src/manager.js`, where gateways capture the authenticated peer and enforce the bearer/miss policy.

### Security Considerations

This narrows peer authority. A caller can no longer select another node's retention set, and possession of the public peer-entry designator does not reveal formula identifiers. Formula provision requires the full unguessable identifier; failures are deliberately non-oracular and bounded to three per session. Agent identity is accepted only when its Ed25519 signature covers the authenticated ephemeral OCapN session public key.

Blob/tree provision remains unchanged because those content hashes are already bearer identifiers. The internal loopback gateway remains unrestricted and is not published by an OCapN session.

### Scaling Considerations

Each OCapN session allocates a small peer-entry/greeter pair and, after `hello`, one gateway plus its miss counter. There is no unbounded per-request state. Empty retention sets now send one initial empty delta.

### Documentation Considerations

`packages/daemon/MULTIPLAYER.md` documents the reciprocal session binding, the formula bearer policy, and `ocapn-advertise-addr`, including a NAT/listen-on-wildcard example. Existing deployments need no change unless their bind address is not externally dialable; those deployments should store the externally reachable `host:port` under `ocapn-advertise-addr`.

### Testing Considerations

Added coverage for a hostile authenticated peer requesting a victim's retention set, host access without its bearer identifier, non-oracular formula misses, the per-session miss limit, reciprocal binding rejection, an explicit empty retention snapshot, advertised-address override behavior, two real daemons dialing each other at once, and a hello under a rotated session key.

Passing locally:

- ESLint and Prettier on the changed files (the repository-wide auto-fix outlasts this host's tool limits, so CI runs the first full lint)
- `ava` on `test/networks-ocapn.test.js`, `test/locator-adoption-ocapn.test.js`, `test/invite-retention-ocapn.test.js`, and `test/invite-retention.test.js` (34 tests) on the head; `test/remote-control.test.js`, `test/retention-accumulator.test.js`, and `test/ocapn-endpoint-locator.test.js` just before its final type-only cleanup
- `yarn workspace @endo/daemon lint:types`
- pre-push source probes

The repository-wide local verifier also ran, but its unrelated global checks could not complete in this checkout: `zizmor` rejected existing workflow syntax, daemon-spawning suites used Node 24 against the Node 22 `better-sqlite3` native build, and TypeDoc exceeded its 2 GiB heap.

### Compatibility Considerations

`EndoGreeter.hello` keeps its existing signature for non-OCapN transports. The OCapN session greeter's `hello` takes `(nodeId, gateway, cancelled, agentBinding)`, without a canceller, so OCapN peers on this branch require the reciprocal agent binding; both dialing and accepting paths supply it. `ocapn-advertise-addr` is optional, so absent configuration preserves current advertised-address behavior.

### Upgrade Considerations

No persisted schema changes are required. Daemons that need a public address may add the new pet value and restart the OCapN network formula. This draft carries the change in #1333's existing daemon changeset because it is stacked in the same release unit.

<!-- garden-job: endo-ocapn-gateway-session-binding-build -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T11:47:59Z
