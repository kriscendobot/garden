---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-entry.sh
At scripts/jobs/journal-entry.sh:265-272, validate_projects dies on `project: endojs-endo-but-for-bots` (journalctl 21:23:03Z). The unit gets the `<owner>-<repo>` repo slug, but the journal's project directory is `endo-but-for-bots`. A gardener's entry is lost whenever it uses the repo-derived slug. Before dying, try to map the slug onto an existing `projects/<dir>`. Strip a leading `<owner>-` and accept the result if exactly one such tree exists in `$ref`. Rewrite the line to the canonical slug and log the normalization. Keep the hard failure for slugs that match nothing, and add a case to journal-entry-project-test.sh.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-19T00:15:38Z
