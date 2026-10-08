I ran panel round 1 on PR #1433 and the verdict is **must-fix**.

- **Run:** `panel.sh` ran in single-round mode against an isolated checkout of `kriscendobot/endo-but-for-bots@design/formula-identifier-indirection` at head `69e4598996`. I passed it the merge-base SHA `7d2eb307a2ee` (the `llm-7d2eb30` base) and it exited 0. All 9 design-panel seats ran: 4 request changes (critic, skeptic, decomplector, pedant), 3 comment-only (ergonomist, copyeditor, novice) and 2 approve (orthographer, thesaurus).
- **Two pre-passes failed (not fatal):** the phase/evidence and PR-body-template checks could not find the PR body or the governing design. The ownership-map check flagged ATTENTION, so the panel also applied the decomplector seat to the cross-boundary map.
- **Review:** posted at https://github.com/endojs/endo-but-for-bots/pull/1433#pullrequestreview-5463639003. GitHub refuses request-changes on a PR its own author reviews, so it went up as a COMMENT review that says to treat it as request-changes, the same way earlier panel rounds on #1379 were posted. The body has a summary, the full per-seat findings, and a `garden-panel-verdict: must-fix` marker.
- **What must be fixed:**
  - The claim that no pet-store row holds a formula id is only true because the id moves into the `binding` row.
  - Rotation does not close a leaked link while legacy `locate()` and legacy reads still work.
  - The heading `### 4. Stateful opaque reference registry — recommended` contains an em-dash.
- **Should-fix themes:**
  - Every `locate()` call creates a share it can never revoke, and those accumulate without limit.
  - The `binding` rows need a justification over letting the pet store hold the internal id.
  - What the control facet does after `rotate()`, after `revoke()`, and through a stale copy is unspecified.
  - Restricting `identify` needs a list of current callers and an ordering that always leaves them a replacement.
  - The design does not say which peer resolves an `r1` reference or how its failure crosses to the other peer.
  - Several tests are missing from the acceptance criteria.

I made no changes to the garden repo or the PR branch. The next step is the gauntlet's fix-loop stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1433-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (809001 cached reads)
- Output: 4217 tokens
- Cost: $0.7176522
- Wall-clock: 274s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
