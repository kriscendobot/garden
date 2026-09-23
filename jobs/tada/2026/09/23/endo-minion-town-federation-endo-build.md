## Stage 1 (Endo guest-locator adoption and daemon bridge): draft PR open, local checks pass

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1333 (draft). It is one commit, `11e726e7b1`, on branch `build/guest-locator-adoption`.

- **Base:** a new frozen branch `job-federation-nonce-f9cbcfc` at `2a0abc1c84`. That is `llm` at `f9cbcfc426` plus the six commits of #1124 (head `96674df196`), which applied cleanly. I did not use #1124's own base because it is 1220 commits behind `llm`.
- **Shared PR heads:** I did not touch the heads of #1124 or #684. #1124 has to land first, and then #1333 should be re-pointed at `llm`.
- **WebSocket (#684):** not included. It is at `efcc498729`, has changes requested, and is also far behind `llm`. Route selection asks each installed network whether it supports a hint, so a WSS hint will work once #684's transport is installed.

**What changed**
- **New CLI command:** `endo adopt-locator <name> [--file <path>] [--as <agent>]`. The locator comes from stdin by default, so it stays out of shell history. `adopt` (message attachment) and `accept` (invitation) behave as before.
- **`adoptFromLocator` is stricter (same signature):**
  - A remote locator must carry hints. Unsupported or malformed hints are skipped if another one is supported; if none is, it fails with "No mutually supported route".
  - The value is resolved through the authenticated peer before the name is stored. A wrong key, an unreachable route, or a formula the peer doesn't host stores nothing.
  - If the peer is already known, its existing route is kept while it still works and put back if the new hints fail. The live CLI run caught a bug where a failed adoption had overwritten a good route and broke the name after a restart; this rule fixes it.
  - Error messages hide the locator and the formula number.
- **Public-endpoint wiring:** the daemon's OCapN network now also answers `bootstrap.fetch(<formula id>)` directly. It uses #1124's bounded, per-session locator and still answers `endo-peer-entry` first, so existing peer traffic is unchanged. The helper that combines them, `makeWellKnownLocatorForSession`, is exported for the next stage to reuse. To set up the endpoint, install the stock OCapN network on the daemon that provisions the account guests. Fetches then reach that daemon's own formula store.
- **Change to #1124's code (inside #1333 only):** `makeFormulaNonceLocator` gets an optional `isLocalNode` check. Guest formulas are named under the guest's own key, so the old check treated every guest ID as a miss.

**Locator format:** `endo://<guest-agent-key>/<formula-number>@<encoded ocapn+noise+tcp://host:port/?node=<hosting-agent-key>&loc=<OCapN location JSON>>?type=guest`

**Tests (all passing locally)**
- **New two-daemon test** (`locator-adoption-ocapn.test.js`, over OCapN):
  - The adopting daemon calls methods on the remote guest in both directions, then re-acquires and uses it after its own restart.
  - A locator whose hint names a different key does not redirect a known peer.
  - Malformed, hintless, no-common-route, wrong-key, unhosted and foreign-node locators all fail and leave no name.
  - A plain OCapN client fetches the same guest directly, and misses look identical.
- **Other new tests:** `ocapn-endpoint-locator.test.js` (unit tests for the combined locator) and `adopt-locator-command.test.js` (CLI).
- **Existing tests re-run:** the #1124 locator tests, `networks-ocapn`, `invite-retention-ocapn` (the full multiplayer suite over OCapN), `invite-retention`, `locator`, and the CLI paths test.
- **Static checks:** `yarn lint:types` in daemon and cli, eslint on changed files (0 errors), prettier, and the repo-root `tsc`. The root `tsc` needed an 8 GB heap to finish.
- **One unrelated failure:** a case in `gateway.test.js` fails because this checkout's path is too deep for a Unix socket path.
- **Live CLI run** against two real daemons (the scratch script was not committed):
  - the three bad locators exited 1 with clear, redacted errors;
  - a good `adopt-locator --file` succeeded;
  - `endo eval` printed "hello from A" through the remote guest both before and after restarting the local daemon.

**Not tested:**
- **Rollback path:** the case where a known peer's old route fails and the new hints also fail.
- **WSS and anything deployed:** no WSS or deployed endpoint was tested; everything ran on localhost TCP.
- **Remote retention:** an anonymous adopter does not keep the guest alive on the hosting daemon; the account store does.

**Decisions needed before stage 2:** the code raised three authority questions, which I posted as a design amendment on #1332 (https://github.com/endojs/endo-but-for-bots/pull/1332#issuecomment-5803040971) and sent to the maintainer:
1. Nothing proves that the hosting daemon speaks for the guest key in the locator.
2. On a public endpoint, the older greeter/gateway path is still open to any peer. #1124's miss limit doesn't apply to it, and its errors reveal whether a formula exists. The client-side direct-fetch path depends on this answer, so I did not build it.
3. Proposal to keep the current behavior: someone who only holds a locator should not be able to keep formulas alive on a public daemon.

Stage 2 should keep public-endpoint changes on its review branch until (1) and (2) are answered.

**Next steps:** #1124 must land and #1333 be re-pointed at `llm`. #684 (WSS) needs a rebase and its review addressed. The maintainer decides when to run the gauntlet on #1333; I did not start one or mark the PR ready.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-minion-town-federation-endo-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 184 tokens (11673030 cached reads)
- Output: 70190 tokens
- Cost: $5.2031420000000015
- Wall-clock: 1173s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
