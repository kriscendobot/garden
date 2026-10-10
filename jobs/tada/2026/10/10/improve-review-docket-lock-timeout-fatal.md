I made the review-docket lock timeout non-fatal and added holder diagnostics. It's pushed to main2 as 44bfcbe6dbf. `scripts/jobs/test/review-docket-test.sh` passes with the new cases. Three other docket-related tests also pass, and shellcheck is clean.

**What I didn't find:** I could not identify what held the lock at 03:51:51Z. The incident left no record, so from now on the timeout message records the holder. One guess, not checked: under the old code the process holding the lock was the one running git, so any git child that outlived it would have kept the lock held. The new code no longer passes the lock to the git work.

**What changed**
- **Who holds the lock:** after taking the transaction lock, the process writes its PID, operation, target and start time to a sidecar file, `transaction.lock.holder`, and removes it on exit. If a waiter times out, its message gives how long it waited and the limit, that holder record and whether that process is still alive, the holder PID and command line from `/proc/locks`, and how many others are waiting. It logs as `WARN`, not `FATAL`.
- **No more dropped intake:** if `upsert`, `reenter`, `retire-review`, `retire-terminal` or a `reconcile` naming specific PRs can't finish in time, it is saved to a spool directory on this host (`$GARDEN_STATE/review-docket/spool/`) and the command exits **76**. For `upsert` the request body is saved too, because the caller deletes its temp file. Repeats of the same call are stored once. A plain `reconcile` or `render` just skips that run and exits 75.
- **Drain:** the next transaction on the host replays the spool oldest-first before its own operation, at most 10 entries and half the time window. Each entry runs with its original timestamp. An entry that fails 20 times moves to `spool/dead/` and logs an `ALERT`.
- **Hung push can't hold the lock:** the commit-and-push work now runs in a child process that is killed when the 180s window ends, and the drain counts against the same window. Each push also has a 60s limit, set through a new optional `GARDEN_PUSH_TIMEOUT` in `common.sh`; no other caller sets it, so nothing else changes.

A plain `timeout` around the push would not have worked. The fleet's `bin/git` wrapper runs every git command under its own 120s timeout in a separate process group, which an outer `timeout` never signals. In testing, the "killed" push survived and kept the next transaction waiting about 26s. So the child runs in its own session and the whole session is killed at the deadline, and the push limit is also passed down to the wrapper. The tests confirm no push process outlives its transaction.

**New tests:** a held lock produces exit 76 with a message naming the holder and wait time, no `FATAL`, and one deduplicated spool entry. A plain `reconcile` exits 75 without spooling. The next `render` drains the spool and the record lands in the journal. A server-side hook that hangs every push gives at least two time-limited attempts, a kill at the window, a spooled operation and no leftover push processes; the saved request is applied on the next run.

**Follow-ups (not done)**
- I left the callers unchanged. They treat 76 like any other failure and retry, which is safe because replaying the spool twice changes nothing. One side effect: `comment-watcher.sh` will still log "REVIEW-DOCKET RETIRE LOST" for a call that was actually spooled. Changing that log line is optional.
- A spool only drains when that host runs another docket transaction. The leader's reconcile timer covers it there, but on other hosts it relies on the caller retrying, as `gardener.sh` does for `reenter`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-review-docket-lock-timeout-fatal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (5034077 cached reads)
- Output: 36416 tokens
- Cost: $2.7208954000000003
- Wall-clock: 1126s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
