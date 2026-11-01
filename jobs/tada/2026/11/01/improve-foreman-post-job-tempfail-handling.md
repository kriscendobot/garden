I changed the foreman so a post-job.sh exit of rc=75 is retried in place instead of failing the tick. It's pushed to main2 as `a9310301aae`.

**Why it was failing:** pid 708218 held the producer journal clone's repository lock from about 04:18:50 to 04:45Z. Each failed foreman tick tried to post the ironhorse step and got rc=75 ("repository lock … busy"). The same lock also blocked other jobs during that window: sends, entries, reaper doom-notices and journal-contention-watch. The 04:49 tick then posted the step normally.

**Changes in `scripts/jobs/foreman.sh`:**
- **Retry:** on rc=75 the foreman retries post-job.sh with doubling waits. Three settings control it:
  - `GARDEN_FOREMAN_POST_TEMPFAIL_RETRIES`: 3 extra attempts.
  - `GARDEN_FOREMAN_POST_TEMPFAIL_DELAY`: first wait 15s, then 30s and 60s.
  - `GARDEN_FOREMAN_POST_TEMPFAIL_DEADLINE`: 240s. No wait starts that would run past this. One attempt can spend minutes waiting on the lock, so this keeps the tick inside the unit's 900s timeout.
- **Safe to repeat:** a retried post can't double-post, because post-job.sh already skips a base or identity it has seen.
- **When retries run out:** it logs a WARN (not an ERROR), writes a `post-tempfail` line to `decisions.log`, and exits 75 as before. It does not touch `LAST_STEP` or the settle clock, so the next tick re-proposes and re-posts the step straight away. A non-75 failure still logs an ERROR.
- **Test hook:** a new `GARDEN_FOREMAN_POST_JOB` setting lets a test substitute post-job.sh.

**Tests:** the new `scripts/jobs/test/foreman-post-tempfail-test.sh` passes 8/8. It covers:
- two failures then a success posting the step in the same tick, with no ERROR;
- persistent failure: 1+3 attempts, exit 75, WARN only, `LAST_STEP` unchanged, decision recorded, nothing posted;
- the deadline stopping retries early.

The existing completed-collision, decision-log, brake, maintainer-notice-dedup and deferred-sigpipe foreman tests still pass.

**The long-lived lock holder (not fixed here):** I couldn't find which job pid 708218 was; it had exited and left no log lines under its own pid. I posted a follow-up job, `investigate-producer-journal-lock-long-holder-20261101`, with the evidence. It asks for three things:
- **Holder:** find the job that can hold the producer clone for tens of minutes, give it a time limit like post-job.sh's 300s deadline, and record the job's tag or unit in the lock's holder file so the culprit is named next time.
- **Stale-lock takeover doesn't work:** after 300s a waiter takes over `journal.lock`, but the same live holder still has the repository lock, so the waiter exits rc=75 anyway (seen at 04:32:29 and 04:42:30).
- **Leftover holder files:** stale `fetch.lock.holder.<pid>` files are piling up (over 60 under this one key, going back to 2026-10-15). Low priority.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-post-job-tempfail-handling.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2441899 cached reads)
- Output: 17463 tokens
- Cost: $1.6256797999999997
- Wall-clock: 275s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
