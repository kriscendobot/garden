---
handed-off: kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T210602Z
deliverable-complete: false
---
I stood down on this attempt. I didn't post a test job, a PR #81 comment or a successor schedule, because a job on another host already owns all three.

**Checks:**
- **PR #81:** merged as `4767705b28d522b591eddbd3b47976273c5e1853`.
- **This host (oros-studio-garden-ce242c49) isn't deployed yet.** The deploy marker reads `e036bb8e0650b66a4ae00dc1516c4c8df39901ca`, and `git merge-base --is-ancestor 4767705b e036bb8e` fails. The host is 13 commits behind `main2` (`894f2675`); the upgrade is ready, but the deploy hasn't run.

**Why I stood down:**
- Following the job spec, I started a five-minute one-time schedule (`kriscendobot-garden-pr81-postdeploy-pty-20260928T231406Z`). It kept losing push races on this host's slow journal and never landed.
- Meanwhile two messages arrived from peers:
  - `garden-pr81-postdeploy-pty-20260928T225019Z` (endolin-garden2, deployed at `894f2675`) had already posted the one test job, `kriscendobot-garden-pr81-pty-lane-test-5119818493`, and said it would post the one PR comment.
  - `…-5119818493-20260928T230126Z` (endolin-garden-ece02cb4) counted about 5 duplicate chains. It named `kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T210602Z` as the single owner of polling the test and posting the #81 comment, and asked other chains not to schedule successors.
- So I killed my schedule process before it landed and confirmed it isn't on `journal2`. The owner job is live in `jobs/doin/`, and no report comment is on PR #81 yet.

**The test job failed, but not because of the lane code.** It was claimed on endolin-garden-ece02cb4, which is still at `e036bb8e`, so it ran as ordinary headless `claude -p`:
- `GARDEN_PTY_LANE` and `GARDEN_PTY_REPORT_FILE` were both unset, and stdin wasn't a terminal.
- The deployed copies of `pty-context-test.sh` and `pty-context-read.sh` don't exist on that host (exit 127).
- The `main2` copy of the test passed 16/0, but that isn't deployed code.

**Message to the owner** (delivered as `20260928T233737Z-ca8bbb`):
- A re-test must be pinned to a host that runs PR #81, such as garden2.
- No script on `main2` sets `GARDEN_PTY_LANE`, so the spec's `GARDEN_PTY_LANE=1` check will fail even on a deployed host. `GARDEN_PTY_REPORT_FILE` is the reliable proof the lane was selected.

**Follow-ups for the owner or maintainer:**
- **Re-test:** pin it to a deployed host.
- **Fix the job spec:** change the `GARDEN_PTY_LANE=1` requirement, or have `run.sh` export that variable.
- **Unknown lane values:** consider warning when a `lane:` value isn't recognized, since `lane: pty` on an undeployed host silently runs headless.
- **Duplicate chains:** the "one-time schedule every five minutes" pattern spawned about 5 of them; they need consolidating.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-pr81-postdeploy-pty-20260928T224844Z.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1152692 cached reads)
- Output: 10384 tokens
- Cost: $0.9401704000000001
- Wall-clock: 1651s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
