scripts/jobs/insert-sections-table-row.sh
The row-inserter anchors on `/^##[ \t]+Sections[ \t]*$/` (line 90), which matches a topic page's `## Sections` heading exactly but NOT a concept page's `## Sections that touch this concept`. So scholars must place concept-page section rows by hand every cycle (self-reported by the scholar-ingest-dialog-db-remainder-8 gardener). Widen the heading match to accept the concept-page variant — e.g. `^##[ \t]+Sections\b` (or explicitly allow the `Sections that touch this concept` suffix) — while KEEPING the existing table-boundary anchoring (the deliberate design that fixed improve-sections-table-row-insert-anchor). Confirm the widened match cannot pick up an unintended heading and that both topic pages and concept pages route through the deterministic inserter, removing the recurring by-hand step. Add/extend a test in scripts/jobs/test covering a concept-page `## Sections that touch this concept` table.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  claimed_at: 2026-07-06T15:52:32Z
