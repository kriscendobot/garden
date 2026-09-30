---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-09-30T04:29:54Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: accountant arc apportionment (garden main2)

Implement designs/accountant-arc-apportionment.md on kriscendobot/garden main2
(§ Build plan): arc-spend.sh schema 2 (fixed weekly window_start), `arc:` job
field with `ratchet-arc` legacy alias across its readers, post-plan.sh --arc,
orchestration arc inheritance, rank ordering in the foreman deferred selector,
per-arc headroom in the foreman digest, set-apportionment.sh (atomic write of
config/apportionment + arc-budgets + generated foreman-mandate, with
--carry-forward), accountant-statement.sh, the edge-latched re-slice nudge, and
the accountant-weekly schedule (do not arm until the maintainer approves).
Tests beside scripts/jobs/test/ironhorse-press-budget-test.sh.
