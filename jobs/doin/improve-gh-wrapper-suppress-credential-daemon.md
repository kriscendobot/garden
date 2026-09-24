---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/bin/gh
The 2026-09-24 23:33:11 `garden-ci-watcher@kriscendobot-vattr97.service` log ("Found left-over process 1870131/1870132/1870137 (git) in control group... unclean termination or service implementation deficiencies") is git credential-helper daemons spawned underneath a `gh` call, per the unit's own header comment ("the source's `gh --paginate` forks git credential helpers"). `scripts/jobs/bin/gh` (the single PATH chokepoint every fleet `gh` call crosses) already injects `GH_TOKEN` explicitly for every call, so no git credential helper should ever be consulted, yet nothing in the wrapper suppresses one from being invoked/daemonized if `gh`'s internals or an ambient `~/.gitconfig` still names one. A daemonized `git credential-cache--daemon` double-forks and detaches from its parent's process group/session, so it survives both the caller's own EXIT trap reaping (ci-watcher.sh:279-292, which only reaps a tracked `$SOURCE_TIMEOUT_PID`) and a normal (non-signaled) service exit, since `KillMode=mixed`'s cgroup-wide SIGKILL backstop only fires on an explicit stop/timeout transition, not a clean completion. Fix at the source: export `GIT_CONFIG_NOSYSTEM=1` and `GIT_CONFIG_GLOBAL=/dev/null` (or explicitly `-c credential.helper=` on any nested git invocation) around the `exec "${_gh_timeout[@]}" "$real_gh" "$@"` line in `scripts/jobs/bin/gh`, so no credential helper — cached or otherwise — can ever be consulted or daemonized by any fleet `gh`/`git` call, eliminating the leftover-process class fleet-wide instead of trying to reap it post hoc.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T23:57:18Z
