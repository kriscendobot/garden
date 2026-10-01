Panel round 1 for endojs/endo-but-for-bots#1390 is done: **must-fix**.

**What happened**
- I made an isolated checkout of the PR head (`endojs/endo-but-for-bots@build/pet-name-path-only`, head `784decdc7a`, base `llm-8e53cc0`) and ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against it. It exited 0 with disposition `must-fix`.
- The seats did not run again. The head has not changed since an earlier gauntlet's panel run (durable record `panel-runs/endojs-endo-but-for-bots-1390/3992f5b21fa7`, all 33 seats finished, 6 requested changes, 19 items), so panel.sh reused that verdict.
- I posted the verdict as review 5375072125 on head `784decdc`. It is a COMMENT review, not request-changes, because the bot (kriscendobot) authored the PR and GitHub won't let it request changes on its own PR. Earlier panel reviews on #1390 have the same shape.

**Must-fix items**
1. **typist:** `packages/floot/src/container-mounts.js:305-308` passes a bare string to `storeValue`, which now throws. The floot test fakes hide this.
2. **locksmith:** `packages/spaces-util/src/command-executor.js` calls `.split('/')` on pet names the user supplies, which turns one name into a multi-part path and widens authority.
3. **surfacer:** `types.d.ts` still uses the old parameter names, so it no longer matches the help text and `AGENTS.md`.
4. **stylist:** `petNames` is not renamed in `packages/lal`, and some help-text headers are stale.
5. **integrator:** the PR body does not mention its overlap with #1343 or say whether this PR is a phase of `designs/fs-interface-consolidation.md`.

There are also two should-fix items (purist, integrator). No code changes and no garden commits; the fix-loop is the next stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1390-gauntlet-20261001-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (573172 cached reads)
- Output: 3980 tokens
- Cost: $0.6114104
- Wall-clock: 58s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
