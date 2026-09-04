# Skill: claude-usage-dashboard-scrape

Read the Claude.ai usage dashboard through an authenticated headless browser on the
**host** and hand the two limit percentages, their reset times, and the temporary-boost
banner to the garden by appending one JSON line to a staging file under the shared
mount. Design: [`designs/claude-usage-dashboard-scrape.md`](../../designs/claude-usage-dashboard-scrape.md).

> **This runs on the HOST, under the maintainer's own identity — never inside the
> garden container, never as a gardener job.** Its session credential is a bearer
> token for your Claude account. See § State for where it lives and why it must never
> touch the garden root.

## Purpose

Replace the hand-typed quota checkpoints (`journal/budget/manual-checkpoints/`,
`journal/budget/reset-events/`) with an automated, tightly meter-paired read, and
capture the plan-wide boost banner that confounds calibration on every run. The
scraper is a **producer only**: it feeds `design-manual-quota-calibration`
(ratio fitting) and `design-reset-time-detection` (reset brackets); it does neither
itself.

## Inputs

- **Playwright + Chromium** installed on the host (`npm i playwright && npx playwright
  install chromium`), outside the garden container.
- **Config** `~/.config/garden-usage-scraper/config.json`:
  `{ "url": "https://claude.ai/chat/<account-id>#settings/usage", "host":
  "<GARDEN-identity>", "journal_root": "<host path to the garden's journal checkout>",
  "timezone": "America/Los_Angeles" }`. CLI flags override individual values. Nothing
  sensitive lives here.
- **Program:** `scripts/host/scrape-claude-usage.mjs` (delivered by the follow-on
  build job `build-claude-usage-dashboard-scraper` — see § Notes).

## State (READ THIS — the trust boundary)

- **Session credential lives host-only, outside `<garden-root>`:**
  `~/.config/garden-usage-scraper/storageState.json`, directory mode `0700`, file mode
  `0600`. It is a live claude.ai session token. It must **never** be written anywhere
  under the garden root, because the container bind mount (CLAUDE.md § Container guard,
  § Host environment) would expose it to the bot-identity fleet. The script refuses to
  write it under the garden root and refuses to run if its mode is looser than `0600`.
- **Only derived readings cross into the garden** — the staging append below carries
  no cookie, token, or credential value, ever.
- **Cursor / tracked logs** live on the garden side, written by the ingest, not by
  this host program.

## Procedure

1. **One-time bootstrap (interactive, by the maintainer):**
   ```sh
   node scripts/host/scrape-claude-usage.mjs --bootstrap
   ```
   A headed Chromium opens at claude.ai. Log in by hand (whatever flow your account
   uses). When the usage page renders its meters, the script persists `storageState`
   to the host-only path and exits. Re-run this whenever a headless run reports an
   expired session.

2. **Each read (headless, repeatable — cron/systemd/manual):**
   ```sh
   node scripts/host/scrape-claude-usage.mjs
   ```
   It restores `storageState`, opens the usage page headless, reads the meters, reads
   `journal/budget/live/<host>` in the same invocation for a same-second meter
   pairing, and appends one `usage-scrape/v1` row to
   `journal/inbound/usage-scrapes/<host>.jsonl`.

3. **Cadence** is your choice — a host `cron` line or `systemd --user` timer at, say,
   30–60 min. The garden does not schedule this program.

## Reading failures

- **"Session expired — re-run --bootstrap"** (non-zero exit, nothing written): the
  headless run hit a login/redirect instead of the dashboard. Re-run step 1. A failed
  read never writes a garbage row.
- **A row with a non-empty `warnings` array** and `pairing_confidence` below `high`:
  `aria-valuenow` disagreed with the plain-text `% used` duplicate — a possible
  one-sided markup change. Both values are recorded; investigate the page markup
  before trusting the number.
- **No new row appears in the tracked `manual-checkpoints/<host>.jsonl`:** the host
  append is fine; check the garden-side ingest timer (`garden-usage-scrape-ingest`),
  which is the half that CAS-commits staged rows into the tracked log.

## Output shape

One JSON object per line appended to `journal/inbound/usage-scrapes/<host>.jsonl`
(`schema: "usage-scrape/v1"`), carrying `weekly_percent` / `session_percent` (from
`aria-valuenow`), their absolute-UTC reset times (`*_resets_at`, derived from the
relative dashboard text plus the configured timezone; the session reset is a
timezone-free duration), the verbatim `boost_banner` (or `null`), the same-invocation
meter fields from `budget/live/<host>` (`meter_spend_tokens`, `meter_sampled_at`,
`meter_window_start_epoch`), `pairing_confidence` (`high` on a clean automated run),
and a `warnings` array. Full field list in the design doc § Output. `reported_by` is
`"playwright-usage-scraper"`.

## Notes

- **The executable is a follow-on build**, not part of this skill scaffold. Two jobs
  carry it: `build-claude-usage-dashboard-scraper` (this host program) and
  `build-usage-scrape-ingest` (the garden-side deterministic timer that projects
  staged rows into `manual-checkpoints/<host>.jsonl`). Until they land, this SKILL is
  the specification of the contract they implement.
- **Select on `role="meter"` / `aria-labelledby`, never on Tailwind classes** — the
  ARIA attributes are an accessibility contract; the utility classes churn every
  rebuild. `aria-valuenow` is the exact integer percent.
- **Timezone** defaults to `America/Los_Angeles` and is recorded per row
  (`reset_tz_assumed`) so a wrong guess is auditable, not silently baked in.
- **Out of scope (future):** the dollar-denominated "Usage credits" section is a
  different mechanism; the first cut tracks only the weekly/session token limits.
