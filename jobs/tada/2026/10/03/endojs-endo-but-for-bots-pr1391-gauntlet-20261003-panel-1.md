Panel round 1 on endojs/endo-but-for-bots PR #1391 finished with a **must-fix** verdict, and the review is posted on the PR.

**How it ran**
- I checked out the PR head `build/sturdyref-ses-accommodation` at `008820366e` in an isolated worktree.
- The base was the stacked branch `build/sturdyref-shim-first-wins-ef4662f`, so I passed its merge-base SHA `ef4662f04b` to `panel.sh` rather than the branch name.
- `panel.sh` ran in single-round mode. All 32 seats returned a verdict, the decider logged no errors, and the run was recorded at `panel-runs/endojs-endo-but-for-bots-1391/063c0cccabd0.md`. I ran it in the background, so I didn't see its exit code directly. It printed the normal final line ("single-round — must-fix"), which is why I treated this as a real verdict and not a panel error.
- Seat results: 2 request-changes, 9 comment-only, 21 approve.

**Must-fix items**
1. **integrator:** the PR adds a `SturdyRef` global that carries its own identity, like a remote object. That clashes with two things it never addresses:
   - the existing `SturdyRef` in `@endo/ocapn`, which is a plain data value with no identity;
   - the maintainer's unresolved request-changes review on #695, which says sturdyrefs should be a new kind of passable value, not a remotable.

   The seat recommends holding this PR behind #695 and #1389.
2. **pruner:** two comments are padding and should be cut:
   - in `packages/ses/src/global-object.js`, the note on `firstWinsPropertyNames` about what a future refactor would take;
   - in `packages/ses/test/_sturdyref-shim-first.js`, a sentence that restates the code below it.

**The review was posted as a comment, not "request changes"**
- GitHub rejected `--request-changes` because the bot account also opened this PR ("Can not request changes on your own pull request").
- So I posted it as a COMMENT review instead: https://github.com/endojs/endo-but-for-bots/pull/1391#pullrequestreview-5399695642. The first lines state "Disposition: must-fix", list both items, and explain why it isn't a request-changes review.
- To stay under GitHub's size limit for a review body, the review gives the full reports from the request-changes and comment-only seats and lists the approving seats by name only.

**Follow-ups**
- The next-stage check and the fix stage's instructions expect a request-changes review. On any PR the bot opened, they will see a COMMENT review instead, which may need a fallback that reads the must-fix disposition from the comment.
- The integrator item is a design question rather than a code fix, so the fix stage may need the maintainer to decide on it.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261003-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1308239 cached reads)
- Output: 6076 tokens
- Cost: $0.8976398
- Wall-clock: 682s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
