I ran panel round 5 on PR #152 (kriscendobot/minion.town). The verdict is **must-fix** and is posted on the PR.

**Run details**
- Reviewed head `b308a11` against the base pinned at `dcc2d64`, in an isolated checkout of `chore/javascript-only-scripts-part-2a`.
- `panel.sh` exited 0 in single-round mode. All 33 seats returned a verdict. The breaker seat timed out once (1200s) and succeeded on its second attempt.
- Tally: 1 request-changes, 13 comment-only and 19 approve.

**Blocking finding (integrator, must-fix)**
- The new shared `isMain` helper at `deploy/aws/scripts/lib/common.js:206-209` compares `argv[1]` against the module URL without resolving symlinks first.
- So any of the PR's 9 new executables run through a symlink skips `main()` and exits 0 without doing anything.
- PR #151 already fixed this in `3e73f007a2` by calling `fs.realpathSync`. PR #152 branched from an older snapshot of #151 and never picked that fix up. This is the third time in this PR's panel history that the stale base has brought a #151 bug back.
- No test covers running a script through a symlink.

**Non-blocking findings**
- The typist seat flagged `→`, `…` and `≤` characters carried over from the shell scripts into log strings and comments.
- Other seats left comment-only notes.

**Posting**
- GitHub refuses a request-changes review from the PR's own author, so the verdict went up as a COMMENT review (`5408236824`), titled "Panel round 5 — must-fix". Rounds 1–4 were posted the same way.
- The full aggregate is about 75 KB, over GitHub's review-body limit. The review carries the integrator block, and the other 32 seat blocks follow as two PR comments, "panel round 5 aggregate (part 1/2)" and "(part 2/2)".

I made no fixes and did not un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (927381 cached reads)
- Output: 5413 tokens
- Cost: $0.8161762000000001
- Wall-clock: 2375s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
