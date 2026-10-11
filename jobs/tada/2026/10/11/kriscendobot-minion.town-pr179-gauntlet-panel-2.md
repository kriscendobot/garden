I ran panel round 2 on kriscendobot/minion.town PR #179 (head `91aa6b5`, base `main-c7bdf20`), and the verdict is **must-fix**. panel.sh exited 0 in single-round mode.

- **Checkout:** I made an isolated project worktree of `kriscendobot/minion.town@gutter-clip-labels` with `ensure-project-worktree.sh`.
- **Restart:** I stopped the first panel run myself because a background task here is cut off at 10 minutes. I relaunched it detached and waited in the foreground. The relaunch picked up the finished seat outputs, and the run's head was `91aa6b5`.
- **Seats:** 34 ran. 10 approved, 18 were comment-only, and 6 requested changes: assessor, saboteur, breaker, spec-keeper, wire-watcher and pruner.
- **Posted to the PR:**
  - The per-seat detail went up as two comments, because the full text is too long for one comment (issuecomment-6107091836 and -6107092066).
  - The summary review starts "Panel round 2: must-fix" and carries the `garden-panel … round=2 disposition=must-fix` marker. GitHub won't let the bot request changes on its own PR, so the review was posted as a comment, the same as round 1.
- **Main items still open:**
  1. **Invisible characters pass the sanitizer:** both copies of the sanitizer let tag characters, stray zero-width joiners and variation selectors through. That lets hidden text reach the LLM through `listSites`, and a name made only of these characters skips the "Clip N" fallback.
  2. **Concurrency limit leaks:** the 4-at-once limit doesn't cap daemon reads that keep running after a timeout.
  3. **No reconnect:** the daemon connection is cached and never retried, so one outage leaves directory clips as "Clip N" until the gateway restarts.
  4. **Shared limiter:** one owner with many clips can make another owner's names time out.
  5. **Smaller items:** names aren't re-sanitized on the MCP path, truncation can split an emoji, and a brief read miss is cached for good. There are also doc and PR-body updates: the design doc, the tool name, a completion summary after the fix push, and the pruner's cuts.

Per the job spec, I made no fixes and left the PR in draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1332562 cached reads)
- Output: 7366 tokens
- Cost: $1.0018484
- Wall-clock: 1150s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
