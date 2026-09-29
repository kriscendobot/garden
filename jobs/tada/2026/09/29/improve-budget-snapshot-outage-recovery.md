## Completion report: improve-budget-snapshot-outage-recovery

When a budget snapshot outage lasts longer than the snapshot max-age, the scaler now re-clones the journal and retries publication once. If that retry fails, the maintainer gets a single alert. Worker reconciliation still proceeds whether or not publication works. Pushed to `main2` as `f0628be5ae3`.

**The problem.** The bounded CAS retry and every later scaler tick all used the same journal clone. When that clone was wedged, each tick failed the same way while the outage latch hid the repeats, so the leader's copy of this host's snapshot silently went stale. This matches the 21:01:05 CAS warning followed by the 21:20:11 stale remote snapshot.

**What changed:**
- **`scripts/jobs/usage-meter.sh`** has a new `budget_publish_outage_recover <clone>`. It runs only when an outage is open and older than `GARDEN_BUDGET_SNAPSHOT_MAX_AGE` (default 1800s), and only once per outage.
  - It records the attempt in a `recloned` marker inside the latch before trying, so a killed or offline attempt is not repeated every tick.
  - It builds a fresh clone in a sibling directory with `reclone_clone`, under `clone_lock`, and swaps it in only if the clone succeeds. A failed re-clone therefore leaves the old clone in place for worker reconciliation.
  - It then runs `ensure_clone` and one publication attempt (`GARDEN_BUDGET_PUBLISH_ATTEMPTS=1`), all inside a subshell so an offline or fatal exit can't kill the scaler.
  - If the retry fails, it sends one maintainer alert through `alert_maintainer_edge` (key `budget-publish-stale-$GARDEN`).
- **`budget_publish_note_success`** now clears that alert, which sends one recovery notice.
- **`scripts/jobs/gardener-scaler.sh`** calls the recovery after `budget_publish_note_failure`, and calls `note_success` if the retry publishes.

**Tests.** The new `scripts/jobs/test/budget-snapshot-outage-reclone-test.sh` covers four cases, and it passes:
- An outage younger than the max-age does not re-clone.
- An outage past the max-age replaces the wedged clone, publishes, and leaks no temp directories.
- A real outage re-clones exactly once, alerts exactly once, keeps the clone, and the alert clears on recovery.
- When the journal is unreachable, the old clone is left intact.

The existing `budget-snapshot-warning-dedup`, `budget-snapshot-publish-retry` and `budget-live-percent-label` tests still pass. `live-budget-admission-test.sh` fails 5 of 58 checks, but it fails the same 5 on the untouched `HEAD` baseline. Those failures are in admission and leveling verdicts, which this change doesn't touch.

**Follow-up:** someone should look at why `live-budget-admission-test.sh` is failing those 5 checks on `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-snapshot-outage-recovery.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (993898 cached reads)
- Output: 13191 tokens
- Cost: $1.0573996
- Wall-clock: 194s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
