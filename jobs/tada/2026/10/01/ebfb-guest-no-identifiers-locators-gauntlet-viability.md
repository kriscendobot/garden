Viability is **proceed**: PR #1404 hasn't been superseded, and the reason it was opened still holds. I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** endojs/endo-but-for-bots#1404, "feat(daemon)!: guests neither produce nor consume identifiers or locators", is open, not merged, and still a draft. It was opened 2026-10-01T06:01Z, its base is the pinned `llm-80054c3` and its head is `0d…` per the PR. It has no comments or reviews yet.

Deciding question: Is kriskowal's directive still unmet on the current `llm` base, with no newer PR already doing the same job? The directive (#1371 comment 5925033783, 2026-10-01T04:57Z) asks to remove guests' ability to produce or consume formula identifiers or locators.

Evidence:
- **The directive is current.** It was posted about an hour before this PR opened, and #1371, where the problem surfaced, is still open.
- **The base hasn't moved.** Comparing `80054c3...llm` shows `ahead_by: 0`, so `llm` is unchanged since the pinned base and no other change has landed in the meantime.
- **The problem still exists on `llm`.** `packages/daemon/src/interfaces.js` on `llm` still gives the guest `lookupById` and its sibling identifier/locator methods.
- **No newer PR replaces it.** A search for "guest identifier locator" across all PRs finds nothing newer that does this work. The nearby open PRs are a different kind of work:
  - The sturdy-ref and locator-federation work (#1398, #1333, #1332, #1124, #703, #695, #1116) is either older or adds ways to recover access. The directive itself names sturdy refs as the recovery path, so this work complements #1404 rather than replacing it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-no-identifiers-locators-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (146598 cached reads)
- Output: 1645 tokens
- Cost: $0.34941959999999994
- Wall-clock: 113s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
