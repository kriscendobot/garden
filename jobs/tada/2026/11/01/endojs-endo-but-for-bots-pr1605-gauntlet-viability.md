PR #1605 can enter the gauntlet. It is open, unmerged and still a draft, nothing newer replaces it, and the gap it fixes still exists on `llm`. I spent no clean, panel, fix, CI-wait or un-draft budget.

Deciding question: Does `llm` still lack the `%RegExp.prototype%` accessor properties (`source`, `flags` and the eight flag getters), with no newer PR or commit providing them? **Yes.**

Evidence:
- **PR state:** open, not merged, draft. It was opened 2026-11-01T07:25Z, minutes before this job was posted, and has no comments or reviews yet. The head is `ironhorse-test262-ratchet-regexp-accessors-20261101`; the base is the pinned snapshot `llm-9a14ddf` (`9a14ddf660`).
- **Base is current:** comparing `9a14ddf` to `llm` shows `llm` has no commits past the pinned base. So nothing has landed upstream since that could replace the change, and the PR's premise holds on today's `llm`. Before this PR, `Object.getOwnPropertyDescriptor(RegExp.prototype, 'global')` is `undefined`. That causes 172 failing rows across the ten `built-ins/RegExp/prototype/<accessor>` test262 shards.
- **No competing work:** a search of the repo's PRs finds only this one for the RegExp accessors. The closest match is #1413, which is merged, older, and covered other engine bugs. The PR names #1602 as an overlap, but only in the regenerated fixtures (snapshot goldens, metamorphic hashes, fuzz seeds), not in source. That is a merge-order matter, not a replacement.
- **Motivation still holds:** this is a coverage slice of the Ironhorse test262 ratchet arc (tracker kriscendobot/garden#51), which is still active.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1605-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (181323 cached reads)
- Output: 1387 tokens
- Cost: $0.42840459999999997
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
