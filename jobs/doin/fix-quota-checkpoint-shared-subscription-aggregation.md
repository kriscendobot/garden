---
role: fixer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: append-quota-checkpoint.sh pairs a SHARED subscription with one host's spend

Repo: the garden itself (`kriscendobot/garden`, branch `main2`, push direct — no PR).

## Problem
`scripts/jobs/append-quota-checkpoint.sh` (~line 111–117) reads ONE live contribution:
`budget/live/<subscription>/$GARDEN` (falling back to the first file found). But
`journal/budget/manual-checkpoints/README.md` says that for a shared subscription the
token totals are aggregated across the mapped hosts. `codex-endolin` is shared by
`endolin-garden2-5bcdff64` and `endolin-garden-ece02cb4` (both run a cleric), so a
checkpoint recorded on garden2 paired the maintainer's 64% with that host's 3,044,024
tokens alone. The actual total was about 21.5M (the leader contributed 18,466,401 in
the same window, `window_start_epoch 1789808673`), so the row's
`implied_weekly_cap_tokens` is 4,756,288 instead of about 33.6M. The 2026-09-22T20:33:59Z
codex-endolin row has the same undercount, since it paired with just one host.

## Ask
1. Aggregate: sum `spend` over every `budget/live/<subscription>/*` file whose
   `window_start_epoch` matches (a host on a stale or different window must be excluded
   and noted, not summed). Derive `meter_sampled_at` and confidence conservatively: use
   the oldest sample, and lower the confidence if the hosts' sample times are far apart
   or a mapped host's file is stale. Record which hosts contributed (e.g. a
   `meter_hosts` field) so a reader can audit the sum. A single-host subscription must
   behave exactly as today. Keep `--host-file` working for tests.
2. Correct the data. The log is append-only, so do NOT rewrite the two bad codex rows.
   Append corrected rows that pair the SAME human readings (the 64% at 2026-09-23T16:17:20Z,
   and the 61% at 2026-09-22T20:33:59Z) with the aggregate spend at those times, which
   you can recover from the `budget-live(...)` commit history on journal2 for both hosts.
   Give each corrected row a `supersedes` field pointing at the original row's
   `checked_at` (and a note), then make sure `fit-quota-calibration.sh` ignores a
   superseded row. If the README's row schema has no supersession field, add one and
   document it.
3. Add a test with two hosts contributing to one subscription, plus one host on a
   mismatched window, and assert the summed spend and the implied cap. Run the
   existing budget/checkpoint test suites and push to `main2`.

Report: commit sha, the corrected implied weekly cap for codex-endolin, and whether
fit-quota-calibration needed changes.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T16:22:44Z
