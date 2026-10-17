## Report: gauntlet fix round 3, kriscendobot/minion.town PR #198

**Result: the fixes are in, but CI never ran.** `ci-wait-merge.sh` hit its 3600s deadline with rc=4 (still pending).

**What I did**
- Made an isolated checkout of the PR head, `kriscendobot/minion.town@feat/beta-home-splash-waitlist`, and read the round-3 panel verdict (review 5558307546, which reviewed head `65b37eef`).
- An earlier claimant of this job had already pushed three follow-up commits that cover every must-fix item, so I pushed nothing new:
  - `6edca7b`: drops `rate_key` from waitlist rows and the table, so the network key lives only in the in-memory limiter. It also names `WaitlistEmailError` and narrows the router's catch to it with `instanceof`, and refuses format (`\p{Cf}`) characters in addresses.
  - `83f7631`: a guest link is now checked with `GET /api/guest` before it is stored, and replacing a different stored credential asks the visitor first. Any fragment holding a `guest` key is cleared from the address bar. `connect.html` now uses `&larr;`. Tests were added in `home-page.test.ts`.
  - `6ef80c1`: the docs state the IAM split honestly (PutItem with `ReturnValues` NONE, and no claim that a known address can't be overwritten or probed). They also give the deploy order, cite sibling PRs by number with #199 named as owner of the coupon-client port, refresh the stale clip-shell Open question #2, and cut the repeated pruner text.
  - The `parseFragment` / `one()` JSDoc now says `@returns {string | null}`.
- Ran local checks on head `6ef80c1`: `tsc --noEmit` is clean, and the waitlist, waitlist-dynamodb and home-page tests pass (69/69).

**CI**
- The only workflow run for `6ef80c1` ("test (typecheck + vitest)") has sat in `queued` since 16:07Z. Eleven minion.town runs are queued and none are in progress, so the self-hosted runner looks stalled or down.
- A board job already owns the runner problem: `minion-town-ci-runner-stall-20261017` (in `todo/`). This host's PAT gets a 403 reading the `CI_RUNS_ON` variable and the status-check rollup, so I couldn't switch runners from here.

**Follow-up:** once the runner is back, the driver should re-post this stage so CI is checked on `6ef80c1`. No new fix commits are needed.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 124 tokens (5653717 cached reads)
- Output: 38338 tokens
- Cost: $3.359383399999999
- Wall-clock: 7948s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
