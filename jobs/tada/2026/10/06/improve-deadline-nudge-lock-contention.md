The deadline-nudge timer no longer dies FATAL when another process holds its clone lock: it waits briefly, then skips the tick quietly and tries again next minute. The change is pushed to `main2` as `98952151bf2`, and the full `deadline-nudge-test.sh` suite passes, 59 of 59.

**What changed in `scripts/jobs/deadline-nudge.sh`**
- **Short wait instead of the 3×60s wait.** The clone stage (`:40`) and journal-sync stage (`:57`) now take the clone lock in the existing soft mode. It waits once, by default 5s (new knob `GARDEN_DEADLINE_NUDGE_LOCK_WAIT`, also checked as a positive integer). If the lock is still busy it exits with rc 75 (`GARDEN_OFFLINE_RC`), the same code an offline journal returns.
- **Busy lock skips the tick without retrying.** Both stages already skip the tick on rc 75 without using up their retry count. Their log line now reads "journal offline or clone lock busy". Real failures still go through the existing retry loops.
- **The lock retake after a sync is also soft.** After a successful sync the stage gives up the lock and immediately takes it back, and another process could slip in between. If that retake hits a busy lock, the tick now logs a plain "tick deferred" line rather than an ERROR or WARN. Other non-zero exits are still reported with full diagnostics.
- **Comment only in `common.sh`.** I added deadline-nudge to the list of callers that use soft locking.

**Tests:** two new cases in `scripts/jobs/test/deadline-nudge-test.sh` hold the lock from a live process, once with no existing clone and once with an existing one. Each checks that the run exits 0 within 30s, skips the tick, makes only one attempt, and logs no FATAL or ERROR. Shellcheck shows no new findings.

**Follow-ups:**
- With an existing clone, the clone stage is always the one that hits the busy lock, because it takes the lock even when the clone is already there. So no test directly covers the journal-sync stage or the retake after a sync. Those paths use the same soft-lock helper.
- The lock taken on the push-rejection path (`push_rejected`) still uses the full wait. That path is rare and is out of this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-lock-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1509292 cached reads)
- Output: 12717 tokens
- Cost: $1.2035664
- Wall-clock: 2084s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
