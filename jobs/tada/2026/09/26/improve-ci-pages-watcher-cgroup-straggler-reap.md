Both watchers now run the hardened cgroup-wide straggler sweep on every exit. Pushed to `main2` as `47b41af5a14`.

**What changed**
- **`scripts/jobs/ci-watcher.sh` and `scripts/jobs/pages-watcher.sh`:** I copied `reap_cgroup_stragglers` and `_straggler_alive` from `approval-reconciler.sh`, following the existing per-script-copy convention. `cleanup()` still does the process-group TERM/KILL, then always runs the sweep, so clean exits get it as well as signalled ones. As in the reference version, the sweep:
  - only acts inside its own service's cgroup (`garden-ci-watcher@*.service` or `garden-pages-watcher.service`) and never kills `$$` or its ancestors;
  - stops after two empty reads in a row, or at the deadline (`GARDEN_{CI,PAGES}_CGROUP_REAP_DEADLINE_SECS`, default 3s);
  - accepts a test-only `GARDEN_{CI,PAGES}_CGROUP_PROCS_FILE` fixture, honoured only when `_in_test_context` says it is a test run.
- **`garden-pages-watcher.service`:** added `ExecStopPost=-/bin/bash @GARDEN_ROOT@/scripts/jobs/cgroup-drain.sh %n` and updated the KillMode comment. `garden-ci-watcher@.service` already had the drain, so it only got the comment update.
- **Tests:** each watcher's test file gets the escaped-straggler and late-forked-straggler cases (section U in `ci-watcher-test.sh`, section K in `pages-watcher-test.sh`).
  - The pages test clears all `GARDEN_*` variables at startup, including `GARDEN_TEST`, so its new cases pass `GARDEN_TEST=1` explicitly.
  - The new cases use their own fixture names (`cg-s.git`, `FIX_CG`) because the ci test's existing section S already uses `$TR/s.git`.

**Tests**
- With the new scripts: `ci-watcher-test.sh` 78 passed, 0 failed; `pages-watcher-test.sh` 19 passed, 0 failed.
- With the old scripts put back temporarily: both new straggler cases fail in each file (76/2 and 17/2), so the tests do catch the bug.
- Shellcheck produced no warnings.

**Follow-ups:** none required. The live units only pick up the new ExecStopPost and the script changes after the next deploy and units reconcile.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-pages-watcher-cgroup-straggler-reap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1682898 cached reads)
- Output: 14152 tokens
- Cost: $1.2222915999999997
- Wall-clock: 771s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
