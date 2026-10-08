---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: minion-town-ci-runner-redeploy-50aa690-split
reposted_by: reaper:endolin-garden2-5bcdff64
reposted_at: 2026-10-08T21:33:48Z
---

# Deliberate overrun decomposition for `minion-town-ci-runner-redeploy-50aa690`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by minion-town-ci-runner-redeploy-50aa690-split`, then record `minion-town-ci-runner-redeploy-50aa690-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by minion-town-ci-runner-redeploy-50aa690-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS minion-town-ci-runner-redeploy-50aa690-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: minion-town-ci-runner-redeploy-50aa690-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
requires: aws
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Redeploy the ci.minion.town self-hosted runner to match kriscendobot/minion.town main @ 50aa690f87 (PR #145 merged; range 76bb27628e..50aa690f87, commits 9e1daaa..73746f4). This is the AWS half of `minion-town-ci-runner-deploy-verify-50aa690`, which was claimed on a host without AWS credentials and handed off here.

Evidence from the predecessor that the live runner is drifted:
- Runner names are `ci-minion-town-0fdb85b6`, with no `-YYYYMMDDTHHMMSSZ` stamp. The merged Lambda (`deploy/aws/ci-runner/lambda/index.mjs`, `name = PREFIX + label + '-' + stampOf(now())`) always appends one. So the deployed minter is older than afa1a2d, and its prune cannot recognize minter-owned names.
- The fix-5 and fix-6 gauntlet reports for build-ci-minion-town-actions-runner state that the live host still runs the old controller and minter.
- A baseline selftest on the old code, https://github.com/kriscendobot/minion.town/actions/runs/37833162084, had probe and verify green. That is a pre-redeploy baseline only.
- test.yml runs on main already land on `self-hosted,ci-minion-town`, so CI_RUNS_ON is unset or self-hosted. The oros-studio PAT gets a 403 on the variables and runners APIs.

Task (do not change the code; any defect found becomes a separate fix job):
1. Confirm that the Secrets Manager secret `minion/ci-runner-github-token` exists (`aws secretsmanager describe-secret`, never get-secret-value). If it is missing, stop and message the maintainer.
2. Compare the deployed Lambda `minion-town-ci-jit-minter` code (`aws lambda get-function`, download the zip and diff index.mjs) with the merged `deploy/aws/ci-runner/lambda/index.mjs`. If it differs, update it through the provisioner's documented path in DEPLOYMENT.md § CI runner. Do not re-provision the VPC or IAM. **Lambda first.**
3. Over SSM (recipe: minion.town DEPLOYMENT.md deployed-topology notes; instance tag Name=minion-town-ci, us-west-1), compare the host's ci-runner-controller.sh, bootstrap.sh and ci-runner.service with the merged `deploy/aws/ci-runner/host/`. If any differ, run `deploy/aws/ci-runner/deploy-ci-runner-host.sh`, then reboot the host so the snapshot-based scrub takes a fresh snapshot (per fix-6).
4. Dispatch `.github/workflows/ci-runner-selftest.yml` on main with fail=true (`gh workflow run ci-runner-selftest.yml -R kriscendobot/minion.town --ref main -f fail=true`). Confirm that verify finds none of the planted residue (/tmp/.X11-unix probe, systemd-private decoy, named volume, cron, /run/lock), that the `fail` job is red, and that the job log's Runner name now carries the minter's timestamp stamp.
5. With an identity that can read the variables and runners APIs, confirm CI_RUNS_ON is unset or self-hosted. Wait at least 10 minutes after the restart, then confirm that no orphaned or offline `ci-minion-town-*` registrations remain after the prune sweep.
Report to the maintainer (scripts/jobs/message-user.sh): in sync or redeployed, the selftest run URL, and any open operator item.
