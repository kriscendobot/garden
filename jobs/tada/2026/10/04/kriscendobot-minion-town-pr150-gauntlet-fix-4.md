Fix round 4 for kriscendobot/minion.town PR #150 is pushed and CI is green: `ci-wait-merge` returned rc 0, with 3/3 checks passing.

**What the panel asked for.** The round-4 panel review (18:05Z) had two seats requesting changes, curator and pruner.

**What I changed** (pushed as follow-up commit `addd516` on top of `731cdb2`, via `safe-push-pr-head.sh` as a fast-forward):
- **Curator: out-of-date tool-name comments in `src/endo/mcp-tool-names.ts`.**
  - The summary at the top of the file now lists `baseline`, `sites`, `claudeForm` and `claudeAgents` as registered.
  - The `claudeForm` group's comment no longer says the tool is not yet wired. It is now marked registered and only optionally mounted, with the Claude wiring.
  - I left the `baselineReserved` comment alone: that group really is still unregistered, so its wording is accurate.
- **Pruner: `DEPLOYMENT.md`, Claude production section.**
  - The long paragraph is now three bullets: what the unit sets, which root subject it names, and why `MemoryMax` is 1536M.
  - The separate "Root endowment" bullet repeated the tool list, so I folded it into the root-subject bullet.
  - The "Verify after deploy" text now points to `deploy-app.sh` (`assert_claude_production`) and states the three checks in plain terms. The hardcoded `1610612736` byte count and the exact log line with its emoji are gone.
- **Pruner: PR description.** The opening background is now one sentence; the rest of the description is unchanged.

**Checks.** `tsc --noEmit` is clean, and the three affected test files pass (44 tests: tool names, clip tools, claude-agents tools).

**Not addressed.** The comment-only findings were not must-fix, so I left them, including:
- the deploy smoke check accepting non-404 errors;
- the `childName` regex duplicating the `isValidChildName` predicate;
- the locksmith's runbook note about restarting after revoking a root subject.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr150-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (857701 cached reads)
- Output: 5678 tokens
- Cost: $0.7729322
- Wall-clock: 374s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
