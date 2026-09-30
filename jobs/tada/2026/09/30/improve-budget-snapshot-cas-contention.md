Budget snapshot publication is now staggered by host within each snapshot bucket, so hosts no longer all push to the journal on the same tick. Commit `cfc49a7a0f3` is pushed to `main2`. The updated publisher test and three of the four related budget tests pass; `live-budget-admission-test.sh` still shows 5 failures, which also occur on the tree without this change.

**What changed** (`scripts/jobs/usage-meter.sh`)
- **Offset:** each host publishes at a fixed offset inside the bucket, computed from its `GARDEN` identity with `cksum` and taken modulo W. The offset is the same every bucket, so a host's samples stay one cadence (900s) apart. All of a host's pools publish together.
- **Stagger width W:** by default W is a third of the cadence (300s). It is capped at half of the room between the cadence and the 1800s maximum age, and kept below the cadence. `GARDEN_BUDGET_SNAPSHOT_STAGGER_SECS` overrides W; setting it to 0 restores the old behaviour of publishing on the bucket boundary.
- **Maximum-age guarantee:** a host publishes immediately, without waiting for its offset, if it has no earlier sample or if its last sample is already older than cadence + W (a missed bucket). So the gap between samples stays within cadence + W plus one scaler tick, which is inside the 1800s maximum age. The check runs in both the current and the legacy publish paths.
- **Retries:** the bounded retry logic (`budget_publish_local_pool`) is unchanged. A host whose push fails keeps retrying on every later tick of the same bucket.

**Tests**
- `budget-snapshot-publish-retry-test.sh` has a new contention section with five hosts, including the two real fleet host names, sharing one bare journal. On each simulated one-minute tick every host syncs first and then publishes with no retry, so they genuinely race.
  - With staggering off, it reproduces the boundary collisions: at least 4 lost pushes.
  - With the default stagger, over two buckets each host publishes exactly on its own slot, no push is lost, and every gap between samples is at most cadence + W.
  - It also checks that offsets are deterministic and fall within [0, W), that W is capped as described, that a stagger of 0 turns it off, and that an overdue host publishes right away.
  - The existing second-bucket case now moves the clock to the host's own slot.
- `subscription-used-percent-per-subscription-test.sh` isn't about staggering, so its one publish call now sets the stagger to 0.
- `budget-live-percent-label`, `budget-snapshot-outage-reclone`, the publisher test and `subscription-used-percent-per-subscription` pass. `shellcheck -S warning` reports nothing on the changed files.

**Follow-ups**
- The 5 `live-budget-admission-test.sh` failures need their own job.
- Offsets are spread over five one-minute slots. With more than five hosts, some will share a slot, so contention is reduced rather than eliminated.
- After an outage that hits the whole fleet, every host is overdue and publishes on the same first tick. Contention then falls back to the existing bounded retry until the offsets take over again in the next bucket.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-snapshot-cas-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1153158 cached reads)
- Output: 16765 tokens
- Cost: $1.1488036
- Wall-clock: 343s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
