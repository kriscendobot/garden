---
created: 2026-09-30
updated: 2026-09-30
author: designer (job design-accountant-role-budget-apportionment)
---

# The accountant: weekly arc apportionment of the foreman's token budget

| Created | 2026-09-30 |
| Author | designer (job `design-accountant-role-budget-apportionment`) |
| Status | Proposed (role brief landed; scripts are a build follow-up) |
| Layers on | [live-budget-admission](live-budget-admission.md), [subscription-budget-model](subscription-budget-model.md), [budgeted-campaign-dispatch](budgeted-campaign-dispatch.md), [recurring-budget-calibration](recurring-budget-calibration.md), [ironhorse-ratchet](../context/operations/ironhorse-ratchet.md) |

> Maintainer directive (kriskowal, 2026-09-30, liaison session): *"carve an
> accountant role out of the liaison's and other roles' skills and
> responsibilities regarding budgeting tokens … a weekly engagement, triggered by
> a scheduled message to the maintainer, inviting the maintainer to adjust the
> token budget for the foreman going forward, such that the pie gets sliced and
> apportioned to various arcs the foreman can draw from to make progress on
> prioritized work in the planned jobs."*

## Survey: where budget responsibility lives today

The garden already has two layers. Neither decides *what the budget is for*.

- **Metering and admission (mechanism, unchanged here).**
  [`usage-meter.sh`](../scripts/jobs/usage-meter.sh) with journal
  `config/budget-pools` + `config/subscription-mapping` meters each subscription
  and fails closed at claim time; [`budget-level.sh`](../scripts/jobs/budget-level.sh)
  levels workers against calibrated caps; `weekly-capacity-calibration.sh`
  measures capacity; `append-quota-checkpoint.sh` records dashboard readings.
  Operator map: [cybernetics.md](../context/operations/cybernetics.md).
- **Pacing brakes.** `GARDEN_FOREMAN_ACTIVE_TARGET` (shipped 10),
  `config/token-backoff-fraction` (`GARDEN_TOKEN_BACKOFF_FRACTION`),
  `brake-foreman.sh`, and the `--budget-hold` gate released by
  `budget-refresh.sh`.
- **Bounded pies (two precedents).** An orchestration's `--budget-tokens N`
  gates each serial child promotion against the campaign's ledger spend
  ([orchestration](../skills/orchestration/SKILL.md)). And a **rolling arc
  budget**: `set-arc-budget.sh` writes `config/arc-budgets/<arc>`, `arc-spend.sh`
  derives spend from `usage/*.jsonl` rows stamped `arc:`, and
  `plan_deferred_status` (`common.sh`) leaves a deferred plan carrying
  `ratchet-arc: <arc>` parked with reason `arc-budget-over`. Today exactly one arc
  uses it (`ironhorse-test262-ratchet`), and no arc budget is currently armed on
  the journal.
- **Priority direction.** `config/foreman-mandate` is free text the foreman
  reads as discretionary guidance; it is hand-written on maintainer direction
  and carries no quantities.
- **The liaison.** Its only standing budget norm is *unknown inference quota is
  depleted until the maintainer says otherwise* (ask for token count and target
  date). Budget watchdog notices (`budget-level` freeze/recovery, pool alerts)
  reach the maintainer inbox and are disposed by hand at muster.
- **Foreman, mentor, gauntlet.** The foreman role brief carries no budget logic
  (its service does the admission checks); the mentor carries none; the gauntlet
  only propagates `ratchet-arc` to its stages.
- **The old "review arc".** The 2026-07 arcs (a press schedule + a
  `kriskowal/garden` tracker issue per arc + `arc-status-daily`) are retired:
  `arc-status-daily` and all but the `claude-on-minion-town` presses are gone from
  `journal/schedules/`. The live arc concept is the `config/arc-budgets` one.

So nobody owns the allocation question end to end: numbers are set ad hoc by
whoever the maintainer happened to tell, the mandate and the arc budgets are
written independently, and the maintainer is never asked on a cadence.

## Decision

1. Add an **accountant** role ([roles/accountant/AGENT.md](../roles/accountant/AGENT.md)),
   scoped to token economics: read spend state, propose an apportionment, run the
   weekly engagement, and be the **sole writer** of the allocation layer
   (`config/apportionment`, `config/arc-budgets/*`, `config/foreman-mandate`).
   It does not level workers, restore fleets, or triage health notices.
2. Generalize the existing arc budget into **the** arc: a named priority thread
   of planned work the foreman draws from. No competing vocabulary.
3. A weekly scheduled **accountant job** carries forward last week's slate,
   messages the maintainer a statement and a proposed slate, waits on its inbox
   for the reply, and applies it.
4. An exhausted slice **holds** (the existing `arc-budget-over` parking), with no
   borrowing and no cancellation.

## The arc

An arc is a record `config/arc-budgets/<arc>`, extended to **schema 2**:

```json
{"schema":2,"status":"active","arc":"minion-town-capabilities",
 "rank":1,"summary":"Run Claude remotely; minion.town as git origin",
 "token_cap":40000000,"window":"week","window_start":"2026-10-03T04:00:00Z",
 "tracker":"https://github.com/kriscendobot/garden/issues/NN",
 "set_by":"accountant-weekly-20261003","set_at":"…"}
```

- `window: "week"` sums spend from a **fixed** `window_start` (the subscription
  week anchor, Fri 21:00 America/Los_Angeles, the cadence
  `weekly-capacity-calibration.sh` already uses), not a rolling window: a weekly
  pie that is re-sliced each week must not inherit last week's spend for six
  days. Schema 1 (rolling `window_seconds`, `press_interval_seconds`) stays valid
  so the Ironhorse press keeps working; `arc-spend.sh` accepts both.
- `rank` orders arcs for the foreman and for the generated mandate. `summary` is
  the arc's one-line direction. `tracker` is optional (the retired review-arc
  tracker issue survives only as this optional pointer).
- **Membership** is a job field `arc: <name>`. `ratchet-arc:` is read as a
  legacy alias wherever `arc:` is absent (`plan_deferred_status`,
  `usage-meter.sh`, `promote-plan.sh`, `gauntlet.sh`, `complete-job.sh`). Producers
  stamp it: `post-plan.sh --arc <name>`; an orchestration record's `arc:` is
  inherited by its children; the foreman stamps the arc it chose when it
  generates a step; gauntlet stages inherit their producer's arc.
- **The reserve** is the pseudo-arc `unallocated`: foreman-drawn work with no
  arc is stamped `arc: unallocated` and charged there, so the pie always sums to
  the foreman's weekly total.

`config/apportionment` records the week as a whole: `week_start`, `total_tokens`
(the foreman's weekly budget), the ordered slate, `authorized_by` (a
`maintainers/allowlist` login), and the maintainer message id it came from.
`set-apportionment.sh` writes it and materializes every
`config/arc-budgets/<arc>` and a regenerated `config/foreman-mandate` in **one**
CAS commit, so the three never disagree. Arcs dropped from the slate get
`status: "retired"` (their plans then fail closed and stay parked, visible in the
next statement).

## How the foreman draws

Only **foreman-drawn** work is gated: the deferred selector's promotions and
the foreman's own idle-generated steps. Maintainer-directed jobs, triagers,
watchers, and schedules are outside the pie (they remain governed by the
admission layer alone).

- The deferred selector already skips `arc-budget-over` plans. It gains one rule:
  among `ready` plans it orders by arc `rank`, then the existing leaf-first order.
- Before invoking the inner foreman agent, the service computes headroom per arc
  and passes it in the digest (next to the mandate). The agent may only generate
  a step for an arc with headroom, and stamps that arc. With no headroom anywhere
  (including `unallocated`) the service does not invoke the agent at all.
- **Accounting vs admission.** Gauntlet stages and chained follow-ups of arc work
  are charged to the arc but not gated (budgets gate admission, not execution —
  the orchestration precedent). A slice can therefore overshoot by in-flight
  follow-through; the statement reports it and the next week's slate absorbs it.

**Exhaustion: hold.** An exhausted arc's plans stay parked until the next
`window_start` or a mid-week re-slice. Borrowing (from the next week or from a
lower-ranked arc) is rejected because it silently reorders the maintainer's
priorities and spends a future decision now; stopping in-flight work is rejected
because it wastes sunk spend and strands half-run gauntlets. To avoid wasting
use-it-or-lose-it subscription quota, the accountant sends one edge-latched
**re-slice nudge** (at most daily) when every slice is held while the pools
report unspent quota near reset per `budget-level.sh`'s pacing bias. The
maintainer decides; nothing spills over automatically.

**Composition with `--budget-tokens`.** A campaign cap is a sub-budget inside an
arc, never a parallel pie: a budgeted orchestration whose record names `arc:` is
admitted only while *both* the campaign cap and the arc slice have headroom, and
its spend counts once, against both (the same ledger rows). The accountant
proposes campaign caps from the owning arc's slice; it does not create
orchestrations.

## The weekly engagement

A schedule `accountant-weekly`, cadence `weekly-at-Sat-09:00-America/Los_Angeles`
(twelve hours after the reset and `weekly-capacity`), set via
[schedule](../skills/schedule/SKILL.md), posts `accountant-weekly-<YYYYMMDD>`
(`role: accountant`). The date suffix is deliberate (recurring verb, same target).

1. **Carry forward first.** Deterministically roll last week's slate to the new
   `window_start` (`set-apportionment.sh --carry-forward`), so the fleet never
   runs unbudgeted while waiting on a human.
2. **Compose the statement** from `accountant-statement.sh` (deterministic, no
   LLM): per pool, calibrated cap, week spend, and pace against the reset; per
   arc, slice, spend, percent, held plans (from `plan_deferred_skipped`),
   completions, and overshoot; `unallocated` spend; foreman decision counts; the
   week's budget watchdog notices; and any unmapped quota source.
3. **Propose** a slate: a table of arcs (rank, summary, last slice, spend,
   proposed slice, one-line reason), plus candidate new arcs seen in parked plans
   or the project roadmap and arcs recommended for retirement.
4. **Send** it with `message-user.sh accountant-weekly-<YYYYMMDD>`; the reply
   routes back to the job's inbox.
5. **Wait and apply.** The reply grammar is line-oriented:

   ```
   total 120M
   minion-town-capabilities 50%
   endor-metering 15M
   ironhorse 20%
   new git-remote "capability git remote on minion.town" 10%
   retire endoclaw-reminder
   keep            # accept the proposal unchanged
   ```

   Order is rank; a missing remainder goes to `unallocated`; over-subscription is
   rejected with an explanation. Free-form prose is fine too: the accountant
   restates its reading and applies only after an unambiguous reading. It applies
   via `set-apportionment.sh` with `authorized_by`, confirms with the resulting
   table, and completes. With no reply before the next weekly job, it completes
   with the carried-forward slate in force.

Mid-week, the maintainer says **apportion** / **re-slice** to the liaison, which
forwards the words to a live `accountant-weekly-*` inbox or posts
`accountant-reslice-<YYYYMMDD>`.

## What moves where

| From | Responsibility | To |
| --- | --- | --- |
| liaison | *Unknown quota is depleted*: ask for token count and target date | accountant (the liaison keeps "never throttle it up" and routes the question) |
| liaison | Hand-disposing budget watchdog notices at muster | accountant's weekly statement (muster archives them as "summarized weekly") |
| liaison / whoever the maintainer told | Writing `config/foreman-mandate` | accountant, generated from the slate |
| ad hoc | `set-arc-budget.sh`, campaign-cap proposals, quota checkpoint prompts | accountant |
| unchanged | Metering, pools, leveling, derotation, drain, `brake-foreman.sh`, backoff fraction, `--budget-hold` | admission/pacing layer, as today |

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Commit authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| maintainer → accountant | inbox message | maintainer | the reply message | maintainer (`authorized_by`) | a slate |
| accountant → journal | `set-apportionment.sh` CAS | accountant applies maintainer's slate | `config/apportionment`, `arc-budgets/*`, `foreman-mandate` | accountant job | one atomic commit |
| journal → foreman | `plan_deferred_status`, `arc-spend.sh` | rank + headroom | `usage/*.jsonl` (immutable) | foreman promotion CAS | ready / `arc-budget-over` |
| foreman → admission | claim-time `usage-meter.sh` gate | pools/brakes | pools, leveling | claim CAS | admit / refuse |

Restart/replay: every step is derived from immutable ledgers plus one config
commit; a requeued accountant job re-reads its inbox and re-applies idempotently.
The allocation layer only ever *narrows* what admission allows: it can hold a
plan the pools would admit, never admit one the pools refuse.

## Build plan (follow-up job)

`arc-spend.sh` schema 2; `arc:` field with `ratchet-arc` alias across the five
readers; `post-plan.sh --arc`; orchestration `arc:` inheritance; rank ordering in
the deferred selector; per-arc headroom in the foreman digest;
`set-apportionment.sh`; `accountant-statement.sh`; the re-slice nudge; the
`accountant-weekly` schedule; tests beside `ironhorse-press-budget-test.sh`.

Considered and rejected: a deterministic-only accountant (proposing a slate needs
judgment over roadmap and board state; the numbers stay deterministic). A
separate `config/arcs/` tree (duplicates `config/arc-budgets`). Charging
maintainer-directed jobs to arcs (the maintainer's direct asks are not the
foreman's to ration).
