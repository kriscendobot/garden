Panel round 2 on kriscendobot/minion.town PR #186 finished with **must-fix**. `panel.sh` exited 0, and I posted the verdict to the PR.

**What I did**
- Checked out the PR head `build/root-canary-principal` @ `8c80972` into an isolated project worktree and ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against `origin/main-e3ffcbb`. 34 seats ran.
- Seat verdicts: 8 request-changes (saboteur, breaker, purist, wire-watcher, engine-realist, pruner, corner-prober, transplanter). The rest were comment-only or approve.
- The three must-fix items from round 1 are closed in the diff.
- GitHub refuses request-changes on the bot's own PR, so I posted the verdict as a comment review, the same way round 1 was posted: https://github.com/kriscendobot/minion.town/pull/186#pullrequestreview-5523568271
- The per-seat blocks were too long for one review body, so the rest went into a follow-up comment labeled "panel round 2 (continued)": https://github.com/kriscendobot/minion.town/pull/186#issuecomment-6176666746

**Must-fix findings for the next fix stage**
1. **engine-realist:** `deploy/probe/root-canary.mjs:192` checks whether it is the main module by comparing `URL.pathname` to `argv[1]`. Run from a symlinked directory or a path with a space in it, the probe does nothing and exits 0, so the canary reports a pass without touching the server. The fix is `fileURLToPath` plus `realpathSync`, and the wrapper should require an explicit `"status":"pass"` line.
2. **saboteur:** at `root-canary.mjs:702`, a bare `catch` around the cleanup `dismissClaudeAgent` swallows the error. A failed dismiss still returns pass and leaves a child running under the root principal.

**Also owed:**
- **Summary comment (scribe):** the round 1 fix-push has no comment naming the three closures, the declined should-fix items, and how they were verified.
- **Should-fix items raised by several seats:**
  - a bad `GARDEN_JOB_BASE` makes the canary exit 75 (the "waiting" code) instead of 1;
  - the mint's login listener stops after a single request;
  - re-minting should also revoke the `AWSPREVIOUS` token;
  - the audit hook is handed the token-carrying `AuthInfo`.

I made no fixes, didn't un-draft the PR and changed nothing in the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (915547 cached reads)
- Output: 6345 tokens
- Cost: $0.8397293999999998
- Wall-clock: 789s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
