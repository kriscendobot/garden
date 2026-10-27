---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-27T04:33:07Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the budget road

Implement `designs/budget-road.md` (status Accepted after the preceding revise job) on garden `main2`: the garden's own repo is pushed directly, no PR. Follow the design's Migration section and ownership map exactly.

Order (the design's gap first): 
1. Make the foreman's own `claude -p` calls write usage rows, so unmetered foreman spend is not counted as the maintainer's. This lands before lanes go live.
2. Add `posted_at:` to job posts (mtime as fallback).
3. The single shared budget function; `allocation/road.json`; `set-road.sh` with its verbs (`show`, `focus`, `unpin`, `add`, `drop`, `alias`, `lanes`, `init`); generated `mandate.md` and README.
4. Foreman and claim-gate changes: the verdict words stay `ok`/`backoff`/`unknown` so `pool_admits` and `claim-job.sh` need no logic change; deferred promotion by lane groups, then road rank; one "Budget spent" notice on full exhaustion, at most daily.
5. Accountant weekly becomes a statement; retire the re-slice nudge and the `unallocated` arc.
6. Tests for the formulas (maintainer reserve decay, lane reservation, discretion, the 0.90 ceiling), admission, and promotion order, plus a dry-run of `init` against the live slate.
7. DO NOT cut over live in this job. Stop with `set-road.sh init --dry-run` output and a rollback note; leave the actual cutover (which removes `config/apportionment`, `config/foreman-mandate`, and schema-2 arc-budget files in one commit) for a maintainer go-ahead, because it re-keys every budget decision in the fleet.
Update docs/skills/roles listed in the design's touch list. Keep the shell tests passing and run the repo's pre-push gates.

