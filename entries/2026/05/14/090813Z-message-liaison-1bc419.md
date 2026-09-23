---
ts: 2026-05-14T09:08:13Z
kind: message
role: fixer
to: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/14/090812Z-result-fixer-0cbacb.md
---

# Dispatch-root path overruns UNIX-socket 108-char limit

A fixer dispatch running in `dispatches/fixer--pr-135-panel-fix--20260514-084845--f3e898/project/` cannot run the daemon's endo.test.js locally. The daemon's UNIX socket path is computed under the project worktree:

```
/home/kris/dispatches/fixer--pr-135-panel-fix--20260514-084845--f3e898/project/packages/daemon/tmp/<test-slug>/endo.sock
```

That is 144 chars before the test slug, well over the 108-char `sockaddr_un` limit. Every endo.test.js test fails with `ENOENT: no such file or directory, access '.../endo.sock'` before any assertion runs. Existing tests (`mount subDir creates confined sub-mount`) hit the same wall, so the failure is not a regression my changes introduced.

A `/tmp/<short>` symlink does not help: the daemon's `dirname` is computed from `import.meta.url` which canonicalises back to the long real path.

Recommended remedies (gardener / dispatch-worktree skill author can pick):

1. Shorter dispatch-root scheme. `dispatches/<role>--<6hex>/project/` would drop ~50 chars per dispatch. The `<role>--<purpose>--<UTC-ts>--<id>` form is useful for `ls`-time auditing, but the index is the journal entry, not the directory name; the directory could be a short id and the journal entry could carry the full role / purpose / ts metadata.

2. The dispatch-prepare script could create a `/tmp/garden-<short-id>` symlink at prepare time and set `TMPDIR=/tmp/garden-<short-id>` for the dispatch. The daemon's `dirname` would still resolve long, but tests that respect `TMPDIR` could target the short path. (Untested; the daemon hard-codes `dirname/.../tmp` in `makeConfig`.)

3. Status quo: fixers running in deep dispatch roots ship their changes blind on endo daemon tests and rely on CI. That is workable because the panel's coverage tests use the same patterns as existing tests and follow the same harness; lint and the non-daemon test files exercise locally. But the cost is real (one round-trip to CI to learn the test even compiles).

For my round of fixes on PR #135 specifically: I ran lint clean, ran the non-daemon test files clean, and pushed to CI for the real signal. The new tests follow the same shape as their immediate neighbours and the daemon-side state is shared, so I am reasonably confident they pass; if CI returns red on one of the new tests, dispatch a fixer-follow-up with the failure trace.

Not a blocker. Recording so the dispatch-root scheme question lands on the orchestrator's queue.
