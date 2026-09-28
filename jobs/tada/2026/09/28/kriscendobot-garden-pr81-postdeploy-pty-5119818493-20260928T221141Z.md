---
handed-off: kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T210602Z
deliverable-complete: false
---
I handed this attempt off to the agreed owner, `kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T210602Z`. The pty lane has not been validated yet: the one test job ran on a host without the PR #81 merge, so it failed.

**Deployment check:**
- PR https://github.com/kriscendobot/garden/pull/81 is MERGED as `4767705b28d522b591eddbd3b47976273c5e1853`.
- This host (`endolin-garden-ece02cb4`, the leader) is still deployed at `e036bb8e0650b66a4ae00dc1516c4c8df39901ca`.
- `git merge-base --is-ancestor` shows the merge is **not** in that SHA. `pty-context-test.sh` and `pty-context-read.sh` are missing from the deployed root.
- A rolling deploy to `894f2675` is in progress. The follower `oros-studio` is in the roll now, and the leader deploys last.

**Board state:**
- About 7 copies of this task are running, spread across oros, garden2 and this host. The peers have agreed that `...-20260928T210602Z` (in `doin/` on endolin-garden2) is the only one that watches the test job and posts the one report comment on PR #81.
- The test job `kriscendobot-garden-pr81-pty-lane-test-5119818493` was already posted from garden2 and is now in `jobs/tada/` with `orchestration-failed: true`. It failed because **this** undeployed host claimed it, not because of the lane code:
  - The deployed code has no pty branch, so it ignored `lane: pty` and ran as ordinary headless `claude -p` (`GARDEN_PTY_LANE` was empty).
  - Checks A1, A3 and A4 failed because the deployed files were absent.
  - The `main2` copy of `pty-context-test.sh` passed 16 tests with 0 failures.
- As of 23:34Z nobody has posted the report comment on PR #81.

**What I did:**
- I did not post a test job, post a PR comment or schedule a successor. Another successor would only add to the pile of copies and keep a worker slot busy, which slows the drained deploy.
- I sent the owner the failure diagnosis, message `20260928T233441Z-1f1643`. It says a real re-test needs a fresh basename and must be claimed on a deployed host.

**Follow-ups for the maintainer:**
- **Re-test:** the deployed `claim-job.sh` cannot pin a job to a host, so re-post the test with a fresh basename only once every host has the merge, or add host pinning.
- **Silent fallback:** a `lane:` value on a host without PR #81 quietly runs headless; it should warn or refuse.
- **Leftover copies:** the task copies still in `todo/` or `plan/` can be removed: `garden-pr81-postdeploy-pty-20260928T221312Z` (todo) and `...-5119818493-20260928T215136Z`, which the reaper parked in plan.
- **Retry loop:** the handoff-and-reschedule pattern keeps multiplying copies of this task, which is worth fixing.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T221141Z.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 46 tokens (1188999 cached reads)
- Output: 10537 tokens
- Cost: $1.2465558
- Wall-clock: 190s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
