---
created: 2026-10-27
author: gardener (job build-budget-road)
---

# The budget road: operating it

The road is a standing ordered list of arcs. Two lanes, primary and
secondary, follow it to the first arcs that have planned work. It replaces the
accountant's weekly slate. Rationale and formulas:
[designs/budget-road.md](../../designs/budget-road.md).

## State

- `allocation/road.json` on `journal2` is the source of truth: `lanes`, the
  `pinned` head, `arcs` (each with a `summary`), `aliases`, and who authorized
  the change. `allocation/mandate.md` (the foreman's priority mandate) and
  `allocation/README.md` (the road for people) are generated from it. `git log --
  allocation` is the record of the maintainer's focus.
- `config/maintainer-reserve` is k, the maintainer's share at window start
  (default 0.50). Writer: `scripts/jobs/set-maintainer-reserve.sh`.
- The 0.90 ceiling is a constant in `budget_road`, not a setting.
- `config/token-backoff-fraction` (the pin) is unchanged: it can only lower the bound.
- Host-local: `$GARDEN_STATE/budget/road/<subscription>` holds P and last week's
  closing P; `$GARDEN_STATE/budget/road-cache/` caches the computation for two
  minutes. The owning host publishes `road_w_kris:` and `road_p:` in its
  `budget/live/<subscription>/<host>` snapshot.

The road is **armed** when `allocation/road.json` exists or
`config/maintainer-reserve` is set. Unarmed, every reader keeps the old
ramp-and-cap behavior and the slate (`config/apportionment`,
`config/arc-budgets/*`, `config/foreman-mandate`) stays in force.

## Reading it

```sh
scripts/jobs/set-road.sh show
```

It prints one line per pool (u, t, the maintainer's reserve R_k, the lane
reservations, discretion now and at the reset, the verdict), then the road in
order with each arc's lane and admission (`reserved`, `discretion`, `held`), or
`(no planned work)`. Every reader is the one function:

```sh
bash -c 'source scripts/jobs/common.sh; budget_road <journal-clone> [subscription]'
```

## Changing it (the liaison, on the maintainer's word)

Every writer verb takes `--authorized-by <maintainers/allowlist login>`,
`--note "<the maintainer's words>"`, and `--message-id <id>`, and `--dry-run`
previews without pushing.

```sh
set-road.sh focus <arc> [--summary T]     # to the head of the pinned list
set-road.sh unpin <arc>                   # stays on the road, ordered by recency
set-road.sh add <arc> --summary T         # a new unpinned arc
set-road.sh drop <arc>                    # off the road: discretion only
set-road.sh alias <old> <arc|->           # fold a retired arc (- = unarced)
set-road.sh lanes <primary> <secondary>   # shares summing to 1
```

To put X in the primary lane and Y in the secondary, run `focus Y`, then
`focus X`. **After every `focus`, run `show`.** An arc whose only plans wait on
`go-ahead`, or a chain parked `blocked` behind a foundation still in `plan/`,
has no planned work and holds no lane. Tell the maintainer what gates it and ask.

## Admission and the foreman

- The claim gate (`pool_admits` → `meter_quota_status`) reads the road verdict
  for Anthropic weekly-tokens pools: `ok` below 0.90 − R_k, `backoff` at the
  reserve, at the ceiling, at a pin, or when everything is spent, and `unknown`
  with no utilization sample. Other pools keep a flat verdict, capped at 90.
- The foreman promotes deferred plans by lane group (holders with reservation,
  then discretion), then by road rank; a held arc's plans are skipped as
  `arc-held:<arc>`. Its digest carries `allocation/mandate.md` and an
  `arc_admission` block, and it refuses a step for a held arc.
- The foreman's own Claude calls write `usage/foreman-<YYYYMMDD>.jsonl` rows, so
  its spend is the fleet's, not the maintainer's.
- One maintainer notice, **"Budget spent"**, at most daily per pool, only when
  every reservation and the discretion are spent.

## Cutover (needs the maintainer's go-ahead)

The cutover re-keys every budget decision in the fleet, so it is never done by
a build job. With the maintainer's word:

1. Preview against the live slate:
   `scripts/jobs/set-road.sh init --from-slate --dry-run --authorized-by <login>`.
   `--from-slate` pins the minion.town focus by default (`--pin a,b,…` to change).
2. `scripts/jobs/set-maintainer-reserve.sh 0.50` (1 − `token-backoff-initial`).
3. `scripts/jobs/set-road.sh init --from-slate --authorized-by <login> --note "…"`.
   One commit writes `allocation/` and removes `config/apportionment`,
   `config/foreman-mandate`, and every schema-2 `config/arc-budgets/<arc>`.
   Schema-1 rolling arcs (the Ironhorse press) stay.
4. Rewrite the `accountant-weekly` schedule body to the statement procedure
   (`set-schedule.sh`); the re-slice nudge goes quiet on its own once the road
   exists.

**Rollback:** `git revert` the `init` commit on `journal2` (and remove
`config/maintainer-reserve`). With no `allocation/road.json` the dormant code
falls back to the ramp and the restored slate.
