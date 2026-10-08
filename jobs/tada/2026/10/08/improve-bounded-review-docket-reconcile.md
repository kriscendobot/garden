The periodic docket reconcile is now bounded, so one slow or large docket can no longer push it past its 900s limit. The change is pushed to `main2` as commit `533aa541403`. The review-docket, approval-reconciler (27/27) and review-queue-docket tests all pass. It has not yet run against the live docket; the deliberate deploy will pick it up.

**What changed in `scripts/jobs/review-docket.sh`:**
- **Batch limit:** a plain `reconcile` checks at most 25 open PRs per run (`GARDEN_REVIEW_DOCKET_RECONCILE_BATCH`). It used to fetch every open PR in turn.
- **Resumable cursor:** each run starts after the last PR the previous run reached, and wraps around at the end of the list. The cursor is a file on the leader host (`GARDEN_REVIEW_DOCKET_CURSOR`, default `$GARDEN_STATE/review-docket/reconcile-cursor`). It only moves after a run commits or finds nothing to change, so a run that dies just redoes its batch.
- **Per-request timeout:** each GitHub metadata fetch gets at most 45s (`GARDEN_REVIEW_DOCKET_METADATA_TIMEOUT`), cut shorter if the run's time is nearly spent. A PR that times out is logged and skipped until a later run. The rest of the batch carries on.
- **Run deadline:** fetching stops 600s after the script starts (`GARDEN_REVIEW_DOCKET_RECONCILE_BUDGET`). That count includes any wait for the lock and leaves about 300s of the 900s unit limit for rendering and pushing.
- **No refetch on retry:** fetched results, failures included, are kept for the whole run. When a push loses the race to another writer and the update is redone, nothing is fetched again.
- **Targeted form:** `reconcile <PR-URL>...` reconciles only the PRs named and leaves the cursor alone.

**Other changes:**
- `scripts/jobs/approval-reconciler.sh` now runs `reconcile` for just the approved PR. Before, each approval it detected set off a full sweep of the docket.
- `scripts/jobs/test/review-docket-test.sh` has new cases for the batch limit, resuming and wrapping from the cursor, a slow request being killed without stopping the batch, a spent deadline (no fetches, cursor unchanged), and the targeted form.

**Side effect, now cleaned up:** my first test run wrote a test cursor (`example-repo-pr7`) into the live host state at `/home/kris/garden2/.garden-state/review-docket/reconcile-cursor`. I deleted it before any real reconcile ran this code. The tests now write their cursor in a temporary directory, and I confirmed nothing is left in the host state.

**Possible follow-up:** fetches still happen while the docket's shared lock is held, so other producers adding review requests can wait up to the 600s deadline. Fetching outside the lock would remove that wait.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-bounded-review-docket-reconcile.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1269012 cached reads)
- Output: 13847 tokens
- Cost: $1.1033344
- Wall-clock: 195s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
