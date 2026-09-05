---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Produce a data-substantiated version of the token-per-quota-ratio report and
publish it as a minion.town clip, per `skills/minion-town-clip-publishing/SKILL.md`.
The prior narrative-only clip
(https://ajvxs5h6lujdqvqlydsiod6ignqj67aimvs73ap2fak4paw4i2xq.ocap.site/, from
`budget-calibration-report-20260904`) asserted findings without showing the
underlying data; this version must show it — every claim needs a chart or table
backing it, not prose alone.

**Data sources** (read, don't re-derive): `journal/budget/manual-checkpoints/
endolin-garden-ece02cb4.jsonl` and `...-5bcdff64.jsonl`, `journal/budget/
reset-events/*.jsonl`, `journal/config/budget-pools`, and the completion reports
`journal/jobs/tada/budget-calibration-20260904.md` and
`.../budget-calibration-report-20260904.md`.

**Required charts/tables** (illustrative, not exhaustive — cover whatever else in
the data substantiates a claim you make):

- A scatter plot of meter `spend` vs. dashboard `weekly_percent` for
  `endolin-garden-ece02cb4`, points colored/grouped by `window_start_epoch`
  incarnation, with the fitted regression line for the chosen fresh 40%-56%
  cluster overlaid (slope 1,354,521 tokens/point, intercept 8,516,853) — visually
  showing WHY that cluster was chosen over the other two incompatible ones (the
  17%-28% and 30%-37% clusters), not just asserting it.
- A table of every checkpoint (both hosts, chronological) with columns for
  checked_at, weekly_percent, session_percent, meter_spend_tokens,
  pairing_confidence, and implied_weekly_cap_tokens, so a reader can audit the
  regression input directly.
- A timeline/annotated chart marking the reset-events (the 2026-09-04T21:57Z
  early-dashboard discontinuity and the 2026-09-05T03:00Z confirmed on-schedule
  reset) against the raw weekly_percent readings, showing the "crash-then-real-
  reset" shape rather than just describing it.
- A current-state summary card per pool: `endolin-garden-ece02cb4` at the new
  calibrated 143,000,000-token cap (provenance `manual-regression-fresh-
  contiguous-cluster`), and `endolin-garden2-5bcdff64` now restored to
  `weekly-tokens` but explicitly `uncalibrated` (5% weekly / 30% session as of
  2026-09-05T03:43Z, no meter pairing available yet) — make the confidence
  difference between the two pools visually obvious, not just stated.

**Constraints:** the clip's CSP is same-origin only (`script-src`/`style-src`/
`connect-src 'self'`, `img-src 'self' data:` — no CDN, no cross-origin fetch); ship
any charting JS/CSS as separate same-origin files, or prefer inline SVG that needs
no library at all. Consult the `dataviz` skill's form/color/accessibility guidance
for chart design even though the publishing mechanism here is a minion.town clip,
not a Claude Artifact. Verify the published clip with `curl -i` (static/immutable
serving) and a Playwright pass confirming the charts actually render (data
present, no horizontal overflow, readable in both light and dark if you make it
theme-aware). Report the published clip URL in your tada report.
