**Retrospective on endojs/endo-but-for-bots#1348, review 5385245565: dismissed (not a miss)**

**Verdict:** `not-a-miss`, category `new-direction`, recorded at `review-misses/dismissed/endojs-endo-but-for-bots-pr1348-review-3fce8521.md` on journal2 by `review-miss-record.sh` (the push went through).

**Why it's not a miss:**
- **The review is a question.** It asks for an explanation of the shell tools and how they are confined. It names no defect and no broken convention, and asks for no change.
- **The panel was not skipped.** #1348 went through six code-panel rounds (33 seats each). Round 6, at head `cb763267`, passed.
- **The panel already raised the nearby issue.** In round 6, locksmith and breaker flagged as should-fix that `readOnly` only restricts the filesystem.
- **The limit was already documented.** The design's § The honest boundary says a Shell grant controls which commands start, not what a started command does.
- **The redesign came later.** The grammar-based approach (passable command grammars, attenuating the shell to a single command, the example catalog, building pipelines) was first stated in the maintainer's later comment 5942897069 and review 5398940612. Those have their own primary jobs and retros.

**Checked against the PR, not just the job report:** the primary's answer is on the PR. The bot replied at 2026-10-01T21:01:50Z (issuecomment-5940470770, 22 minutes after the review) with a layer-by-layer explanation citing the design. The primary job is in `jobs/tada/2026/10/01/`. The job report and the PR agree.

**Clustering, threshold, improvement job:** none, because a dismissal creates no cluster.

**Follow-ups:** none from this retro. Review 5398940612 (CHANGES_REQUESTED, asking for richer command grammars) is the one more likely to raise a real review-miss question, and it gets its own retro.

Self-improvement: nothing to change. Checking the PR directly and reading an earlier dismissal record for the format was all this needed.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `cb763267fc9604c2b984203420c85679a628ac8a`; this job presented `808f037289a2788e2bd81fb0bdac9aa793bca9ce`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-review-3fce8521-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (309595 cached reads)
- Output: 2958 tokens
- Cost: $0.562967
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
