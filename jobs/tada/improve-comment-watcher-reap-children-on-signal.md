All tests pass on the rebased tree and my inbox is empty. The work is complete.

## Completion report

**Job:** Harden `scripts/jobs/comment-watcher.sh` against the recurring `garden-comment-watcher@*.service: Found left-over process <pid> (git) in control group while starting unit` warning.

**Root cause confirmed:** The watcher's only trap was `trap 'rm -f "$SRC" "$ERRF"' EXIT` — no `INT`/`TERM` arm. A systemd stop/restart that SIGTERMs the oneshot mid-tick never ran cleanup and never reaped the `gh`/`git` descendants `handlers/comment-source-gh.sh` spawns (`gh --paginate` forks git credential helpers), so they orphaned into the unit cgroup and were flagged "left-over" on the next start.

**Changes (committed `c854ce209`, pushed to `main2` as `2267c26f0` after one rebase):**

1. **`scripts/jobs/comment-watcher.sh`**
   - Replaced the EXIT-only trap with a `cleanup` function trapped on `EXIT INT TERM` (the signal arms `exit 143`/`exit 130` so a signalled stop drains cleanly).
   - Run the source under `timeout --signal=TERM --kill-after=10s ${GARDEN_COMMENT_SOURCE_TIMEOUT_SECS:=180}s`, backgrounded so the trap can TERM the timeout pid. Because `timeout` (not `--foreground`) runs the command in its own process group and forwards a received signal to that whole group, the reap reaches `gh` + every forked `git` — even any that already reparented (PGID is stable). The timeout also bounds a hung fetch so it can't outlive the tick absent a stop.
   - Bounded the self-test `gh api` call in `source_path_healthy` with `timeout 30s` the same way.
   - Kept the set-e-safe `wait … || src_rc=$?` idiom and the loud-stderr-on-failure behavior.

2. **`scripts/systemd/garden-comment-watcher@.service`** — added `KillMode=mixed` so the initial SIGTERM reaches only the main process (self-heal-run.sh forwards it to the watcher, whose trap reaps), with the cgroup-wide SIGKILL backstop catching TERM-ignorers. Mirrors `garden-gardener@.service` (b3074e154). Default `TimeoutStopSec` is ample since the source is itself bounded.

3. **`scripts/jobs/test/comment-watcher-test.sh`** — added case **FF**: a source stub forks a long-lived child (recording its pid) and blocks; the test SIGTERMs the watcher mid-tick and asserts the child does not survive. Verified to **fail** against the old EXIT-only trap and **pass** with the fix.

**Verification:** Full suite `97 passed, 0 failed`, both before and after rebase. `bash -n` clean on both files; no new shellcheck warnings (the lone `SC2034 GARDEN_TAG` is pre-existing — it's consumed by `common.sh`'s `log`).

**Follow-ups:** None. The change is self-contained; if `GARDEN_COMMENT_SOURCE_TIMEOUT_SECS` ever proves too tight on a very large repo it can be raised via the env override with no code change.
