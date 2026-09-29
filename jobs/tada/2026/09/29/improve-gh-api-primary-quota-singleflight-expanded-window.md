# Completion report: improve-gh-api-primary-quota-singleflight-expanded-window

Concurrent `gh_api_retry` callers now make exactly one request when the GitHub primary quota runs out, not one each. Pushed to `main2` as **6155bb901da** ("fix(gh-api): single-flight gh_api_retry admission under the cooldown lock").

**What changed** (`scripts/jobs/common.sh`)
- **Serialized admission:** `gh_api_retry` now takes the shared cooldown lock (`GARDEN_API_COOLDOWN_LOCK`) before each attempt. While holding it, it:
  1. re-checks the host-wide marker (and also the GraphQL marker for `graphql` calls);
  2. sends the request;
  3. on a primary-quota refusal, writes the one-hour latch (`api_primary_quota_secs`) before letting go of the lock.

  A REST refusal latches the host-wide marker; a GraphQL refusal latches only the GraphQL marker.
- **Refusal without a request:** when a latch is already live, the call returns rc 75 without running `gh` and logs `WARN: gh api <label> NOT ISSUED: host-shared gh-api cooldown live …`. Callers read that line as a transient failure, and as a primary-quota refusal when the latch came from one, so the comment source stops querying the rest of its tick.
- **Lock is held per attempt,** only while `gh` runs, never across a backoff sleep. The design is documented in a comment block above `_gh_api_admit`.
- **Deadlock safety:**
  - The lock uses a dynamically allocated fd, never fd 9, and the fd is closed in the `gh` child.
  - A `gh_api_retry` nested inside an admitted call skips the lock instead of waiting on its parent (via `_GARDEN_GH_API_ADMITTED`).
  - The lock wait is capped by the new setting `GARDEN_GH_API_ADMISSION_WAIT_SECS` (default 60s). After that the call goes ahead unserialized and logs a WARN.
- **Disable switch:** `GARDEN_API_COOLDOWN_SECS=0` skips the lock and the latch entirely, which is the old behavior.
- **Small helpers:** the bodies of `api_cooldown_active` and `start_api_cooldown` moved into two helpers that assume the lock is already held (`_api_cooldown_live_locked`, `_api_cooldown_record_locked`). This is how `gh_api_retry` can write the latch without taking the lock a second time. No callers were changed.
- **Watchers keep their single warning:** a latch written by `gh_api_retry` (tag `gh-api:…`) is taken over by the first watcher whose `start_api_cooldown` reports it. That watcher gets rc 0 and logs the one outage WARN; the expiry is never extended, and later watchers remain observers. Without this, the issue-inbox watcher had gone silent in its test.

**Tests**
- **`gh-api-retry-test.sh`** (60/60 pass; new SUBTEST 4):
  - six concurrent callers against the primary-quota stub make exactly one `gh` request, latch the marker, and the other five are refused with rc 75 and the NOT ISSUED line;
  - GraphQL and REST latches are kept separate;
  - the disable switch gives four requests and no latch;
  - the lock is released during a backoff sleep;
  - a nested call does not deadlock;
  - the capped lock wait falls through as designed.

  The suite now keeps its latches in a private directory, and the stub gained an optional `GH_STUB_SLEEP` so callers really overlap. Against the old `common.sh` the concurrent case made 6 requests and 8 checks failed.
- **`api-cooldown-test.sh`** (22/22 pass): new checks for the takeover rule.
- **`mirror-closer-test.sh`:** its section-J quota case now uses its own cooldown directory; otherwise the new latch refused the later cases' reads.
- **Also passing:** ci-watcher, comment-latency-watch, issue-inbox-watcher, issue-inbox-tick-bounds and dependabot-watcher tests.
- **Failing before and after this change:**
  - `receipt-watcher-test.sh` fails the same 2 checks on the unchanged baseline.
  - `comment-watcher-test.sh` case BQ ("quote-reply did NOT dispatch") fails some runs and passes others, both with and without this change. That suite disables the cooldown throughout, so the new code never runs there.

CLAUDE.md is unchanged: the latency-watch paragraph is still accurate.

**Follow-ups**
- **Behavior change to note:** while any shared latch is live, including the short 300s window for a transient 5xx, every `gh_api_retry` caller on the host now fails fast with rc 75 instead of trying. That includes gardener jobs, not just watchers. This is what the job asked for, but it could interrupt a job's work for up to 5 minutes after a brief GitHub outage.
- **Throughput:** `gh_api_retry` requests on one host now run one at a time. If contention shows up, the capped wait falls back to issuing requests unserialized.
- **Not covered yet:** `gh_pr_view_retry` (GraphQL through `gh pr view`) still has no admission check. Also, the ci-watcher's primary-quota latch tag (`ci:$slug:source`) lacks "primary-quota", so a call refused behind it is logged as transient rather than primary.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gh-api-primary-quota-singleflight-expanded-window.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3727474 cached reads)
- Output: 39767 tokens
- Cost: $2.5578508
- Wall-clock: 3427s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
