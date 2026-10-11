**Viability report: kriscendobot/minion.town PR #179**, "feat(shell): real clip names and icons in the gutter". Verdict: **proceed**.

**PR facts:** The PR is open, unmerged and still a draft. It was opened at 2026-10-11T02:14Z by job `minion-town-ui-gutter-clip-labels`, as gutter increment 1 of arc `minion-town-ui`. Its head is `gutter-clip-labels` @ `9550ed3fbe`. Its base is the frozen branch `main-c7bdf20` @ `c7bdf20188`. It has no reviews or comments yet.

Deciding question: Has `main` gained a newer way of giving clips real names and stable icons in the gutter, or is the shell still showing position-based placeholder names, so that this PR is still the live answer?

Evidence:
- `compare c7bdf20...main` shows `ahead_by=0`, so `main` has not moved since the base was pinned. Its tip is still `c7bdf20188` (merge of #176, a git-remote change unrelated to this PR).
- `main` has no `src/endo/gateway/clip-title.ts`. Its `deploy/aws/www/shell.js` maps `/account/clips` `{hash,url,serving}` to gutter records with no name source from the server, so the placeholder "Clip N" names and position-rotated icons this PR replaces are still in place.
- No other PR, open or merged, does the same thing. Searching for clip names and the gutter turned up only #143 (merged; made the gutter list real clips, which this PR builds on), #90 (the earlier shell), and unrelated clip design or feature PRs (#85, #88, #93, #100, #142, #173, #174).
- The reason for the PR still holds. It is the planned increment 1 of the clip-gutter plan (`designs/minion-town-clip-gutter-plan.md`) under the design of record `designs/clip-shell-framework.md`. Publishing still records no name for a site, so the `<title>` is still the only available name.

Both conditions hold: the PR has not been superseded, and the need behind it remains. The gauntlet can begin. I spent no clean, panel, fix, CI-wait or un-draft budget. Follow-ups: none.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (230014 cached reads)
- Output: 1581 tokens
- Cost: $0.43949479999999996
- Wall-clock: 22s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
