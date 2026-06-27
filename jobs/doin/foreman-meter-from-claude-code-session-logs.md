# Foreman token meter: re-point at Claude Code session logs (Max x20 subscription, NOT the API)

Map: **build** (garden infra) on the garden's own repo, branch main2. Isolated
worktree off origin/main2; explicit-pathspec commit; push HEAD:main2 via git-rebase
CAS loop.

Follow-up to `foreman-token-quota-backoff` (the gate landed in scripts/jobs/foreman.sh
but is DISARMED and its meter reads 0). Maintainer clarified 2026-06-27: **the whole
fleet runs `claude -p` on a SINGLE Claude Max x20 subscription** — not an API key.

## Why the current meter is wrong
- `usage-meter.sh` reads a hand-appended `$GARDEN_USAGE_LEDGER` that nothing populates,
  so `meter_window_total` returns 0 and `meter_quota_status` can never reach `backoff`.
- The Admin Usage & Cost API (`/v1/organizations/usage_report`) does NOT apply to a
  subscription — it's API-key/Console billing only. Do not wire it.

## Correct source: Claude Code's own session logs (ccusage-style)
- Authoritative consumed-token data already exists at `~/.claude/projects/**/*.jsonl`
  (~2724 files on endolinbot). Each assistant-turn line carries a `message.usage`
  object with `input_tokens`, `output_tokens`, `cache_creation_input_tokens`,
  `cache_read_input_tokens`, plus a timestamp.
- Re-implement `meter_window_total` to SUM billable tokens from these logs over the
  trailing `GARDEN_TOKEN_WINDOW_SECS` (default 7 days) — deterministically, in plain
  code (jq over the JSONL; require_tools jq). Define "billable" to match how the Max
  plan counts (start with input + output + cache_creation; document the choice and make
  it easy to adjust). Dedup by message id / line so re-reads don't double-count.
- Keep the existing handler-appended ledger path as an optional fallback, but the
  session logs are the primary source.

## Multi-host note
`~/.claude` is per-host. The Max x20 weekly quota is GLOBAL to the subscription. If the
fleet ever spans multiple hosts sharing the one subscription, per-host sums undercount —
aggregate across hosts via the journal (each host publishes its trailing-window total;
the meter sums them), or treat it as a documented single-host assumption for now. Pick
one and note it; default to single-host (endolinbot) with a clear TODO for aggregation.

## Arm the gate
- Set `GARDEN_TOKEN_WEEKLY_QUOTA` to the Max x20 weekly token allowance. If that number
  isn't cleanly machine-readable, take it as a config value (surface it as an open
  question to the maintainer in the report; do NOT guess a number into the unit silently)
  and wire it via the foreman unit env / a journal-tracked config so it's tunable.
- Align `GARDEN_TOKEN_WINDOW_SECS` / the window boundary to the subscription's weekly
  reset cadence (Claude Code `/usage` shows the reset; if not machine-readable, a rolling
  7-day window is the documented default).
- Keep `GARDEN_TOKEN_BACKOFF_FRACTION` (default ~0.85) high-water behavior.

## Coordinate with the current manual pause
The foreman is currently HELD by a systemd drop-in
(`~/.config/systemd/user/garden-foreman.service.d/pause.conf`, `ExecCondition=/bin/false`).
Do NOT remove that drop-in as part of this job — the maintainer lifts the manual pause
separately. This job makes the meter REAL so that, once unpaused, the foreman backs off
automatically near the weekly limit instead of needing a manual pause.

## Tests
Extend run-test.sh: a fixture of synthetic session JSONL lines → `meter_window_total`
sums the trailing-window tokens correctly and ignores older lines; under-quota →
`ok`/pump, at/over the high-water mark → `backoff`/no-pump; a missing/garbled log dir
fails OPEN with a logged warning (never wedge the pump on a broken meter).

Deliverable: a deterministic, subscription-correct weekly token meter the foreman gates
on, sourced from Claude Code's session logs, with the quota armed (or a clear open
question for the quota number), and the manual pause left untouched.

---
claim:
  host: endolinbot
  gardener: 37
  claimed_at: 2026-06-27T16:30:29Z
