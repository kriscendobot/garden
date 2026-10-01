I fixed `ci-wait-merge.sh` so it looks only at the newest run of each check. A stale cancelled run on an otherwise-green commit no longer reads as red. The change is pushed to `main2` as `697976e718f`.

The job named `scripts/jobs/ci-wait-merge.sh`, but the script is actually at `scripts/jobs/gardening/ci-wait-merge.sh`.

**Change** (`scripts/jobs/gardening/ci-wait-merge.sh`):
- A new jq helper, `latest_checks`, groups the check list by check identity (workflow plus name for a check run, the context for a commit status) and keeps one entry per group.
- **Which entry wins:** a run that is still queued or in progress counts as newest, because a queued rerun reports a zero start time. Otherwise start time, then finish time, then the Actions job id decide. Checks stay in their original order, so the billing message still lists check names the same way.
- **Where it applies:** every place that judges CI now uses it. That covers the failed, pending and total counts, the "red:" failure listing, and the account-billing check (a stale cancelled job can no longer push a billing-blocked result to an ordinary red, or the reverse).
- The ratchet-mode format check still validates every entry, as before.

**Tests** (`scripts/jobs/test/ci-wait-merge-test.sh`):
- T33: a stale CANCELLED run plus a green rerun of the same check → merges. It fails on the old script, so it reproduces the bug.
- T34: a stale green run plus a red rerun → exit 3, no merge.
- T35: a stale red run plus a still-queued rerun → keeps waiting and times out with exit 4, no merge.
- The suite ends at 80 passed, 2 failed. Both failures are T8 (the fallback to the `gh` on PATH when the configured path has vanished). T8 fails the same way on unmodified `main2`, so it is caused by this host's PATH `gh`, not by this change.
- shellcheck reports only the info-level SC1091 notice for the existing `source` line.

**Follow-up:** T8 failing on this host may be worth a look on its own.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (690310 cached reads)
- Output: 7587 tokens
- Cost: $0.7963379999999999
- Wall-clock: 100s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
