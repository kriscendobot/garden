**Result: overtaken.** PR #1061 should not enter the gauntlet. I spent no clean, panel, fix, CI-wait or un-draft budget.

The PR itself is still OPEN, not a draft, and GitHub reports it mergeable. Head is `0be93590639` on base `master-8c402ee`. kriskowal approved it on 2026-08-25, and six panel rounds ran on 2026-08-29.

**Deciding question:** Does the maintainer still want marshal's public types moved into a hand-written `src/types.d.ts` (the change this PR exists to carry upstream), rather than replaced by another approach?

**Evidence:**
- kriskowal marked #1061 as the mirror of upstream https://github.com/endojs/endo/pull/3361, which had the same title and head `f16337904`.
- On 2026-09-03 mhofman commented on #3361: "I would prefer we move to .ts authoring. But I suspect I have to finish reviewing some of Turadg PR for that." That points to turadg's open endojs/endo#3137, which adds `.ts` runtime modules.
- kriskowal closed #3361 without merging on 2026-09-05, two days later. That is after their 2026-08-25 approval of #1061, and there is no other review or comment on #3361.
- Upstream `master` has not landed the change: `packages/marshal/src/` there still has `types.js` and no `types.d.ts`.
- No newer implementation exists. The fork's `llm` branch has no marshal `types.d.ts`, and no other fork PR does this work. So it is the motivating premise that changed (a hand-written `.d.ts` is no longer the wanted direction), not a competing PR.
- Caveat: kriskowal gave no stated reason for closing #3361. If they closed it for some other reason and still want a fork-only `.d.ts`, they can re-post the gauntlet and it would proceed. The PR was approved and mergeable when last checked.

Option: close as superseded

I made no changes to any repo or the journal. The only follow-up is the maintainer's choice: close #1061 as superseded, or tell the garden to proceed anyway.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1061-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (358956 cached reads)
- Output: 3012 tokens
- Cost: $0.5337352
- Wall-clock: 39s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
