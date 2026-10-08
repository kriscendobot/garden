---
created: 2026-10-08
author: liaison
---

# Skill: minion-town-ci-runner-switch

Switch kriscendobot/minion.town's CI between GitHub-hosted runners and the
self-hosted ephemeral runner at `ci.minion.town`, in either direction, with one
repository variable. Use it when a GitHub Actions **billing block** stops
minion.town CI from starting, and again to switch back after the monthly billing
reset.

## Why only minion.town

The block is on the `kriscendobot` account: *"The job was not started because
recent account payments have failed or your spending limit needs to be
increased."* It hits kriscendobot's **private** repos once the month's
included hosted minutes are spent. In practice that means minion.town.
- **Public repos are not affected.** Hosted minutes are free there, so every
  kriscendobot fork keeps running.
- **endojs/endo-but-for-bots is not affected.** It is billed to the endojs org.

minion.town is not a fork, so there is no upstream to restore and nothing for
the [boatman](../../roles/boatman/AGENT.md) to compensate.

The block lifts by itself at the monthly billing reset. The maintainer changes
nothing:
- The 2026-09-30 block cleared at about 20Z that day.
- The 2026-10-08 block is expected to clear around 2026-10-30 or 31.

**Never attach the self-hosted runner to a public repository.** Its jobs have
root-equivalent docker access on the host. Operator detail:
[context/operations/ci-minion-town-runner.md](../../context/operations/ci-minion-town-runner.md).

## Inputs

- The `kriscendobot` gh identity (the fleet default). It needs repo admin to
  write Actions variables.
- That `test.yml` on the PR's base contains the `CI_RUNS_ON` switch
  (kriscendobot/minion.town#145):
  `runs-on: ${{ fromJSON(vars.CI_RUNS_ON || '["self-hosted","ci-minion-town"]') }}`.

## The switch

The repository variable `CI_RUNS_ON` decides where CI runs. When it is unset,
the workflow default sends jobs to the self-hosted runner.

| Target | Command |
| --- | --- |
| **GitHub-hosted** (normal months) | `gh variable set CI_RUNS_ON -R kriscendobot/minion.town --body '"ubuntu-latest"'` |
| **ci.minion.town** (during a billing block) | `gh variable delete CI_RUNS_ON -R kriscendobot/minion.town` |
| Read the current target | `gh variable list -R kriscendobot/minion.town` (absent = self-hosted) |

The variable is read when each run starts. So a flip applies at once to every
new run on every PR, whatever its frozen base. No re-pin is needed, as long as
that base already contains #145. A PR whose base predates #145 still has the
old hard-coded `runs-on`; weave it onto a base that includes #145.

## Procedure

### To ci.minion.town (a billing block has struck)

1. **Confirm the trigger.** Read the failed job's check-run annotations
   (`gh api repos/kriscendobot/minion.town/check-runs/<job-id>/annotations`) for
   the billing message. Rerun `--failed` once to rule out a transient block.
   `ci-wait-merge.sh` exits 5 on this, and a gauntlet parks as
   `parked-ci-billing`.
2. **Confirm the runner is up.**
   `gh api repos/kriscendobot/minion.town/actions/runners --jq '.runners[]|[.name,.status,.busy]'`
   should show one `ci-minion-town-*` runner, `online`. If not, restart it per
   the operator page. Do not flip CI onto a dead runner, or every job will
   queue forever.
3. **Flip.** `gh variable delete CI_RUNS_ON -R kriscendobot/minion.town`.
4. **Prove it.** Rerun one failed run (`gh run rerun <id> --failed`). The job
   log must show `Machine name: 'ci-minion-town'` and the run must get past
   runner allocation.
5. **Unpark.** Rerun the remaining billing-failed runs one at a time, because
   the runner serializes jobs. Resume parked gauntlets with
   `scripts/jobs/gauntlet.sh --resume-from-stage <g> <clean|fix> [--iteration N]`.
6. **Schedule the return.** Post a one-time switch-back job just after the
   expected reset:
   `scripts/jobs/set-schedule-once.sh minion-town-ci-runner-to-hosted-<YYYYMM> <ISO> minion-town-ci-runner-to-hosted-<YYYYMM> <body>`.
   The body names this skill and the "To GitHub-hosted" direction. Skip this
   step if such a schedule already exists in `journal/schedules/`.
7. **Tell the maintainer** in one line: which direction, when, and the proving
   run's URL.

### To GitHub-hosted (after the reset)

1. **Probe hosted runners first.** Flip with
   `gh variable set CI_RUNS_ON -R kriscendobot/minion.town --body '"ubuntu-latest"'`,
   then dispatch *ci-runner selftest*
   (`gh workflow run ci-runner-selftest.yml -R kriscendobot/minion.town`) or
   rerun a recent run.
2. **If a hosted job starts and passes,** leave it there and report.
3. **If it is still billing-refused,** the reset has not happened yet. Flip back
   (`gh variable delete CI_RUNS_ON …`), rerun anything the probe failed, and
   re-schedule this direction for a day later. Do not leave CI pointed at a
   blocked target.

Leave the `ci.minion.town` host running as a warm standby (about $35/month).
Tearing it down needs the maintainer.

## Notes

- **CD is separate.** `deploy.yml` always runs hosted, so during a block
  production deploys stay blocked whichever way `CI_RUNS_ON` points. Moving CD
  onto the runner would put the production deploy role on that host, and that
  is the maintainer's call.
- **The runner's GitHub credential stays broad on purpose.** It is the bot's
  gh OAuth token. The maintainer declined to narrow it to a fine-grained PAT
  (2026-10-08), because a PAT expires and would need human intervention to
  renew. Do not re-raise this as an outstanding item.
- **Capacity.** One `t3.large` spot instance runs one job at a time. The arm64
  harness takes about 13.5 of its 20 minutes, and CPU credits throttle after
  about 20 full CI runs a day. When throughput blocks the arc, say so. Scaling
  above $50/month needs maintainer approval.
- _2026-10-08_: written when the second billing block (from 07:59Z) stopped
  every minion.town shepherd while #145 was still an unmerged draft. Getting it
  landed is orchestration `minion-town-ci-runner-unblock-20261008`.
