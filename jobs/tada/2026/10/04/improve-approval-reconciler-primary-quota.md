The fix is pushed to `main2` as `f3d058dd65e`. When the shared PR source reports GitHub's primary hourly quota is used up, `approval-reconciler.sh` now pauses GitHub API calls for the full quota window instead of 300s.

**What changed**
- **`scripts/jobs/approval-reconciler.sh`:** before the generic transient check (formerly line 530), a source failure is now tested with `is_gh_primary_rate_limit_text`. On a match it starts the host-wide cooldown, tagged `approval:<slug>:source`, for `api_primary_quota_secs`. It logs "PR source hit GitHub primary REST quota exhaustion" and exits 0. This matches how `ci-watcher.sh` and `dependabot-watcher.sh` already handle it. Before, this 403 also matched the transient check, so it got the 300s default and the next tick retried a call that would fail again within the same quota hour.
- **`scripts/jobs/test/approval-reconciler-test.sh`:** new case T. A stub source emits the shared source's (`ci-pr-source-gh.sh`) primary-quota 403 text. The case checks that:
  - the reconciler exits 0;
  - it logs the primary-quota warning, not the transient one;
  - the host-wide cooldown runs for the full 3600s window and carries the source tag;
  - no job is posted;
  - a later tick 600s into the window skips without calling the source.

  It points `GARDEN_ROOT` at a test directory so the cooldown file is never written to the live root.

**Verification**
- The test suite passes 27/27 with the fix.
- With the old reconciler swapped back in, case T fails 4 checks and shows the original misleading "transient gh-api blip … 300s" message, so the test does catch this bug.
- `bash -n` is clean.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-approval-reconciler-primary-quota.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (704546 cached reads)
- Output: 6105 tokens
- Cost: $0.7784332
- Wall-clock: 136s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
