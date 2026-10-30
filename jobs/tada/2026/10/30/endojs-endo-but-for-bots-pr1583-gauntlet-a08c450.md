gauntlet-status: not-viable
viability-result: overtaken
repo: endojs/endo-but-for-bots
pr_number: 1583
# gauntlet endojs-endo-but-for-bots-pr1583-gauntlet-a08c450 - not viable

the premise was overtaken. Deciding question: Is #1583 still the only open PR recording endojs/endo#3376 against `designs/hardened-text-codecs-shim.md`, with its account of the remaining work still accurate? Option: close as superseded.

## Viability report

Checked: #1583's reconciliation duplicates other open PRs touching the same design doc. Writing the report now.

## Viability report: endojs/endo-but-for-bots#1583, gauntlet `a08c450`

**Verdict: overtaken.** This stage spent no clean, panel, fix or CI budget.

**PR facts:** Open, not merged, not draft. Title: "docs: reconcile hardened text codec supersession". Base `llm-9a14ddf` (`9a14ddf660`), head `a08c4505c0`. It edits only `designs/hardened-text-codecs-shim.md` and `designs/README.md`.

Deciding question: Is #1583 still the only open PR recording endojs/endo#3376 against `designs/hardened-text-codecs-shim.md`, with its account of the remaining work still accurate?

Evidence:
- **Nothing has landed on `llm`.** `llm` is still at `9a14ddf660`, the PR's base. The design file's last change there is `345438a788` (2026-10-07). So no merged change displaces #1583, and the need to record endojs/endo#3376 still holds.
- **endojs/endo-but-for-bots#1431 already records the same remedy.** It is open, not draft, and was rebuilt on the same base `llm-9a14ddf` with last commit `1286f427b5` at 2026-10-29T15:35Z. That is after #1583 was opened (2026-10-29T04:11Z).
  - #1431's diff records the same things #1583 does: endojs/endo#3376 merged as `679d9afaa4` but not yet on `llm`, #1349 closed as superseded, the Chromium 120–137 affected / 138–140 clean boundary, and the remedy's residual.
  - #1431 is also the more mature carrier. It has been through six panel rounds plus a 2026-10-29 panel, and its gauntlet stopped at `review-budget-reached`, waiting on the maintainer.
- **endojs/endo-but-for-bots#1576 already carries the Phase 3 audit.** It is open and edits the same two files. #1583's re-run audit ("22 matching lines in 13 files, all Node-host code") repeats #1576's per-file audit.
- **One of #1583's claims is now false.** It says the XS smoke coverage is still wanted and "no open PR carries it". But endojs/endo-but-for-bots#1584, "test(ses): smoke-test the host text codecs on XS", opened 2026-10-29T04:59Z and says it supersedes #1349's XS coverage.
- **Merging all of them would conflict.** #1583, #1431 and #1576 all rewrite § Status and the remaining-work list of the same design doc. Running #1583's gauntlet would spend budget on a doc whose content is split across the other three PRs.

Option: close as superseded

**Recommendation:** Close #1583 as superseded by #1431 (the supersession record), #1576 (the Phase 3 audit) and #1584 (the XS smoke coverage). Only one piece is unique to #1583: it separates the XS lockdown-Compartment repair owned by endojs/endo-but-for-bots#1425 and makes the XS follow-up depend on it. That could go into #1431 as a small fix.

If you would rather keep #1583 as the single carrier, the alternative is to close #1431 and #1576 instead. In that case, #1583's claim that no open PR carries the XS coverage must first be corrected to cite #1584.

**Follow-ups:** None posted. This needs your decision; it is not fleet work.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1583-gauntlet-a08c450-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (308410 cached reads)
- Output: 3765 tokens
- Cost: $0.5543739999999999
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
