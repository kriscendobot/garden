## Report: fix-comment-watcher-missed-minion-town-pr112-conduct

The comment-watcher missed kriskowal's "Please conduct" on minion.town#112 because it was silenced by a cooldown meant for a different rate-limit bucket. Its verb detection, the trust gate and the sender gate were all fine. The fix is on main2 as `d1bb518590`, with regression tests, and all affected test suites pass.

### Why it was missed
- **What went wrong:** The ci-watcher reads CI status with `gh pr view`, which only uses GitHub's GraphQL rate-limit bucket. When that bucket ran out, it set the host's one shared gh-api cooldown for 3600s (`rollup_hit_primary_quota`). The comment-watcher checks that same cooldown at `api_cooldown_active` and exits without logging anything.
- **Why it lasted hours:** The GraphQL bucket ran out again every hour, so the cooldown was set again on the first ci tick after each expiry: 17:41, 18:41, 19:42, 20:42 and 21:42Z. From 17:40Z on, every `garden-comment-watcher@kriscendobot-minion.town` tick exited silently. At 22:24Z the GraphQL bucket showed 3859/5000 used while the REST bucket was untouched, and everything the comment-watcher needs to detect and acknowledge a comment is REST.
- **Mention-watcher:** its units are rendered on this host but not enabled (arming it needs maintainer authorization), so it could not have caught this.
- **Latency watch:** it did alert, but as a flood of `comment-watcher-dead-*` notices for all 16 repos (the minion.town one was on its 37th amendment). That false-"dead" flood is already fixed by `987bb13b9b` (landed about 70 minutes before this job, not yet deployed). With that fix, this situation shows up as a single "stuck in cooldown" notice for the host. I only added the GraphQL cooldown to that notice's description.
- **Verb parsing:** the exact comment body, including the trailing second sentence, correctly produces `<slug>-pr112-conduct` in the regression test.

### What changed
- **`common.sh`:** `start_api_cooldown` can now set a GraphQL-only cooldown in its own file (`marker-graphql`). `api_cooldown_active` takes what the caller needs: `all` (the default, unchanged), `rest`, or `graphql`.
- **`ci-watcher.sh`:** a GraphQL quota refusal now sets only the GraphQL cooldown.
- **`comment-watcher.sh` and `issue-inbox-watcher.sh`:** they now only stop for the REST/host-wide cooldown. The comment-watcher's one GraphQL call (the mergeable check) is skipped while the GraphQL cooldown is active, and a conduct request still becomes a conductor job, because the conductor's merge step re-checks CI and approval itself.
- **`pr-mergeable-gh.sh`:** a failed read now exits 3 ("unreadable") instead of 1 ("not green"), and a GraphQL quota refusal sets the GraphQL cooldown.
  - The comment-watcher keeps the conductor on exit 3 instead of guessing a shepherd.
  - `approval-reconciler.sh` retries next tick on exit 3.
- **Tests:**
  - A new GQL case in `comment-watcher-test.sh` uses the exact #112 body and checks for the conductor job, the 👀, no shepherd, no mergeable call and the cursor advancing (380 passed, 0 failed).
  - New scope cases in `api-cooldown-test.sh` (19 passed).
  - `ci-watcher-test.sh` now checks that the CI cooldown is GraphQL-only (75 passed).
  - The approval-reconciler, latency-watch, issue-inbox, mention-watcher and cursor-outage suites also pass.

### Follow-ups
1. **Posted `diagnose-hourly-graphql-quota-exhaustion-20260923`.** Something uses up about 5000 GraphQL points an hour. With this fix the comment-watchers keep running, but the ci-watcher, dependabot-watcher, approval-reconciler and conductor still stall every hour until the cause is found.
2. **The hand-posted conductor job for #112 will likely stall.** The PR has no approving review, and the merge path requires a current maintainer approval (`a7e082497e`). Before this fix, the watcher would also have turned the request into a shepherd job rather than a conductor job. kriskowal's "do not request review for pin advancement" sounds like a merge-policy exception, which only the maintainer can decide.
3. **None of this is live until deployed:** both this fix and `987bb13b9b` are only on main2 so far.
4. **Side effect:** during diagnosis I accidentally ran `comment-latency-watch.sh` from the worktree once. It re-amended the same watchdog notices the timer already writes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-comment-watcher-missed-minion-town-pr112-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (8343704 cached reads)
- Output: 43668 tokens
- Cost: $3.8790928
- Wall-clock: 580s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
