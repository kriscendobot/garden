---
role: builder
tier: mentor
fallback-tier: minion
arc: minion-town
dispatch: automatic
---
# Build: make the minion.town prod probe actually run every 3 hours

Repo: kriscendobot/minion.town (supervised-carry; the arc supervisor of kriscendobot/garden#58 carries the PR — no maintainer review).

**Problem (evidence, 2026-10-13T00:05Z):** `.github/workflows/prod-probe.yml` has `cron: "17 */3 * * *"`, but GitHub has fired only 3 scheduled runs since 2026-10-11T21:57Z (2026-10-11T21:57Z, 2026-10-12T05:57Z, 2026-10-12T15:25Z): roughly 8 slots were expected, and the ones that did fire were 40 minutes or more late. The 18:17Z and 21:17Z slots on 2026-10-12 never ran. Production was still green when a manual dispatch ran (run 38325275451, success). This probe is the automatic production validation behind every checked primary-phase box in garden#58, so a probe that does not run leaves those objectives unvalidated.

**Deliverable:** a deterministic backstop, so a probe run starts at least every ~3h even when GitHub drops the cron event. A suggested shape: a systemd timer on the self-hosted CI runner host (ci.minion.town, the host `PROBE_RUNS_ON` targets) that checks the newest `prod-probe.yml` run and calls `workflow_dispatch` when none has been created within 3.5h. A different deterministic mechanism is fine. Constraints:
- No LLM in the loop. Use a least-privilege token (actions:write on this repo only); never a maintainer credential.
- Keep `--strict` semantics and the existing failure-issue reporting unchanged.
- Document it in DEPLOYMENT.md § Production objectives probe, including the staleness alarm ("no probe run in >4h means the backstop or runner is down").
- Validate in production: show the backstop dispatching a run after a simulated or real gap.

Open a DRAFT PR; the gauntlet follows automatically.
