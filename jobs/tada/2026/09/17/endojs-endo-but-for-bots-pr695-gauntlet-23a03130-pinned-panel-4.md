Panel round 4 complete for endojs/endo-but-for-bots PR #695.

**What I did:**
- Re-derived job state after the reaper requeue: PR #695 is OPEN, draft, mergeable, based on pinned `llm-387ea66` (sha `387ea66`), head `70cfa71a`. Prior rounds 2 (02:55Z) and 3 (03:38Z) verdicts were already posted; round 4 had not been posted yet — the two prior panel-4 attempts were reaped as transient exit0.
- Set up an isolated project checkout of the PR head via `ensure-project-worktree.sh`.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against the head worktree with base sha `387ea66`. It **resumed from the durable record `aecb7e56d1ec`** (seats not re-run) and returned disposition **must-fix** (panel.sh exit 0).
- Posted the aggregate as a `gh pr review` on #695 (review id `5231029295`), as a COMMENTED review carrying the explicit **must-fix** disposition — the same shape prior rounds used because GitHub forbids request-changes on an own-authored PR.

**What changed:** one new panel-verdict review on PR #695 (round 4, must-fix, 20 outstanding items across copyeditor/critic/decomplector).

**Follow-ups:** none from this stage — I ran exactly one round and stopped. The gauntlet driver owns the next stage (fix loop) based on the must-fix disposition.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 3 host(s)
- Input: 94 tokens (2188081 cached reads)
- Output: 15740 tokens
- Cost: $2.7993205000000003
- Wall-clock: 491s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
