Pushed cleanly to `main2` on the first attempt. The job is complete.

## Completion report

**Job:** `build-heavy-handler-budget-fix` — enable build-heavy jobs to succeed and poison deterministic overruns faster.

**Committed & pushed to `main2`:** `62f8a89b4f9dcdde627b66bed434eaefbdacb5b3`

### What changed (tuning, no new machinery)

**1. Build-heavy jobs can now hold a budget big enough to complete**
- **`GARDEN_CLAIM_TTL` 3600 → 14400** (4h), synced in both `scripts/jobs/gardener.sh` and `scripts/jobs/reaper.sh`. The per-job `handler-timeout:` cap the code derives (`budget_max = CLAIM_TTL − KILL_AFTER − 1`) grows from ~3539s (~59 min) to **14339s (~3.98h)** — comfortably covering a cold `docker build`.
- **Default `GARDEN_HANDLER_TIMEOUT` unchanged at 2400** — headerless jobs still run at the 40-min default; only a job carrying an explicit `handler-timeout:` header rides the larger budget.
- The single-owner invariant still holds at the max: `14339 + 60 = 14399 < 14400`.

**2. How the docker job class gets its budget** — there is no automated docker-build producer in the repo (these jobs are posted by the liaison via the `build`/post-job path), so I **documented the requirement** at the three places a build-heavy job is born: a new "Per-job handler budget" section in `skills/job-board/SKILL.md`, a new operating-norm bullet in `roles/liaison/AGENT.md` (the producer owns the header; e.g. `handler-timeout: 10800` for a ~3h docker build), and a corrected TTL note in `skills/restore/SKILL.md`. So `ocapn-pet-daemon-dockerfile-minion` (or its re-post) completes once posted with a `handler-timeout:` header.

**3. Notice the burn faster** — **`GARDEN_REAP_OVERRUN_THRESHOLD` 2 → 1**: a no-progress `garden-deadline-overrun` claim is poisoned (parked held + maintainer notice) after the **first** cycle instead of the fifth. The general `GARDEN_REAP_POISON_THRESHOLD` (5, for non-deterministic stale claims) is untouched. The existing productive-cycle exemption still resets the counter, so a healthy long job on the resume treadmill can never false-poison at threshold 1. Stale "(2)" comments in `gardener.sh`, `common.sh`, and the two affected tests were updated.

### Verification evidence
- `bash -n` + `shellcheck -S warning` clean on both scripts; diffed against `origin/main2` — **zero new shellcheck warnings**.
- Committed test suite still green: `handler-budget` 12/12, `reaper-poison-park` 5/5, `productive-cycle` 10/10, `outage-poison-pause` 10/10, `reaper-live-handler-guard` 3/3.
- Focused harness at the **shipped new defaults**: (a) computed cap = 14339s / invariant `14399 < 14400` / thresholds `overrun=1, poison=5`; (b) a `handler-timeout: 10800` (3h) job is logged "honoring … ≤ claim budget max 14339s" and **completes to tada**; (c) an overrun-marked claim **poisons at cycle 1** (`deadline-overrun` signature) while a plain stale claim **requeues to todo** (`garden-reaped: 1`, not poisoned).

### Follow-ups / notes
- **Takes effect on this host at the next deliberate deploy** (the root checkout advances only via `deploy-garden.sh`).
- **Tradeoff of the wider TTL:** a claim whose gardener died *silently* (host crash / hard SIGKILL, no reap-now hint) now waits up to 4h to reap instead of 1h; same-host fast paths (reap-now hint, live-handler guard) are unaffected. Documented in `restore/SKILL.md`.
- **Systemd interaction (pre-existing, not introduced):** `garden-gardener@.service` has `TimeoutStopSec=2700`, so a per-job budget job that catches a systemd stop mid-run is SIGKILLed at 45 min. This already applied to the old ~59-min cap; a build-heavy job normally completes under normal operation (deploys quiesce via the fleet-pause and abort rather than force-killing mid-job). If long jobs should survive a restart, raising `TimeoutStopSec` is a separate follow-up.
