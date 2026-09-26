Panel round 4 complete. Verdict posted.

## Completion report

Re-derived state on this clean requeue: PR #17 (`kriscendobot/minion.town`, head `feat/endo-guest-pkce-demo` → base `main-af30574`, still draft/open). Prior gauntlet history intact — panel rounds 1/2/3 all `must-fix`, fix-3 ran. No round-4 review had been posted yet, so I ran it.

**What I did:**
- Got an isolated project checkout of the PR head via `ensure-project-worktree.sh` (keyed to this job's base).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against the worktree with base `main-af30574`. Terminal disposition: **must-fix**. Run recorded to `panel-runs/kriscendobot-minion.town-17/ea93901f498b.md`.
- Posted the aggregate as a `gh pr review` on PR #17. Posted as a **comment** review (cannot request-changes on own PR, per prior rounds), carrying the round-4 `must-fix` header and the `garden-gauntlet … stage=panel iter=4 disposition=must-fix` marker. Because the full per-seat aggregate is ~89 KB (over GitHub's comment limit), the body leads with a curated must-fix digest and includes the aggregate truncated to fit.

**Must-fix items surfaced this round** (for the next fix stage): mode-selector has no closed-set validation and typos fall through to the max-authority branch (surfacer); `mcp/guest` scope is unadvertised so a deployed base yields `invalid_scope` not `insufficient_scope`, and `MCP_GUEST_PET_NAME`/`MCP_GUEST_TEXT` are documented one-way but read two ways (corner-prober); PR body cites neither the B2 increment nor the design doc (integrator); and — now 3× repeat — three fix pushes with zero PR summary comment (scribe).

No garden code changes were needed, so nothing to commit/push. Stage stops here (no fix, no un-draft) as specified.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr17-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 37 tokens (941994 cached reads)
- Output: 9868 tokens
- Cost: $1.2304270000000002 (2 engagement(s) unpriced)
- Wall-clock: 798s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
