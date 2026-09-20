# Subscription reset events

One append-only JSONL file per canonical subscription id. Reset ownership is
independent even when two schedules currently coincide.

Rows carry `subscription_id`, `event_type`, `reset_at`,
`reset_at_precision`, evidence, and `cadence`. Calendar facts additionally carry
`schedule_weekday` (ISO 1..7), optional `schedule_time`, and `timezone`.
Day-only declarations intentionally omit the time; pacing uses the end of that
local day as a conservative deadline until it is refined.

`cadence: manual` never implies a weekday or period. Its window begins at the
last observed manual reset event, and no next reset is computed. This is the
required shape for `codex-endolin`.
