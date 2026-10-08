---
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-08T21:45:46Z cleared=none -->

---
requires: aws
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
---

# Validate the redeployed ci.minion.town self-hosted runner

This is the final validation and maintainer-reporting slice of
`minion-town-ci-runner-redeploy-50aa690-split`. The serial orchestration runs it
only after the Lambda and host synchronization children succeed. Validate
`kriscendobot/minion.town` main at `50aa690f87`. Do not change project code.

Use fresh AWS and GitHub observations rather than trusting predecessor prose.
The old runner name `ci-minion-town-0fdb85b6` has no timestamp suffix and is
known pre-deployment drift. A prior pre-redeploy baseline selftest was
https://github.com/kriscendobot/minion.town/actions/runs/37833162084.

1. Determine whether the host was rebooted by the preceding deployment and its
   boot/restart time. Do not begin the post-restart registration conclusion until
   at least ten minutes have elapsed after that restart. If the host was already
   in sync and not rebooted, confirm its current boot is already older than ten
   minutes.
2. Dispatch `.github/workflows/ci-runner-selftest.yml` on `main` with
   `fail=true` using:
   `gh workflow run ci-runner-selftest.yml -R kriscendobot/minion.town --ref main -f fail=true`.
   Identify the exact dispatched run and wait in the foreground for it.
3. Confirm from the run jobs and logs that the intentional `fail` job is red;
   verify finds none of the planted residue (`/tmp/.X11-unix` probe,
   systemd-private decoy, named volume, cron, or `/run/lock`); and the job log's
   Runner name has the minter-owned timestamp suffix
   `-YYYYMMDDTHHMMSSZ`. Record the run URL and evidence.
4. With an identity that can read repository Actions variables and runners APIs,
   confirm `CI_RUNS_ON` is unset or selects the self-hosted runner. After the
   ten-minute prune window, confirm no orphaned or offline
   `ci-minion-town-*` registrations remain.
5. On success, notify the maintainer through
   `scripts/jobs/message-user.sh minion-town-ci-runner-redeploy-verify-50aa690`
   with: whether the Lambda and host were in sync or redeployed, the selftest run
   URL, the runner/prune conclusions, and any open operator item. Use fresh
   `origin/journal2` reports for the predecessor dispositions if needed.

If every fleet-accessible check is complete and the only remainder needs
interactive maintainer login or MFA, do not send a duplicate auth notice. State
the completed evidence and needed operator action in the report, then end with:

`<<<GARDEN-ORCHESTRATION-AUTH-UNAVAILABLE>>>`
`<<<GARDEN-JOB-COMPLETE>>>`

For any other failure to achieve the required validation outcome, notify the
maintainer with the run URL and open operator item, then end with:

`<<<GARDEN-ORCHESTRATION-FAILED>>>`
`<<<GARDEN-JOB-COMPLETE>>>`
