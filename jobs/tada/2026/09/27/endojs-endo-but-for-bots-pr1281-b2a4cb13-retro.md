This retrospective found a real review miss on #1281. It was the third instance in its cluster, which is enough to trigger a fix, so I posted an improvement job.

**Verdict: review miss** (category `docs-drift`, severity minor).
- **Checked on GitHub, not just in the primary's report:** kriskowal asked, on 2026-09-16, for the title and description to follow the upstream PR template. The PR's edit history shows the primary rewrote the body at 16:46Z. The body now has the template's Refs line, `## Description` and the six `### … Considerations` headings, so the primary's work is done.
- **Why it's a miss:** the rule was already written down. `skills/pr-formation` and `skills/pre-pr-checklist` both say to fill in the base branch's `.github/PULL_REQUEST_TEMPLATE.md` heading by heading. That template exists on the PR's base `master-aaf9ea4` and on `llm`. The PR was aimed at upstream from the start, but it was opened, and edited again later, with made-up sections ("Goal", "What was noisy").
- **The panel had the chance to catch it:** the `ses-node26-lockdown-permits` gauntlet ran six panel rounds and five fixer rounds before the comment, all with the integrator seat present. That seat's brief asks directly whether the description follows the PR template. The integrator even used that part of its brief to flag the title, but never flagged the body.
- **How this differs from the #1099 dismissal:** on #1099 no panel had run, and the ask was simply to get the PR ready to carry upstream.

**Recorded:** `review-misses/misses/endojs-endo-but-for-bots-pr1281-b2a4cb13.md`, written by `review-miss-record.sh` and joined to the existing `pr-description-reviewer-attention` cluster. The summary line was `count=3 status=open prs=16,1281 recurrence=0 drain_reopen=0`, so this isn't a recurrence and no alert went out. The cluster fits: its two other members, both from kriscendobot/agoric-sdk#16, have the same cause. PR prose the garden writes breaks the skill that governs it, and no review stage checks the finished text against that skill. The record that started the cluster had already named template non-conformance as part of this family.

**Threshold:** met, with 3 misses across 2 different PRs, so I dispatched instead of holding. The pattern is consistent, no fix is in progress, and #1281 shows a line in a seat's brief isn't enough on its own; the template check can be automated.

**Posted:** builder job `review-improve-pr-description-reviewer-attention` (identity `review-cluster:pr-description-reviewer-attention`). The cluster is now marked `improvement-dispatched`, with my rationale saved. The job must deliver both parts:
- **Prevention:** `ensure-pr.sh` checks a PR body against the base branch's template headings, and the pr-formation and thread-reply skills get tighter concision guidance.
- **Sensing:** a panel-stage script that checks the live PR body against the template and reports gaps as must-fix, plus an integrator or pruner brief line with a panel-hints probe that fires on over-long bodies.

It also has to show its checks catch each of the three past cases, including #1281's body as first opened.

**Follow-ups:** none beyond that builder job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1281-b2a4cb13-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1251750 cached reads)
- Output: 8889 tokens
- Cost: $1.107562
- Wall-clock: 151s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
