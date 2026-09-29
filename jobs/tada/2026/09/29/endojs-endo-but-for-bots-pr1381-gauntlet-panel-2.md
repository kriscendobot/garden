Panel round 2 on endojs/endo-but-for-bots#1381 came back **must-fix**, and I posted the verdict on the PR.

**What I did**
- Checked out the PR head `5ff580e372` (branch `design/hardened-text-codecs-shim-status-reconciliation`) in an isolated worktree.
- Ran `panel.sh` in single-round mode against the PR's base commit `7ff30afbce` (`llm-7ff30af`). It ran the design panel, all 11 seat runs finished with status ok, and its last line was `design-panel single-round — must-fix`.
- I started the panel detached, so I never saw its exit code. I'm counting it as exit 0 because it printed a verdict and no seat failed.

**Seat verdicts**
- **Request changes (4):** critic, skeptic, copyeditor, integrator.
- **Approve (5):** decomplector, ergonomist, pedant, orthographer, thesaurus.
- **Comment only (1):** novice.
- The pruner seat also ran, forced by the PR-description concision check; its verdict isn't in this list.
- The PR-description template check came back NONCONFORMING, which forces must-fix on its own.

**Main findings**
- **Test plan contradicts § Status:** Test plan item 6 in `designs/hardened-text-codecs-shim.md` still says the XS runner tests a host without the codecs. § Status now reports that current XS has both codecs (endojs/endo-but-for-bots#1349).
- **Wrong milestone reference:** the note that the remaining items don't "gate Milestone 2" is misleading. This design was never tracked under M2, and M2 was already complete on 2026-06-15.
- **"Exactly the prototype permits" overclaims:** the permits table leaves out the `@@toStringTag` rows.
- **Totals edited in place:** the `designs/README.md` "Current totals" line was changed directly, instead of adding a groom note to `ARCHIVE.md` as the README's own preamble requires.
- **PR description:** it doesn't follow the base template (integrator seat).

**Posting the review**
- It went up as a **COMMENTED** review, headed "must-fix", at 2026-09-29T20:18:49Z. GitHub won't let the bot request changes on its own PR.
- The first attempt was blocked by the `gh` wrapper because the review text had bare `#N` references. I rewrote them as `endojs/endo#3322` and `#3340`, and `endojs/endo-but-for-bots#1349` and `#1355`, then posted.
- The full review is saved in `/home/kris/garden2/scratch/panel-pr1381-r2/`.

**Follow-ups:** the next stage is the fix loop. It needs to fix the findings above and rewrite the PR description to match the base template.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1381-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (594975 cached reads)
- Output: 4528 tokens
- Cost: $0.5860589999999999
- Wall-clock: 621s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
