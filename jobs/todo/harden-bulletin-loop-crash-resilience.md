# Harden the bulletin loop: one bad tick must not kill the service (it went dark ~2h)

Wear the **mentor** role. The **`garden-bulletin.service`** (the maintainer's live dashboard)
**died for ~2 hours** on 2026-06-25: at 21:51 it crashed on `sort: fflush failed: 'standard
output': Broken pipe` / `sort: write error`, and although the unit has **`Restart=always`
(RestartUSec=5s)** it stayed dead — the rapid crash-restarts **hit systemd's start-limit** and
systemd gave up, so the bulletin stopped updating (last commit 21:32) until the liaison manually
restarted it. A single transient pipe error should never take down a continuous service.
Infrastructure on `main2` (bot identity; isolated worktree off `origin/main2`; redeploy).

## Fixes

1. **Tick-level resilience (the core fix).** Wrap each bulletin **tick** in error handling so a
   failure in one tick is **logged and the loop continues to the next tick** — the continuous
   loop must never exit on a single bad tick. If the loop uses `set -e`/`set -o pipefail`, ensure
   a failed tick is caught (subshell + `|| log` ) rather than terminating the process. Reading a
   transient git/sort/jq hiccup is expected; survive it.
2. **Fix the `sort` broken-pipe specifically.** Find the `sort | head` (or `sort`-into-an-
   early-closing-consumer) pipeline that SIGPIPEs and make it benign — e.g. don't run that
   pipeline under `pipefail` where the downstream closes early, or restructure so `sort`
   completing-after-`head`-exits is not a fatal pipeline status. "Broken pipe" from a head/limit
   is normal and must not be fatal.
3. **Start-limit resilience.** So a crash loop can never permanently kill the dashboard: set
   `StartLimitIntervalSec=0` (or a generous burst/interval) on the unit, AND rely on fix #1 so it
   does not crash-loop in the first place. The service must self-recover even if it does hit a bad
   patch.
4. **Unit hygiene.** The unit emits `Unknown key name 'CollectMode' in section 'Service'`
   (line ~11) — `CollectMode` belongs in `[Unit]`, not `[Service]`. Move or remove it.

## Verify

- Inject a failing tick (e.g. a sort that SIGPIPEs, or a transient git failure) and confirm the
  loop **logs and continues** rather than exiting; confirm the service stays `active` across it.
- `systemd-analyze verify` (or load) the unit shows no `CollectMode` warning. `shellcheck`/`bash
  -n` clean. Redeploy `garden-bulletin.service` and confirm it ticks and rewrites
  `journal/README.md`.

## Definition of done

The bulletin loop survives a single bad tick (logs + continues), the `sort` broken-pipe is no
longer fatal, the unit cannot be permanently killed by a crash loop (start-limit tuned), and the
`CollectMode` key is fixed — committed/pushed to `origin/main2`, redeployed, verified ticking.
Report the SHA, the root-cause pipeline, and the resilience change.

Posted by the liaison on behalf of the maintainer.
