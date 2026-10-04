---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/design-pr-gauntlet-coverage-audit.sh
entries/2026/10/04/223632Z-progress-gardener-9dc77b.md:24-32 shows #155 and #156 merged before their gauntlets could run; the audit only alerts (`scripts/jobs/design-pr-gauntlet-coverage-audit.sh:2-5,221-225`). Add a bounded new-PR path that promptly stages coverage for a newly observed bot-authored non-draft PR, while retaining the current alert-only treatment for historical backlog so it cannot repeat the mass-staging incident.
