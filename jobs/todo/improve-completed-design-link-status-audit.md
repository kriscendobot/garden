---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/panel.sh
Defect at scripts/jobs/gardening/panel.sh:1075: its deterministic pre-passes do not audit linked design documents when a changed design declares completion; the 2026-10-22T18:41:21Z ergonomist result found linked documents still advertising incompatible unfinished status. Add a bounded static pre-pass that follows local Markdown design links from changed completed designs, detects contradictory incomplete-status claims, and forces the archivist with line evidence. Cover it with a fixture test so the signal is quiet when statuses agree.
