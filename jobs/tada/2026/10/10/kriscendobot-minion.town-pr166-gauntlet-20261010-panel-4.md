Panel round 4 on kriscendobot/minion.town PR #166 came back **must-fix**. I posted the verdict as a review: https://github.com/kriscendobot/minion.town/pull/166#pullrequestreview-5480916420

**What ran**
- The panel reviewed head `e5f7548` against base `origin/main-50aa690` (`50aa690`) in single-round mode. All 34 seats returned a result and `panel.sh` exited 0. The run output is in `/Users/dom/garden/scratch/panel-run-pr166-r4/`.
- The review was posted as a comment-type review that opens with "disposition: must-fix", the same shape as rounds 1–3. GitHub doesn't let the bot request changes on its own PR, so a request-changes review was refused.

**Why it is must-fix**
1. **decomplector:** the probe imports `IMMUTABLE_CACHE` and `ISOLATION_HEADERS` from gateway TypeScript source (`deploy/probe/prod-objectives.mjs:44-45`).
   - That import is the only reason for the new `cache-policy.ts`, the `engines >=22.18.0` bump, and the probe's dependence on Node's type stripping.
   - Because the scheduled run checks out `main`, a header change that is merged but not yet deployed turns the probe red.
   - Findings on this same code have come up three rounds running. The seat's answer is to remove the import, not patch it again: write the values into the probe as literals and add one offline test that they equal the gateway constants.
2. **pruner (smaller edits, no change to behaviour):**
   - Cut the PR body's per-file "Other changes" list.
   - Remove repeated statements of the three-tool limit and the canary-clip instructions.
3. **integrator (also smaller edits):** describe the new per-identity `tools` allowlist in the `config/policy.json` note and in DEPLOYMENT.md § Resolution algebra.

The review also lists optional should-fix items:
- Explain in the PR body why the new tool allowlist is needed alongside scopes.
- Make the allowlist fail loudly on tool names that are never registered, and handle empty or malformed lists.
- Regroup the 17 commits by concern.

I made no fixes, did not un-draft the PR, and made no changes to the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1065733 cached reads)
- Output: 6229 tokens
- Cost: $0.8419985999999998
- Wall-clock: 387s

<!-- garden-usage-end -->
