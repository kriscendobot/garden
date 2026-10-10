## Completion report: improve-self-deploy-deferred-status-retry

Self-deploy now retries the deferred-status publish within the tick, and if every attempt fails it saves the status locally and republishes it on the next tick. The rolling-deploy test suite passes with the new cases, 119 passed and 0 failed. Pushed to `main2` as `cdec66ef8c0`. That test run was on the commit before it was rebased onto `origin/main2`; I did not re-run it after the rebase.

**Root cause.** `publish_fleet_health` (in `common.sh`) does retry when the journal push loses a race. But when its journal sync (the fetch) fails, it gives up straight away. So a single transient fetch failure produced the "could not publish the deferred status" warnings seen at 16:56Z and 16:59Z on 2026-10-07, and the leader never learned the canary was deferring.

**What changed in `scripts/jobs/self-deploy.sh`:**
- **Bounded retry:** a new `publish_deferred_status` tries the publish up to `GARDEN_SELF_DEPLOY_PUBLISH_ATTEMPTS` times. That setting defaults to 3 and is defined in `common.sh`. Each attempt runs a fresh journal sync, with the standard `backoff` wait between attempts.
- **Pending marker:** if every attempt fails, it writes `$STATE/deferral-pending` (the target sha plus the status fields). The rate limit on republishing a continuing deferral is skipped while this marker exists.
- **Next-tick republish:** a new `republish_pending_deferral` runs at the start of every tick, before any early exit (no upgrade-ready, not yet settled, drained, and so on).
  - If the deferral record is still there, it republishes the saved status.
  - If the record is gone, it drops the marker without publishing. `deploy-garden.sh` removes that record at the start of every run, so this keeps a stale "deferred" from overwriting a deploy that has since landed.
- **Placement:** `now`, `pub_file` and `pending_file` are now set near the top of the script so this early step can use them.

**Tests (`scripts/jobs/test/rolling-deploy-test.sh`, "PUBLISH RETRY").** They use the existing `GARDEN_FETCH_CMD` hook to make only the producer clone's fetches fail:
- One fetch failure followed by a success: the status lands in the same tick and no marker is left behind.
- Every attempt fails: the marker is written and the warning is logged.
- The next tick, with upgrade-ready removed so it exits early, still republishes the saved status and does not start another deploy.
- A marker whose deferral has ended is dropped and never published.

**Follow-ups:** none needed. The fix takes effect on each host at its next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-self-deploy-deferred-status-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1235455 cached reads)
- Output: 15368 tokens
- Cost: $1.2073550000000002
- Wall-clock: 240s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
