Empty inbox. Work complete.

## Completion report

**Job:** `improve-issue-inbox-child-git-reaping` — stop `garden-issue-inbox.service` from leaking orphan `git` children (the "Found left-over process (git) in control group while starting unit" warning at 00:36:21).

**Root cause:** The issue source (`handlers/issue-source-gh.sh`) runs `gh api --paginate`, which forks git credential helpers. A mid-tick SIGTERM on stop/restart left those git descendants orphaned in the unit cgroup, so the next start inherited stragglers. The unit had neither `KillMode=mixed` nor a bounded `TimeoutStopSec` (only `TimeoutStartSec=900`), and the watcher's EXIT-only trap never reaped the source subtree on a signal.

**Fix** (mirroring the already-proven `garden-comment-watcher@` pattern, both halves the job requested):

- **Unit-side (robust half)** — `scripts/systemd/garden-issue-inbox.service`: added `KillMode=mixed` (initial TERM to the main process only) + `TimeoutStopSec=20s` (cgroup-wide SIGKILL backstop fires well before the next timer firing instead of racing the ~90s default).
- **Watcher-side (belt-and-suspenders)** — `scripts/jobs/issue-inbox-watcher.sh`: launch the source under `timeout --signal=TERM --kill-after=…` so the whole subtree shares one process group; an EXIT/TERM/INT `cleanup` trap TERMs the negated PGID, `wait`s for the group to drain, then SIGKILLs as a backstop; a final `reap_cgroup_stragglers` sweep fells any child `gh` placed in a different process group, on every exit path (including a clean tick). The sweep is a strict no-op outside the real `garden-issue-inbox*.service` cgroup, so it never touches test or non-systemd runs.

**Verification:** `bash -n` clean; all 25 cases in `scripts/jobs/test/issue-inbox-watcher-test.sh` pass (the timeout-wrapping is transparent to the stubbed source). Committed and pushed to `main2` (`a6461b9d7..467761ae9`).

**Follow-ups:** None required for this defect. Note (out of scope, flagged in the job's poison postmortem): the `endolinbot2` host-identity drift (`/home/kris/.garden` = `endolinbot2` vs. `hostname -s`/leader marker = `endolinbot`) is still live, which keeps this leader-only unit gated off on that host — a separate infra issue, not addressed here.
