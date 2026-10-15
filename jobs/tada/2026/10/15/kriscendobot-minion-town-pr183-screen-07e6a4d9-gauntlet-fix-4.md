Fix round 4 for kriscendobot/minion.town#183 is pushed and CI is green: `ci-wait-merge` returned rc=0 with all 3 checks passing. PR head moved `74e2c98` → `bf575c0`.

**Must-fix items**
- **archivist #1:** the `infer` tool description in `src/endo/guest-tools.ts` no longer says "confined". It now says the inference runs "over the root's own unsliced backend", which matches the `inferRootAuthored` path.
- **curator #1:** every constructor of `ClaudeHandles` / `rootAuthoredInferFor` is already updated in the diff, so no code change was needed. I added a "New required handle member" section to the PR body that lists them:
  - Production builds the handle only in `makeClaudeAgentsFor` in `src/endo/claude/wiring.ts`, reached through `src/http.ts` → `src/server.ts` → `registerClaudeAgentsTools`.
  - In tests, every handle in `test/claude-agents-tools.test.ts` passes `inferRootAuthored`. The other tests build deployments through `makeClaudeDeployment`, which supplies the method.
  - The one cast stub, in `test/claude-account-endpoint.test.ts`, never reaches the agents path.

**Should-fix items also applied**
- The retry wording now matches in `containment.ts`, `inbox-responder-caplet.ts` and `DEPLOYMENT.md`: "never retried in-process; a responder restart re-presents it".
- The `refuse?` JSDoc now says the refusal applies "while its child is live".
- A comment at the `makeClaudeAgent` export states the rule: facet call sites use `makeFacetAgent`, and only `makeRootAuthoredInfer` calls `makeClaudeAgent` directly.
- From the pruner:
  - Deleted four comments that restated nearby code.
  - Removed the drifting pointer to `DEPLOYMENT.md` from the `containment.ts` header.
  - Cut the duplicated note about which flags `buildArgv` owns from the test.
  - Trimmed the PR body: dropped the "What" paragraph, the four-bullet caller list and the list of passing suites. The breaking-change note, the rollback line and the phase ledger stay.

**Verification:** `tsc --noEmit` passes. The agents-tools, cli-backend and wiring test files pass (50 tests).

**Not done (left for later panels):**
- The decomplector's two should-fix design items: the refusal is implemented twice (`refuse` and the refusing exo), and each child holds two agent handles. Both are structural changes, too large for one fix round.
- The curator's suggestion to tag `makeCredentialVault` `@deprecated`.
- Prettier reports formatting issues in 4 of the touched files. They were already there before this round, so I left them.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1416049 cached reads)
- Output: 8549 tokens
- Cost: $1.0040618000000001
- Wall-clock: 954s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
