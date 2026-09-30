Viability report for endojs/endo-but-for-bots PR #1399 (`design(sturdyref): layer 9 — SturdyRefs in the daemon Agent API`)

**Result: proceed.** The PR is still needed and nothing newer has replaced it. I rechecked the PR facts gathered earlier in this session and they still hold. The last session stopped only because the completion signal was not the final line.

PR facts: open, draft, not merged. Head `aeb35421b2`, base `build/sturdyref-daemon-formula-8b57a39`. It adds `designs/sturdyref-agent-api.md` and adds one line to `designs/README.md`. It was opened 2026-09-30 as layer 9 of the 9-PR SturdyRef stack that kriskowal asked for on #695.

Deciding question: Has a newer design or implementation of the daemon Agent API's produce/accept/retain SturdyRef surface landed on `llm` or been opened as a PR, or has the layering premise it builds on been dropped?

Answer: No, on both counts.

Evidence:
- **This PR is the newest version, not the old one.** No newer PR on this topic exists. The older PRs, #695, #871 and #511, are the ones this PR says it replaces.
- **Nothing has landed on `llm`.** `designs/sturdyref-agent-api.md` does not exist on `llm`, and no related design commit has landed there recently.
- **The layers it depends on are all still open.** #774, #1389, #1391–#1394 and #1396–#1398 are all OPEN. Layer 8 (#1398) is at `8b57a398`, which is exactly this PR's base commit.
- **No reviews and no maintainer objection.** The only comment is the garden's note that the earlier gauntlet run (`endojs-endo-but-for-bots-pr1399-gauntlet`) halted at the clean stage. That is about process, not a sign the PR is obsolete.

Two things for the next stages:
- **Wrong base name in the PR body.** The body says the base is `build/sturdyref-daemon-formula-1d4d84b`, but the actual base is `build/sturdyref-daemon-formula-8b57a39`.
- **The earlier clean-stage halt should be looked at.** That run stopped with CI red at an older head (`cdf23ab9`).

I made no commits and spent no gauntlet budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1399-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (171956 cached reads)
- Output: 2537 tokens
- Cost: $0.8793292
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
