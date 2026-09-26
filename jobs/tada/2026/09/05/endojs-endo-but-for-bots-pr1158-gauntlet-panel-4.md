The review is attached. The panel round 4 is complete: disposition **must-fix**, verdict posted as a `--comment` review (bot-authored PR blocks `--request-changes`) carrying the "Must-fix before merge" heading that downstream automation recognizes.

## Completion report

**Job:** Gauntlet PANEL stage, round 4 — endojs/endo-but-for-bots PR #1158 (`design(exo-db): define portable passable databases`).

**What I did:**
- Resolved PR head (`kriscendobot:design/exo-db`, HEAD `bebe3240`) and base (`llm`, merge-base SHA `f109e8f4` from `gh api .base.sha` per the upstream-base normalization gotcha).
- Provisioned an isolated project worktree keyed to this job's base.
- Ran `panel.sh` in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the worktree. It fanned the design panel seats and aggregated to disposition **must-fix** (exit 0).
- Posted the aggregate as a `gh pr review` on PR #1158. `--request-changes` was rejected (GitHub blocks it on a self-authored bot PR), so per the panel-review skill I fell back to `--comment` with the full body plus the "Must-fix before merge" heading downstream automation keys on. Review submitted (COMMENTED, `submittedAt` 14:59:16Z).

**Verdict:** must-fix. Design panel seats returned request-changes on concrete gaps: crash-recovery intent not scoped to the database formula (critic); DynamoDB single-table-vs-per-table scaling never considered (critic); predicate value type too narrow for narrow int64/float64 columns (skeptic); synchronous-failure retention leak untested (skeptic); dual key representation (decomplector); `low`/`high` field-shape collision and overloaded `ConflictError` (ergonomist); plus copyeditor/pedant/novice doc findings. orthographer approved (no British spellings).

**Follow-ups:** None from this stage — I ran exactly one round and stopped (no fix, no un-draft). The next gauntlet stage (fixer) owns addressing the must-fix findings.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1158-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1089973 cached reads)
- Output: 7208 tokens
- Cost: $1.2989054999999998
- Wall-clock: 518s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
