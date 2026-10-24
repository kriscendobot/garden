## Report: improve-deadmail-completed-collision

`deadmail.sh` now treats exit code 79 from `post-job.sh` as a finished promotion. It checks that the completed job is on origin, then removes the dead-mail entry. If it can't confirm the job, the entry stays queued and is retried quietly. The new test and the existing deadmail tests pass, and the change is pushed to `main2` as `948afcf9ded`.

**What changed in `scripts/jobs/deadmail.sh`:**
- **Collision handling:** exit code 79 (`GARDEN_COMPLETED_COLLISION_RC`) no longer goes through the "WARN … failed (rc=79)" retry path. It sets a `collided` flag and goes on to the existing check-then-remove path, so removal still uses the same retry loop. The commit message for that case is `deadmail: retired <msgid> — <base> already completed`. If `verify_posted` can't find the job on origin, an info line is logged with no WARN and the entry is left for the next tick.
- **A second bug in the check:** `verify_posted` looked for completed jobs only at the old flat path `jobs/tada/<base>.md`. Completed jobs are now filed under dated folders (`jobs/tada/<yyyy>/<mm>/<dd>/`), so that lookup could never match. Without fixing this, the rc=79 change would have kept every collided entry forever. It now searches origin's dated folders with `tada_find_tree`. The todo/doin checks are unchanged.

**Tests:**
- **New test,** `scripts/jobs/test/deadmail-completed-collision-test.sh`, added to `.github/workflows/checks.yml`. It seeds one entry whose completed job is in a dated folder on origin and one whose job isn't. Over two ticks: the first entry is removed with the "retired" commit, the second is kept and retried, there are no WARN lines, and the exit code is 0.
- **Existing tests:** `deadmail-tempfail-short-circuit` (4/4) and `deadmail-schedule-carry-forward` (11/11) still pass.
- **shellcheck:** only info-level notes, all of which were already there.

**Follow-ups:**
- The seven stuck entries will clear on each host's first tick after this change is deployed, as long as their jobs are found in the dated folders.
- The end-of-tick "promoted N" count includes entries removed this way. That's harmless, but the number reads slightly high.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadmail-completed-collision.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (591064 cached reads)
- Output: 7017 tokens
- Cost: $0.7430168
- Wall-clock: 147s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
