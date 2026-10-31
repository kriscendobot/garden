**Completion report: improve-latency-mid-sweep-rest-reserve**

The latency sweep now rechecks the shared REST cooldown and the reserve before each new source, not only once at the start. If either one trips partway through, it stops quietly with a cooldown heartbeat. The fix is pushed to `main2` as `b2c786b2687`, and the tests pass.

**Changes in `scripts/jobs/comment-latency-watch.sh`:**
- **New `source_gate` check.** It runs before every source after the first; the first is already covered by the start-of-tick checks. It covers the armed comment repos, the issue inbox and the GitHub-wide mentions source.
  - A live shared REST cooldown (`api_cooldown_active rest`) sets `SHARED_COOLDOWN_HIT`.
  - A reached reserve (`gh_rest_budget_defer comment-latency-watch`) sets a new `BUDGET_DEFER_HIT` flag.
  - Either one stops the sweep.
- **Stopping.** `sweep_stopped` now also checks `BUDGET_DEFER_HIT`. When the sweep stops mid-way, the script writes a `cooldown` heartbeat and exits 0. It adds no warning, does not arm or extend the latch, and sends no notices. The remaining quota is left for the acknowledgment watchers. `gh_rest_budget_defer` already logs its own line once per quota window.
- **Test hook.** `GARDEN_COMMENT_LATENCY_SOURCE` now accepts a colon-separated list of handlers, and each one goes through the same gate as the real sources. A single handler behaves exactly as before.

**Tests in `scripts/jobs/test/comment-latency-watch-test.sh`:**
- **Shared cooldown:** a first source latches the cooldown, and the second source is never called. The heartbeat is `cooldown`, with no warning and no notices.
- **Reserve:** a first source drops the REST budget to 300/5000, below the 10% reserve. The second source is never called, the deferral is logged, and the heartbeat is `cooldown`.
- **Control:** with budget to spare, both sources run and the heartbeat is `full-poll`.

I also turned off each half of the gate in turn, and the matching new test failed each time. `comment-latency-watch-test.sh` and `gh-rest-budget-test.sh` (41/41) pass, and shellcheck shows no warnings.

**Follow-up (not done):** after collection, the per-row checks — reaction lookups and the issue open-state check — also make REST calls, and they still don't recheck the reserve. If quota exhaustion shows up during that phase, the same gate could go there.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-latency-mid-sweep-rest-reserve.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (780007 cached reads)
- Output: 11197 tokens
- Cost: $0.9367893999999999
- Wall-clock: 183s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
