---
role: fixer
pr: https://github.com/endojs/endo-but-for-bots/pull/1404
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix non-test consumers of the removed guest identifier/locator methods — endojs/endo-but-for-bots PR #1404

PR #1404 (head `guest-no-identifiers-locators`, base `llm-80054c3`) removes
`identify`, `locate`, `storeIdentifier`, `storeLocator`, `lookupById`,
`lookupByLocator`, `invite`, `accept`, `deliver`, etc. from `EndoGuest`, and guest
messages no longer carry `from`/`to`/`ids`/`promiseId`/`resolverId`/`valueId`
(guests see `fromNames`/`toNames` instead). The gauntlet clean stage
(ebfb-guest-no-identifiers-locators-gauntlet-clean) fixed the `@none` stub in
`manager.js` and the daemon/agentry tests, but these PRODUCTION call sites still
call the removed methods on a guest and will throw at runtime. No test covers them,
so CI does not catch them:

- `packages/fae/src/subagent-host.js` ~185-226: `E(spawnerGuest|driverGuest).storeLocator(name, loc)`.
  Mechanical fix: `E(hostAgent).storeLocator([<agentName>, name], loc)`, using
  `spawnerProfileName`/`driverProfileName`. The host's directory traverses into a
  guest via `amplifyNameHub`.
- `packages/floot/floot-factory-setup.js` ~184: `E(oracleGuest).storeLocator('account-profile', …)`
  → `E(agent).storeLocator([powersName, 'account-profile'], …)` (or `copy`).
- `packages/floot/src/container-mounts.js` ~599: `E(sessionGuest).identify(...namePath)`
  is the possession check. It needs a host-side resolution of the session guest's
  name, or a design that does not need the formula id.
- `packages/lal/agent.js`: runs AS a guest and uses `E(powers).locate('@self')` +
  `msg.from === selfLocator` (use `msg.fromNames.includes('@self')`),
  `E(powers).lookupById(msg.valueId)` (adopt the value by message number instead),
  and `E(guest).storeIdentifier('primer', id)` (bind from the host agent by path:
  `E(agent).storeIdentifier([`profile-for-${name}`, 'primer'], id)` or `copy`).

Add a test where it is cheap, push to the PR head with
`scripts/jobs/gardening/safe-push-pr-head.sh`, and keep CI green.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-01T08:37:52Z
