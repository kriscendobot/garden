## Completion report: deadmail-issue-comment-5884119530 (issue kriscendobot/garden#51)

**The comment:** kriskowal pointed out that the issue title still said the arc was paused. They asked to resume the arc, but only within a budget and a press interval that only the foreman can wake. Each engagement should park a plan to continue, and the foreman promotes it only if budget permits.

**Where things stood:** the arc was about to be woken by the scheduler, not the foreman. The `ironhorse-ratchet` schedule (a 2-hour mentat watcher) was due to fire first at 14:00Z today. The parked job `activate-ironhorse-ratchet-autopilot-20260929-r4` was about to let that tick through.

**What I did:**
1. **Snoozed the schedule:** ran `snooze-schedule.sh ironhorse-ratchet '2027-01-01 00:00:00Z'`, so no scheduler tick can wake the arc. The merge delegation of 2026-09-28 is untouched.
2. **Annotated the parked activation job:** `activate-ironhorse-ratchet-autopilot-20260929-r4` now carries the directive (key `maintainer-directive-5884119530`). Its step that would let a scheduler tick through is marked superseded; its deploy-verification step is still useful.
3. **Posted `build-ironhorse-foreman-woken-press`** (builder, mentor tier, ISSUE NOTE carried verbatim). It covers:
   - a `not_before` press interval on deferred plans, honored by the foreman's promotion and refusing to promote when the value can't be read;
   - a per-arc token budget derived from the usage ledger;
   - each engagement parking exactly one deferred successor plan;
   - keeping all existing mentat gates, retiring the schedule, and updating docs.
4. **Updated the issue:** new title "Arc: Ironhorse Test262 compliance ratchet (resuming — foreman-woken budgeted press)" and a rewritten description with current state, pins, PRs #1087, #1113 and #1359, and the latest sweep numbers.
5. **Replied on the issue:** https://github.com/kriscendobot/garden/issues/51#issuecomment-5884729877. The reply says what changed and asks two questions: what the arc's budget number is, and whether a 6-hour press interval is acceptable. It also restates the unanswered round-3 historical-floor question. The issue stays open.

**Follow-ups:**
- The maintainer needs to answer the budget amount and the press interval. Until they name a budget, the build job will park the first engagement rather than guess one.
- The round-3 floor question (parked job `ironhorse-test262-ratchet-round3-floor-resolution-20260928`) is still unanswered; this comment didn't answer it.
- `build-ironhorse-foreman-woken-press` owns all the mechanism work.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5884119530.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1658013 cached reads)
- Output: 12527 tokens
- Cost: $1.2989505999999997
- Wall-clock: 155s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
