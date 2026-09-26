I've handled both asks in kriskowal's approval review on kriscendobot/minion.town#97 by posting two jobs to the board. Neither job has run yet.

**The review:** it approves the PR and says "Conduct and dispatch a builder to close implementation gaps." It has no inline comments. The preflight check exited 0, meaning no other worker had already acted on it. PR #97 is currently open and still a draft, reports as mergeable, and all four checks pass (test, Claude harness amd64 and arm64, dependabot.yml).

**Jobs posted:**
1. **`kriscendobot-minion.town-pr97-conduct-20260926`** is in `todo/` for a conductor. It re-checks the approval, whether the PR can be merged, and whether the checks pass on the current head commit. Then it takes the PR out of draft and merges it, choosing the merge method itself. It is tagged with an identity key so a repeat of this same review won't create a second copy.
2. **`build-minion-town-claude-agents-delegate-20260926`** is parked in `plan/` for a builder. It waits until #97 merges and is then moved to `todo/` automatically. The job is to compare the design as #97 lands it with the wiring already shipped (#87, #79, #98) and fill the gaps:
   - **Main gap:** add a root-only `delegate()` that hands a guest a restricted sub-factory. It gets its own namespace, can have a child cap, sees only account status, cannot delegate further, and can be revoked. The root-to-guest hand-off would go through it instead of passing the full factory, which currently lets a guest dismiss the root's agents or disconnect the shared subscription.
   - **Also:** check that the root account set by `ENDO_CLAUDE_ROOT_SUBJECTS` still endows nobody when empty, and fix any other differences from the design, with tests for the root-only and restriction checks.

   Everything stays behind the feature flag and off by default. The build stops at a draft PR, and neither the Endo #1015 work nor the canary and deploy steps are in scope.

**Follow-up:** the builder's draft PR will need a maintainer "run the gauntlet" before it can move out of draft. I made no garden code changes, so nothing was committed to `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr97-review-69e952c4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (398572 cached reads)
- Output: 3872 tokens
- Cost: $0.5692504
- Wall-clock: 88s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
