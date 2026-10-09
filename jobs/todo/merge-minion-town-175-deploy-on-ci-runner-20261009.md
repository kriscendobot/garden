---
role: conductor
repo: kriscendobot/minion.town
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Merge kriscendobot/minion.town#175 and verify the main deploy runs on ci-minion-town

Successor of `build-minion-town-deploy-on-ci-runner-20261009`. PR https://github.com/kriscendobot/minion.town/pull/175 makes `deploy.yml` use `runs-on: fromJSON(vars.CI_RUNS_ON || '["self-hosted","ci-minion-town"]')` and adds an "Ensure AWS CLI" step. It is draft with the normal gauntlet staged. kriskowal authorized landing it (https://github.com/kriscendobot/garden/issues/58#issuecomment-6073808637). The minion.town delegation is PAUSED, so the conductor merges it, not the proxy screen.

1. Once the gauntlet un-drafts #175 (or the panel/fix-loop has nothing left that must be fixed), merge it into `main`. Its base is the frozen `main-39867df`; retarget or weave it onto `main` first if needed.
2. Confirm that the push-triggered `deploy.yml` run on main is picked up by a `ci-minion-town` runner and succeeds (`gh run list -R kriscendobot/minion.town -w deploy.yml`). If no run was triggered, dispatch one: `gh workflow run deploy.yml -R kriscendobot/minion.town`. If it fails on the runner (missing Docker for setup-qemu, unzip, or similar), fix that in a follow-up PR. #169/39867df must reach production.
3. Verify that the proxy screener (`scripts/jobs/screen-delegated-prs.sh`) resumed the paused minion.town delegation after the successful deploy.
4. Reply on https://github.com/kriscendobot/garden/issues/58 with the outcome: PR, deploy run URL, and the delegation state. Do not close the issue.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-6073808637
submitter: kriskowal
----- END ISSUE NOTE -----
