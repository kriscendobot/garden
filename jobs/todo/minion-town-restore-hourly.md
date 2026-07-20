# Restore minion-town-agenda-review to hourly (weekend cadence reduction over)

The weekend cadence reduction (Fri 2026-07-17 -> Sun 2026-07-19, `minion-town-agenda-review` dropped
to 6h) is over. Restore it to **hourly**.

- In a synced `journal2` clone, edit `schedules/minion-town-agenda-review.md`: change the `cadence:`
  frontmatter line from `6h` back to `hourly`. Preserve everything else (body, prefix, preflight,
  last_dispatched). CAS-push to `journal2` (re-sync + retry on push race). If it is already `hourly`
  (someone restored it early), no-op and say so.
- Verify `origin/journal2:schedules/minion-town-agenda-review.md` reads `cadence: hourly`.

## Done
`minion-town-agenda-review` is back to hourly cadence on `journal2`.
