I applied the panel-1 fixes to kriscendobot/minion.town#224, pushed them, and CI came back green (`ci-wait-merge` reported 3/3 checks passed, 0 failed).

**What I did**

- **Restart failures now fail the script** (the must-fix raised by assessor, saboteur, spec-keeper, wire-watcher, integrator and purist). A new shared helper, `deploy/aws/scripts/lib/endo-daemon-clients.sh`, is pulled into the remote scripts through `$ENDO_DAEMON_CLIENTS` in `common.sh`. I moved the existing safe socket probe (`sock_accepts`/`endo_probe`) into it, plus `restart_daemon_clients`. That function:
  - waits up to 60s for the daemon to answer `endo list` before touching anything;
  - restarts `minion-mcp` and `endo-gateway` only if each is running, and skips one that isn't, with a message;
  - requires each restarted client to answer HTTP within 30s without systemd restarting it (`/healthz` for the app, any HTTP answer from the gateway on port 3002);
  - fails on anything else. The old `try-restart … || true` is gone.
- **Clients wait for daemon readiness on every path** (saboteur, breaker, purist, spec-keeper, wire-watcher, corner-prober). In `deploy-endo-daemon.sh` the helper now runs:
  - when the upgrade preflight fails, since the snapshot step had already restarted the live daemon (engine-realist);
  - after the automatic rollback;
  - after a successful deploy.

  In the two failure paths it runs as `|| true`, with a comment, because the script exits 1 straight afterwards anyway. In `rollback-endo-daemon.sh tree` it replaces the fixed `sleep 3`.
- **Two missed daemon-restart paths are covered** (breaker):
  - `deploy-endo-federation.sh disable` now calls the helper after the box script restarts the daemon. Before, it restarted `minion-mcp` before the daemon, so the app was left holding a dead session.
  - The `@pins` revival test in `provision-guest-reminders.sh` now calls it after its daemon restart.
- **Regression test** (prover, corner-prober, integrator): `test/endo-daemon-clients.test.ts` runs the helper with stubbed `sudo`, `systemctl`, `curl` and `sleep` and checks six cases: slow daemon readiness, a daemon that never answers, an inactive client, a failed restart, an unhealthy client, and a crash loop. It also checks that every restart path calls the helper and that `try-restart` is gone. When I deleted the success-path call, the test failed.
- **Comments and PR body** (archivist, pruner): the comment now names what actually doesn't recover — the app's boot-time `@sites` install and the gateway's daemon connection — rather than saying the app never reconnects. I also dropped the incident narrative from the comment, and rewrote the PR body without the per-file tour, the run ID, the check tally and the #222 paragraph.

**Checks:** typecheck passes, prettier is clean, and the `test/endo*` and `test/deploy*` suites pass (193 tests). The rendered remote deploy script passes `bash -n`, and shellcheck is clean on the new helper. ESLint isn't set up in this repo (there's no config file), so it didn't run.

The push was three follow-up commits, 10bc4c6a → 5d1bccaf. I didn't re-run the panel; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr224-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (3127100 cached reads)
- Output: 27686 tokens
- Cost: $2.121884
- Wall-clock: 641s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
