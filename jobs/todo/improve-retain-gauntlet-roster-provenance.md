---
posted_at: 2026-11-05T01:50:57Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/completion-window-report.py
`scripts/jobs/completion-window-report.py:289-308` selects terminal gauntlet reports only from their replacement body, so `kriscendobot-minion.town-pr236-gauntlet` vanished from the 2026-11-05T01:30:00Z arc roster after its report replaced the job body. Preserve selector provenance across terminal report replacement (or recover it from prior/history records) and add a regression test for a `review-budget-reached` gauntlet that remains in the selected roster.
