---
role: builder
tier: mentor
handler-timeout: 10800
fallback-tier: minion
dispatch: automatic
---

# Endo: bind the OCapN peer gateway to the authenticated session; add an advertised OCapN address

Repo: endojs/endo-but-for-bots. Base: stack on https://github.com/endojs/endo-but-for-bots/pull/1333 (branch build/guest-locator-adoption; frozen base job-federation-nonce-f9cbcfc), or on llm if #1333 has landed. Open or adopt a DRAFT PR only through ensure-pr.sh with this job's base. Do not un-draft it or start a gauntlet.

Found by endo-minion-town-federation-town-build (minion.town draft https://github.com/kriscendobot/minion.town/pull/117, DEPLOYMENT.md § Guest-locator federation). These are the two Endo preconditions that block the minion.town account daemon from exposing its OCapN network.

1. **Security: peer gateway authority.** In packages/daemon/src/manager.js, one `localGateway` is handed to every peer by `EndoGreeter.hello()`. That peer can be anyone who fetches `endo-peer-entry` and holds a locator's designator.
   - `followRetentionSet(peerNodeNumber)` runs `listFormulaNumbersByNode(peerNodeNumber)` (`SELECT number FROM formula WHERE node = ?`) on a node the caller chooses. Nothing checks it against the authenticated remote node.
   - `provide(id)` serves any local formula.
   - Together they let the caller list the host key's formulas and provide the top EndoHost.

   Fix: `hello` must hand each session a gateway bound to its authenticated remote node. `followRetentionSet` then answers only for that node. Also decide and document what `provide` may serve to an unauthenticated peer: bound it like #1124's per-session miss limit, keep errors non-oracular, and exclude agent/host formulas unless the peer holds their id as a bearer.

   Tests to include:
   - a hostile peer that calls `followRetentionSet(<victim node>)` gets nothing;
   - a hostile peer cannot reach the host;
   - the existing peer/retention suites (`invite-retention-ocapn`, `networks-ocapn`) and #1333's `locator-adoption-ocapn` still pass.

   Keep the fix consistent with authority question (2) in https://github.com/endojs/endo-but-for-bots/pull/1332#issuecomment-5803040971. If the maintainer has answered it, follow the answer.
2. **Advertised address.** packages/daemon/src/networks/ocapn.js advertises its bind host (`tcp:host`) in the location and hint. A daemon listening on `0.0.0.0` behind NAT therefore advertises an address nobody can dial.
   - Add an optional pet value `ocapn-advertise-addr` (`host:port`, parallel to `ocapn-listen-addr`). It overrides only the advertised `tcp:host`/`tcp:port` and the hint authority; the bind address is unchanged.
   - Test: a locator for a daemon bound to 127.0.0.1 with the override set carries the override in both places.
   - minion.town's box script stores exactly this name, and its preflight greps the tree for it.

Report the PR URL and the commit SHAs. Stop at a draft.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-23T21:35:43Z
