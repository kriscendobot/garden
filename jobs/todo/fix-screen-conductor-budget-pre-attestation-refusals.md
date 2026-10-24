---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
# Screen conductor attempt budget: don't count conductors refused before the exact-panel attestation

Garden repo (kriscendobot/garden, main2). File: scripts/jobs/screening/driver.py, `conductor()`.

Defect: the per-head conductor budget (`CONDUCTOR_ATTEMPTS = 3`, names
`screen-minion-town-pr<N>-<sha7>-conduct`, `-r2`, `-r3`) counts EVERY finished conductor
for that head, including ones that ran before the head had an exact-panel attestation and
were refused by the panel-freshness gate. Live case 2026-10-24: kriscendobot/minion.town#218
at 5e2b623 — the three conductors (jobs/tada/2026/10/24/screen-minion-town-pr218-5e2b623-conduct*.md)
were all refused `panel-head-freshness: stale ... review-required`; the fresh panel then
ran and the screen wrote an exact attestation at 19:32:52Z
(screenings/kriscendobot-minion.town/218/5e2b6232....json), but `conductor()` found all
three names in TADA and only emitted the STALLED notice. The PR sat green, un-drafted,
panel-clean and unmerged for 2h+. Commit 03fb3fa40f2 stopped NEW legacy attestations from
burning -rN retries but does not recover a head whose slots were already burned.

Fix shape (pick the simplest correct): only count a finished conductor against the
budget if it completed after the attestation's `screened_at` (or if the attestation it ran
under was `panel_match: exact`); otherwise derive the next free name past the burned ones.
Keep the bound for genuine post-attestation failures. Add a regression test alongside the
existing screening tests (35 screening tests in the repo) covering: three pre-attestation
refusals + exact attestation → a conductor is posted; three post-attestation failures →
STALLED notice. Run the screening test suite + shellcheck; push to main2.
