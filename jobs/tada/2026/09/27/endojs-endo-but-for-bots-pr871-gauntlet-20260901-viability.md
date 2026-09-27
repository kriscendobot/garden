**PR #871 viability: proceed.** The PR is still open, nothing newer has replaced it, and the design it implements is still live. I spent no budget on clean, panel, fix, CI-wait or un-draft.

**Deciding question:** Does current `llm` or any other PR already provide the SturdyRef agent provide/accept surface from design #695, or has that design been dropped?

**Answer: no, and no.**

**Evidence:**
- **PR state:** #871 is OPEN, draft and unmerged. Its head is `build/sturdyref-agent-surface` at `e88511ea55`, rebased today (2026-09-27) onto the `llm-efabaed` base pin. GitHub reports it MERGEABLE, and a new CI run was in progress at the time of the rebase comment. It has no reviews yet.
- **Base matches `llm`:** a GitHub compare of `llm-efabaed...llm` shows 0 commits ahead, so nothing newer has landed since the base was pinned.
- **Not already on `llm`:** these files the PR adds are all missing (404) on `llm` right now:
  - `packages/agent-tools/src/sturdyref-escrow.js`
  - `packages/daemon/src/sturdyref-store.js`
  - `packages/daemon/src/ocapn.js`
  - `packages/daemon/src/foreign-sturdyref.js`
  - `packages/ocapn/src/client/sturdyref-uri.js`
- **No competing implementation:** searching all PRs for "sturdyref" finds only the related stack, still open and unmerged (bridge cuts #698 and #700–#704, #737, #774, #541). They are prerequisites or siblings, not replacements. The only earlier attempt at this same surface, #865, was closed on 2026-07-28, before #871's current work. #1124 (nonce locator) and #1220 (thixotrope) cover other ground.
- **Premise still holds:** design #695 ("agent provide/accept surface") is still open. On 2026-09-17 kriskowal wrote "Please rebase and finish the gauntlet above, and open for review. I am inclined to approve." #871 implements phases 2 and 3 of that design.
- **Caveat:** an earlier rebase comment (2026-09-01) noted the genie package had been removed from `llm`, so the PR description's mention of Genie escrow is out of date. The core daemon, Lal and Fae surface is unaffected, so this doesn't change the decision.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr871-gauntlet-20260901-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (159757 cached reads)
- Output: 2183 tokens
- Cost: $0.4292914
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
