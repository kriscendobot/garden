The panel round 4 verdict is posted. Panel ran cleanly (exited 0), disposition is `must-fix`.

Panel round 4 complete for endojs/endo-but-for-bots#1013 (`design: relative routing`, a design-doc PR).

**What I did:**
- Set up an isolated project worktree of the PR head (`endojs/endo-but-for-bots @ design/relative-routing`).
- Computed the diff base as the merge-base against `origin/llm`: `ccdc0b2eb65f30901676bb9b9f09d342ce9b1e4d` (base ref `llm`, per the origin-only normalization rule).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode. It fanned 7 design-panel seats, aggregated, and printed disposition `must-fix` (exit 0 — it decided).
- Posted the aggregate as a `gh pr review` on the PR. A `--request-changes` review is rejected by GitHub on a bot-authored PR ("cannot request changes on your own pull request"), so — matching all three prior rounds on this PR — I posted it as a `--comment` review whose body carries the explicit `disposition: **must-fix**` header the next-stage-owed heuristic recognizes.

**Verdict:** must-fix. Recurring blockers across seats: (1) `selectRoutes` pseudocode operates on a parsed `{ scope }` struct while the design's named primary substrate `ConnectionHint` is a bare string with the scope in a `#scope=` fragment — parse boundary unspecified; (2) absent-scope legacy hints auto-promoted to "global," reintroducing the loopback/private-address bug the design exists to fix; (3) unspecified `costOf`/`selectRoutes` behavior for an "extensible" `<kind>` the local config doesn't rank; (4) no Test Plan, unlike sibling milestone designs.

**Follow-ups:** none owed by this stage — I ran exactly one round and stopped (no fix, no un-draft). The gauntlet's next stage owns the fix-loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1013-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (716400 cached reads)
- Output: 5084 tokens
- Cost: $0.9684389999999998
- Wall-clock: 416s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
