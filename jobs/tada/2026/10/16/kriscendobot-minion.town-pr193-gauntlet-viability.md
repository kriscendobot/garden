**Viability report: kriscendobot/minion.town PR #193, "feat(probe): OCapN guest canary (design #191 §6)"**

The PR is open, unmerged and still a draft. It was opened 2026-10-16T01:40Z. Head is `2c6f59ab`. Its base is the pinned snapshot `main-30a4c62` (`30a4c62a`).

Deciding question: Is there still no other OCapN guest canary on the base or in another open PR, and does the maintainer still want OCapN validation built first, as design #191 §6 says?

Evidence:
- **Maintainer direction still stands.** On #191 (2026-10-15T20:05Z), kriskowal wrote: "I move to *start* with OCapN canary validation". In a review comment they said GitHub/OAuth is only needed for MCP, and OCapN auth uses the secret formula identifier held on endolin-garden1. The design was revised to `90db939` to add §6, which is the section this PR builds. No later maintainer comment withdraws that direction.
- **Nothing newer has replaced it.** The base `main-30a4c62` is level with `main` (the comparison shows 0 newer commits), so no change has landed upstream since. `deploy/probe/` on `main` has only `canary`, `canary.json`, `prod-objectives.mjs` and its test. There is no `ocapn-canary`. None of the 15 most recent PRs (#179–#193) implements an OCapN canary. #186 (the root MCP credential path) and #183 (inference phase 3) are the MCP/OAuth path, which the maintainer moved behind OCapN; they don't overlap with this PR.
- **One thing to watch:** design #191 is still open, with a CHANGES_REQUESTED review ("Please clarify") that the bot has answered. Its gauntlet halted because its base is floating. That doesn't make #193 obsolete, but if #191 is revised again, §6 could change underneath this PR.

The PR has not been superseded and the need behind it still holds, so the gauntlet may proceed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (152541 cached reads)
- Output: 1701 tokens
- Cost: $0.37491220000000003
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
