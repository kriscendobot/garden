---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# context-graph-size-audit-focused (recurring)

Re-run the focused context-graph size audit — library, context, roles, and
skills only (designs and journal/projects excluded, per maintainer directive:
large designs are one-shot rationale docs, not frequently reused context).

Run `scripts/context-graph-size-audit.py --exclude-root-glob 'designs/*.md'
--exclude-journal-seed 'projects/README.md'` (main2 checkout as `--main-root`,
the `journal/` worktree as `--journal-root`, `--date` = today).

Land the report as a NEW dated file,
`journal/reports/context-graph-size-audit-focused-<date>.md`, via
`scripts/jobs/land-journal-edit.sh`. Do not overwrite prior runs' reports —
each is a dated snapshot so size trends are comparable over time.

Complete with a short summary: documents walked, candidates flagged, report
path, and — when a prior focused report exists — how the largest-15 list and
candidate counts moved since the previous run (net growth is itself a signal
worth calling out).

Precedent runs: journal/reports/context-graph-size-audit-focused-2026-08-13.md
(the first, hand-posted run this recurring schedule continues).
