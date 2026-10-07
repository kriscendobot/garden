**Verdict: not a miss (category `new-direction`). I recorded the dismissal at `review-misses/dismissed/kriscendobot-garden-pr116-review-66d1a44d.md`.** It needed no cluster, threshold check or improvement job.

**Why it is not a miss:** PR #116 was a design PR opened under the open-questions carve-out (its body carries the `garden-design-open-questions` marker). The design was already on `main2` in commit 98db6149401, and the PR existed only so the maintainer could answer six open questions. In review 5432482973 (APPROVED), kriskowal answered all six inline:
- the ramp is per subscription
- the curve is linear
- the fraction is computed when read
- the fallback is 0.95 when no reset window is known
- an override with an `until` gate stays in force until that time
- resets are tracked per subscription: a manual Claude reset keeps its phase, a Codex reset shifts it

The review then told the fleet to conduct, build and deploy without further review. Every point picks between options the design itself marked undecided, so no seat brief, skill or standing rule could have decided them. The marker turns off the design panel for such PRs on purpose, so having no gauntlet run for #116 is the documented path, not a skipped evaluator.

**Checked against the PR and board, not just the primary's report:**
- PR #116 is MERGED.
- `designs/standing-token-backoff-ramp.md` on `main2` contains the decisions (fixup eb6b9c13b6a: the 0.95 fallback, the `--until` gate, per-subscription reset tracking).
- The primary handed off to `orch-standing-token-backoff-ramp-delivery`.
- `build-standing-token-backoff-ramp` and `release-standing-token-backoff-ramp` are both in `jobs/tada/2026/10/06`.

What I found matches what the primary reported.

**Changes:** only the dismissal record on journal2, written by `review-miss-record.sh`. Nothing changed on `main2`.

**Follow-ups:** none.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-pr116-review-66d1a44d-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (420067 cached reads)
- Output: 2962 tokens
- Cost: $0.5526614
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
