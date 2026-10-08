---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-08T21:41:29Z cleared=none -->

---
requires: aws
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Synchronize and, if needed, reboot the ci.minion.town runner host

This is the second operational slice of
`minion-town-ci-runner-redeploy-50aa690-split`. The serial orchestration runs it
only after `minion-town-ci-runner-lambda-sync-50aa690` succeeds, preserving the
required Lambda-first order. Work against `kriscendobot/minion.town` main at
exactly `50aa690f87`. Do not change project code.

1. Read `DEPLOYMENT.md` CI-runner and deployed-topology instructions.
2. Locate the `us-west-1` EC2 instance tagged `Name=minion-town-ci`. Use the
   documented SSM procedure to compare the deployed
   `ci-runner-controller.sh`, `bootstrap.sh`, and `ci-runner.service` with
   `deploy/aws/ci-runner/host/` at the target commit.
3. If any file differs, run
   `deploy/aws/ci-runner/deploy-ci-runner-host.sh` through its documented path,
   then reboot the host so the snapshot-based scrub captures a fresh snapshot,
   as required by fix-6. Do not re-provision the VPC or IAM.
4. If all files already match, do not perform an unnecessary deployment or
   reboot. Record that disposition.
5. Report the instance identity, exact file-comparison evidence, whether a
   deployment/reboot occurred, and the observed reboot/boot time needed by the
   validation successor.

If the required host state is not achieved after all in-scope attempts, end the
report with these exact lines:

`<<<GARDEN-ORCHESTRATION-FAILED>>>`
`<<<GARDEN-JOB-COMPLETE>>>`
