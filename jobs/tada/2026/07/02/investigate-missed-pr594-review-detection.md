Inbox empty. The job is complete. All deliverables landed.

## Completion report

**Root cause (cited, three hypotheses tested against code + runtime state):**

1. **Reviews coverage — NOT the cause.** `handlers/comment-source-gh.sh` §3 already polls `/pulls/<n>/reviews`, iterates every open PR (activity-bounded), and surfaces `pr-review-body` rows prefixed `[CHANGES_REQUESTED]`; `classify()` mints a `review` job for a trusted reviewer (kriskowal is an endojs member → trusted). The reviews path is present and correct.
2. **Leader-gating outage — contributing, not decisive.** The unit was `ExecCondition`-skipped ~09:44–10:10 and resumed 10:12. But the cursor is frozen while down, so the 10:14:32Z review was still in-window on resume — the outage alone wouldn't drop it.
3. **The actual cause — head-of-line blocking.** The batch is processed in ascending `created_at` order behind one scalar cursor. An earlier #548 comment (05:21:04Z, base `pr548-b3d56f1b`) kept hitting `POST LOST` (its already-`tada`-done job couldn't be confirmed via a stale/slow verify clone), and the old code did `failed=1; break` — exiting before ever reaching the #594 review at the tail. Every tick re-polled from the frozen `04:04:09Z` cursor, re-hit #548, broke again. Evidence: cursor stuck at `last_seen: 2026-07-02T04:04:09Z`; watcher logs at 10:23:53Z/10:35:35Z show the `POST LOST ... pr548-b3d56f1b` + `cursor unchanged (acted on 0; failed=1)`.

**Fix (landed on `main2`, commit `7f06119a1`):** `comment-watcher.sh` no longer `break`s on `POST LOST`. It records `fail_floor = first lost item's created_at` and `continue`s, so later independent directives are still classified and posted this tick; a `slide()` helper freezes the cursor at the last success strictly before `fail_floor`, so the failed directive re-polls while never stranding it. Re-processing already-posted later items next tick is a cheap idempotent no-op.

**Test / repro:** Added case **HOL** to `comment-watcher-test.sh` — an earlier lost #59 shepherd post no longer blocks a later #594 `[CHANGES_REQUESTED]` review: the review job lands, the cursor stays frozen below the lost item, the loss is logged. Full suite **186 passed, 0 failed**.

**Journal:** result entry `entries/2026/07/02/143501Z-result-investigator-958c16.md` posted.

**Follow-ups (out of scope):** the verify clone (`$GARDEN_STATE/comment-watcher/verify`) was doing a 62k-object index-pack per tick — the reason #548's confirm "loses"; the head-of-line fix makes it non-fatal for detection but it still burns a POST LOST + retry each tick. Worth a separate verify-clone-health look. The #594 review itself is handled via `ebfb-lint-master-strategy-evidence`.
