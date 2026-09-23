The comment review is posted. Panel round 1 is complete with disposition **must-fix**.

## Completion report

**Job:** Gauntlet PANEL round 1 — endojs/endo-but-for-bots PR #1158 (`design(exo-db): define portable passable databases`).

**What I did:**
1. Resolved the PR head (`kriscendobot:design/exo-db`, base `llm`) and set up an isolated project worktree at the PR head (`cbed9e1ec`). The diff is a single 575-line design doc, `designs/exo-db.md`.
2. Ran `panel.sh` in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against merge-base `f109e8f42`. Seven design-panel seats fanned out (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice); all returned request-changes. Terminal disposition: **must-fix**.
3. Posted the aggregate (from `$RUNDIR/round-1.md`, ~30 KB) to PR #1158. GitHub rejects `--request-changes` on an own-authored PR, so I posted it as a `--comment` review (author `kriscendobot`, state `COMMENTED`) with the disposition headlined as **must-fix** in the body.

**Notable must-fix findings** (for the fix stage): DynamoDB portability breaks the atomic row+ledger retention guarantee (no transactions); float64→DynamoDB `N` is lossy (38-digit decimal); paged query continuation lacks a total-order tiebreak; `replace` collides with SQLite `REPLACE`; `Bound.inclusive`/reverse orientation undefined; `designs/README.md` not updated with the new design row.

**Stopped here** as instructed — no fix, no un-draft, no loop.

**Note for the driver:** the mechanical transition keys off the report marker below (`gauntlet.sh` greps it). The PR-side record is a COMMENTED review rather than REQUEST_CHANGES only because the PR is bot-authored; its body still states must-fix explicitly for the fixer to read.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1158-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (721267 cached reads)
- Output: 5015 tokens
- Cost: $0.9842835000000001
- Wall-clock: 421s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
