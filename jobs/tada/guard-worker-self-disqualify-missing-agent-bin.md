# Report — `guard-worker-self-disqualify-missing-agent-bin`

**Landed on `main2` as `7173c6dd36`** (direct push, per CLAUDE.md § Conventions).

## The invariant, as landed

**A worker that cannot run a job never takes one.** The agent-CLI probe moved from *inside the handler* (post-claim, after the job was already stolen from `todo/`) to *before the claim*, in `gardener.sh`'s poll loop.

## What changed

**`scripts/jobs/common.sh`** — new § *pre-claim worker health gate*:
- `agent_bin` field added to the worker-kind registry: gardener→`claude`, cleric/hermit/fireworker→`codex`, mystic→`kimi`. One gate covers every kind the spine runs.
- `worker_health_gate` / `worker_health_probe` / `worker_agent_bin` / `worker_health_marker`. The probe reuses the existing resolver (`GARDEN_<NAME>_BIN` → PATH → known install locations), so gate and handler can never disagree on what "present" means.
- **One report per edge, not per tick.** The unhealthy episode is latched by an atomic `mkdir` of a host-local, kind-scoped marker, so exactly one worker of a ~20-strong pool emits the journal `error`, and exactly one emits the `progress` on recovery. Paired `alert_maintainer` / `alert_maintainer_clear` close the loop in the maintainer inbox.

**`scripts/jobs/gardener.sh`** — gate called before `claim-job.sh`. Unhealthy → park and re-poll on the shared exponential backoff (a third counter, `health_attempt`), never exit into a systemd restart loop. Under `GARDEN_ONESHOT` it exits *clean* instead (that deployment is timer-rearmed; a failure rc would arm a self-heal responder against an environmental condition no code fix addresses). Placed after the drain/stop checks and the bus read, so a parked worker still honors a stop, a deploy, and its messages.

**Scope guard:** with a *substituted* `GARDEN_JOB_HANDLER` the spine cannot know the dependencies, so the gate does not apply (`GARDEN_WORKER_HEALTH_GATE=0` disables it outright). That is what keeps every existing test — all of which stub the handler — bit-for-bit unchanged.

**`designs/job-board.md`** — new § *The pre-claim health gate* under § 2 (the claim protocol), recording the work-sink argument and why the fix has to live in the worker.

## Verification

New `scripts/jobs/test/worker-health-gate-test.sh` — **28 assertions, 0 failures**:
- **The simulation the job asked for:** the *real* `gardener.sh` poll loop with its CLI denied (fail-closed `GARDEN_CLAUDE_BIN`), against a throwaway board — board untouched, job still in `todo/`, **no `doin/` entry**. Run for both the production default handler *and* a tattling stub whose "I ran" marker never appears, proving the refusal is **pre-claim**, not a post-claim handler crash.
- Park-then-self-heal: the worker is still alive across 6 park ticks having claimed nothing, then un-parks **by itself** once the binary appears mid-run and completes the job — with exactly **one** journal `error` entry and **one** `progress` entry for the whole episode.
- Edge-once accounting across 5 ticks/workers, in both directions, plus a second episode re-reporting.
- Healthy control: claims and completes to `tada/`, no episode latched, zero health entries.

Regression: `run-test.sh 8 4` produces the **identical 30 failures with and without this change** (diffed by name — no regressions, nothing newly fixed). Green: `worker-spine-kinds` (136), `claude-bin-resolver` (27), `completion-signal` (17), `handler-budget` (12), `productive-cycle` (10), `signal-kill-classifier` (17), `outage-poison-pause` (10), `token-cost-ledger` (5).

## Relationship to the companion job

`improve-gardener-claude-bin-resolution` has **already landed** — `claude_bin`/`agent_bin`/`die_environmental` are in `main2`, and all five sibling handlers (`triager`, `watchman`, `bulletin`, `proxy`, `follow-up`) already use the resolver with an environmental exit. Nothing duplicated. Division of labour held: that job made the binary easier to *find*; this one makes a worker that still cannot find it stop taking work.

## Follow-ups (not in scope here)

1. **`run-test.sh` has 30 pre-existing failures on `main2`.** They are environmental/unrelated (sandbox has no network for `github.com:kriskowal/garden.git`, so the sync_clone corruption-classifier block fails wholesale; a `shellcheck` wrapper subtest; a foreman fill-batch block). Worth a job — right now the suite is red by default, which means it cannot gate anything.
2. **`run-test.sh` hardcodes `TR=/home/kris/.garden-test` and `rm -rf`s it at startup.** Two workers running it concurrently clobber each other. Keying it by PID or job base would fix it.
3. The gate does not free jobs **already stranded in `doin/`** on a broken host — the reaper still owns that, on its TTL. If ps23's 52 claims are still held, they will requeue rather than be released early.
