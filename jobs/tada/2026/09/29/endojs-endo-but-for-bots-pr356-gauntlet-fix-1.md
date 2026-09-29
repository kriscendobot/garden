I applied the panel-1 must-fix items to PR #356 and CI is now green (26/26 checks, `ci-wait-merge.sh` rc 0) on the current head `18b52cac`.

**The fix.** I pushed one follow-up commit, `4019b9bda`, to `endojs/endo-but-for-bots` branch `design/gateway-packaging-aws-stack` using `safe-push-pr-head.sh` in advance mode. It changes four design docs:

- **`gateway-package.md`:**
  - The docs said the gateway would be extracted from `web-server-node.js`. That file doesn't exist at the base commit; the real file is `ws-gateway.js` (about 226 lines, only a token handshake and a rate limiter). Phase 1 and Open Question 7 now separate moving that code from building virtual hosting and the cache from scratch.
  - Naming is consistent: `UserDaemonHandle` everywhere, `getApps` only on the local-socket `GatewayBootstrap`, and the public-facing version renamed `PublicGatewayBootstrap`.
  - Allocation-policy "profiles" are now "modes", so "profile" only means a named configuration.
  - Added a Test Catalog section with adversarial tests for each security boundary.
  - Replaced `→` in prose with `->` and removed the paragraph in Open Question 3 that duplicated Open Question 5.
- **`gateway-aws-attuned.md`:**
  - The enclave-signed credential is now described as a second, account-scoped credential. The existing formula-identifier tokens used for Git and Chat are unchanged.
  - The claim that the token-rotation question is fully resolved is narrowed: only verification and key custody are resolved. The requirement that object identity survive key rotation stays an open question.
  - The DynamoDB ledger row is marked as a reserved key prefix only, since the parent design defers the ledger.
  - A new section says how database tenant and account records relate to capability handles.
  - Added a Test Catalog section and turned the text diagram into a mermaid diagram.
- **`gateway-aws-deployment.md`:**
  - A new section shows that several instances each with their own local sqlite can't share registrations. Phase B is now limited to registrations baked into config and read-only at runtime.
  - This is now Open Question 1 (the others are renumbered), and Design Decision 8 gives correctness under scaling as the main reason to move storage later.
- **`gateway-packaging-ci.md`:** the ledger is no longer listed as versioned state, since its schema isn't defined yet.

**CI.** The first CI run after my push failed on `zizmor`, the GitHub Actions workflow linter. Five later commits to the branch that I didn't write fixed it, including one that makes action pin comments immutable. The current head still contains my commit.

**Left unchanged:** the pedant's should-fix on heading capitalization in `gateway-aws-deployment.md`. The flagged headings are AWS product names, so lowercasing them would be wrong. I also left the novice's two comment-only notes, and the arrows and `web-server-node.js` mentions in `gateway-bearer-token-auth.md`, which this PR doesn't touch.

Panel-2 is next and is posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr356-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 3 host(s)
- Input: 190 tokens (10619490 cached reads)
- Output: 46839 tokens
- Cost: $8.943909300000001
- Wall-clock: 1003s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×3

<!-- garden-usage-end -->
