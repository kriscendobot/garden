I ran panel round 2 on endojs/endo-but-for-bots PR #1442 and the verdict is **must-fix**. I posted it as a review on the PR and did not fix anything or change the PR's draft state.

**What I did**
- Made an isolated checkout of the PR head, `endojs/endo-but-for-bots@mirror/endo-3372-ses-frozen-null-pills` at `26b4d946cf`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's real merge base `356d6e70af` (`master-356d6e7`). It exited 0 with disposition `must-fix`. All 33 seats returned without error: 4 requested changes (stylist, packager, archivist, integrator), 20 were comment-only and 9 approved. The PR-body concision pre-pass also fired: the description touches 5 distinct file paths.
- Posted the result as review 5512008477: https://github.com/endojs/endo-but-for-bots/pull/1442#pullrequestreview-5512008477. GitHub does not let the bot request changes on its own PR, so the review is a `COMMENTED` one. Round 1 was posted the same way. The body opens with the "Panel verdict — round 2: **must-fix**" header and grouped findings, then the four request-changes seats in full. The comment-only and approve seats appear only as a one-line list, to keep the review well under GitHub's size limit.

**Findings for the fixer**
- **Must-fix:** squash the `fixup!` commit `4395ad9a6e` into `f040b54870`.
- **Should-fix:**
  - Fold the "address panel review" commit `26b4d946cf` into `f040b54870`.
  - The `git clean` script fix and the `configstore`/`nconf` resolutions ride along with the SES fix. Either name all three in the title and description or split them out, and say which package pulls in the resolutions.
  - Add a test that pins `package.json`'s `clean` script to `gitCleanArguments` so the two copies can't drift.
  - In `_prepare-with-frozen-null-pills.js`, fix the garbled opening comment ("that permit removal will visit").
  - In the same file, rename `shapes`/`pill` to descriptor names, and use one name for both `shape` and `pillShape`.

**Notes**
- The PR is already out of draft, so the later un-draft stage will have nothing to do.
- No garden repo changes; nothing committed to main2.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1442-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (901818 cached reads)
- Output: 5153 tokens
- Cost: $0.8224155999999998
- Wall-clock: 216s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
