Panel round 10 for kriscendobot/minion.town PR #186 finished with **must-fix**. I posted the verdict on the PR and stopped there, without fixing or un-drafting anything.

**What I did**
- Checked out the PR head (`build/root-canary-principal` @ `d6f4e64`) in an isolated project worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 186 origin/main-e3ffcbb`. It exited 0 with `code-panel single-round — must-fix`.
- Posted the verdict:
  - **Review:** GitHub refused a request-changes review on the bot's own PR, so it went up as a COMMENTED review headed "round 10: **must-fix**", the same shape as round 8.
  - **Size split:** the full aggregate (87 KB) is over GitHub's review body limit. The review carries the header and the four request-changes seat blocks in full. The other 30 seat blocks (approve or comment-only) went into two PR comments, #issuecomment-6196772892 and #issuecomment-6196773735.

**Must-fix findings (4 seats requested changes: saboteur, breaker, pruner, decomplector)**
- **Saboteur:** an empty or malformed "unallowed" token passes the negative-path gate. In `deploy/probe/root-canary.mjs:162-170`, the helper's stdout is used as the token without validation.
- **Breaker:** the negative-path gate passes without actually testing the allowlist that `DEPLOYMENT.md` says it enforces.
- **Pruner and decomplector:**
  - The PR goes against kriskowal's standing directive on #150 (2026-10-04) to convert shell scripts to JavaScript.
  - The same mechanism (`root-canary-common.sh` and `root-canary.mjs`) has now drawn must-fix findings for three rounds running (heads 81beda5a, f51219b6, and now d6f4e64). `root-canary-common.sh` checks token signatures with a mix of shell plumbing and inline `node -e`.

**Follow-ups**
- Because the same mechanism keeps failing, the next fix round should rewrite the shell token and verification scripts in JavaScript per the maintainer directive, not patch them again.
- Locksmith also raised a should-fix (in its comment block): `DEPLOYMENT.md` claims more isolation than the code gives.
- My inbox was empty.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-panel-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1027372 cached reads)
- Output: 5076 tokens
- Cost: $0.7017944
- Wall-clock: 616s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
