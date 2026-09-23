The fix is fully implemented, tested, and pushed; the maintainer has everything needed to open the PR in one click. The only remaining step — opening the PR — is structurally blocked and requires maintainer action I'm forbidden to bypass. I've handed it off cleanly.

---

## Completion report

**Ported the `followRetentionSet` peer-binding security fix from fork PR endojs/endo-but-for-bots#978 to upstream `endojs/endo` base `llm`.**

**Adaptation (the trees differ — reported as instructed):** The fork's fix in `manager.js` extracts three bearer-read methods (`provide`, `provideBlob`, `provideTree`). Upstream `daemon.js` has **only `provide` and `followRetentionSet`** on the gateway — the web-seed `provideBlob`/`provideTree` methods don't exist on `llm` yet (confirmed via `types.d.ts` `EndoGateway` and the code). So the port is smaller: I extracted `gatewayProvide` + `makeRetentionSetFollower`, added `makeGatewayForPeer(boundNodeNumber)`, kept `localGateway` refusing the local node, and made `hello` return `makeGatewayForPeer(remoteNodeId)`. Upstream returns retention via `makeIteratorRef` (fork uses `readerFromIterator`) — kept upstream's.

**Bearer-read audit (step 2):** `followRetentionSet` is the **only** enumerating method on the upstream gateway; `provide` answers only to a holder of the secret id and enumerates nothing. Upstream has **no additional** enumerating methods the fork lacks (it has fewer). The known outbound residual (a dialed peer following a *third* node's set via the `hello` consumer calling the remote gateway) is left out of scope and noted as follow-up in the PR body.

**Files changed** (`packages/daemon/{src/daemon.js, test/endo.test.js}`, +260/−39): the fix plus 3 tests — peer confined to its own set, local index not enumerable, and a `testNeedsNodeWorker` positive interop control.

**Verification:**
- 3 new security tests: **pass**
- Cross-daemon `invite-retention.test.js` suite: **7/7 pass** (incl. three-party partition/recovery) — peer-to-peer retention following unaffected
- `tsc`: clean (only a pre-existing `@libp2p/kad-dht` node_modules resolution error, unrelated)
- `eslint`: 0 errors (pre-existing warnings only)
- Running the daemon suite required a local `ENDO_TEST_DIRNAME` shim because this worktree's path overflows the unix `sun_path` ~104-char limit; that shim was **reverted, not committed**.

**Pushed:** `kriscendobot/endo` branch `ocapn-gateway-retention-peer-binding` (commit `92e405239`), off `llm` @ `33311ae9a`.

**Not done — PR not opened (needs maintainer):** `endojs/endo` restricts PR creation to org members/prior contributors; kriscendobot is a non-member (pull-only), so both `gh pr create` and the REST endpoint return the "does not have the correct permissions to execute CreatePullRequest" / 404. Per the job bounds I did **not** switch identity to open it as a member. I messaged the maintainer (via the liaison) with the one-click compare URL, suggested title, full change summary, and an offer to paste the ready PR body or retry once the bot is granted access:
`https://github.com/endojs/endo/compare/llm...kriscendobot:endo:ocapn-gateway-retention-peer-binding?expand=1`

**Follow-ups:** (1) Maintainer opens the PR (or grants the bot contributor access so a retry succeeds). (2) The parked outbound-binding residual remains separate (`ocapn-gateway-outbound-peer-binding`).

The code deliverable is complete and pushed; the outstanding PR-open is a structural permission gate requiring maintainer action, so I'm reporting it as handed-off rather than looping a requeue that would re-hit the same wall.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-upstream-llm-retention-set-peer-binding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (5167686 cached reads)
- Output: 43664 tokens
- Cost: $4.6928610000000015
- Wall-clock: 721s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
