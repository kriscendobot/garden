---
gate: go-ahead
priority: normal
posted_by: build-budget-road
posted_at: 2026-10-27T05:18:36Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Cut over to the budget road

Maintainer go-ahead required: this re-keys every budget decision in the fleet.
Garden repo, journal2 only (no code change). Built by `build-budget-road`
(main2 89a77e757cb); procedure in context/operations/road.md § Cutover.

1. `scripts/jobs/set-road.sh init --from-slate --dry-run --authorized-by kriskowal` and check the preview.
2. `scripts/jobs/set-maintainer-reserve.sh 0.50` (1 - config/token-backoff-initial).
3. `scripts/jobs/set-road.sh init --from-slate --authorized-by kriskowal --note "<the go-ahead words>" --message-id <id>`
   (one commit: writes allocation/, removes config/apportionment, config/foreman-mandate, schema-2 config/arc-budgets/*).
4. Rewrite the accountant-weekly schedule body to the statement procedure (roles/accountant/AGENT.md § Under the budget road) with set-schedule.sh.
5. `set-road.sh show`; confirm the claim gate and foreman read the road (foreman decisions.log, budget_road).

Rollback: git revert the init commit on journal2 and remove config/maintainer-reserve.
