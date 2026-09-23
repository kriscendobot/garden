# Manual quota checkpoints

Append-only observations keyed by subscription, never host. One file per
canonical subscription id. A row records `subscription_id`, `checked_at`,
`weekly_percent`, optional reset/session facts, and the nearest token-meter
pairing (`meter_spend_tokens`, `meter_sampled_at`,
`meter_window_start_epoch`, and `pairing_confidence`).

Live host contributions are paired from
`budget/live/<subscription-id>/<host>`. For a shared subscription token totals
are aggregated across mapped hosts while account-level percent observations use
the freshest sample. When aggregation actually spans more than one host the row
also carries `meter_hosts`: an auditable array of
`{host, spend, window_start_epoch, sampled_at, included}` records (excluded hosts
add an `excluded_reason`) so a reader can reconstruct the sum. `meter_spend_tokens`
is the sum of the `included` hosts, `meter_sampled_at` is the OLDEST included
sample (the conservative pairing instant), and a wide spread between the hosts'
sample times lowers `pairing_confidence` by a notch. A single-host subscription
omits `meter_hosts` and behaves exactly as before. Only hosts on the reference
`meter_window_start_epoch` (the freshest sample's anchor) are summed; a host on a
different or stale window is excluded and noted, never summed.

`pairing_confidence` is `high`, `medium`, `low`, or `none`. Never compare rows
across a `meter_window_start_epoch` change. A percent decrease before a recorded
reset, an anchor change, or a note containing `DISCONTINUITY` is a series break:
rate inference starts a fresh baseline and does not smooth through the jump.

A row may carry `supersedes`, whose value is the `checked_at` of an earlier row in
the same file that it wholly replaces (a mispaired or mis-aggregated observation).
The log stays append-only — the bad row is never rewritten; the correction is
appended with `supersedes` set (and a `notes` explaining the fix), and may reuse
the superseded row's own `checked_at` (it names the same human reading).
`fit-quota-calibration.sh` drops any row whose `checked_at` is named by another
row's `supersedes` before fitting, so a superseded observation never governs a cap.
