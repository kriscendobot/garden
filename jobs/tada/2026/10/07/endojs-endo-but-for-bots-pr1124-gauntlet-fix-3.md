# Fix round 3 for endojs/endo-but-for-bots PR #1124: all five must-fix items applied, CI green

The PR head is now `5a3cfb1d5` on `kriscendobot/endo-but-for-bots:build/ocapn-nonce-locator-mechanism`. CI finished green, with 33 of 33 checks passing and none failing (`ci-wait-merge` returned 0).

**Must-fix items from the round-3 panel:**
- **packager:** added a top-level shim `packages/daemon/formula-nonce-locator.js` and pointed the `./formula-nonce-locator.js` export at it. The unit test now imports the public path too.
- **integrator:** squashed the nine commits, whose subjects read like a panel log, into three that describe the change. I pushed them with `safe-push-pr-head.sh --mode rewrite`, which checks first that the remote head hasn't moved.
  - `feat(ocapn): add makeLocatorForSession hook and thread peerPublicKey through the handshake`
  - `feat(daemon): add formula nonce locator` (includes the changeset)
  - `docs(daemon): relate external-connectivity §2 to the formula nonce locator`
- **surfacer:**
  - Added an "OCapN formula nonce locator" section to the daemon README. Its wiring example uses `locator: { get: formulaLocator.get }`.
  - Cut the ocapn README down to the generic hook example and a pointer to the daemon README.
- **decomplector:** I kept the miss bound and took the reviewer's other offered fix, a one-sentence reason for it. Dropping it would have removed the session hook, and three parked minion.town plan jobs rely on that hook to enforce incoming miss bounds.
  - The sentence: the bound limits resources, not secrecy. Each miss costs the daemon a formula-table read, possibly a failed incarnation, and a log line, so the bound caps how much of that one connection can force.
  - That reason is now in the module comment, the daemon README and the PR description.
  - I rewrote the §2 design note so it follows §2 instead of reversing it. The note no longer calls the well-known bootstrap swissnum "foreclosed": that swissnum is checked first, in front of the formula locator, as §2 describes. It also says the bound covers all incoming peer traffic only once the locator replaces `EndoGateway.provide`, which is what §2's title says.
- **typist:** removed the added `→` and `…` characters along with the rewritten text, and pulled the duplicated `get` type out into one named `FormulaNonceLocatorGet`.

**Smaller fixes from comment-only seats:**
- The `peerPublicKey.id` docs now say to key on a hex encoding, because it is a byte array compared by identity. They also say a peer can mint a fresh key for every connection, so per-key accounting doesn't stop an anonymous prober.
- The changeset now has one sentence per line, drops the deployment caveats, and names the two new typedefs.
- The PR description no longer says the follow-up wiring lives on minion.town. That wiring is `packages/daemon/src/networks/ocapn.js` in this repository.

**Local checks:** the daemon locator tests pass (20), `@endo/ocapn` `yarn test` passes (559), and `tsc` is clean in both packages. ESLint shows no errors on the changed daemon files (3 warnings in the unit test), and Prettier is clean.

**Not done; for the next panel or a follow-up:**
- decomplector should-fix: move the bound into a separate wrapper over any `NonceLocator`.
- surfacer: have the daemon import its types from the `@endo/ocapn` main entry instead of `client/types`, and re-export the types through the daemon's types index.
- Move the module from `src/networks/` to `src/`. The shim means this would not change the public path.

The panel was not re-run; the gauntlet driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3570156 cached reads)
- Output: 20061 tokens
- Cost: $1.9297951999999996
- Wall-clock: 2082s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
