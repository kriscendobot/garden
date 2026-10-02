Panel round 3 on endojs/endo-but-for-bots#1406 came back **must-fix**. I posted the verdict as a review on the PR.

**What ran**
- I got an isolated checkout of the PR head, `bot/build/claude-pinned-cli-bump` at `22c23fb0ad`, in `scratch/project-wt-build-e-26a9dc43f8e7-ce7879c2`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1406 d4124e6e40…`, passing the frozen base `llm-d4124e6` as its SHA. It exited 0 with the result "must-fix".
- 33 seats reviewed: 9 requested changes, 6 left comments only, 18 approved.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1406#pullrequestreview-5392732396
- It is a COMMENTED review, the same form rounds 1 and 2 used, and opens with the `<!-- garden-panel-verdict: must-fix round=3 head=22c23fb0ad… -->` marker.
- The full aggregate is about 72 KB, which is over GitHub's 65,536-character limit for a review body. So the review has the full write-up from every seat that requested changes or left comments, and lists the approving seats by name only.

**Must-fix items**
1. **`--settings` can appear more than once.** In `packages/claude/src/argv.js`, `--settings` is only checked for presence, not for appearing exactly once. Under the CLI's last-flag-wins rule, an extra trailing `--settings /attacker.json` would override the plugin-disabling settings and the credential. Six seats flagged this independently.
2. **The changeset doesn't mention `--settings`.** It doesn't say `--settings` is now required (or cover the duplicate check from item 1).
3. **The PR body has a heading outside the template.** "### Live re-run against 2.1.280" should be folded into Testing Considerations.
4. **No completion-summary comment after the last push.** `22c23fb0ad` fixed the lint failure, but no summary comment followed it.

**Follow-ups:** none from this job. The next stage is the fix loop for these four items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1040492 cached reads)
- Output: 5970 tokens
- Cost: $0.8279304000000002
- Wall-clock: 461s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
