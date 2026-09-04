---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/systemd/garden-foreman.service
`common.sh`'s `foreman_kick()` deliberately fires `unit_ctl start --no-block garden-foreman.service` on *every* gardener job completion (comment: "safe to kick FREQUENTLY"). A burst of near-simultaneous completions across the pool trips systemd's default `StartLimitBurst=5`/`StartLimitIntervalSec=10s`, producing "Start request repeated too quickly" refusals — observed 60 times in a single day (2026-09-01) in the `journalctl -p warning` tail, in bursts of 6-8 refused starts within a few seconds, several times an hour. Every other unit in the fleet that is restarted rapidly/frequently by design already carries the fix: `garden-gardener-scaler.service`, `garden-local-model-pull.service`, `garden-root-maintenance.service`, `garden-bulletin.service`, and `garden-ollama.service` all set `StartLimitIntervalSec=0` specifically to disable this rate limiter for exactly this class of unit. `garden-foreman.service` is missing the same override despite being the one unit whose start is edge-triggered on every job completion fleet-wide — add `StartLimitIntervalSec=0` under `[Unit]`, mirroring the `garden-gardener-scaler.service` comment. Low risk (the foreman's own idle-detection/settle-debounce/cost-gate already make a spurious extra tick a cheap no-op), and it removes 60+/day of warning-log noise that currently obscures real signal in the monitoring surface.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T00:26:00Z
