---
kind: result
role: investigator
host: endolinbot
at: 2026-07-02T14:35:15Z
---
# result: why the garden missed kriskowal's #594 CHANGES_REQUESTED review — head-of-line block

**Job:** investigate-missed-pr594-review-detection (investigator, garden-infra).
**Incident:** kriskowal's CHANGES_REQUESTED review on endojs/endo-but-for-bots #594
(pullrequestreview-4616520025, submitted 2026-07-02T10:14:32Z) was not auto-detected;
the liaison relayed it by hand.

## Root cause (cited, not guessed): head-of-line blocking in comment-watcher.sh

The three hypotheses in the spec were tested against the code and the runtime state:

1. **Reviews vs comments coverage — NOT the cause.** `scripts/jobs/handlers/comment-source-gh.sh`
   § 3 already polls `gh api repos/<repo>/pulls/<n>/reviews`, iterates every OPEN PR
   (paginated `pulls?state=open&sort=updated&direction=desc`, activity-bounded at the
   cursor), and surfaces a `pr-review-body` row prefixed `[CHANGES_REQUESTED]`.
   `comment-watcher.sh` classify() then mints a `review` job for a trusted reviewer
   (kriskowal is an endojs org member → trusted). The reviews path is present and correct.

2. **Leader-gating outage — contributing, not decisive.** systemd journal confirms the
   `garden-comment-watcher@endojs-endo-but-for-bots` unit was `ExecCondition`-skipped
   (Skipped due to 'exec-condition') from ~09:44 to ~10:10 while the host was a follower,
   and resumed at 10:12. But the cursor is FROZEN while the unit is down, so on resume the
   10:14:32Z review is still in-window (cursor at 04:04:09Z) — the outage alone would not
   drop it. The resume path is time-keyed but safe here because it never advanced past the
   unseen review.

3. **The actual cause — one un-postable earlier item `break`-ing the whole batch.**
   Evidence:
   - Cursor `comments/endojs-endo-but-for-bots`: `last_seen: 2026-07-02T04:04:09Z`,
     never advanced past the review.
   - Watcher logs at 10:23:53Z and 10:35:35Z:
     `POST LOST for endojs-endo-but-for-bots-pr548-b3d56f1b — push did not reach
     origin/journal2; leaving cursor at 2026-07-02T04:04:09Z to retry` then
     `cursor unchanged ... (acted on 0; failed=1)`.
   - The batch is processed in ASCENDING created_at order. The #548 comment
     (issuecomment-4862458763 by erights, created 05:21:04Z, base `pr548-b3d56f1b`)
     sorts BEFORE the #594 review (10:14:32Z). Its post could not be confirmed on
     origin/journal2 (the job is in fact already `tada/`-done — the verify clone could
     not see it, so verify_posted read it as un-posted → POST LOST). The old code did
     `failed=1; break`, exiting the loop before ever reaching the #594 review at the tail.
     Every subsequent tick re-polls from the frozen 04:04:09Z cursor, re-hits #548 first,
     loses again, breaks again — the #594 review is never processed. Classic head-of-line block.

## The fix (landed on main2, commit 7f06119a1)

`scripts/jobs/comment-watcher.sh`: on POST LOST, no longer `break`. Record
`fail_floor = first lost item's created_at` and `continue`, so later independent
directives are still classified and posted this tick. A `slide()` helper freezes the
high-water cursor at the last SUCCESS strictly before `fail_floor`, so the failed
directive re-polls next tick while the cursor never strands it. Re-processing the
already-posted later items on the next tick is a cheap idempotent no-op (verify_posted
pre-check + post-job.sh identity dedup).

## Regression test (documented repro)

`scripts/jobs/test/comment-watcher-test.sh` case **HOL**: a batch of an earlier #59
shepherd comment (05:00:00Z, wired to POST-LOSE via a lying post stub) followed by
kriskowal's later #594 `[CHANGES_REQUESTED]` review (10:14:32Z). Asserts the poison #59
job is absent (push lost), the LATER #594 `review` job IS posted despite the earlier
lost post, the cursor stays frozen below the lost item (so #59 retries), and the loss is
logged. Full suite: **186 passed, 0 failed**.

## Follow-ups (out of scope here)

- The underlying reason #548's post "loses" is a stale/slow verify clone
  (`$GARDEN_STATE/comment-watcher/verify`) whose `git fetch origin journal2` was doing a
  62k-object index-pack each tick, so verify_posted could not confirm an already-completed
  job. Worth a separate look at verify-clone health / fetch cost; the head-of-line fix
  makes it non-fatal for detection, but it still burns a POST LOST + retry each tick.
- The #594 review itself is being addressed via `ebfb-lint-master-strategy-evidence`
  (per the job spec); this job closed only the detection gap.
