Panel round 6 on kriscendobot/minion.town PR #154 came back **must-fix**, and I posted the result as a review on the PR. I did not fix anything or un-draft the PR.

**The run:** I ran `panel.sh` in single-round mode at head `e461d76` against base `chore/javascript-only-scripts-part-2b-2ca6c15` (`2ca6c15`). It exited 0 with the must-fix verdict. 31 seats voted: 3 asked for changes, 11 left comments only, and 17 approved.

**The review:** https://github.com/kriscendobot/minion.town/pull/154#pullrequestreview-5408592021. I posted it as a comment, like rounds 1–5, because the bot can't request changes on its own PR. It summarizes the findings and includes the full seat outputs.

**Round 5's three must-fix items are all fixed:**
- the `endo()` wrapper now uses a single backslash;
- `FEDERATION_HOST`/`FEDERATION_PORT` are validated and quoted;
- file hashing reads in chunks instead of loading the whole file.

**New must-fix items in round 6:**
1. **No hash check on the Node download (wire-watcher):** `deploy-endo-daemon.js` downloads the Node tarball and extracts it into `/usr/local` as root without checking its hash. I confirmed the base `.sh` had the same gap, so this isn't a regression. Two sibling scripts in this PR already do the check, so the fix is to copy that pattern.
2. **Bad config lines silently ignored (saboteur):** `deploy-app.js:46` drops malformed `ENDO_CLAUDE_*` unit lines without an error. The deploy should fail on them instead. The shell "predecessor" the saboteur cites comes from commit `a7a3f4b`, which is on a sibling branch and not in this PR's base or head. The fix is still right, and I said so in the review.
3. **Missing input checks and tests (breaker):** in `provision-guest-reminders.js`, the `provision`/`demo`/`deprovision` commands don't validate the agent name. `makeRollbackProgram` has no input validation and no tests. Neither has a test with hostile input.

The review also lists the comment-only suggestions: stale `ENDO_COMMIT` and `.sh` references in the docs, a weaker exit-0 check in the reaper test, module comments lost from the shell versions, and missing edge-case and property tests.

**Follow-ups:** the gauntlet driver should post the fix stage for these three items. The coverage seat couldn't measure coverage of new lines because there is no c8 report in the worktree.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1320391 cached reads)
- Output: 8092 tokens
- Cost: $0.9714381999999998
- Wall-clock: 723s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
