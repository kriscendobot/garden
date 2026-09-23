All done. Worktree torn down, bulletin active under the wrapper, no inbox messages.

---

## Completion report

**Job:** `apply-self-healing-wrapper-to-all-services` (mentor role) — **DONE**, committed/pushed/redeployed/verified.

**SHA:** `555f6772a` on `origin/main2` (single commit), deployed to `/home/kris` via `--ff-only` and `install-units.sh install` (daemon-reload done).

### 1. Reusable self-heal runner (extracted before the driver's removal)
`scripts/jobs/self-heal-run.sh` + responder `scripts/jobs/handlers/self-heal-claude.sh`.

**API:** `self-heal-run.sh <context> [--work-id <id>] [--role <brief>] [--expect <code>] -- <command...>`
- Runs the command, tees combined stdout+stderr to journald **and** a bounded capture file.
- On an **unexpected** non-zero exit: hashes the tail via `capture_blob` into `$GARDEN_STATE/self-heal/journal` and hands **only the blob SHA** (per common.sh §self-healing) to a task-specific `claude -p` responder (mentor role by default) that diagnoses → posts a `JOB…ENDJOB` fix job or a throttled maintainer-inbox report.
- **Preserves the child's exit code** so systemd `Restart=`/journal/central-mentor still see the failure (wrapper diagnoses; systemd restarts). SIGTERM/SIGINT is forwarded to the child and treated as a **clean shutdown**, never diagnosed.
- **Hard throttle:** responder fires at most once per `(context, exit-code)` signature per `SELF_HEAL_THROTTLE_SECS` (30m) and ≤ `SELF_HEAL_DAILY_CAP` (12)/UTC-day; state under `$GARDEN_STATE/self-heal/throttle/`, outside the unit. Responder is `timeout`-bounded (300s) and fully OR-guarded so self-heal can never crash the service or amplify a crash loop.

### 2. Per-service application status (17 units wrapped)
- **bulletin** (first, the proven failure) — wrapped + **restarted live under the wrapper** (Main PID = `self-heal-run.sh`, child = `bulletin.sh`).
- **Oneshots** (adopt new ExecStart on next timer fire automatically): watchman, follow-up, foreman, proxy, scheduler, mentor, deadmail, repo-watcher, mirror-closer, mention-watcher, gardener-scaler — each also got `TimeoutStartSec=900` so a synchronous diagnosis isn't cut off.
- **Templated:** comment-watcher@, triager@, watcher@ (context carries `%i`); **gardener@** shares one context `garden-gardener` with `--work-id %i` so the 100-instance pool is throttled **fleet-wide** (the "throttle especially there" requirement). design-poller wrapped too.
- **CAS-primitive exception honored:** reaper and the git/CAS primitives (post/claim/complete, cursors, inboxes) left unwrapped — contention heals via retry, not a responder (`SELF_HEAL_CAPTURE_ONLY=1` is available for capture-only). **driver@** skipped (being removed + already self-heals).
- Composes with the in-flight `harden-bulletin-loop-crash-resilience`: the wrapper is the **outer diagnosis** layer; bulletin's tick isolation + `StartLimitIntervalSec=0` are the **inner survival** layer — both hold.

### 3. Verification
- `bash -n` + `shellcheck -S error` clean on all new scripts; `systemd-analyze verify` clean on the wrapped units (deployed bulletin & mentor verified clean at the real path).
- **Live fault-injection on the deployed bulletin path** (real wrapper + real common.sh + real journal clone, stub responder to avoid token burn / board noise): rc=1 preserved → responder fired **once** → content-addressed blob written and **readable in `$GARDEN_STATE/self-heal/journal`** → repeat same signature **throttled** (still 1) → throttle markers written outside the unit.
- Added **run-test.sh SUBTEST 21** (clean-exit silence, fire-once + rc + work-id, blob capture, same-sig throttle, distinct-rc signature, daily cap, SIGTERM-clean) + `self-heal-stub.sh` — 7/7 pass. Recorded the runner as the canonical live exemplar in `skills/self-healing-wrapper/SKILL.md`.

### Follow-ups
- **Gardener pool adoption:** the 100 gardeners (and any watcher@/design-poller) pick up the wrapped ExecStart on their **next restart**. I did **not** mass-restart them — I am gardener@39 and a pool restart would interrupt in-flight claims (including this job). A deliberate rolling restart (or a `set-gardeners` rescale) by the maintainer/scaler will roll them onto the wrapper cleanly when convenient.
- The default responder uses the generic **mentor** role brief per service; a future refinement could carve per-service `--role` briefs for the highest-signal services (gardener state-machine, bulletin journalist) for sharper diagnoses.
