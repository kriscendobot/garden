# Quota reset events

A record of when each host's Anthropic weekly quota actually reset — as
distinct from `../manual-checkpoints/`, which records *usage level* at a
point in time. This log records the *reset events themselves*: the scheduled
Friday 8pm Pacific reset, and any anomalous mid-week reset (kriskowal,
2026-09-03: *"Anthropic occasionally resets mid-week, as they did on Tuesday
this week"*).

One file per host: `<host>.jsonl`, append-only, newest last.

## Why this needs its own log, not just a note in manual-checkpoints

A reset is usually invisible to a coarse checkpoint sampler: usage percent
necessarily crosses zero somewhere between a high reading and the next, lower
reading, and with only two widely-spaced samples the exact crossing time is
unknown — it could be anywhere in that bracket. The scheduled Friday reset is
easy (its time is contractual, not inferred). The **anomalous** ones are the
problem: nothing announces them, and the only trace is a sudden usage drop
between two checkpoints or samples, so recovering their timing at all
requires deliberately looking for and recording that signature — and every
recorded instance narrows what "occasionally" means over time (how often,
what triggers it, whether it's a genuine Anthropic-side reset or a local
measurement artifact that only looks like one).

## Row schema

```jsonc
{
  "host": "endolin-garden-ece02cb4",
  "event_type": "scheduled-weekly",       // scheduled-weekly | anomalous-midweek | expected-next-scheduled
  "reset_at": "2026-09-01T18:17:54Z",     // best available estimate
  "reset_at_precision": "exact",          // exact | bracketed | extrapolated | scheduled
  "bracket_lower": null,                  // for bracketed/extrapolated: latest evidence BEFORE the reset
  "bracket_upper": null,                  // earliest evidence AFTER the reset
  "evidence": "free text citing the concrete artifact(s) this is grounded in",
  "recorded_at": "2026-09-03T21:30:00Z",
  "notes": "free text"
}
```

`reset_at_precision`:
- **exact** — a source timestamps the event directly (e.g. the local usage
  meter's own `window_start_epoch`, or a captured error message with a
  wall-clock time).
- **bracketed** — known to have happened between two specific, reasonably
  close timestamps, without a more precise source.
- **extrapolated** — interpolated from a high-then-low usage pair with no
  tighter bracket; least precise, and the interpolation method used should be
  named in `notes`.
- **scheduled** — a forward-looking expected reset per the known weekly
  cadence, not yet observed. Superseded by a real row once it happens (an
  anomalous reset before the scheduled time does NOT cancel the scheduled
  one — Anthropic's cadence is presumably calendar-fixed regardless of an
  off-cycle reset in between, but this is not yet confirmed either way; a
  future occurrence will show which is true).

## Open problem this log does not yet solve

There is a real, unresolved tension in the one anomalous event recorded so
far: `journal/config/budget-pools`' own header attributes it to a **local
credential/entitlement refresh artifact** ("This is not a new ceiling"), not
a genuine Anthropic-side reset — but kriskowal's framing on 2026-09-03 treats
it as Anthropic actually resetting mid-week. Both readings are consistent
with the same evidence (a sudden fresh-0% reading). This log deliberately
records the event and both interpretations rather than picking one; the
`design-manual-quota-calibration` job (posted 2026-09-03, see
`journal/jobs/` for its current state) or a follow-up should build the actual
automatic bracket-and-interpolate detector this log's schema anticipates —
recording the two known events here now is the seed data for that, not a
finished detector.
