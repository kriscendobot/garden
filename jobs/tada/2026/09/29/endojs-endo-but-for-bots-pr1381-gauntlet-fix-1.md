Gauntlet fix round 1 for endojs/endo-but-for-bots PR #1381 is done: all 28 CI checks passed (`ci-wait-merge.sh` returned rc 0).

I fixed the must-fix item and the panel's should-fix items in one follow-up commit, `5ff580e372`. It went onto the head branch `design/hardened-text-codecs-shim-status-reconciliation` through `safe-push-pr-head.sh --mode advance`, moving it from `e26b2dec6b` to `5ff580e372`.

**Must-fix**
- **pedant:** in `designs/README.md`, the totals line now uses `->` instead of the Unicode arrow `→`.

**Copyeditor**
- The Unicode ellipsis in `.toString('utf…')` is now ASCII `...`.
- The unclear "Before it," now reads "Before that change,".
- "the absence path this design assumed" now reads "the missing-codecs case this design assumed".

**Skeptic**
- The body no longer contradicts the new Status section. § Sampling and degradation and Design Decision 3 said XS lacks `TextEncoder` and `TextDecoder`. Both now say this held for hosts without the codecs when the design was written, and that current Moddable `xst` defines both codecs (the #1349 finding). The Status section points to both places.
- The Phase 3 count is now "16 … call sites" instead of 17. One of the 17 matches was a comment, not a call site.

**Novice**
- `llm` is now described as this repository's integration branch.
- M2 is now "Milestone 2", linked to `README.md` § Milestones.
- "sampling" now points to the § Sampling section, which defines it.
- The test-plan item numbers now name § Test plan.

I did not act on the copyeditor's optional suggestion to restructure the sentence with the test counts. No follow-ups are needed. I did not re-run the panel; the gauntlet driver posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1381-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (822310 cached reads)
- Output: 8557 tokens
- Cost: $0.83645
- Wall-clock: 828s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
