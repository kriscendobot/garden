---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-entry.sh
Validate any `project: <slug>` body tag against `projects/<slug>/` in the synced journal before posting, and fail loudly for unknown slugs. This would have rejected the minority `endojs-endo-but-for-bots` tag that made the daily Dependabot backstop miss its ledger; add a hermetic regression test.
