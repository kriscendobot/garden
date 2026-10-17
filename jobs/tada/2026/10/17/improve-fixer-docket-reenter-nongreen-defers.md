Fixed and pushed to main2 as `5b93a4d2ab5`. A fixer that finished its work no longer fails just because its PR's CI isn't green yet, and the re-entry now targets the job's own PR. Both affected test suites pass, along with two related ones.

**What was wrong:** after a fixer finished, `gardener.sh` re-entered the PR on the review docket and treated any nonzero result as a failure. `review-docket.sh` returned 3 whenever CI wasn't green, so a finished job was left in doin for the reaper to retry. On top of that, the PR it re-entered was simply the first URL in the report. In `fix-minion-town-pr180-ocap-key-audit-20261017` that was the docs-only draft #203, not #180.

**Changes:**
- **Deferral instead of failure (`review-docket.sh`):** when CI isn't green, re-entry now records a pending entry under `review-docket/pending-reenter/<slug>.json` and exits 0. If there's no earlier review request to inherit, it records nothing and exits 0. Repeating the same request does nothing new.
- **Applied when CI goes green (`review-docket.sh` reconcile):** the leader's periodic reconcile now also checks the pending entries. It creates the re-review request once CI is green, keeps waiting while it's red or pending, and drops the entry if the PR is merged or closed. Running reconcile for specific PRs only touches those PRs' entries.
- **Job outcome (`gardener.sh`):** rc 2 and 3 from re-entry are now logged as a deferral and the job completes normally. Only other nonzero codes still keep the job retryable. A fixer job that names no PR of its own skips re-entry.
- **Choosing the PR (`common.sh`, new `fixer_reentry_pr`):** it picks, in order:
  1. a PR named in both the job file and the report;
  2. otherwise the job file's first PR;
  3. otherwise, if the job name contains `pr<N>`, the single report PR with that number.

  If no PR can be attributed to the job, it picks none. Jobs carry no head-branch field, so matching is on the PR URL, not the branch.

**Tests:**
- `review-docket-test.sh` has new cases for parking on pending CI, repeated requests, nothing to inherit, waiting on red, applying on green, and dropping on merge.
- New `fixer-reentry-pr-test.sh` replays the #180/#203 incident and covers the fallbacks and the ambiguous case.
- Both pass, as do `assert-producer-pr-draft-test.sh` and `auto-gauntlet-handoff-test.sh`.

**Follow-ups:**
- The stuck job `fix-minion-town-pr180-ocap-key-audit-20261017` will complete cleanly on its next requeue, but only once this host's deployed root has picked up `5b93a4d2ab5`.
- A pending entry whose CI stays red keeps waiting indefinitely. Nothing expires it, and it doesn't appear in `PRIORITIES.md`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fixer-docket-reenter-nongreen-defers.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2137953 cached reads)
- Output: 17895 tokens
- Cost: $1.5663306000000001
- Wall-clock: 272s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
