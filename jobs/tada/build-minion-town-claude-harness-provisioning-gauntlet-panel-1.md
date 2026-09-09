Panel round 1 complete for kriscendobot/minion.town PR #99.

**What I did**
- Resolved the PR head (`kriscendobot:build/claude-harness-provisioning`, base `b83741a…`) and obtained an isolated project worktree keyed to this job's base.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 99 b83741a3543cc598cdd7fe513243c35df24ba5db`. All seats fanned, aggregated, and the panel's terminal disposition was **must-fix**.
- Assembled the aggregate (`round-1.md`) into a review body. The raw aggregate (70.4 KB) exceeded GitHub's review-body limit, so I prepended a **Must-fix summary** capturing all four blocking findings, then included the full seat-by-seat aggregate truncated at a line boundary to fit under 65 KB (all must-fix items are preserved in the top summary regardless of truncation).
- Posted it to the PR. GitHub refuses `--request-changes` on the bot's own PR, so I posted it as a **COMMENTED** review whose header states `disposition: **must-fix**` — the standard own-PR fallback carrying the panel verdict.

**Must-fix findings (for the fix stage)**
1. **assessor** — `deploy/aws/scripts/deploy-app.sh:200-219`: post-promotion `claude --version` re-check is a bare statement in the success branch under `set -e`; its failure kills the script before the `else` rollback runs. Fold into the guarded `&&` chain.
2. **wire-watcher** — pinned Claude Code signing key captured from an unverified interactive session, not a documented provenance channel.
3. **engine-realist** — harness tooling needs Node ≥22.15 (zstd) but repo floor is ≥20.12 and `tools/claude-harness/package.json` declares no floor.
4. **transplanter** — `tools/claude-harness/claude-code.asc:1-2` begins with two leaked shell diagnostic lines; strip them.

Additional request-changes verdicts: stylist, breaker, purist, corner-prober.

**Stopped here** per single-round contract — no fix, no un-draft, no loop. No inbox messages. No garden-repo changes were needed (this stage only reads the project repo and posts a review), so nothing to commit/push to main2.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-harness-provisioning-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (867133 cached reads)
- Output: 7724 tokens
- Cost: $1.1072255000000002
- Wall-clock: 532s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
