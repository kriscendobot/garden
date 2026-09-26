Done.

## Completion report

**What I did:** Added `StartLimitIntervalSec=0` under the `[Unit]` section of `scripts/systemd/garden-foreman.service`, with an explanatory comment mirroring `garden-gardener-scaler.service`.

**What changed:** `garden-foreman.service` was the only edge-triggered oneshot missing the start-rate-limiter override, despite `foreman_kick()` firing `start --no-block garden-foreman.service` on *every* gardener job completion fleet-wide. Bursts of near-simultaneous completions were tripping systemd's default `StartLimitBurst=5`/`StartLimitIntervalSec=10s` and producing "Start request repeated too quickly" refusals (60+/day observed 2026-09-01). Disabling the limiter matches the fix already present on `garden-gardener-scaler`, `garden-local-model-pull`, `garden-root-maintenance`, `garden-bulletin`, and `garden-ollama`.

**Commit:** pushed to `main2` (rebase CAS loop, succeeded first attempt).

**Follow-ups:** The unit file change takes effect where the unit is (re)rendered/reloaded — the next `deploy-garden.sh` + `install-units.sh` reconcile on the leader host will lay down the updated unit and `systemctl --user daemon-reload`. No code/behavior change beyond the systemd override; low risk as noted (a spurious extra foreman tick is a cheap no-op behind the existing idle/settle/cost gates).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-start-rate-limit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (182202 cached reads)
- Output: 1796 tokens
- Cost: $0.48201399999999994
- Wall-clock: 33s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
