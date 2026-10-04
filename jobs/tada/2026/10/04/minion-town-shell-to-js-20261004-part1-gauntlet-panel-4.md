Panel round 4 on kriscendobot/minion.town PR #151 finished with a **must-fix** verdict, and the review is posted on the PR.

**What I did**
- Checked out the PR head (`chore/javascript-only-scripts-part-1` at `29c75412a2`, on kriscendobot's own repo) in an isolated worktree.
- Ran `panel.sh` in single-round mode against the PR's actual base commit `a378bb3dd5` (`main-a378bb3`). That base gives the same 37 changed files GitHub shows. Before passing it, I confirmed GitHub's base commit was available in the checkout. I set `GARDEN_YARN=npm` because minion.town uses npm.
- `panel.sh` exited 0 with the code panel: `panel #151: code-panel single-round — must-fix`. All 33 seats ran without errors. The run is recorded at `panel-runs/kriscendobot-minion.town-151/7fbcdd9057ae.md`.
- Posted the verdict as review 5407844791 (https://github.com/kriscendobot/minion.town/pull/151#pullrequestreview-5407844791). GitHub refused a request-changes review because kriscendobot opened the PR, so it went up as a comment review headed "Panel round 4 — must-fix" with **Disposition: must-fix**, the same shape as rounds 1–3. The body is a summary plus the full text of the 14 seats that did not approve, about 54K characters, which is under GitHub's limit.

**Result:** 8 request-changes, 6 comment-only, 19 approve. Round 3's must-fix (the symlink and extensionless-file gaps in the JavaScript-only check) is confirmed closed, and its new tests would fail if the fix were reverted.

**Must-fix items for the next fix stage:**
1. **saboteur:** `readFirstLine` builds file paths with `new URL`, so a `#` or `?` in a filename makes it read the wrong file, and a bad `%` escape crashes the check.
2. **engine-realist:** the installed `preflight.js` only loads as ESM on Node 22.7 or later, but the install guard accepts any v22. Ship it as `.mjs` or require at least 22.7.
3. **prover:** the writability-probe fix in `inspect-image.js` has no regression test.
4. **curator:** `lib/common.js` repeats the AWS constants already defined in `deploy-cd-iam.mjs`.

There are also about ten should-fix items, including ASCII-only email lowercasing, the main-module check being skipped when the script runs through a symlink, `replaceAll` in the vendor tool, and regrouping the commits and refreshing the PR description.

**Follow-ups:** none from this stage. The next gauntlet stage is the fix loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1236899 cached reads)
- Output: 8602 tokens
- Cost: $1.0287557999999999
- Wall-clock: 561s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
