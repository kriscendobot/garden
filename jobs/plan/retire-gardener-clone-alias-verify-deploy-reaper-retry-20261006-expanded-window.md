---
gate: orchestrated
orchestrated_by: retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006-split
handler-timeout: 10800
split-indivisible-reason: 'remaining work is one serial fetch-timeout-test.sh verdict (15-50 min per run under host load, must also run against the 70b6d1e3d42^ extract); one suite run cannot be partitioned'
priority: normal
posted_by: producer
posted_at: 2026-10-06T19:44:09Z
---

---
arc: garden-upkeep
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fixer on kriscendobot/garden (main2): finish the regression check for 70b6d1e3d42, the commit that retired the GARDEN_GARDENER_CLONE alias. Only the fetch-timeout verdict is left.

Already done by the parent claim (retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006), so don't redo it:
- Run with `env -i HOME=$HOME PATH=$PATH TMPDIR=$TMPDIR GARDEN_TEST=1`, HEAD showed no FAILs in reaper-requeue-cap (5/0), reaper-live-handler-guard (3/0), reaper-doom-park (12/0), deploy-garden (rc=0) or deadline-nudge (rc=0). The parent extract showed only pre-existing deploy-garden FAILs.
- The doomed plan entry `retire-gardener-clone-alias-verify-deploy-reaper` has been withdrawn to jobs/withdrawn/.

Remaining: on HEAD, fetch-timeout-test.sh had exactly one FAIL: subtest 7, "gardener loop did not log 'claim transiently offline'". That check gives the gardener loop `timeout 6` and ran at load ~19. The commit's only change on that path renames GARDEN_GARDENER_CLONE to GARDEN_WORKER_CLONE in the test, and gardener.sh reads that variable first. The parent extract's run recursed ("shell level (1000) too high") in subtest 5 and never reached subtest 7, so there is no baseline.

Do this: rerun fetch-timeout-test.sh on HEAD with the scrubbed env, detached (setsid nohup, timeout 3600), when load is low. Wait for it in the foreground with a bounded poll loop.
- If subtest 7 passes, it was host load. Report that and land nothing.
- If it still fails, test whether the commit is the cause: run gardener.sh with GARDEN_GARDENER_CLONE versus GARDEN_WORKER_CLONE, or apply the test hunk in reverse. Land a fix only if 70b6d1e3d42 caused it. Otherwise report it as a separate pre-existing issue.
Never run the suite concurrently with another copy of itself or with the reaper/deploy suites, because they share fixed ~/.garden-*-test fixture paths.
