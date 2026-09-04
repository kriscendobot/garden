---
gate: go-ahead
priority: normal
role: builder
posted_by: designer
posted_at: 2026-09-04T05:43:53Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build the garden-side ingest counterpart for the usage-dashboard scraper, per `designs/claude-usage-dashboard-scrape.md` § Follow-on work (landed on main2, job `design-claude-usage-dashboard-scraper`).

A deterministic, leader-only, no-`claude` timer following the sysop/reaper/watcher pattern and `scripts/jobs/common.sh` `ensure_clone`/`sync_clone`/CAS-push discipline:
- `scripts/jobs/usage-scrape-ingest.sh` + `garden-usage-scrape-ingest.{service,timer}` unit (installed by `install-units.sh`, gated `is-main-host.sh`).
- Tail each `journal/inbound/usage-scrapes/<host>.jsonl` from a per-host consumed-offset cursor (e.g. `journal/inbound/usage-scrapes/.cursor/<host>`); idempotent so a re-run never double-appends.
- Project each new `usage-scrape/v1` line into a `journal/budget/manual-checkpoints/<host>.jsonl` row exactly per that log's README (drop scrape-only fields, compute `implied_weekly_cap_tokens`, carry the new `boost_banner` field, `reported_by: "playwright-usage-scraper"`), then CAS-commit+push.
- Do NOT reimplement reset-bracket detection: reset-events population stays `design-reset-time-detection`'s detector over the checkpoints. This ingest's job is narrow (staging -> manual-checkpoints).

Cross-check `design-manual-quota-calibration` / `design-reset-time-detection` state before building in case they landed a shared `append-quota-checkpoint.sh`-shaped helper this should reuse rather than duplicate.
