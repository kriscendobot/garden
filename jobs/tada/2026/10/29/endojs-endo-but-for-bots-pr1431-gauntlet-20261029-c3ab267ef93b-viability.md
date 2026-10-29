PR #1431 can enter the gauntlet (`viability=proceed`). It is open, unmerged and still a draft, and nothing on `llm` has displaced it. One caveat: another open PR, #1583, edits the same design doc for the same reason.

**Deciding question:** Has `designs/hardened-text-codecs-shim.md` on `llm` already been brought up to date with the remedy merged in endojs/endo#3376 (the frozen-`null` `caller`/`arguments` tolerance in `cauterizeProperty`), whether by landing directly or through another PR, so that #1431's revision is no longer needed? **Answer: no.**

**Evidence:**
- **PR facts:** head `c3ab267ef93b`, last pushed 2026-10-29T15:25Z. Base is the frozen `llm-9a14ddf`, which is the current `llm` tip (`9a14ddf660`, 2026-10-28). One file changes: `designs/hardened-text-codecs-shim.md` (+119/−3).
- **Base code:** the last `llm` commit to touch the design doc is `345438a788` (2026-10-07, "mark hardened text codecs shim implemented"). The doc on `llm` never mentions #3376, `cauterize`, or the frozen `caller`/`arguments` shape. It still says the XS smoke test is open in #1349, which is now closed. So the doc is stale, and recording the landed remedy is still needed.
- **The premise is current:** the PR was rebuilt today to match what actually happened. #1349 and endojs/endo#3377 closed unmerged as superseded by endojs/endo#3376, which merged 2026-10-29 as `679d9afaa4`. The PR no longer documents the rejected encapsulation approach.
- **Overlapping open PR:** endojs/endo-but-for-bots#1583 ("docs: reconcile hardened text codec supersession", opened 2026-10-29T04:11Z, not a draft, same base) also records that #3376 supersedes #1349, in the same doc plus `designs/README.md`.
  - #1583 only updates status and the remaining-work list.
  - #1431 adds a full Revision section that #1583 lacks: the failure mechanism, the measured Chrome for Testing boundary (120–137 affected, 138–140 clean), the accepted sloppy-function residual raised as an open question, and the rejected alternatives.
  - Neither has merged, so #1431 is not superseded. But the two will conflict on the Status / test-plan item 6 hunks, and whichever lands second needs a weave.
- **Unrelated overlap:** #1576 (the Phase 3 downstream audit) says it avoids the sections #1431 edits.
- **Earlier gauntlet:** it ended `review-budget-reached` after 6 rounds on 2026-10-08, against an earlier head that still described the encapsulation approach. The current head is a substantive rewrite, so a fresh gauntlet is justified.

**Follow-up for the maintainer:** decide the landing order with #1583, or fold #1583's `designs/README.md` index update into #1431. This doesn't block the gauntlet.

I made no edits, commits, or PR changes in this job.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-20261029-c3ab267ef93b-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (243824 cached reads)
- Output: 2638 tokens
- Cost: $0.5278688
- Wall-clock: 51s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
