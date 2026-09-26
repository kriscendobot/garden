---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh, scripts/jobs/pages-watcher.sh
Follow-up to improve-approval-reconciler-cgroup-straggler-reap (main2 0fa4e171b93). ci-watcher.sh and pages-watcher.sh still use the un-hardened reap: their cleanup() only does `kill -TERM "-$pid"` on the source's setsid/timeout process group, which a `gh --paginate`-forked git credential helper (or an ssh master in its own session) escapes, so it survives into the next tick's cgroup as a "left-over process". Port the bounded cgroup-wide `reap_cgroup_stragglers` sweep (leaf-scoped to the script's own service unit, never kills $$/ancestors, returns on two consecutive zero-reads, deadline-capped, test-only *_CGROUP_PROCS_FILE fixture gated by _in_test_context) into each cleanup() so it runs on every exit path; reference implementation is approval-reconciler.sh (commit 0fa4e171b93) or dependabot-watcher.sh. Add the matching escaped-straggler + late-forked-straggler tests (see approval-reconciler-test.sh § S), and add `ExecStopPost=-/bin/bash @GARDEN_ROOT@/scripts/jobs/cgroup-drain.sh %n` to garden-pages-watcher's unit if it lacks one (garden-ci-watcher@.service already has it).
