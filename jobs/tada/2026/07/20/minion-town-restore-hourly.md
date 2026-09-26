Verified — `origin/journal2:schedules/minion-town-agenda-review.md` now reads `cadence: hourly` with all other frontmatter (`last_dispatched: 2026-07-20T14:50:05Z`, `job_basename_prefix`, `role: gardener`) and the body preserved. The trailing error is just the shell noticing I removed the temp clone (its cwd) during cleanup — harmless.

## Completion report

**What I did:** Restored the `minion-town-agenda-review` schedule to hourly cadence on `journal2` after the weekend cadence reduction (Fri 2026-07-17 → Sun 2026-07-19).

**What changed:** In a fresh synced clone of `journal2`, edited `schedules/minion-town-agenda-review.md`, changing the frontmatter line `cadence: 6h` → `cadence: hourly`. Body, prefix, preflight, `last_dispatched`, and all other frontmatter left untouched. Committed and CAS-pushed to `origin/journal2` (`92467bd5a..7fe83b6e1`); the first attempt lost a push race, so I fetched, rebased onto the latest `origin/journal2` (which had a concurrent README change), and re-pushed cleanly.

**Verification:** `git show origin/journal2:schedules/minion-town-agenda-review.md` now reads `cadence: hourly` on line 1, with the rest of the file preserved.

**Follow-ups:** None. The scheduler will resume hourly dispatch on its next tick.
