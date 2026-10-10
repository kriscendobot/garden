**Viability check: endojs/endo-but-for-bots PR #1436** ("docs: A note about abbreviations in style (split from #344)")

**Verdict: proceed.** The PR is still needed and nothing has replaced it, so the gauntlet can begin.

I re-checked the PR just now and nothing has changed since the last session: it is still open, still a draft, not merged, and the head is still `60760fed`. The base is the frozen `master-46d4edf`. It adds 7 lines to the Coding Style section of `CONTRIBUTING.md` and has no comments or reviews.

Deciding question: Is the unabbreviated-names rule from endojs/endo#3047 still missing from the fork's `CONTRIBUTING.md`, with no other PR or newer base history adding it, while the upstream PR it mirrors is still open?

Evidence:
- **Upstream is still open.** endojs/endo#3047 is open and not merged, and upstream `master`'s `CONTRIBUTING.md` has no abbreviation rule.
- **The fork doesn't have the rule yet.** On the fork's current `master` tip and on `llm`, the Coding Style section has only the `/** @import */` bullet, with no text about abbreviations.
- **No other PR replaces it.** The parent mirror #344 is still open and was split on purpose so this rule gets its own review. Searching open PRs on the fork and on upstream endo found no other PR adding the rule.

The previous session finished this same check but put the completion signal before the stage marker, so the job wasn't recorded as done. This time the marker comes first and the completion signal is last. Nothing was changed: no files were edited and no clean, panel, fix or CI budget was spent.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1436-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (288296 cached reads)
- Output: 2231 tokens
- Cost: $0.9010876000000001
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
