---
created: 2026-09-30
updated: 2026-09-30
author: designer (job design-accountant-role-budget-apportionment)
amended_by: designer (job design-accountant-budget-request-intake)
---

# The accountant: weekly arc apportionment of the foreman's token budget

| Created | 2026-09-30 |
| Author | designer (job `design-accountant-role-budget-apportionment`); § Budget requests by designer (job `design-accountant-budget-request-intake`) |
| Status | Proposed (role brief and `budget-request` skill landed; scripts are a build follow-up) |
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

## Budget requests (intake)

> Maintainer ask (kriskowal, 2026-09-30, liaison session): *"A number of efforts
> are clamoring for a budget slice. I feel we need to find a way to nudge roles to
> dispatch messages to an accountant inbox so the accountant can roll up what
> needs tokens and present a proposed budget, informed by the current priorities
> the foreman currently holds."*

Without intake, the accountant proposes a slate from spend history and parked
plans alone, and demand reaches it only when the maintainer relays it by hand.
Intake gives every role one cheap way to say "this effort needs N tokens", and
gives the weekly statement a demand column next to spend.

### The queue: `budget/requests/` on the journal

Requests live in a **durable journal queue**, not on the bus:

```
budget/requests/open/<effort>.md             one file per effort (the dedup key)
budget/requests/closed/<week_start>/<effort>.md   decided, with its disposition
```

The two bus mechanisms were considered and rejected. The `role/accountant` topic
keeps read cursors host-local and outside the journal, and it has no per-message
state, so it cannot say which requests are still open or decided. A directed
`inbox/accountant` exists only while one accountant job is live, and a send to an
absent inbox is dead-lettered into a *new job*, which is the wrong outcome for a
request that should wait for next Saturday. A journal tree is the pattern
`budget/manual-checkpoints/` and `budget/reset-events/` already use. It survives
every accountant job, and closing a request is a file move.

### Request shape

```markdown
---
schema: 1
effort: minion-town-git-remote        # dedup key; lowercase slug
arc: minion-town-capabilities         # existing arc, or empty for "propose a new arc"
tokens: 15M                           # estimate for the window; may be empty only when source is not a role
window: next                          # this | next (week, per the arc window anchor)
serves: 1                             # foreman-mandate item number, or "none"
urgency: blocked                      # blocked | soon | whenever
if_unfunded: "git-remote build stays parked; #86 goes stale"
link: https://github.com/kriscendobot/minion.town/pull/86
source: role                          # role | orchestration | foreman
requesters: [designer:design-minion-town-git-remote]
first_requested_at: 2026-09-30T22:00:00Z
requested_at: 2026-09-30T22:00:00Z
request_count: 1
status: open
---
One to three lines of justification.
```

Writing a request is one command, so the cost is the estimate and nothing else:

```sh
scripts/jobs/request-budget.sh --from <your-base> --effort <slug> --tokens 15M \
  [--arc A] [--window this|next] [--serves N|none] [--urgency blocked|soon|whenever] \
  [--if-unfunded TEXT] [--link URL] ["justification"]
```

It infers `requester_role` from the posted job's `role:` field, defaults `window`
to `next`, `urgency` to `soon`, and `serves` to `none`, and lands the file with the
producer-clone CAS loop (`commit_and_push`). It never writes into `config/`.

**Dedup.** The effort slug is the identity. A repeat request for an open effort
**amends** the file instead of adding one: the latest `tokens`, `window`,
`urgency`, `if_unfunded`, and body win; `first_requested_at` stays;
`request_count` increments; and the requester is appended to `requesters` if it
is new. Two roles asking for the same effort therefore produce one line in the
roll-up, not two. Different efforts in the same arc stay separate files and are
summed under the arc.

### Nudges: who files, and where the nudge lives

Where the request can be filed by a script, the script files it. Prose nudges are
only for cases that need an estimate from judgment.

| Moment | Who files | Where it lives |
| --- | --- | --- |
| An orchestration recorded with `--budget-tokens N` | `post-orchestration.sh` files `effort: <orch-base>`, `tokens: N`, `source: orchestration`, arc from `--arc`. | Deterministic (build) |
| The foreman finds an arc's ready plans held `arc-budget-over` | The foreman service files `effort: <arc>`, `urgency: blocked`, `source: foreman`, and `held_plans: K`, with no `tokens` (the accountant estimates from the ledger). It files once per arc per window. | Deterministic (build) |
| A designer lands a design whose build needs more than one build job, an orchestration, or a press | The designer, with a whole-build estimate. | [designer](../roles/designer/AGENT.md) brief |
| An orchestrator setting up a multi-part job with no `--budget-tokens` cap | The orchestrator, with an estimate for the whole campaign. | [orchestrator](../roles/orchestrator/AGENT.md) brief |
| A producer wanting a press or campaign cap (formerly a hand `set-arc-budget.sh`) | The producer files the request. Only the accountant writes arc budgets. | [budget-request](../skills/budget-request/SKILL.md) |
| Any job that parks itself on `--budget-hold`, or that knows its effort will outrun its arc | The role, when it can estimate the effort. A bare `--budget-hold` already appears in the statement's held-plan count without a request. | [COMMON](../roles/COMMON.md) § Asking for budget |

The skill [`budget-request`](../skills/budget-request/SKILL.md) is the one playbook.
`roles/COMMON.md` carries a two-line pointer, and only the designer and
orchestrator briefs name the skill directly.

### Roll-up in the weekly statement

`accountant-statement.sh` gains a deterministic **Demand** section, read from
`budget/requests/open/`:

- **Group by arc.** Each arc row adds `requested` (the sum of `tokens` over its
  open requests for the window), `requests` (count), `blocked` (count with
  `urgency: blocked`), and `held_plans`. Requests with an empty `arc` are listed
  under **new-arc candidates**, with their `serves:` item.
- **Rank against the mandate.** Arcs are ordered by slate `rank`. The generated
  `config/foreman-mandate` is the slate's prose, so this is the foreman's current
  priority order. A new-arc candidate is placed by its `serves:` item. A request
  whose `serves:` disagrees with its arc's rank is flagged, not silently re-ranked.
- **Requested against available.** `available` is the proposed week `total`
  times a **planning ceiling** (`config/apportionment` `planning_ceiling`, default
  `0.90`), which leaves headroom for accounting-only overshoot. To that it adds
  any **reset credit** the maintainer has recorded for the window in
  `budget/reset-events/` (an early reset or a temporary quota boost). The line
  reads `requested R / available A (ceiling 90%, +C reset credit)`.
- **Estimate the unsized.** A `source: foreman` request with no `tokens` is
  sized by the accountant from `arc-spend.sh` history (median spend per completed
  plan in that arc, times `held_plans`). The statement shows the estimate as
  such.

The accountant's proposed slate then funds arcs in rank order up to `available`
and names each request's proposed disposition. That judgment is the accountant's;
the numbers above are the script's.

### Disposition and roll-forward

After the slate is applied (or carried forward with no reply), the accountant
closes each request it decided with:

```sh
scripts/jobs/close-budget-request.sh <effort> funded|partial|deferred|declined|expired [note]
```

- `funded` / `partial` / `declined` move the file to
  `budget/requests/closed/<week_start>/`, stamping `disposition`, `granted` (the
  arc slice or campaign cap that covers it), `decided_by` (the accountant job),
  and `authorized_by` (the maintainer login from the slate).
- `deferred` keeps the file open and sets `window: this` for next week's
  roll-up. An open request not renewed (no amend) for **three** weekly
  statements is closed `expired`, so the queue cannot silt up.
- **The disposition goes back to each requester.** For every entry in
  `requesters` whose job is still live, the script sends an `inbox-send.sh`
  message with `GARDEN_NO_DEADLETTER=1`. A completed requester does not get a
  resurrected job. The closed file is the durable answer, and a later job for the
  same effort reads it before re-filing.

Mid-week, the accountant does not act on requests alone. The **re-slice nudge**
(at most daily, edge-latched) gains a second trigger: an open `urgency: blocked`
request whose arc has no headroom. The nudge names the request, and the
maintainer decides whether to re-slice.

### Guardrails

- **A request is advisory input only.** It never writes `config/`, never
  changes admission, and never grants tokens. Only a maintainer-authorized slate
  applied through `set-apportionment.sh` grants budget. A funded request is
  funded because the slate says so.
- **No borrowing and no cancellation** (§ How the foreman draws): a `blocked`
  request waits for a slate. It does not draw on another arc or on next week.
- **Dedup by effort** (above). A requester re-filing to be louder only increments
  `request_count`, and the statement shows that count as signal, not as extra
  tokens.
- **Injection hygiene.** Requests are written only by garden jobs and scripts
  through journal push access, the same trust boundary as the bus. The accountant
  treats the justification text as data to summarize for the maintainer, never as
  instructions.

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
| any role → accountant | `request-budget.sh` CAS (amend by effort) | requester estimates; advisory only | `budget/requests/open/<effort>.md` | requester's job (file only; no `config/`) | an estimate + justification |
| accountant → requester | `close-budget-request.sh` + live-only `inbox-send.sh` | accountant applies the slate | `budget/requests/closed/<week>/` | accountant job | a disposition |
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

**Intake scope (added with § Budget requests).**
- `request-budget.sh`, with the amend-by-effort dedup.
- `close-budget-request.sh`, with live-only disposition delivery and expiry.
- `post-orchestration.sh` auto-filing on `--budget-tokens` (and an `--arc` flag
  if orchestration `arc:` inheritance does not already add one).
- The foreman service filing one `urgency: blocked` request per held arc per
  window.
- The statement's Demand section, `planning_ceiling`, and the reset-credit read.
- The re-slice nudge's blocked-request trigger.
- Tests: dedup/amend, close/expire, no dead-letter on a completed requester, and
  the Demand arithmetic.

Intake does not depend on the rest of the build and could land first, because
requests can accumulate before the first slate. The weekly job consumes them once
`accountant-statement.sh` exists.

Considered and rejected: a deterministic-only accountant (proposing a slate needs
judgment over roadmap and board state; the numbers stay deterministic). A
separate `config/arcs/` tree (duplicates `config/arc-budgets`). Charging
maintainer-directed jobs to arcs (the maintainer's direct asks are not the
foreman's to ration).
