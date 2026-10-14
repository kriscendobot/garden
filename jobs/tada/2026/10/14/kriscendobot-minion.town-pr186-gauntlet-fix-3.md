## Gauntlet fix round 3: kriscendobot/minion.town PR #186

I fixed all three must-fix items from panel round 3 (review 5525235959) and pushed commit `63265e4` to `build/root-canary-principal`. CI is green: `ci-wait-merge` returned rc 0 with 3 checks passing and none failing.

**What changed**
- **Audit claim in the runbook (archivist):** `DEPLOYMENT.md` used to say every admitted Claude tool call is audited. It now names the four root-only tools that are audited (`claudeStatus`, `createClaudeAgent`, `dismissClaudeAgent`, `infer`) and says `submit` is not. I changed the docs, not the code. I made the same correction to the Phase 5 line of the PR body's evidence ledger.
- **Mint callback and mint host (transplanter):**
  - `root-canary-mint.sh` used to listen on a hardcoded `127.0.0.1:8765`. It now listens on the host and port taken from `ROOT_CANARY_CALLBACK`, so overriding that URL can no longer make the mint hang. A callback URL that isn't `http` with an explicit host and port is rejected.
  - `ROOT_CANARY_MINT_HOST` no longer defaults to `endolin-garden1`. Both `root-canary-mint.sh` and `root-canary-deploy-client.sh` now stop with an error unless it is set; the runbook table documents this.
- **Padding (pruner):**
  - The PR body's `## What` section is now one sentence, and its paragraph restating `awaiting-login` is gone.
  - In `DEPLOYMENT.md`, I removed the "pending login" restatement and the repeated "waiting condition" phrase.
  - In code, I removed the "toy tools retired" history comments in `src/http.ts` and `src/server.ts`, and the duplicate `auditClaudeTool` doc in `src/server.ts`; the doc in `guest-tools.ts` stays.
  - The duplicated sentence in the `root-canary-mint.sh` header is gone.

Before pushing, the typecheck passed, the 24 tests in the two root-canary test files passed, `bash -n` passed on the canary scripts, and I checked the callback-URL parsing by hand. There is no automated test for the new callback binding or for the required mint host.

**Follow-ups (should-fix items, not addressed here)**
- **Stale-name sweep:** in `deploy/probe/root-canary.mjs`, one undeletable stale child aborts the whole canary run. The panel wants this changed to continue-and-report, or a test showing abort is intended. It also suggested tests for the exact one-hour cutoff and for future-dated names.
- Concurrent refreshes in `makeRefreshingFetch` should share one in-flight promise.
- `root-canary-revoke.sh` can't be retried after a partial failure.
- The `root-canary-exec.sh` header doesn't mention the exit-1 case where Cognito returns no access token.

Per the job, I did not re-run the panel; the driver posts panel round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1115343 cached reads)
- Output: 8943 tokens
- Cost: $0.9541845999999998
- Wall-clock: 893s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
