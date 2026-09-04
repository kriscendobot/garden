---
gate: go-ahead
priority: normal
role: builder
posted_by: designer
posted_at: 2026-09-04T05:43:43Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build the host-side Claude usage dashboard scraper `scripts/host/scrape-claude-usage.mjs` per `designs/claude-usage-dashboard-scrape.md` (landed on main2, job `design-claude-usage-dashboard-scraper`) and its playbook `skills/claude-usage-dashboard-scrape/SKILL.md`.

Node ESM + `playwright`. Implement:
- `--bootstrap` (headed Chromium, human logs in once, persist `context.storageState()` to `~/.config/garden-usage-scraper/storageState.json`, dir 0700 / file 0600, refuse any path resolving under <garden-root>).
- headless replay (restore storageState, open the account's `#settings/usage`, scrape).
- ARIA scrape: `[role="meter"]` + `aria-labelledby` sibling text ("Current session" vs "All models" vs per-model rows); read `aria-valuenow` as the integer percent; cross-check the plain-text "N% used" duplicate and `aria-valuetext`, lowering `pairing_confidence` and appending a `warnings` entry on mismatch.
- reset-text parsing: session "Resets in 3 hr 12 min" -> now+duration (tz-free); weekly "Resets Fri 8:00 PM" -> next occurrence in the configured tz (default America/Los_Angeles), both stored as absolute UTC; record `reset_tz_assumed`.
- boost banner captured verbatim into `boost_banner` (or null) every run.
- same-invocation read of `journal/budget/live/<host>` for meter pairing (spend / sampled_at / window_start_epoch); pairing_confidence "high" on a clean run.
- expired-session detection: land on login/redirect (no meter within timeout) -> exit non-zero, "re-run --bootstrap", write NOTHING.
- append one `usage-scrape/v1` JSON line to `journal/inbound/usage-scrapes/<host>.jsonl`.
- one-time network-tap probe during implementation: check whether the page fetches an internal JSON usage endpoint; prefer it if stable, else the ARIA path.

Config `~/.config/garden-usage-scraper/config.json` { url, host, journal_root, timezone }, CLI overrides. This is a HOST program (maintainer identity, never the container, never a gardener job) — hence `scripts/host/`. No git, no bot credential in this program; it only appends to the staging file. Row schema, field list, and the trust boundary are fully specified in the design doc — do not re-decide them.
