# Foreman edge-trigger on gardener job completion

**Repo:** the garden's own library (`kriskowal/garden`), dev branch `main2`.
**Origin:** maintainer directive via the liaison (2026-07-03) — "enable the foreman
to top off the idle gardeners; should be edge triggered, deterministically, by
gardener job completion." The foreman is now enabled but fires only on its 5-minute
poll + a 240s idle-settle debounce, so after the board drains it can be minutes
before idle gardeners get refilled. Make the top-off *additionally* edge-triggered
by the completion event itself, deterministically (plain code, no `claude -p`).

## Task

Add a deterministic, non-blocking, best-effort edge trigger so that the instant a
gardener completes a job, the foreman is kicked to re-evaluate and (on sustained
idle) pump the next step — without waiting for the timer.

### 1. `scripts/jobs/common.sh` — add a `foreman_kick` helper

- New function `foreman_kick()` that requests a foreman run via the existing
  `unit_ctl` indirection: `unit_ctl start --no-block garden-foreman.service`.
- **Non-blocking:** use `--no-block` so it returns immediately (never stalls the
  completing gardener).
- **Best-effort / never fatal:** swallow all errors (`|| true`), so a missing unit,
  absent systemd (standalone/test invocation), or a follower host never fails or
  delays the completion that called it. Must be safe under `set -euo pipefail`.
- **Toggle:** honor `GARDEN_FOREMAN_EDGE_KICK` (default `1`/on; `0` disables).
- **Test seam:** because it routes through `unit_ctl`, `GARDEN_UNIT_CTL` already
  mocks it — assert on that in tests.
- Comment the rationale: it is safe to kick frequently because (a) the foreman is a
  **leader-only** singleton — its `ExecCondition=is-main-host.sh` means a kick on a
  follower host starts the unit but the tick is skipped cleanly (no-op); and (b) the
  foreman's own idle-detection + `GARDEN_FOREMAN_IDLE_SETTLE` debounce + weekly
  token cost-gate + anti-flap mean a kick while the board is busy or still within
  the settle window is a cheap no-op that spends no `claude -p`.

### 2. `scripts/jobs/complete-job.sh` — call it on successful completion

- After the successful `commit_and_push` (the `log "completed '$base'"` / `exit 0`
  branch, ~line 39–41), call `foreman_kick` **before** `exit 0`. This is the exact
  doin→tada→push edge = "gardener job completion."

### 3. Keep the 5-minute timer as a backstop (do NOT remove it)

The edge trigger is local to the host whose gardener completed the job. Two cases
the local edge cannot cover, which the timer backstop must still handle:
- **Cross-host:** a *follower* gardener's completion kicks only its own (skipped)
  foreman, never the leader's — the leader's timer catches it.
- **Fully-idle post-settle pump:** the *last* completion that drains the board sets
  the idle-since clock but the pump waits out the settle window; since the fleet is
  now idle there are no further completion edges to re-fire the foreman, so the
  timer fires the delayed pump.

### 4. (Optional, second phase — flag in the report, do not assume) pure-edge settle

To eliminate the residual timer latency on the fully-idle case, the edge-kicked
foreman, when it finds the board idle but still within the settle window, may arm a
single one-shot `systemd-run --user --on-active=<remaining>s garden-foreman.service`
(idempotent via a marker so kicks don't stack) so the post-settle pump fires
promptly with no polling. This touches the token-spending pump's control flow — do
it only if cleanly testable; otherwise leave the timer backstop as the settle-expiry
trigger and note the tradeoff in the report. **Do not silently expand scope.**

## Tests

Extend the foreman / complete-job test suite (uses `GARDEN_UNIT_CTL` +
`GARDEN_FOREMAN_HANDLER` mocks):
- A successful completion invokes `unit_ctl start --no-block garden-foreman.service`.
- `GARDEN_FOREMAN_EDGE_KICK=0` suppresses the kick.
- A failing/absent `unit_ctl` (mock returns non-zero) does **not** fail the
  completion (job still lands in tada/, exit 0).

## Definition of done

- Helper + call + tests implemented; existing tests still green.
- Pushed directly to `origin/main2` (garden's own repo uses no PR workflow).
- Report notes: this goes live on each host only at its next `deploy-garden.sh`
  (this leader host — endolinbot2 — is currently ~50 commits behind `main2`), and
  whether the optional §4 pure-edge settle was included or deferred.

---
claim:
  host: endolinbot2
  gardener: 4
  claimed_at: 2026-07-03T18:06:42Z
