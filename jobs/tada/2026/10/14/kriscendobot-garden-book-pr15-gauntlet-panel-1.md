Panel round 1 on PR #15 finished with a **must-fix** verdict, and the review is posted. GitHub would not let the bot request changes on its own PR, so it went up as a comment review with the must-fix verdict stated at the top.

**What I did**
- Checked out the PR head (`755ef9b`, branch `garden-book-illuminations-republish-20261014`) in an isolated worktree.
- Ran `panel.sh` in single-round mode against the base commit `5acd916ca3df` (`main-5acd916`). It exited 0 with disposition `must-fix`: 33 seats ran, 2 requested changes, 10 approved and 21 were comment-only.
- My first panel launch was stopped after a few seconds because a background command would have been cut off at 10 minutes. I re-ran it detached, and the verdict comes from that complete second run.
- The full aggregate was 74K characters, over GitHub's 65,536-character review limit. The review therefore carries a summary plus the two request-changes seat reports in full. All 33 seat reports follow as two PR comments: issuecomment-6164574782 and issuecomment-6164575219.

**Must-fix items**
1. **migrator:** the published page's documented content-security policy (`default-src 'none'; style-src 'self'`) has no `img-src`, so the 25 new WebP images may render blank once published. The check tool tests under a policy it made up (`img-src file:`) rather than the real one.
2. **packager:** commit `05f1907` adds a procedural redraw of about 2.4k lines that commit `bc42bef` then deletes. It should be squashed away.
3. **packager:** `bc42bef` mixes the build pipeline, asset removal, new art, tests and docs in one 71-file commit. It should be split.

The seats also raised should-fix items:
- a stale `.svg` regex in `tools/illumination-check.mjs`
- a leftover reference to the deleted `title-garden.svg` in `art/chapter-illustrations-brief.md:475`
- old files left in the output directory would still be published
- the `ratio` labels can disagree with the actual image dimensions
- a `×` character in the evidence prose

**Follow-up:** the gauntlet's next-stage check should be confirmed to accept a comment-state review with the must-fix marker in its body. That is the only verdict shape GitHub allows on the bot's own PRs.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1370699 cached reads)
- Output: 6168 tokens
- Cost: $0.8884598
- Wall-clock: 272s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
