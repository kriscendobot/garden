**Gauntlet viability report: endojs/endo-but-for-bots PR #1613**

PR #1613 is open, still a draft and not merged, so it may enter the gauntlet. It hasn't been replaced by anything newer, and the CI failure it fixes is still happening on `llm`.

**Deciding question:** Does `llm` still run `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` on `ubuntu-latest` (now Ubuntu 26.04), and is there no newer change on `llm` that fixes the stage3-math 054/055 asinh/acosh oracle failure? **Yes.**

**Evidence:**
- **The fix is not on `llm` yet.** The PR's pinned base `llm-9a14ddf` and the current `llm` tip are the same commit (compare shows 0 ahead, 0 behind). On `llm`, `ci.yml` `test-ironhorse-oracle` and `ironhorse-sanitizers.yml` `oracle-sanitizers` both still say `runs-on: ubuntu-latest`. So nothing newer has displaced the 24.04 pin.
- **The PR's fix works in CI.** On head `4066142f`, both `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` passed. Per the PR body, these same jobs fail on every other PR (for example #1609 and #1548).
- **The only competing PR is older and stalled.** #1585 (opened 2026-10-31) takes a different approach: it accepts either rounding of asinh/acosh. It is still a draft, has no reviews, and its gauntlet halted with CI red. #1613 is newer, CI-green, and keeps the "no tolerance" stance described in `DETERMINISM-METERING.md` § C7. If anything, #1613 makes #1585 the redundant one. The maintainer may want to close #1585 once #1613 lands, but I did not act on that.
- **No discussion yet.** #1613 has no comments or reviews and was opened 2026-11-01T11:43Z.

**What I did:** Read-only checks only (the PR, `llm` workflows, base drift, the competing PR). I made no edits or pushes and spent no clean, panel, fix or CI-wait budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1613-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (180884 cached reads)
- Output: 2081 tokens
- Cost: $0.4536927999999999
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
