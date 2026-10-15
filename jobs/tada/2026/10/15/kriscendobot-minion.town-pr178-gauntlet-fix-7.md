# Gauntlet fix round 7: kriscendobot/minion.town PR #178

I fixed the round-7 panel's request-changes items and pushed them to `git-remote-push-caps` (2a6064d → 21c0c05). CI is green: `ci-wait-merge` exited 0 with 1/1 runs passing.

**The must-fix input.** Only the breaker seat asked for changes, with three should-fix items. All the other seats approved or left comments only. I fixed the breaker's three items:

1. **A full partition could not be emptied by a push.**
   - The ref advertisement no longer refuses a full partition.
   - At the POST, a full partition now gets the one-byte `receive.maxInputSize` grant instead of a 507. Any pack is refused before a ref moves, but a ref deletion (which sends no pack) goes through.
   - `DEPLOYMENT.md` now gives the operator step to free the space: delete the refs, then run `git gc --prune=now`.
   - Downside: a stock client pushing to a full partition now sees git's "pack exceeds maximum allowed size" error, not the earlier "partition is at its … size limit" message.
2. **The size walk ran on unthrottled requests.** The advertisement no longer measures the partition. Probes (≤4-byte unencoded bodies) skip both the push slot and the measurement. So the measurement runs only under the per-partition push slot, after rate admission.
3. **The push queue had no limit.** A push is now counted against the rate limit when it arrives, not after the size check. A new cap, `maxPendingPushes` (default 4, env `GIT_REMOTE_MAX_PENDING_PUSHES`), limits how many pushes per partition can run or wait at once. Past it, a push gets an immediate 429.

**Smaller fixes from other seats:**
- `Content-Length` must now be digits only and a safe integer, or the push gets a 400.
- `Content-Encoding` is compared case-insensitively.
- Added the missing `windowMilliseconds` `@param`.
- Corrected the `refusePushRequest` comment, and the docs now say "apparent size".

**Commits:**
- `9e30215 fix(git-remote): let a full partition shrink and bound the push queue`
- `21c0c05 docs(git-remote): document full-partition recovery and the pending-push cap`

**Tests:**
- Typecheck is clean.
- The limits and config suites pass (29/29).
- I replaced the old "full partition refused" test with one that checks a pack is refused but a ref deletion succeeds.
- New tests cover the queue-depth 429 and a `Content-Length` past the largest safe integer (400). The "failing limit check" test now expects the advertisement to be served and the POST to fail with a 500.

**Follow-ups:**
- One test fails in this local run in a file I didn't touch: `capability.test.ts`, "propagates a git failure rather than reporting the ref absent". It fails without my changes too, likely because the scratch temp directory sits inside a parent git repository. It does not affect the PR.
- I did not take up the other seats' optional items: squashing the commit history, an end-to-end gzip-bomb test, and a router-level test for a client hanging up mid-walk.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2518875 cached reads)
- Output: 22957 tokens
- Cost: $1.744659
- Wall-clock: 1246s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
