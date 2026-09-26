Worktree pruned, inbox empty, work pushed. Done.

---

## Completion report — `finbot-loop-daemon-wiring`

**Goal:** wire the driving loop + standing daemons to run the in-process OODA pipeline. Done in the `kriscendobot/finbot` repo; pushed to `main` (`8a46439..5070e8d`).

### What I built

**1. Harness compute hook (the requested integration).** Added a `compute` config hook to `packages/harness/loop.js`'s `runOnce` — a fifth phase that runs an injected in-process OODA cycle with a journal-bound recorder and records real per-stage entries, *alongside* the existing job-posting path. Respected the dependency direction: the harness imports neither `@finbot/pipeline` nor `@finbot/simulator` (verified by grep) — it only invokes the hook it is handed. Added a `jobBoard: false` gate (compute-only ticks, no job spam) and a `localOnly` flag threaded through every journal write in the loop (start tick, inbox drain, all `postJob` calls, stage recorder, complete tick).

**2. Pipeline wiring (the piece that needs both).** New `packages/pipeline/driver-compute.js` exporting `makeDryRunCompute()` — builds a fresh warmed simulator world per tick (GBM seed derived from the tick id, so each tick faces a different-but-reproducible market), runs `runOodaCycle` in dry-run, and asserts `walletTouched === false`. Exported from the pipeline index + package `exports`.

**3. `bin/finbot` flags.** `--compute` (builds the hook from `@finbot/pipeline`), `--no-job-board`, `--local-only`. Refuses `--compute --live` (the compute path is dry-run by construction).

**4. Scripts + systemd units.** `scripts/driver/persistent-driver.sh` (persistent dry-run compute driver), `scripts/watcher/oracle/watcher.sh` (shell-only read-only oracle poll daemon, idles safely until a trusted endpoint set is configured), `scripts/daemons/agent-loop.sh` + `steward-loop.sh` + `journalist-loop.sh` (LLM-context role loops, idle cleanly when the `claude` CLI is absent), and `install-units.sh`. Units: `finbot-driver.service`, `finbot-watcher@.service`, `finbot-steward.service`, `finbot-journalist.service` — each with `StartLimitIntervalSec=0` and tick-level resilience (the parent garden's crash-loop lesson). READMEs for `scripts/`, `scripts/watcher/`, `scripts/watcher/oracle/`, `scripts/daemons/`; `.gitignore` entry for watcher caches.

### Safety bounds honored
Dry-run only (bin refuses `--compute --live`; the cycle never constructs a wallet — asserted); oracle polling read-only against pinned endpoints only with safe idle default; steward never originates a live executor dispatch; no script reads the keystore. No agoric-sdk work.

### Verification
- Tests: 163 → **171, all green** (+6 pipeline `driver-compute`, +2 harness loop tests for the hook and the `jobBoard:false` gate).
- Smoke-tested end-to-end: `finbot --once --compute --no-job-board --local-only` journals all 6 stages + 2 tick markers; additive path posts 2 jobs *and* 6 stages; persistent driver ticks repeatedly; oracle watcher idle + configured paths; steward loop prompt path. `node --check` + `bash -n` clean on all changed files.

### Follow-ups (not blocking)
- The oracle watcher's per-endpoint JSON-RPC read + basis-point math is stubbed pending `skills/oracle-poll/SKILL.md` (the loop, event-posting, and idle path are wired). Noted in `scripts/watcher/oracle/README.md`.
- The steward/journalist loops invoke `claude -p`; their per-cycle behavior depends on those role briefs and a `claude` CLI on the host.

**Self-improvement:** nothing this time.
