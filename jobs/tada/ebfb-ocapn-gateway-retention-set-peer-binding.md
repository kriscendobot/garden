The work is complete. Here is my report.

---

## Completion report

**Job:** Security fix for the OCapN daemon gateway retention-set leak in `endojs/endo-but-for-bots` (base `llm`).

**Defect confirmed in source** (`packages/daemon/src/manager.js`): the gateway reachable from the `hello` greeter exposed `followRetentionSet(peerNodeNumber)`, which ran `listFormulaNumbersByNode` on any caller-supplied node number with no binding to the authenticated peer — so a caller could pass the local node (publicly revealed via `nodeId()`) and enumerate the entire local formula index, the secret that keeps the bearer-based `provide` safe.

**Fix** (`packages/daemon/src/manager.js`):
1. **Peer binding.** `hello` now returns a gateway bound to the authenticated peer's node (`makeGatewayForPeer`). Its `followRetentionSet` answers only for that node — passing another peer's node, or the local node, is refused.
2. **Local index never enumerable.** The shared `localGateway` (presented on outbound/loopback paths that don't flow through `hello`) refuses `followRetentionSet(localNodeNumber)` outright. Verified safe: no legitimate caller ever follows the local node's own set — `getPeerIdForNodeIdentifier` throws for self, so a node never creates a self-peer/self-follower.
3. Extracted the three bearer read methods (`provide`/`provideBlob`/`provideTree`) unchanged and shared them between both gateways.

**Full-surface audit (job point 3):** `provide` (refuses non-local ids; bearer, no enumeration), `provideBlob`/`provideTree` (content-hash bearer, no enumeration) all require the caller to already hold a secret and enumerate nothing. `followRetentionSet` was the sole enumerating method. **One residual reported (not a local-index leak):** on the *outbound* transport path the shared gateway is presented un-bound to the specific dialed peer, so a peer we dial could still follow a *third* node's set (local remains refused). Fully binding outbound needs the peer identity threaded through the host `gateway()` powers facet across all transports — flagged as follow-up in the PR.

**Tests** (`packages/daemon/test/endo.test.js`): 3 new tests — authenticated peer confined to its own set (local + third node refused); shared gateway refuses local node but still answers a remote node; peer-bound gateway still `provide`s a local value (interop). All pass. The full cross-daemon `invite-retention.test.js` suite (10 tests, real `hello`→gateway→`followRetentionSet`) stays green, proving OCapN peer retention is unaffected. `eslint` clean (0 errors); both files syntax-check.

**Delivered:** DRAFT PR **endojs/endo-but-for-bots#978** (hardening-framed, no exploit recipe per the security constraint). Left draft — containment and deploy are the maintainer's call, and this is the code change both minion.town containment jobs named as the prerequisite for restoring OCapN-over-Noise. Maintainer notified via the bus with the PR link, the residual, and the cost note.

**Follow-ups:** (a) bind the outbound-path gateway to the dialed peer (thread identity through the host `gateway()` powers facet across iroh/tcp/ws transports); (b) maintainer to decide un-draft/merge/deploy and lift the two containments once deployed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-ocapn-gateway-retention-set-peer-binding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 154 tokens (8920412 cached reads)
- Output: 71535 tokens
- Cost: $7.851209999999999
- Wall-clock: 1110s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
