# The budget road: an ordered list of arcs and two lanes

| | |
| --- | --- |
| Created | 2026-10-27 |
| Author | designer (job `design-budget-road`) |
| Status | Accepted (maintainer decisions, liaison session 2026-10-27; review [kriscendobot/garden#127](https://github.com/kriscendobot/garden/pull/127)). Built and dormant (job `build-budget-road`; operator page [context/operations/road.md](../context/operations/road.md)); cutover (`set-road.sh init`) awaits the maintainer's go-ahead. |
| Source | The tower's [*The road and its lanes: budgeting a fleet by focus*](https://tower.kriskowal.com/f7koc4preplunizm7bx55vtxf4/) (Kris Kowal, 2026-10-26), written for the garden to rebuild |
| Replaces | [accountant-arc-apportionment.md](accountant-arc-apportionment.md) (the weekly slate, the schema-2 arcs, the `unallocated` reserve, the re-slice nudge); [foreman-discretion-budget-pool.md](foreman-discretion-budget-pool.md) (Proposed, unbuilt: its three linear pools are this design's maintainer reserve, lanes, and discretion) |
| Subsumes | [standing-token-backoff-ramp.md](standing-token-backoff-ramp.md) (with no maintainer spend, the road's ceiling is that ramp lowered by 0.10: 0.40 → 0.90) |
| Keeps | [subscription-budget-model.md](subscription-budget-model.md), [live-budget-admission.md](live-budget-admission.md) (meter, pools, claim gate), [budgeted-campaign-dispatch.md](budgeted-campaign-dispatch.md) (`--budget-tokens`), the schema-1 rolling arcs ([ironhorse-ratchet](../context/operations/ironhorse-ratchet.md)) |

## Why

Today the accountant asks the maintainer every Saturday to approve a **slate**:
`config/apportionment` plus one schema-2 `config/arc-budgets/<arc>` token cap per
arc (eight arcs and an `unallocated` reserve as of the week of 2026-10-24). In
practice the maintainer can push only a couple of arcs to success at a time. A
slate of eight caps spreads the fleet thin. It needs a weekly round-trip that has
become a carry-forward ritual (the 2026-10-02 directive: "keep distributing tokens
to this ranking … each reset"). It also parks budget on arcs with nothing
runnable. `plan_deferred_status` holds an arc's plans the moment its cap is
spent, while another arc's cap sits idle with no ready plans.

The road replaces the slate with:

- a standing ordered list of arcs, **the road**, which the maintainer reorders
  when their focus moves; and
- two **lanes**, fixed shares that follow that focus down the road to whichever
  arcs have work.

Nothing is approved weekly. The road stands until the maintainer changes it.

## The model

The fleet never plans past **0.90** of any subscription: that is the
**ceiling**, fixed, not configurable per road (the 2026-10-02 directive, "spend
each subscription to 90%, never 100%", confirmed by the maintainer 2026-10-27).
The last 0.10 of every week is never the fleet's.

Below the ceiling, each subscription pool's week is split in two. Half the pool
(k = 0.50) belongs to the **maintainer's own sessions**, and that reserve decays
to zero at the pool's reset. The rest under the ceiling, 0.40 of the pool,
belongs to the **arcs**, split between two lanes:

| Lane | Share of the arcs' part | Of the pool at window start | Held by |
| --- | --- | --- | --- |
| primary | 0.6 | 0.24 | the first arc on the road with planned work |
| secondary | 0.4 | 0.16 | the next arc on the road with planned work |

The 0.6 / 0.4 split is the designer's choice, not the maintainer's, and it is
easy to change: `set-road.sh lanes <primary> <secondary>` rewrites it in
`road.json` with no code change. There is no library lane, because the garden
has no ongoing library curation yet (maintainer, 2026-10-27). One can be added as
a third entry in `lanes` once curation is ongoing.

Each lane's reservation also decays over the week. Whatever nobody has reserved
is the foreman's **discretion**, spent in road order. Discretion is zero at the
start of the week, and it can reach the whole ceiling, 0.90 of the pool, by the
end of a week in which nobody else spent.

### Terms

| Term | Meaning |
| --- | --- |
| arc | A named stream of work, stamped on a job as `arc:` (`job_arc` in `common.sh`; `ratchet-arc:` stays a legacy alias). The unit the budget meters. |
| road | Every arc, in order: a pinned head in the maintainer's order, then the rest by recency of activity. |
| lane | A share of the arcs' part (c − k). Each lane is held by at most one arc at a time. |
| planned work | Work the foreman could admit or make right now (§ Planned work). |
| reservation | What remains of a lane's decaying share after its holder's spend this week. |
| discretion | Everything not used and not reserved. Arcs without a lane, lane holders past their reservation, and unarced work draw on it. |
| alias | A retired arc folded into its successor, for spend and for stamped jobs alike. |

### Formulas (per subscription pool)

Everything is a fraction of the pool's week, 1.0.

- **t** is the fraction of the pool's window gone: 0 at window start, 1 at the
  deadline, to the minute. It comes from the same `subscription_pacing_window`
  output that `token_backoff_ramp_window` uses today, so the road and the ramp
  read one window per subscription.
- **u** is the pool's newest seven-day utilization:
  `subscription_used_percent / 100`. Its primary source is the
  `rate_limit.seven_day.utilization` that `usage_capture_rate_limit` already
  records on each Claude usage row. A fresher manual checkpoint wins, as it does
  today. If neither source has a figure, u falls back to the token/cap ratio that
  `meter_quota_status` computes.

| Term | Value |
| --- | --- |
| c | the ceiling, fixed at 0.90 |
| k | the maintainer's share at window start, default 0.50 (`config/maintainer-reserve`) |
| maintainer's reserve R_k | max(0, k·(1 − t) − kris_u) |
| lane share s_l | primary 0.6, secondary 0.4 (`road.json` `lanes`) |
| lane reservation R_l | max(0, s_l·(c − k)·(1 − t) − arc_u_h), where h is the lane's holder now; 0 for an empty lane |
| discretion D | c − u − R_k − Σ R_l |

With no spend, D is 0 at window start and c = 0.90 at the reset. Spending inside
a reservation moves u and that reservation by the same amount, so D does not
move. Only time, overspending, unlaned work, and a change of holder move it.

The fleet may admit work while **u < c − R_k = 0.90 − R_k**. R_k is never
negative, so the fleet never plans past 0.90, even at the reset. When the
maintainer has spent nothing, the bound is 0.40 + 0.50·t: the standing ramp from
`config/token-backoff-initial = 0.50` (0.50 + 0.50·t, reaching 1.00 at reset),
lowered by the 0.10 the fleet never plans to spend. The old ramp's "reaches 100%
at reset" (2026-09-28) therefore does not survive; the newer 2026-10-02 directive
governs, and the road's bound reaches 0.90 at reset. The other difference is that
the maintainer's own spend inside the reserve no longer counts against the
fleet. That is the point of the reserve, and it is why the ramp is subsumed
rather than kept alongside. The ceiling binds only the fleet's admission: the
maintainer's own sessions are never gated, and they may take u past 0.90.

### Turning tokens into utilization

The provider reports u only for the whole pool. To charge spend to arcs and to the
maintainer, convert tokens through **P**, the weighted tokens per unit of
utilization.

- **Weights** follow list-price ratios: input 1, output 5, cache creation 1.25,
  cache read 0.1. The tower found that raw billable tokens per unit of
  utilization ranged over almost two orders of magnitude, while weighted tokens
  held within about 10% from week to week. The garden's `_meter_session_total`
  "billable" sum (input + output + cache creation, cache read excluded) remains
  the fallback for the legacy cap path. The road uses only weighted tokens.
- **Calibration:** P = (W_fleet + W_maintainer) / u, taken from the current week
  once u ≥ 0.10, where the provider's 0.01 rounding costs at most 10%. Before
  that, use last week's closing P. With neither, the conversion is unknown: R_k
  holds whole (kris_u = 0), and every arc is open below the ceiling.
- **Spend:** fleet_u = W_fleet / P; arc_u_a = W_a / P (since window start, with
  aliases folded); kris_u = max(0, u − fleet_u).
- **W_fleet** is the weighted sum of the pool's `journal/usage/*.jsonl` rows
  since window start. Each row is attributed to its subscription through
  `config/subscription-mapping` on the row's `host` and provider.
- **W_maintainer** is counted on the owning host from the per-message `usage`
  fields of the Claude session logs that `meter_window_total` already reads
  (`GARDEN_CCUSAGE_LOGDIR`), **excluding** every job session
  (`job_session_dirs` plus `GARDEN_RETIRED_TRANSCRIPTS`). What remains is the
  liaison and other interactive sessions. Only token counts, message ids, and
  timestamps are read, never content, and only per-week sums are kept. Use on
  other machines goes unseen. That inflates fleet_u, so the error falls on the
  fleet, not the maintainer.
- **State:** P, its provenance (`current`/`last-week`/`-`), and W_maintainer are
  host-local, under `$GARDEN_STATE/budget/road/<subscription>`. The owning host
  also publishes them in its existing `budget/live/<subscription>/<host>` snapshot
  (`budget_publish_local_pool`), so the leader's foreman and accountant read the
  same figures as the owning host's claim gate.

## Admission, per arc, at each tick

- **reserved:** a lane holder whose lane has R_l > 0, while u < c − R_k. The
  maintainer's reserve is senior.
- **discretion:** a lane holder past its reservation, every arc without a lane,
  and unarced work, while D > 0, in road order.
- **held:** otherwise. An arc that runs out never stops the fleet by itself.

The **pool verdict** replaces `meter_quota_status`'s high-water comparison for
`weekly-tokens` Anthropic pools. It keeps the existing words, so `pool_admits`,
`claim-job.sh`, `budget_fleet_status`, and the foreman need no new vocabulary:

- `ok` while u < c − R_k and some arc has reservation or D > 0;
- `backoff` when R_k holds the fleet (subtype `reserve`), when u ≥ c (subtype
  `ceiling`, which is the same condition as `reserve` once R_k reaches 0), or when every
  reservation and the discretion are spent (subtype `spent`); only `spent`
  notifies the maintainer;
- `unknown` with no u sample yet, which fails open under the claim gate's
  existing sensor-grace logic.

`pool_admission_refusal` (unmetered or uncalibrated pools fail closed) is
unchanged and still runs first. The verdict is cached host-locally for about two
minutes, so the claim gate and the foreman do not each rescan the ledger.

The **pin** stays as an independent brake. `config/token-backoff-fraction`, with
its optional `until`, written by `set-token-backoff-fraction.sh`, means `backoff`
while u ≥ the pinned fraction, whatever the reserves say. A pin can only lower
the bound: a pinned fraction above 0.90 does not lift the ceiling. An environment
`GARDEN_TOKEN_BACKOFF_FRACTION` keeps highest precedence, as now.

**Other pools.** A pool without a reported utilization *and* a projected reset
gets no reserves. Today that is `codex-endolin` (`percent` kind,
`cadence: manual`) and any `weekly-usd` pool. Such a pool keeps today's flat
verdict against its configured ceiling, capped at 90 (codex-endolin's 95
becomes 90), or the pin.
Without a projected reset there is no window to decay across. An `unmetered`
pool stays a refusal, never unbounded. Arcs still order the foreman's work on
such pools by road rank. They have no reservations there.

## The road

### Order

1. The pinned head, in the maintainer's order.
2. Every other arc by recency of activity, newest first. Activity is the latest
   of the arc's usage-row `ts` (spend) and its planned jobs' posting time.
   Counting the posting time lets an arc the maintainer just gave work to rise
   before it has spent anything. Garden jobs carry no `posted_at:` today. The
   build adds it in `post-job.sh` and `post-plan.sh`, and until then the reader
   falls back to the file's mtime, as `plan_deferred_ranked` already does.
3. Arcs with no activity keep the stored order.

Finished jobs are not walked each tick: their spend is already in the usage rows.

### Planned work, mechanically

An arc has planned work when it has any of:

- a job stamped with the arc in `jobs/todo/` or `jobs/doin/`;
- a plan in `plan/` whose gate is `deferred` (or unset) and whose `not_before`
  has passed. This is `plan_deferred_status`'s temporal half, minus its arc-cap
  half, which this design deletes.

A plan gated on the maintainer (`go-ahead`, `awaiting-maintainer`), on another job
(`blocked`), or on an orchestration (`orchestrated`) is not planned work. A
running orchestration still lanes its arc through the child it has promoted into
`todo/`/`doin/`. The tower's third source, a roadmap item its roadmap tool marks
ready, has no garden equivalent yet. The foreman's milestone generation is the
garden's way of making new work, so that source is omitted, and an arc whose
only work is ungenerated milestones holds no lane.

### Laning

- Primary and secondary go to the first two arcs on the road with planned work.
  An arc with none cedes its lane to the next arc down.
- A lane with no holder is empty, and its share becomes discretion.
- A lane's spend is the week's spend of the arc holding it **now**. An arc drawn
  into a lane brings its spend with it, and the arc it displaced takes its own
  spend down the road. A mid-week change of focus takes effect at the next tick.
- Unarced work ranks after the road and draws only on discretion. So does any arc
  kept off the road with `drop`. The `unallocated` pseudo-arc
  (`GARDEN_ARC_RESERVE`) retires: `admission_arc` stops charging unarced plans to
  it.

## Files

The road lives beside the board it governs, on `journal2`, in `allocation/`.
One script writes it, in one CAS commit, and only on the maintainer's
authorization:

```
allocation/road.json   the source of truth
allocation/mandate.md  generated: the priority mandate in the foreman's digest (replaces config/foreman-mandate)
allocation/README.md   generated: the road rendered for people
```

```json
{
  "schema": 1,
  "lanes": { "primary": 0.6, "secondary": 0.4 },
  "pinned": ["minion-town-claude-api", "minion-town-mcp-ocapn", "minion-town-git-remote", "minion-town-ui"],
  "arcs": [
    { "arc": "minion-town-claude-api", "summary": "minion.town agents on the Claude API" },
    { "arc": "minion-town-mcp-ocapn", "summary": "minion.town operational over MCP and OCapN" },
    { "arc": "endo-ocapn-background", "summary": "Background Endo/OCapN: SturdyRef, byte arrays, streams" }
  ],
  "aliases": { "unallocated": null },
  "authorized_by": "kriskowal",
  "message_id": "",
  "notes": "the maintainer's words, verbatim",
  "set_by": "set-road",
  "set_at": "2026-10-27T00:00:00Z"
}
```

The lanes are armed whenever `road.json` exists. Without it there are no lane
reservations, the arcs' part is all discretion, and the foreman stamps no arc.
`R_k`, the 0.90 ceiling, and the pin apply either way. The ceiling is a constant
in `budget_road`, not a `road.json` field, so no road edit can raise it. `git log -- allocation` is the record of the
maintainer's focus. `config/maintainer-reserve` (k, default 0.50) is fleet
config beside `config/budget-pools`, not part of the road. The calibration and
the maintainer's weekly sums are host-local state (§ Turning tokens into
utilization).

## Verbs: `scripts/jobs/set-road.sh`

```
set-road.sh show                                    the road in order, each arc's lane and admission, or "(no planned work)"
set-road.sh focus <arc> [--summary T]               draw an arc to the head of the pinned list
set-road.sh unpin <arc>                             leave it on the road, ordered by recency
set-road.sh add <arc> --summary T                   a new arc, unpinned
set-road.sh drop <arc>                              take an arc off the road (its work draws only on discretion)
set-road.sh alias <old> <arc>                       fold a retired arc into another
set-road.sh lanes <primary> <secondary>             shares, summing to 1
set-road.sh init < road.json                        write the whole road, retiring the old slate
```

Every writer verb requires `--authorized-by <login>`, checked against
`maintainers/allowlist`. It also takes `--note` (the maintainer's words) and
`--message-id`. `show` is read-only. The **liaison** runs the writer verbs on
the maintainer's word: a liaison session, an issue-inbox comment, or a bus
reply. It then shows the maintainer `show`. To put arcs X and Y in the primary
and secondary lanes, run `focus Y`, then `focus X`. The last focus ends up first.

**After every `focus`, check `show`.** An arc focused to the head whose only plans
wait on `go-ahead` holds no lane. The lane passes to the next arc with work, so a
maintainer who says "put X in the primary lane" can be surprised. When `show`
prints "(no planned work)" for the focused arc, the liaison tells the maintainer
what is gated and asks. Likewise, a chain of fixes parked `blocked` behind a
foundation lanes its arc only while the foundation is in `todo/`/`doin/`. Post
foundations to `todo/`, not `plan/`.

## One function, every reader

The whole computation is one function, `budget_road` in a new
`scripts/jobs/budget-road.sh` (sourced by `common.sh`, beside `usage-meter.sh`):

```
budget_road <journal-dir> [<subscription>]
```

It emits TSV. An unknown number is `-`:

```
pool   sub t u P P_from kris_u R_k sum_R_l D verdict subtype D_at_reset c k fleet_u W_fleet W_kris resets_at
arc    sub rank arc lane share spend_u R admit W planned pinned last summary
alias  from to
```

`D_at_reset` (R_k and every R_l at 0) shows how much discretion the week will
end with if nothing more is spent. Every consumer reads this function and
nothing else: `meter_quota_status` (hence `pool_admits` and the claim gate), the
foreman's promotion order and digest, `accountant-statement.sh`, `set-road.sh
show`, `review-docket.sh`, and `quota-panel.sh`. They therefore cannot disagree,
the property `arc_headroom_lines` was built for, extended to the whole budget.

## The foreman's part

The gate order is unchanged: brake, capacity, settle, unblock, then budget,
deferred promotion, and generation. The road changes three of these steps.

1. **Budget.** The foreman reads the verdict. Both of its notices, the
   `token-backoff` note and the `fleet-budget-backoff` note, collapse into one
   maintainer notice, **"Budget spent"**. That notice goes out only for the
   `spent` subtype, at most once a day per pool, never for a pin, and never when
   R_k alone holds the fleet. `record_budget_halt` still records every halt.
2. **Deferred promotion.** Open slots fill from `plan/` in two groups:
   1. plans on lane holders that still have reservation, by road rank;
   2. then plans drawing on discretion (holders past their reservation, arcs
      without a lane, unarced work), by road rank.

   Within an arc, the existing order holds: leaf-first omega rank
   (`plan_deferred_ranked_omega`), then priority, then age. Plans on a held arc
   are skipped, and `plan_deferred_skipped` records them as `arc-held:<arc>` in
   place of today's `arc-budget-over:`. If anything was promoted, the tick ends
   without calling the model, as now.
3. **Generation.** The digest carries `allocation/mandate.md` in place of
   `config/foreman-mandate`, and an `arc_admission` block (rank, arc, lane,
   admit) in place of `arc_headroom`. The handler's `ARC` line contract is
   unchanged. A proposed step on a held arc is refused (`arc-refused`), and an
   accepted one is posted with `--arc` stamped.

**A metering gap to close first.** The foreman's own `claude -p` calls
(`handlers/foreman-claude.sh`) write no usage row today. Under the road that
unmetered spend would land in kris_u, shrink R_k, and *raise* the fleet's
ceiling at the maintainer's expense, the wrong direction. The build therefore
makes the foreman write one usage row per call
(`usage/foreman-<YYYYMMDD>.jsonl`, `role: foreman`, `arc:` the step's arc)
through `usage_ledger_stage_row`'s format, before the lanes are armed. A failed
capture is recorded as `source: none`, never as zero, as the gardener's rows
already are.

## The accountant becomes a statement

The weekly engagement stops asking for approval. `accountant-weekly` (Saturdays
09:00 America/Los_Angeles) runs `accountant-statement.sh`, now a renderer over
`budget_road`. The statement covers each pool's lanes, their holders, spend,
reservations, and discretion now and at the reset. It also covers the road's
order with any "(no planned work)" arcs and what gates them, plus the Demand
section from open `budget/requests/`. It sends the statement with
`message-user.sh` and completes without waiting for a reply. A reply that asks
for a change becomes a `set-road.sh` verb run by the liaison, not an accountant
re-slice.

Budget requests stay demand, not grants. A request is closed with
`close-budget-request.sh`, under the new disposition `routed`. That disposition
names the lane or discretion the requester's arc draws on, and it points a
maintainer-facing reprioritization ask at `focus`. The accountant no longer
writes any allocation file. The road's only writer is `set-road.sh`.

## Migration

One deploy, then one authorized `init`:

1. **Build** (`build-budget-road`): `budget-road.sh` / `budget_road`; the verdict
   swap inside `meter_quota_status` (dormant unless `allocation/road.json` exists
   or `config/maintainer-reserve` is set); W_maintainer counting; P calibration
   and its snapshot publication; foreman usage rows; `posted_at:` stamping;
   `set-road.sh`; the foreman's promotion order and digest; the accountant
   statement rewrite. Tests: a hermetic fixture per formula row and per
   admission case. Cases include the 0.90 ceiling at reset (u = 0.90 with
   R_k = 0 is `backoff`), a pin above 0.90 not lifting it, the holder change mid-week, the `go-ahead`-only
   arc that cedes its lane, a blocked chain, no u sample (`unknown`), P unknown
   (R_k whole), the pin overriding `ok`, and codex-endolin staying flat.
2. **Seed k.** Write `config/maintainer-reserve = 1 − token-backoff-initial`
   (0.50 today). `set-token-backoff-initial.sh` becomes `set-maintainer-reserve.sh`
   (a thin rename; the old name prints a redirect).
3. **`set-road.sh init`**, authorized by the maintainer, writes a `road.json`
   from the live slate. The pinned head is the maintainer's minion.town focus
   (2026-10-27), in this order: `minion-town-claude-api`, `minion-town-mcp-ocapn`,
   `minion-town-git-remote`, `minion-town-ui`. Any of the four not already a slate
   arc is added. The other slate arcs are unpinned, keeping slate order as the
   stored order, and rank by recency of activity. `garden-book` and `endo-backlog`
   carry over as ordinary arcs, and `unallocated` becomes an alias to null
   (unarced). In the **same commit**, `init` removes `config/apportionment`,
   `config/foreman-mandate`, and every **schema-2** `config/arc-budgets/<arc>`.
   Schema-1 rolling arcs (`set-arc-budget.sh`, the Ironhorse press) stay: they
   are campaign-level bounds that `arc-spend.sh` still reads, and they compose
   inside a lane the way `--budget-tokens` does.
4. **Schedules.** Rewrite the `accountant-weekly` schedule body to the statement
   procedure. Retire the re-slice nudge (`accountant-reslice-nudge.sh` and its
   timer), since the foreman's "Budget spent" notice replaces it.
5. **Mark superseded** [accountant-arc-apportionment.md](accountant-arc-apportionment.md)
   and [foreman-discretion-budget-pool.md](foreman-discretion-budget-pool.md), and
   mark [standing-token-backoff-ramp.md](standing-token-backoff-ramp.md) subsumed.

Rollback is `git revert` of the `init` commit, which restores the slate files.
The dormant code then reads no `road.json` and falls back to today's
ramp-and-cap behavior.

## What it touches

| Path | Change |
| --- | --- |
| `scripts/jobs/budget-road.sh` (new) | `budget_road`, the one function: the 0.90 ceiling, t, u, P, spends, R_k, R_l, D, laning, verdict, admission |
| `scripts/jobs/set-road.sh` (new) | the road's single writer; regenerates `allocation/{mandate,README}.md` |
| `scripts/jobs/usage-meter.sh` | `meter_quota_status` reads the road verdict for reserve-eligible pools; `token_backoff_fraction_for` survives only for the pin and as the dormant fallback; W_maintainer excludes job sessions; snapshots publish P/W_kris; verdict cache |
| `scripts/jobs/common.sh` | `arc_rank`, `arc_headroom_lines`, `arc_reserve_armed`, `admission_arc`, `GARDEN_ARC_RESERVE` replaced by `budget_road` readers; `plan_deferred_status` drops its arc-cap half; promotion order gains the lane groups |
| `scripts/jobs/foreman.sh` | promotion order; one "Budget spent" notice; `arc_admission` + `allocation/mandate.md` in the digest |
| `scripts/jobs/handlers/foreman-claude.sh` | writes a usage row per call; prompt text says `arc_admission`, not `arc_headroom` |
| `scripts/jobs/claim-job.sh` | no logic change; reads the new verdict through `pool_admits` |
| `scripts/jobs/arc-spend.sh` | schema-2 path retired; schema-1 rolling arcs kept |
| `scripts/jobs/set-apportionment.sh`, `accountant-reslice-nudge.sh` | retired (redirect stubs naming `set-road.sh`) |
| `scripts/jobs/set-arc-budget.sh` | kept for schema-1 rolling arcs only |
| `scripts/jobs/set-token-backoff-initial.sh` | renamed `set-maintainer-reserve.sh` |
| `scripts/jobs/set-token-backoff-fraction.sh` | unchanged (the pin) |
| `scripts/jobs/accountant-statement.sh` | rendered from `budget_road` |
| `scripts/jobs/review-docket.sh`, `quota-panel.sh` | read the road instead of `config/apportionment` |
| `scripts/jobs/post-job.sh`, `post-plan.sh`, `promote-plan.sh` | stamp `posted_at:`; `--arc` warns on an arc not on the road or in `aliases` |
| `scripts/jobs/budget-level.sh` | unchanged in this design (levels workers against calibrated caps); reading 0.90 − R_k as its ceiling is a follow-up |
| `scripts/jobs/test/accountant-arc-apportionment-test.sh` | replaced by `budget-road-test.sh` |
| `roles/accountant/AGENT.md` | statement, not approval; no allocation writes |
| `roles/foreman/AGENT.md`, `roles/liaison/AGENT.md` | lanes and admission; liaison vocabulary *focus X*, *show the road*, the after-`focus` check |
| `skills/budget-request/SKILL.md`, `skills/orchestration/SKILL.md`, `skills/job-board/SKILL.md`, `roles/COMMON.md` | slate/apportionment references → road |
| `context/operations/accountant.md`, `cybernetics.md`, `scaling.md`, `review-docket.md`, `README.md` | operator pages; a new `context/operations/road.md` |
| README § Key vocabulary, CLAUDE.md § Capacity | *focus*, *road*; `token-backoff-initial` → `maintainer-reserve` |

## Ownership map

| Concern | Owner | Writes | Reads |
| --- | --- | --- | --- |
| Focus (the road) | maintainer, via the liaison running `set-road.sh` | `allocation/*` | everyone through `budget_road` |
| Maintainer share k, the pin | maintainer / operators | `config/maintainer-reserve`, `config/token-backoff-fraction` | `budget_road` |
| The 0.90 ceiling | maintainer (2026-10-02, confirmed 2026-10-27) | a constant in `budget_road` | `budget_road` |
| Measurement (u, W, P) | each subscription's owning host | usage rows, host-local calibration, `budget/live/` snapshots | `budget_road` |
| Admission | `budget_road` (pure, no writes beyond its cache) | — | claim gate, foreman |
| Spending order | foreman | promotions, stamped posts | — |
| Statement | accountant | messages only | `budget_road` |

## Alternatives considered

- **Keep the slate and auto-carry it forward.** This is the status quo. It still
  spreads budget across eight caps and still holds an arc with work behind its
  cap while idle caps sit unused.
- **[foreman-discretion-budget-pool](foreman-discretion-budget-pool.md)**:
  three linear pools over the slate. It has the right shape for time, but it
  keeps per-arc caps that need weekly approval, and it does not credit the
  maintainer's spend against their own reserve.
- **Meter arcs in raw billable tokens against token caps.** That is today's
  `arc-spend.sh` quantity. The tower's first day showed that raw tokens do not
  calibrate to utilization. The road's lanes are fractions of u, through the
  weighted P.

## Decisions

The maintainer (kriskowal) answered the three open questions in a liaison
session on 2026-10-27, recorded on
[kriscendobot/garden#127](https://github.com/kriscendobot/garden/pull/127):

1. **No library lane.** The garden has no ongoing curation yet. The road has two
   lanes, primary and secondary; no `garden-library` arc is created. The
   0.6 / 0.4 split is the designer's default (§ The model), changeable with
   `set-road.sh lanes`. A library lane can be added when curation is ongoing.
2. **0.90 is the ceiling.** The fleet never plans past 0.90 of any subscription
   (the 2026-10-02 directive). It is a fixed constant in the formulas
   (u < 0.90 − R_k, D = 0.90 − u − R_k − Σ R_l), not an optional field.
3. **Focus on minion.town.** `init` pins, in order, `minion-town-claude-api`,
   `minion-town-mcp-ocapn`, `minion-town-git-remote`, `minion-town-ui`. The rest
   rank by recent activity.

## Follow-ups

- `build-budget-road` (§ Migration step 1); the open questions are answered
  (§ Decisions).
- `budget-level.sh` reads the road's ceiling for worker leveling (to be filed
  after the build).
