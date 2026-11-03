## Viability for PR #1645: proceed

**What I checked:** I read the PR facts and description, compared the pinned base with the live `llm` branch, read `packages/agentry/src/harness/pi-agent.js` and `packages/agentry/package.json` on `llm`, and searched for other open or closed PRs touching the same area. I spent nothing on the clean, panel, fix or CI stages, and I made no commits.

**PR facts:** #1645 "fix(agentry): keep system messages in makePiAgent requests" is OPEN, draft and not merged. It was opened 2026-11-03T05:24:52Z. Head is `fix/agentry-pi-agent-system-messages` @ `d080647e4b`, and base is the frozen `llm-48d6f3e` (`48d6f3e08b`). It has no comments or reviews yet.

Deciding question: Does the live `llm` branch still lose system messages in `makePiAgent`, with no newer PR or commit already fixing it?

Evidence:
- **No newer work:** comparing `48d6f3e…llm` shows `llm` has 0 commits beyond the PR's base, so nothing has landed since the PR branched.
- **The bug is still on `llm`:** `defaultConvertToLlm` in `pi-agent.js` on `llm` still keeps only `user`, `assistant` and `toolResult` messages. It drops `role: 'system'`.
- **The cause still applies:** `llm` is on `@earendil-works/pi-agent-core` and `pi-ai` `^0.87.1`. That is later than 0.86, the release the PR says started sending the system prompt and tools only inside a `system` message. So the filter still strips them.
- **Not superseded:** the search turned up no other PR addressing this. Related agentry PRs (#1348, #907, #517) are about other features.
- The PR was opened minutes before this check and comes from job `agentry-makepiagent-drops-system-messages-fix`.

The PR is not superseded and the bug it fixes is still present on `llm`, so the gauntlet can go ahead. No follow-ups.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1645-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (182915 cached reads)
- Output: 1454 tokens
- Cost: $0.444895
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
