The panel round-2 stage completed.

## Completion report

**Stage:** PANEL round 2 for endojs/endo-but-for-bots PR #1158 (`design(exo-db): define portable passable databases`), part of gauntlet `endojs-endo-but-for-bots-pr1158-gauntlet`.

**What I did:**
1. Resolved the PR head (`kriscendobot:design/exo-db`, base `llm`) and the true merge-base SHA (`f109e8f42281556439434b71c9717811185b9155`) via `gh api`.
2. Set up an isolated project worktree of the PR head.
3. Ran the panel single-round: `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1158 f109e8f42…`. Seven seats fired (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice). Terminal disposition: **must-fix**.
4. Posted the aggregate verdict to PR #1158 as a `gh pr review`. Note: `--request-changes` is rejected by GitHub because the bot owns the PR ("Can not request changes on your own pull request"), so I posted it as a `--comment` review (COMMENTED, 08:55:56Z) carrying the full aggregate under a "disposition: **must-fix**" header.

**Verdict summary (must-fix drivers):** critic — signed-zero `-0/+0` violates "equal keys, equal bytes"; unbounded startup reconciliation scan. skeptic — float64→DynamoDB rationale misstates the failure mode (0.1 does round-trip; the real limit is exponent-range overflow); missing concurrency tests. ergonomist — inconsistent precondition-failure signaling across insert/update/delete; `KeyError` conflates domains; `update` full-row contract stated in the wrong place. Plus should-fix findings from decomplector, copyeditor, pedant, novice (value-based conditional writes, forward-reference glosses, hyphenation/capitalization/cross-ref consistency).

**Stopped here as instructed** — no fix, no un-draft, no loop.

**Follow-up:** Standing constraint — the bot cannot post request-changes reviews on its own PRs; the gauntlet's control flow relies on the stage-result marker (below), and the fix stage can read the must-fix aggregate from the COMMENTED review body.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1158-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (650568 cached reads)
- Output: 4839 tokens
- Cost: $0.938558
- Wall-clock: 445s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
