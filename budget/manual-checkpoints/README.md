# Manual quota checkpoints

Append-only observations keyed by subscription, never host. One file per
canonical subscription id. A row records `subscription_id`, `checked_at`,
`weekly_percent`, optional reset/session facts, and the nearest token-meter
pairing (`meter_spend_tokens`, `meter_sampled_at`,
`meter_window_start_epoch`, and `pairing_confidence`).

Live host contributions are paired from
`budget/live/<subscription-id>/<host>`. For a shared subscription token totals
are aggregated across mapped hosts while account-level percent observations use
the freshest sample.

`pairing_confidence` is `high`, `medium`, `low`, or `none`. Never compare rows
across a `meter_window_start_epoch` change. A percent decrease before a recorded
reset, an anchor change, or a note containing `DISCONTINUITY` is a series break:
rate inference starts a fresh baseline and does not smooth through the jump.
