---
created: 2026-08-12
updated: 2026-08-12
author: designer (job budgeted-campaign-dispatch-design)
---

# Budget-bounded campaign dispatch

| Created | 2026-08-12 |
| Author | designer (job `budgeted-campaign-dispatch-design`) |
| Status | Proposed (phase 1 is the same-day build target) |

An orchestration can currently promote every child it names without regard to the
cost of the campaign as a whole. The fleet-wide [`usage-meter.sh`](../scripts/jobs/usage-meter.sh)
gate is disabled on this host, applies to all work rather than one campaign, and
uses a trailing window. [`cost.sh`](../scripts/jobs/cost.sh) reports attributed
spend after it lands but does not govern promotion. This design adds one optional
token cap to the existing orchestration record and checks the existing
[`usage/<base>.jsonl` CostRecord ledger](token-cost-ledger.md) immediately before
each serial child promotion.

Phase 1 is deliberately narrow: it gates serial orchestration children, derives
spend fresh from their existing ledger files, and can be applied to the staged
Ironhorse resume as soon as the small script change and tests land. It creates no
campaign ledger, reservation counter, or pool allocator.

## Decision

1. `post-orchestration.sh --budget-tokens N` writes `budget_tokens: N` into the
   existing `jobs/orch/<campaign>.md` record. The record's existing `created_at`
   is the accounting epoch. A record without `budget_tokens` keeps today's
   behavior.
2. Phase 1 accepts a budget only with `--serial`. Parallel dispatch admits every
   child on the first tick and therefore cannot stop promotion as actual spend
   accrues.
3. Campaign spend is recomputed from the existing CostRecord files immediately
   before `advance_serial` promotes a parked child. The enforced quantity is
   billable tokens: `input_tokens + output_tokens + cache_creation_tokens`.
   Cache reads remain excluded, matching `usage-meter.sh`'s default definition.
4. If cumulative spend is at or above the cap, the watcher does not call
   `promote-plan.sh`. It terminates the campaign with
   `orchestration-status: budget-exhausted`, leaves every not-yet-run child in
   `jobs/plan/`, and reports budget, actual spend, overshoot, and the parked
   remainder.
5. There is no persistent "spent" field. `budget_tokens` is the declaration;
   cumulative spend is a derived value. A stale counter cannot disagree with the
   ledger.
6. Unspent budget is permission that was never exercised, not a reserved asset
   that needs a transfer. Completion surfaces `max(budget - spend, 0)` in the
   orchestration's `tada` report and a maintainer-inbox notice. The next campaign
   may allocate that still-unused weekly headroom explicitly. No automatic
   rollover or pool ledger is introduced.

## Current calibration and the first cap

The last Friday 9 p.m. Pacific reset was 2026-08-07T21:00:00-07:00, or
2026-08-08T04:00:00Z. A fresh fold of every ledger row at or after that cutoff,
read on 2026-08-12, produced:

| Host | Rows | Billable tokens | Notional `total_cost_usd` | Reported quota used | Implied weekly token capacity |
| --- | ---: | ---: | ---: | ---: | ---: |
| `endolin-garden-ece02cb4` | 81 | 2,885,040 | $97.93 | 48% | 2,885,040 / 0.48 = 6.01M |
| `endolin-garden2-5bcdff64` | 120 | 6,377,205 | $205.15 | 53% | 6,377,205 / 0.53 = 12.03M |
| Combined | 201 | 9,262,245 | $303.08 | two independent quotas | 18.04M under the displayed pairing |

The recomputation was:

```sh
jq -s --arg cutoff 2026-08-08T04:00:00Z '
  [.[] | select((.ts // "") >= $cutoff)]
  | group_by(.host)
  | map({host: .[0].host,
         billable: (map((.input_tokens // 0) + (.output_tokens // 0)
                        + (.cache_creation_tokens // 0)) | add),
         dollars: (map(.total_cost_usd // 0) | add)})
' journal/usage/*.jsonl
```

The proposed Ironhorse cap remains **2,080,000 billable tokens**. It is 11.5%
of the combined implied weekly capacity under that host-to-percentage pairing.
The prompt's approximately $63 proxy has moved with the ledger mix: the current
blended rate is $303.0761685 / 9.262245M = $32.72 per million billable tokens,
which prices 2.08M at approximately **$68.06 notional**. Reversing the unrecorded
48%/53% host pairing implies 18.73M combined capacity and makes the same cap
11.1%; it does not change the enforced token number.

Each flat subscription costs $200 per month in real money. Amortized weekly,
that is `$200 * 12 / 52 = $46.15` per account and **$92.31 per week combined**.
Comparing reset-to-date notional ledger dollars with that fixed weekly cost gives
this snapshot:

| Host | Reset-to-date notional | Weekly real cost | Current notional / real index |
| --- | ---: | ---: | ---: |
| `endolin-garden-ece02cb4` | $97.93 | $46.15 | 2.12x |
| `endolin-garden2-5bcdff64` | $205.15 | $46.15 | 4.44x |
| Combined | $303.08 | $92.31 | 3.28x |

At the current combined 3.28x index, the campaign's $68.06 notional proxy is
**$20.73 real-dollar-equivalent**. Retaining the earlier $63 proxy would give
$19.19. Both differ from the maintainer's earlier same-day estimates of about
2.0x, 3.6x, and 2.8x (which put $63 near $22-23), because additional ledger
rows and their token mix changed the numerator. They also differ from the older
8.7x finding reported in `true-cost-vs-notional-ledger`. The ratio is a
workload- and observation-window-dependent allocation index, not a constant
conversion rate. A campaign report recomputes and timestamps it rather than
copying any of these snapshots.

This fold also found 95 `source: none` rows with no token fields. The displayed
token and dollar totals are therefore ledger totals, not a claim that the ledger
captured every invocation. Phase 1 fails closed for an unmetered row belonging
to the campaign, as described below.

Notional dollars are not money invoiced on the fleet's flat subscriptions. The
library's current `cost-ledger` concept (`journal2:library/concepts/cost-ledger.md`,
unum source commit `e489be2`) treats raw tokens as the re-priceable truth and the
CLI dollar field as a convenient comparison axis. The garden's
[`issue-cost-and-triple-evaluation.md`](issue-cost-and-triple-evaluation.md)
separately uses capped proxy wall-clock for true cost. This campaign therefore
enforces tokens and prints both notional and real-equivalent dollars only for
human sizing. The real subscription charge is flat and sunk whether the campaign
runs or not; `real-dollar-equivalent` does not assert a marginal invoice.

## Phase 1 record and command surface

The first consumer is posted after the recovery job has restored the 23 parked
children:

```sh
post-orchestration.sh --serial --on-child-failure halt \
  --budget-tokens 2080000 \
  ironhorse-test262-implementation-completion-resume \
  <the original 29 child basenames in order>
```

The resulting record adds one field to the existing shape:

```yaml
---
order: serial
children: ironhorse-js-00-... ironhorse-js-01-... ... ironhorse-js-28-...
on-child-failure: halt
state: pending
budget_tokens: 2080000
created_by: producer
created_at: 2026-08-12T01:30:00Z
---
```

`post-orchestration.sh` validates `N` as a positive base-10 integer and rejects
`--parallel --budget-tokens`. It does not offer `--budget-usd`: enforcing a
notional price would make the cap depend on model mix and CLI pricing while the
subscription quota is expressed by tokens.

`created_at` prevents an old use of the same child basename from spending a new
campaign's budget. This matters for the Ironhorse resume: all 29 basenames are
listed so the watcher skips the six already in `tada/`, but usage recorded before
the resume record's `created_at` is outside the new 2.08M-token epoch.

## Derived campaign membership and spend

Phase 1 membership is the orchestration's enumerated child list. For each child
`c`, the reducer reads exactly `usage/c.jsonl`; it does not scan all usage rows
and does not infer ownership from prose. It folds every row whose `ts` is at or
after the record's `created_at`, including `tada`, requeue, and fail outcomes.
The work is proportional to the named children and their engagement rows, rather
than the size of the fleet ledger.

This exact-file rule is intentional. The existing auto-gauntlet handoff creates
new jobs such as `<build>-gauntlet-clean`. Those jobs are not enumerated children
of this phase-1 campaign and can continue independently. Treating every prefix
match as campaign spend would count those jobs but would not let
`orchestrate.sh` prevent `gauntlet.sh` from dispatching their later stages. That
would promise a campaign-wide stop the implementation cannot perform. Stable
transitive membership and cross-driver admission are phase 2.

A small deterministic helper, `campaign-spend.sh`, owns the fold and returns one
machine-readable object:

```json
{
  "budget_tokens": 2080000,
  "spend_tokens": 1841022,
  "unspent_tokens": 238978,
  "overshoot_tokens": 0,
  "notional_usd": 55.84,
  "real_equivalent_usd": 17.01,
  "notional_to_real_index": 3.2833,
  "calibration_as_of": "2026-08-12T01:00:00Z",
  "engagements": 13,
  "unpriced": 0,
  "unmetered": 0
}
```

The watcher and terminal-report renderer call the same helper. Dollar coverage
is explicit: an unpriced row contributes tokens but not dollars. The real-dollar
equivalent divides campaign notional spend by a freshly recomputed reset-to-date
fleet index, using the two-account `$400 * 12 / 52` weekly cost, and stamps the
calculation time. It is reporting metadata and never participates in admission.
A malformed
JSON line, an unreadable named file, or a matching `source: none` row produces a
non-zero exit with a reason. The watcher then terminates the campaign as
`orchestration-status: budget-meter-incomplete`, promotes nothing, leaves the
remainder parked, and notifies the maintainer. Counting an unknown row as zero
would turn a bounded campaign into an unbounded one.

An absent usage file is normal before a child runs. The existing capture path is
best-effort, so phase 1 cannot prove that no completed engagement was omitted
entirely. Closing that gap requires making a campaign-tagged completion's ledger
append mandatory and belongs with phase 2's stable tag. Phase 1 is an admission
gate over recorded actuals, not pre-payment and not a kill switch.

## Promotion and terminal behavior

The budget check sits in `advance_serial`'s `parked` branch, immediately before
the current `promote-plan.sh` call:

```text
child done    -> continue to the next child
child active  -> wait; already admitted work is not killed
child parked  -> derive campaign spend
                 spend < budget  -> promote this child
                 spend >= budget -> finish budget-exhausted, promote nothing
child failed  -> apply the existing halt or continue policy
```

The comparison is `>=`, so a campaign at exactly its cap admits no further work.
Actual cost is known only after a child runs. One admitted child can therefore
take the campaign past the declaration before the next check. The terminal
report calls this `overshoot_tokens`; it never reports a negative unspent value.
A strict no-overshoot limit would need a conservative per-child reservation or
pre-payment scheme, neither of which the current ledger supplies.

Budget exhaustion is a terminal outcome, not a quiet `state: running` record
that never advances. `finish_budget` writes `jobs/tada/<campaign>.md`, removes
the orchestration record, and differs from the existing failure halt in one
respect: it does **not** sweep downstream plan files. The report has this shape:

```markdown
orchestration-status: budget-exhausted
campaign-budget-tokens: 2080000
campaign-spend-tokens: 2144102
campaign-unspent-tokens: 0
campaign-overshoot-tokens: 64102

# orchestration ironhorse-test262-implementation-completion-resume - BUDGET EXHAUSTED

Stopped before promoting child 18/29. 17 children were already complete.
12 not-yet-run children remain parked: ...
Notional spend at the terminal snapshot: $65.41 (0 unpriced engagements).
Real-dollar-equivalent: $19.92 at the 3.2833x fleet index as of 2026-08-12T01:00:00Z.
```

Normal all-children completion also includes the four `campaign-*` quantities.
If it finishes at 1.71M of a 2.08M cap, both the `tada` report and one
maintainer-inbox notice say that 370,000 tokens remain unused. The notice is the
visible "return to pool" event. No code assigns the 370,000 tokens to another
campaign; a later `--budget-tokens` declaration does that explicitly.

To resume parked remainder, use a new orchestration basename and a new budget
epoch. Phase 1 adds `post-orchestration.sh --resume-from <terminal-campaign>` as
an adoption path: it verifies that the old `tada` report names a parked
remainder, atomically retags those plan files' `orchestrated_by` to the new base,
and records the new orchestration. Completed children may remain in the full
list and are skipped as today. This keeps each budget epoch auditable and avoids
editing an old declaration in place.

## Consistency and failure rules

- The watcher syncs its private journal clone once, then reads the orchestration
  record and usage files from that same checkout. A later ledger append appears
  on the next tick.
- The budget helper never writes to `usage/` or the orchestration record. Only
  normal CostRecord capture writes spend facts.
- A budget parse error, missing `created_at`, malformed ledger row, or campaign
  row without token fields stops promotion and yields the explicit
  `budget-meter-incomplete` terminal state.
- A notification is sent only after the terminal CAS lands. A retry cannot send
  duplicate completion notices for a record that still exists.
- Existing unbudgeted serial and parallel orchestrations do not call the helper
  and retain byte-for-byte behavior.
- Budget exhaustion does not cancel a child already in `todo/` or `doin/`.
  Campaign admission controls the next promotion; it does not revoke work.

## Phase 1 build slice

This is the same-day or next-day implementation:

1. Add `--budget-tokens`, `--resume-from`, validation, and record fields to
   [`post-orchestration.sh`](../scripts/jobs/post-orchestration.sh).
2. Add read helpers for `budget_tokens` and `created_at` in
   [`common.sh`](../scripts/jobs/common.sh).
3. Add `campaign-spend.sh`, a plain `jq` reducer over the named files and epoch.
   Its reporting branch also recomputes the reset-to-date notional / weekly-real
   index; that value never enters the token comparison.
4. Add the pre-promotion check and non-sweeping terminal renderer to
   [`orchestrate.sh`](../scripts/jobs/orchestrate.sh).
5. Extend `scripts/jobs/test/orchestrate-test.sh` with: under-budget promotion;
   exact-cap stop; one-child overshoot; prior-epoch rows excluded; requeue and
   fail rows counted; unmetered and malformed rows fail closed; remainder not
   swept; under-budget completion reports unspent; `--parallel` rejection; and a
   new-budget resume that retags the parked remainder.
6. Update [`skills/orchestration/SKILL.md`](../skills/orchestration/SKILL.md) and
   [`orchestration-jobs.md`](orchestration-jobs.md) with the optional flag and
   terminal states.

The Ironhorse resume is the first acceptance run. Before posting it, run the
same reducer command against the freshly synced ledger and record the exact
snapshot in the operator output. Then post the full 29-child list with
`--budget-tokens 2080000`. The first six completed children are skipped and their
pre-epoch spend is excluded. On each later promotion, the watcher logs
`spend/budget` and the next child basename.

## Phase 2: account-aware and transitive campaigns

Phase 1 deliberately uses one combined cap. That is the number this week's
Ironhorse campaign needs and it does not require changing the fleet's claim
race. It is not account-correct: each host uses a separate Claude subscription,
and a job claimed on one host consumes only that host's quota.

Phase 2 should add two related capabilities:

- **Stable transitive membership.** Preserve `campaign: <base>` in promoted job
  frontmatter, add it to the existing CostRecord row, and propagate it through
  auto-gauntlet records and stage jobs. Every dispatcher that inherits the tag
  calls the same campaign admission predicate. This covers descendants whose
  basenames were not enumerable when the campaign was posted without creating a
  second ledger.
- **Per-account caps.** Treat `host` as the current account proxy and declare a
  host-keyed token map in addition to an optional combined cap. Admission must
  know which host will claim before it can enforce that map, so this requires a
  host-aware award or reservation in the claim path. It cannot be bolted onto
  `advance_serial`, which promotes to a fleet-wide queue with no claimant yet.

The account mapping should become an explicit journal configuration rather than
assuming one account per host forever. Phase 2 also decides whether a
campaign-tagged usage append becomes mandatory before completion, closing phase
1's undetectable-missing-row gap.

A separate follow-on track, the recurring weekly capacity calibration and the
persistent token bucket, is designed in
[`recurring-budget-calibration.md`](recurring-budget-calibration.md). It replaces
the hand-supplied `--budget-tokens N` with a scheduled deterministic measurement
of real weekly capacity and a shared journal-backed balance a campaign draws from,
and composes with the account-aware track above (its `per_account_capacity` is the
per-account ceiling the account-aware caps would enforce).

## Alternatives considered

- **A new `campaign-usage.jsonl` or mutable spent counter.** Rejected. It would
  duplicate CostRecord facts and need transactional updates across every
  completion and requeue path. Fresh aggregation has one source of truth.
- **A `--budget-usd` enforcement mode.** Rejected for phase 1. The subscription
  does not invoice the CLI's API-list-price dollars, and a dollar cap changes
  meaning with model mix. Dollars remain a display proxy.
- **Automatic rollover into a global pool.** Rejected. No pool allocator exists,
  and the two subscriptions make a single fungible pool inaccurate. Reporting
  unspent tokens and leaving remainder parked supplies the useful behavior
  without a new authority that silently launches more work.
- **Allow budgeted parallel orchestration.** Rejected until admission uses
  reservations. Promoting all children before any actual exists defeats the
  gate.
- **Count child-prefix files in phase 1.** Rejected because the gauntlet driver
  can continue dispatching prefix descendants after the top-level orchestration
  stops. Phase 2 tags and gates every participating dispatcher instead.

## Open questions

- Which reported percentage belongs to which host? Phase 1's combined token cap
  does not depend on the answer, but per-account calibration does.
- What conservative reservation should bound the final child's overshoot if a
  future campaign needs a strict total-spend ceiling rather than a stop-before-
  next-dispatch ceiling?
- Should campaign-tagged CostRecord append become fail-closed at completion, or
  should a second independent session-log check supply the missing-row proof?
- Should a later account-aware budget key the durable account identity directly,
  or key `host` through an account-mapping configuration so a host can change
  subscriptions without rewriting ledger history?
- What durable configuration should own the flat monthly subscription cost and
  reset instant used for real-equivalent reporting? Phase 1 uses the confirmed
  two-account $400/month total and Friday 9 p.m. Pacific reset; neither belongs
  in the enforcement quantity.
