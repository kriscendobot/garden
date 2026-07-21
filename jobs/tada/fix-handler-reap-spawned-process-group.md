The work is complete. Inbox is empty, the DoD test passes at HEAD.

## Completion report

**Job:** `fix-handler-reap-spawned-process-group` — reap the spawned process tree on handler overrun/poison (fleet-wide).

**Root cause (2026-07-20/21 incident):** A claim-scoped handler that overran its budget (`rc=124`) or returned on its own leaving a runaway tree (a `claude -p` that crashed/quota-cut, then requeue-exhausted into poison) had its **board** job requeued/poisoned while the **OS process tree** it spawned kept running headless — 356 orphans (four `endor-xst` pegging cores + a 344-proc `endor`/`manager-node.js` daemon tree) reparented to `systemd --user`. The pegged cores starved the next tick into overrunning too — a self-reinforcing loop.

**What I changed** (commit `8eb3354a7e`, pushed to `main2`):
- `scripts/jobs/gardener.sh` — the single handler call site now launches the handler in its **own process group** via job control (`set -m`), with `timeout --foreground` so the whole non-detaching descendant tree stays in the one group whose pgid we capture (`$!`). After the handler returns **for any reason**, the gardener sweeps that group. The `wait` runs in a resume-across-signals loop so a deploy-drain SIGTERM still lets the in-flight handler run to completion (graceful-drain contract preserved) instead of falsely reaping a live tree. Added the `GARDEN_HANDLER_REAP_GRACE` knob (default 5s).
- `scripts/jobs/common.sh` — new `reap_process_group PGID [GRACE]` helper: SIGTERM → poll-until-empty grace → SIGKILL to `-<pgid>`. Idempotent; hard-guarded so it can only ever signal *this job's own* freshly-minted group (refuses non-numeric / `0`/`1` / this-process's-own-pgid targets), never a peer's.
- Tests: `handler-orphan-reap-test.sh` (+ two handler stubs) proving the DoD.

**Why the gardener, not the reaper:** the gardener is the one process that knows the pgid and shares the host; in every overrun/poison path the handler has already *returned* to the gardener, so the unconditional post-return sweep covers both the `rc=124` wall and the self-exit/poison path. The reaper (separate process, cross-host) has no host-local handle to the tree.

**Evidence (before/after):**
- Reproduced the leak: under the old `timeout ... handler`, a handler that **self-exits** leaving a tree → **3/3 descendants survive** (the incident's poison path; old `timeout` only group-kills on `rc=124`, and even then setsid escapees leave).
- After the fix: self-exit → **0/3**, overrun (`rc=124`) → **0/4**. Test result: **15 passed, 0 failed**.
- No regressions: `completion-signal`, `handler-budget`, `worker-spine-kinds`, `signal-kill`, `empty-output`, `elapsed-constancy` all green; `timeout-classifier` unchanged at 33 pass / 3 pre-existing fails (SUBTEST 4, reaper overrun-threshold — identical on the pristine tree, untouched by this change). `bash -n` clean on all touched files.

**Residual / follow-ups:**
- A descendant that itself `setsid()`/daemonizes into a **new session** leaves the group and is not reachable by a pgid sweep (no pgid- or cgroup-free scheme can catch it from the parent). This is documented in-code and is covered by defense-in-depth at the leaf — the `xs2rust-endor-press` charter's per-test `timeout` + self-reaping, which is a **separate** job. A future stronger structural option would be a systemd transient scope / cgroup per handler (kill catches even daemonized descendants) — noted, not in scope here.
- The pre-existing 3 `timeout-classifier-test` SUBTEST 4 failures are unrelated (reaper overrun-threshold) and worth a separate look.
