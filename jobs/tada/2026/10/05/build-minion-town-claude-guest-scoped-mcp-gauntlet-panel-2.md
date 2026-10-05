I ran round 2 of the panel on kriscendobot/minion.town PR #160 at head `061a975`, and the verdict is **must-fix**. `panel.sh` exited 0 in single-round mode.

**What I ran:**
- Ran `panel.sh` against PR #160's head branch `claude-guest-scoped-mcp`, compared with the PR's frozen base commit `9ac858df` (`main-9ac858d`). It ran detached under `GARDEN_YARN=npm`.
- 33 seats reported. The scribe seat timed out once after 1200s, the retry succeeded, and every seat returned a verdict.
- Six seats requested changes: assessor, corner-prober, integrator, pruner, purist and scribe. The rest approved or left comments only.

**Posted** review 5418591240 on PR #160 ("Panel round 2 — must-fix", against `061a975`):
- It went up as a COMMENTED review, not a request-changes review. GitHub refuses request-changes on the bot's own PR, which also happened in round 1.
- The full aggregate is 86 KB, over GitHub's 65,536-character review limit, so I cut it at 64 KB with a truncation note. A summary at the top lists every must-fix item.
- The `gh` wrapper blocked the first post because of bare `#149` references. All of them mean kriscendobot/minion.town#149, so I reposted with `GARDEN_ALLOW_BARE_ISSUE_REF=1`.

**Must-fix items for the next fix round:**
- **Integrator:** the `PRUNED_SERVER_TOOLS` comment in `cli-provider.ts:165-168` points its follow-up at #149, but this PR fixes #149, so merging closes it. File a new tracking issue for the pruned catalog and cite that instead. The separate-unix-user follow-up needs its own issue too.
- **Corner-prober:** no test covers the documented promise that a broker closes when its child is removed. Add one that calls `brokerFor` and `transport()`, then `removeChild`, and checks that `broker.close()` ran.
- **Assessor and purist:** broker sockets live in `runtimeDirectory` beside the `spawn-*` directories.
  - Another guest's session, running as the same unix user, can reach those sockets.
  - The startup sweep never removes stale broker directories.
  - Brokers close only when their connection does.
  - The fix is to move the sockets somewhere spawns can't reach, or to document that tool confinement is the only boundary.
- **Scribe:** no summary comment followed the round-1 fix push `061a975`.
- **Pruner:** the PR description needs to be more concise.

Per the job, I didn't fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (845671 cached reads)
- Output: 5769 tokens
- Cost: $0.7053862000000001
- Wall-clock: 1560s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
