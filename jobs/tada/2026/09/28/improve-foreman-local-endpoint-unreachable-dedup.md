The "local inference endpoint not reachable" branch now raises a throttled maintainer notice instead of only printing to stderr. The change is pushed to `main2` as `fac772d7c6c`.

**What changed**
- **`scripts/jobs/handlers/codex-provider-common.sh`**:
  - **Unreachable branch:** it now builds the diagnosis into `msg` and calls `alert_maintainer "local-endpoint-unreachable-${GARDEN}" "$msg"`, then prints it to stderr. This mirrors the "serves no $model" branch, so repeated foreman ticks fold into one notice whose count rises.
  - **When the notices close:** once the endpoint is ready, directly or after a successful hermit self-heal, both `local-endpoint-unreachable-${GARDEN}` and `ollama-model-less-endpoint-${GARDEN}` are cleared with `alert_maintainer_clear`. Each clear is a single file test when nothing was raised. If the endpoint answers but lacks the model, the unreachable notice is cleared, because the endpoint is reachable again.
  - **Model-less notice:** it had no clear anywhere before, so it now closes when the endpoint recovers instead of staying open.
- **`scripts/jobs/test/hermit-ollama-self-heal-test.sh`**: a new UNREACHABLE ALERT section checks that two down ticks produce exactly one notice, and that recovery sends one RECOVERED notice and clears both saved alert states.

**Tests**
All four related test suites pass:
- `hermit-ollama-self-heal-test.sh`: 33/33
- `foreman-provider-order-test.sh`: 28/28
- `mentor-provider-order-test.sh`: 40/40
- `ollama-serve-backoff-test.sh`: 15/15

**Follow-ups**
- The stderr diagnosis is still printed on every tick, as the model-less branch does, so `journalctl -p warning` will still show one line per tick. The maintainer inbox is the part that is now deduplicated. If the journal noise should go too, the print could be limited to ticks where the alert is actually delivered.
- The actual outage on host `endolin-garden-ece02cb4` (no Ollama unit serving) is not fixed by this change. It needs an operator to either start a serving unit or remove `local` from the foreman's provider order.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-local-endpoint-unreachable-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (477638 cached reads)
- Output: 5022 tokens
- Cost: $0.6690236
- Wall-clock: 118s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
