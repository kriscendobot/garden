---
gate: orchestrated
orchestrated_by: minion-town-ci-runner-unblock-20261008
priority: high
posted_by: producer
posted_at: 2026-10-08T18:29:16Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
handler-timeout: 10800
priority: high
dispatch: automatic
---

# Land ci.minion.town (kriscendobot/minion.town#145), part 1: weave, fix, undraft

**HIGH PRIORITY (maintainer, liaison session 2026-10-08).** Since 2026-10-08 07:59Z, GitHub Actions has refused every hosted job on the kriscendobot account: "recent account payments have failed or your spending limit needs to be increased." The maintainer expects the block to last until the monthly billing reset at the end of October. It blocks every minion.town shepherd and merge. The self-hosted runner at `ci.minion.town` is the way out: it is **already deployed, online and idle** (`ci-minion-town-0fdb85b6-20261007T170100Z`). However, its workflow change (PR #145, still draft) never merged, so `main`'s `test.yml` still targets hosted runners. Operator page: `context/operations/ci-minion-town-runner.md`.

PR: https://github.com/kriscendobot/minion.town/pull/145 (head `ci-minion-town-runner`, base is the stale `main-c54f507`). Its gauntlet ended on 2026-10-03 at the review budget (`journal/jobs/tada/2026/10/03/build-ci-minion-town-actions-runner-gauntlet-panel-6.md`).

1. **Weave** the PR onto a fresh frozen snapshot of current `main`, resolving any conflicts. The PR's own `pull_request` CI uses the PR's workflow, so it should run on the self-hosted runner. Confirm in the job logs that it ran there (`Machine name: 'ci-minion-town'`).
2. **Apply panel round 6's must-fix items:**
   - **Required: root-owned files must not survive the between-jobs scrub** in `ci-runner-controller.sh`. That covers files in world-writable directories and stray `/tmp/systemd-private-*`. Docker jobs can create root-owned files, so this lets one job leave files behind for later jobs. Extend the selftest to cover it. Any controller change must also be redeployed to the host with `deploy-ci-runner-host.sh`, then run the selftest again.
   - Type the bare JSDoc `Function`.
   - List `minion/ci-runner-github-token` in DEPLOYMENT.md's table of secrets a maintainer must create by hand.
   - Post a comment mapping each change to its review item.
   - Skip the optional comment-only suggestions unless they are trivial.
3. Get CI green on the self-hosted runner, then **undraft**. Do not run another full six-round gauntlet; one confirming panel round is enough if you want it.

Out of scope: moving `deploy.yml` (CD) to the self-hosted runner. That stays a maintainer decision. Do not attach the runner to any public repository.

Done: #145 is ready for review on a current frozen base, with CI green on `ci.minion.town`.

<!-- garden-annotation: key=cc627e8c389f by=producer at=2026-10-08T18:30:07Z fields=priority=high -->

Maintainer 2026-10-08: high priority, billing block stops all minion.town shepherds.
