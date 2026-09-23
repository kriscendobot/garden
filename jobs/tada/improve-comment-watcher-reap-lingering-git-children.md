Done. Pushed to `main2` as `5cb7aff5d`.

## Completion report

**Problem.** `garden-comment-watcher@.service` kept leaking git children into its cgroup ("Found left-over process … (git) in control group while starting unit") despite already carrying `KillMode=mixed` + an EXIT/INT/TERM trap. I traced two compounding causes:

1. **Fire-and-forget trap.** The cleanup signalled only the `timeout` PID and `exit`ed *immediately* without waiting. So the watcher (and thus `self-heal-run.sh`, the unit's main process) was already gone while `gh`/`git` were still mid-network-syscall, dying asynchronously in the cgroup — and the 90s timer raced that drain.
2. **`timeout`'s escalation gap.** `timeout --kill-after` only SIGKILLs while its *monitored child* is alive. If the source's bash wrapper dies on TERM but leaves a TERM-ignoring grandchild (a `git` mid-syscall), `timeout` exits without felling it.

**Changes** (`scripts/jobs/comment-watcher.sh`, `scripts/systemd/garden-comment-watcher@.service`, `scripts/jobs/test/comment-watcher-test.sh`):
- Cleanup now signals the **negated PGID** directly (`timeout` `setpgid(0,0)`s itself, so PGID == its pid), **`wait`s for the group to drain**, then **SIGKILLs the whole group** as a hard backstop. The cgroup is empty before the watcher exits.
- `--kill-after` is now overridable via `GARDEN_COMMENT_KILL_AFTER` (for the test).
- Unit gets `TimeoutStopSec=20s` — the poll holds no in-flight work worth preserving (a killed tick re-polls; the cursor only advances on a verified post), so a straggler the process-group reap can't reach (e.g. a `gh` child in its *own* process group) is cgroup-SIGKILLed well before the 90s next firing, instead of racing it at the 90s `DefaultTimeoutStopSec`.
- Tests: FF made zombie-aware; new **FF2** pins the SIGKILL-escalation path with a TERM-ignoring source child. Verified FF2 **fails** under the old cleanup and **passes** under the hardened one. Suite: **99 passed, 0 failed**.

**Follow-up (not blocking).** The unit-file change only takes effect after a deploy + `daemon-reload` of the deployed garden root; running watcher instances keep the 90s stop timeout until then. No action needed from me — the normal deliberate-deploy flow picks it up.
