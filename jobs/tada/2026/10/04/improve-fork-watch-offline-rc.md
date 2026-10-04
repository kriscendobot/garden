**Completion report: improve-fork-watch-offline-rc**

The fork-watch provisioner now treats a silent rc=75 probe as a quiet host-wide outage instead of an `unclassified` failure. The fix is pushed to `main2` as `152cf11291c`, and the provisioner test suite passes (97 passed, 0 failed).

**Cause.** `gh_api_retry` returns `GARDEN_OFFLINE_RC` (75) with no output to every caller after the first one that hits a live host-shared gh-api cooldown. The first caller has already logged the warning. The provisioner treated that silent 75 as `unclassified`: it raised the escalating silent backoff and logged a misleading WARN. That is what happened at 2026-10-04T00:41:52Z, when all 15 forks were deferred.

**Changes in `scripts/jobs/fork-watch-provisioner.sh`:**
- A probe that returns `${GARDEN_OFFLINE_RC}` with output that matches no known failure type is now classed `offline`. That class is host-wide, so probing stops for the rest of the tick.
- When there is no output at all, it is treated as quiet:
  - It opens a fixed cooldown of the base length (default 300s, set by `GARDEN_FORKWATCH_INCONCLUSIVE_COOLDOWN_SECS`).
  - It does not advance the silent-failure escalation level.
  - It logs no WARN, only one informational line when the cooldown opens ("upstream checks temporarily unavailable (rc=75…)").
  - While the cooldown is live, later ticks skip probing and log nothing (existing behaviour).
- Deferral still fails open: a deferred fork is never armed, tombstoned or retired.
- The test hook `GARDEN_FORKWATCH_UPSTREAM_CHECK` now also treats rc 75 as inconclusive, so tests can drive this case.

**Tests in `scripts/jobs/test/fork-watch-provisioner-test.sh`:**
- **New section O** uses a stub that returns rc 75 silently and checks that:
  - only one fork is probed;
  - the cooldown is recorded as `offline`, not `unclassified`;
  - the window is the base length and escalation is untouched;
  - no WARN is logged, only the one informational line;
  - a live window defers quietly with no probe;
  - after the window expires, it retries once and reopens at the same base length (no doubling);
  - forks are left unchanged;
  - probing resumes normally once the outage clears.
- **Separate fix to the suite:** 13 assertions in sections G–L were already failing at unmodified HEAD in this environment. The fleet git wrapper skips fetches it considers recent, so the test read stale data from its own test journal. The suite now exports `GARDEN_FETCH_MAX_AGE_OVERRIDE=0`, and all 97 assertions pass.

shellcheck (warning level) and `bash -n` are clean.

**Follow-ups:** none required. A silent 75 doesn't distinguish a primary-quota cooldown from a shorter one, so the fixed base window can delay probing slightly after a short cooldown clears. That's within the job's "bounded retry" requirement.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fork-watch-offline-rc.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1173823 cached reads)
- Output: 11710 tokens
- Cost: $1.0677325999999998
- Wall-clock: 294s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
