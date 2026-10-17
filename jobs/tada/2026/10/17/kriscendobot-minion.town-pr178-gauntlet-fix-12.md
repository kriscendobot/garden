Fix round 12 for kriscendobot/minion.town PR #178 is done, and CI is green on head `1d4ae13`. A previous claimant of this job had already pushed the fixes before the requeue, so this run only watched CI and made no new commits.

**What the previous claimant did:**
- **prover must-fix (two concurrency tests failing on the head):** the cause was the review host, not the tests. The garden's fleet `git` wrapper was first on PATH. Each `git http-backend` started in the test runner's working directory, so the wrapper took an exclusive repo lock on every push. That serialized pushes across partitions and left 3 backends running where the test expected 1.
  - Commit `958200c` starts the backend in the project root. The suite now passes 42/42 even with the wrapper on PATH.
  - Garden commit kriscendobot/garden@3adb16860b2 lets server-side git commands skip the wrapper's lock, with a regression test.
- **pruner must-fix (repeated prose and comments):** commit `1d4ae13` makes `DEPLOYMENT.md` point to the design's env table instead of repeating the defaults, and trims the design-doc bullets and the PR body. It also removes the comments that only restated nearby code.
- The disposition summary is posted on the PR (comment at 2026-10-17T06:13Z).

**This run:** the round-12 panel review asked for those must-fixes, and the head already contains them. `ci-wait-merge.sh --no-merge` returned rc 0. All 3 checks passed: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.

**Follow-ups:** a few should-fix items were deliberately left for a later slice because they are design changes, not fix-round patches:
- **prover 2:** replace the fixed 1500 ms sleep in the queued-push test with polling.
- **breaker 1 and 2:**
  - Pushes that only create refs can grow a partition without tripping the size cap.
  - Thin packs can store more than the size limit allowed.
- **decomplector 1–3:**
  - Send the 4-byte probe through the normal backend path.
  - Combine the three admission checks into one function.
  - Move the partition size cap to storage or metering (#174).

The panel-13 stage is next; the driver re-posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-12.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 100 tokens (4246507 cached reads)
- Output: 24555 tokens
- Cost: $2.7331214
- Wall-clock: 1320s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
