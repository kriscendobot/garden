---
posted_at: 2026-11-07T05:52:24Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/minion-town-press-preflight.sh
Defect: `scripts/jobs/minion-town-press-preflight.sh:146` only recognizes completed idle reports, while the arc press exhausted its retry without completion at 2026-11-07T05:24:11Z and repeated `jobs/plan/minion-town-arc-press-*` failures remain invisible to its gate. Extend the gate for the arc schedule to recognize recent same-prefix `requeue-exhausted` plan records and park dispatch with one deduplicated maintainer notice. Wire that preflight into `schedules/minion-town-arc-press.md` so a repeatedly nonproductive supervisor does not consume another agent tick before its failure is resolved.
