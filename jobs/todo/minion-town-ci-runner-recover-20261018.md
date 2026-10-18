---
role: gardener
requires: aws
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Recover the kriscendobot/minion.town self-hosted CI runner (ci-minion-town)

As of 2026-10-18T05:40Z, six minion.town Actions runs labeled
`self-hosted,ci-minion-town` have been queued with no runner picking them up.
The oldest is from 2026-10-18T02:41Z, on feat/guest-coupons, and PR #197
(feat/clip-live-frame) has been queued since 02:44Z. That blocks every
minion.town gauntlet. The reporting host (oros-studio) has no AWS credentials
and its PAT gets a 403 on the runners API.

Follow context/operations/ci-minion-town-runner.md § Operate:
1. Check the runners list.
2. Find the `minion-town-ci` instance in us-west-1. Spot reclamation is likely.
3. Over SSM, run `systemctl restart ci-runner`, or reboot or re-converge with
   `deploy/aws/ci-runner/deploy-ci-runner-host.sh`.
4. Confirm the queued runs start.

Report the root cause.
