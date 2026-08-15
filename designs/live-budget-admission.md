---
created: 2026-08-15
updated: 2026-08-15
author: gardener (job `garden-budget-enforcement`)
---

# Live budget admission at every dispatch path

| Created | 2026-08-15 |
| Author  | gardener (job `garden-budget-enforcement`) |
| Status  | Proposed |
| Builds on | [`budgeted-campaign-dispatch.md`](budgeted-campaign-dispatch.md) (phase 1), [`recurring-budget-calibration.md`](recurring-budget-calibration.md) (the bucket), [`omega-task-rank-and-foreman-retirement.md`](omega-task-rank-and-foreman-retirement.md) (the promoter) |

The five-part budget study built a correctly-priced, **retrospective** cost ledger
and an omega task-rank proposal. Nothing it built makes a job *check against* a
budget while it runs. Phase 1 ([`budgeted-campaign-dispatch.md`](budgeted-campaign-dispatch.md))
added a live admission gate, but only for a **serial orchestration that opts in**
with `--budget-tokens N`; phase 2 ([`recurring-budget-calibration.md`](recurring-budget-calibration.md))
adds a persistent bucket, also drawn only by an opt-in `--from-bucket` campaign. A
producer who forgets the flag posts unbudgeted work, and every non-orchestration
dispatch path (foreman promotion, triager posts, watcher posts, schedule dispatch,
a hand-posted `post-job.sh`) carries no budget at all.

This design makes a live budget draw a **standing property of every dispatch**, not
an orchestration opt-in, and makes the manual cross-host worker rebalancing the
liaison did on 2026-08-15 a property of the system. Its central finding is that the
mechanism **already exists and is nearly complete** — `usage-meter.sh` is a
deterministic, near-100%-coverage, per-account live meter, and its `off/unknown/ok/
backoff` verdict is already consulted by the foreman and by the gardener's own
per-job handler. What is missing is three things: the meter is **off** (quota
unset), its verdict is **not consulted at every admission surface**, and **nothing
turns its reading into worker-count leveling**. This design closes those three gaps
and says explicitly how it composes with the omega-ranked promoter.

## 0. The finding that reframes the coverage question

The prompt asks whether raising attribution from `cost-by-pr.sh`'s **28.8%** toward
100% is achievable. The honest answer is that **28.8% is the wrong denominator for
live enforcement**, and the number a live budget rides is already near 100%.

`cost-by-pr.sh`'s 28.8% (`garden-budget-triple.md`) is the fraction of *merged-PR*
cost it can **attribute to a PR**, folding the per-job `usage/<base>.jsonl`
CostRecord ledger. Two things depress it, neither of which a live budget needs to
solve: (a) standing services (foreman, triager, watchman, bulletin) run `claude -p`
**off** the gardener claim spine and never reach `complete-job.sh`, so they write no
`usage/<base>.jsonl` row at all (`garden-budget-omega.md` §2.4); and (b) only a job
that maps to a PR can be joined to one. Attribution-to-a-PR is a genuinely hard,
open-ended problem.

Live budget enforcement does **not** attribute cost to a PR. It asks one question —
*how many billable tokens has this account spent since its weekly reset* — and the
garden already answers it from a different, near-complete source. `usage-meter.sh`'s
primary source is **Claude Code's own session logs** (`~/.claude/projects/**/*.jsonl`),
which record *every* assistant turn on the host, deduped by message id, regardless of
whether the job wrote a `usage/` record or mapped to a PR (`usage-meter.sh` header,
`_meter_session_total`). A foreman `claude -p` that the retrospective ledger cannot
see is nonetheless in the session logs and **is** counted by the live meter.
Therefore the live meter's coverage of a host's Claude spend is effectively ~100%
already, and closing the retrospective 28.8% gap is **not a precondition** for this
design. The two data sources answer two different questions; live enforcement rides
the high-coverage one.

The non-Claude pools (§3) are different and are covered in that section: their spend
is genuinely per-call metered in real dollars, so the `usage/` ledger's dollar rows
are the right source for them, and the attribution gap matters less because those
calls are individually priced rather than pooled under a flat subscription.

## 1. What "the token budget" is

There is not one budget; there are several independent **pools**, and a design that
gates dispatch and levels worker counts must read the same live figure for each.

- **Anthropic — the binding constraint, and the reason this design exists.** The
  fleet runs `claude -p` on **flat Claude Max 20x subscriptions**, two accounts at
  $200/mo each, $400/mo combined (`garden-budget-ratecard.md`). On a flat plan the
  *marginal* dollar cost of a job is ~0 until the plan limit; the binding constraint
  is the **weekly rate-limit quota**, not a dollar ledger (`garden-budget-triple.md`
  follow-ups; `garden-budget-omega.md` §4). Each account is an **independent weekly
  quota**: a job claimed on one host draws only that host's account. This is a token
  budget, measured by `usage-meter.sh` from that host's session logs.
- **Metered API pools (OpenAI/Sol, Moonshot/Kimi, Fireworks).** These bill real
  dollars per call. Their spend is captured in `usage/<base>.jsonl` with real
  `total_cost_usd`, so the pool's spend is a fold of those rows, not a session-log
  token sum. Each is its own pool with its own dollar ceiling.
- **Local (served Qwen / hermit).** Hardware-amortized, ~free at the margin; a pool
  with an effectively very high ceiling, present in the model so the leveling
  controller can prefer it when the paid pools are constrained.

A **pool** is therefore `(provider[, account])`. Anthropic is one provider with two
accounts (its two hosts); the others are one pool each today. The worker kinds map
onto pools by provider: **monk** → Anthropic, **cleric** → OpenAI, **mystic** →
Moonshot, **fireworker** → Fireworks, **hermit** → local (`skills/model-selection`).
The generic gardener/Claude handler draws Anthropic.

**Per-host = per-account is already correct for our topology.** `usage-meter.sh`'s
header carries a `TODO(multi-host)` warning that a per-host session-log sum
*undercounts* a quota that is "GLOBAL to the subscription." That warning describes a
fleet where **one** subscription is shared across **many** hosts. Our fleet is the
opposite — **one subscription per host** — so the per-host session-log sum is exactly
the per-account spend, and the TODO's hazard does not apply. This design records that
topology explicitly (in the pool config below) so the meter's per-host reading is
understood as per-account-correct, not as the undercounting the header warns about.
If the topology ever changes (two hosts sharing one account), the per-account fold
must sum the sharing hosts' session logs via the journal, which is that TODO's real
work and stays out of scope here.

### 1.1 Pools as journal config

Represent the pools as journal config, extending phase 2's proposed
`config/claude-subscriptions` rather than inventing a parallel file. One row per
pool, keyed by pool id, carrying the account→host binding, the ceiling source, and
the ceiling itself:

```
# config/budget-pools — one row per independent budget pool. Tab-separated:
#   pool_id         provider   account/host                  ceiling_kind  ceiling
# ceiling_kind=weekly-tokens: ceiling is billable tokens/week (Anthropic, from
#   usage-meter session logs). ceiling_kind=weekly-usd: real $/week (metered APIs).
#   ceiling_kind=unmetered: effectively unbounded (local).
anthropic:endolin-garden-ece02cb4    anthropic   endolin-garden-ece02cb4   weekly-tokens  <cap-a>
anthropic:endolin-garden2-5bcdff64   anthropic   endolin-garden2-5bcdff64  weekly-tokens  <cap-b>
openai                                openai      -                         weekly-usd     <usd>
local                                 local       -                         unmetered      -
```

The Anthropic ceilings are the **open number** this design cannot invent (§10): the
Max 20x weekly token quota is not machine-readable from the subscription
(`usage-meter.sh` header). Phase 2's `weekly-capacity-calibration.sh` is the
mechanism that *measures* it (max billable tokens over the trailing four weeks per
account); until that lands, the maintainer supplies each account's cap by hand, read
off Claude Code's `/usage` panel. This design **requires** a number in this file to
turn the meter on; it does not fabricate one.

## 2. One admission predicate, consulted at every dispatch surface

### 2.0 Two budget granularities, and three disjoint gates that exist today

Keep two distinct budget concepts separate, because conflating them is the easiest
way to get this wrong:

- **The per-account weekly quota** (`usage-meter.sh`, `GARDEN_TOKEN_WEEKLY_QUOTA`) —
  the rate-limit ceiling of one Claude subscription. This is what should gate
  dispatch and drive leveling; it is the maintainer's primary ask.
- **The per-job token budget** (`role_default_token_budget`/`applied_token_budget`,
  `common.sh`) — a per-job spend cap keyed by role. This **already exists** and is
  already enforced — but **reactively**, only by the reaper when a job is being
  doomed: a doomed job whose output-token spend is over its role budget is parked
  with `sig=over-token-budget` → `budget_hold: true` (`reaper.sh:831-840`,
  `:920-937`). It bounds *how much one admitted job may draw*; it does not decide
  *whether to admit*.

The two compose: the account gate (this design) decides admission; the per-job
budget bounds an admitted job's draw. This design does not change the per-job budget;
it adds the missing account-level admission gate and notes that the same role-keyed
budget could later inform per-job *pre-admission* sizing (a refinement, not built
here).

Three disjoint budget gates exist today, and **none is a universal admission point**:
(1) the foreman **pre-pump** meter gate (`foreman.sh:213`, gates only the autonomous
`claude -p` pump); (2) the reaper **post-hoc per-job** park just described
(`reaper.sh:831-840`); (3) the **orchestration campaign** gate (`orchestrate.sh:581`
via `campaign-spend.sh`, only for a budgeted serial campaign before each child
promotion). This design adds the fourth-and-general one: a per-account admission
predicate at the surfaces below.

### 2.1 The surfaces, and why there is no single chokepoint

The garden has **no single admission chokepoint** — this is the crux. Work reaches a
claimable state through several independent surfaces:

| Surface | How a job becomes claimable | Consults the meter today? |
| --- | --- | --- |
| plan→todo promotion | foreman step 1 batch-promotes `plan_deferred_ranked` into `todo/` (the `promote-plan.sh` loop, `foreman.sh:244-258`); omega's future `garden-promoter` replaces it | the foreman gates its **generative pump** on the meter (`foreman.sh:213`), but **not** its promotion step |
| direct post to `todo/` | `post-job.sh` (`:126`, the nominal routing chokepoint) from a triager, a watcher (`ci-`/`dependabot-`/`pages-watcher.sh`), the scheduler, or the liaison — **but `gauntlet.sh:378-380` and `auction.sh:135` write `JOBS_TODO` directly, bypassing it** | **no** |
| claim | a gardener races `todo/`→`doin/` (`claim-job.sh:176`) at an id-derived offset, arbitrary order, behind the existing `job_eligible_for_kind` / `job_requirements_available` / bid-auction predicates | **no** at claim; the gardener's **handler** gates the per-Claude-call at `mentor-claude.sh:245` (`meter_quota_status != backoff`) |

`post-job.sh` is the closest thing to a chokepoint but two producers bypass it, so a
post-time gate there would not be universal. The **claim** surface *is* universal —
every job, however it was created, is claimed through `claim-job.sh` — which is why
the claim gate (surface 3 below) is the load-bearing one.

Because there is no single post-time chokepoint, the design **does not** try to build
one. It defines one shared predicate and calls it at each surface. The predicate
already exists: `meter_quota_status` returns `off | unknown | ok | backoff` for the
current host's account (`usage-meter.sh:213`). Generalize it to `pool_admits <pool>` — the same
verdict, parameterized by pool, reading the session-log sum for an Anthropic pool or
the `usage/` dollar fold for a metered pool, against that pool's `config/budget-pools`
ceiling and the existing `GARDEN_TOKEN_BACKOFF_FRACTION` (0.85) high-water mark.

The three insertions, each fail-open (`off`/`unknown` ⇒ proceed, per the meter's
existing discipline — a broken meter must never wedge dispatch):

1. **Promotion (foreman today, `garden-promoter` after omega Stage 2).** Before
   promoting a `deferred` plan job, check the account it would most likely run on. In
   practice promotion is fleet-wide (no claimant yet), so the promotion gate is
   **fleet-level**: promote while **any** pool has headroom, and stop batch-promoting
   when **all** relevant pools are in `backoff`. This is a coarse gate; the precise
   per-account decision happens at claim (surface 3), which knows the actual host.
2. **Direct post to `todo/`.** When the fleet-level check is `backoff`, `post-job.sh`
   routes the new job to `plan/` with `--budget-hold` (§4) **instead of** `todo/`,
   so it parks and auto-returns at the next quota refresh rather than sitting
   claimable on an exhausted fleet. When `ok`/`off`/`unknown`, behavior is unchanged.
3. **Claim.** This is the surface that makes per-account enforcement real, because it
   is the only point that knows *which host/account* will run the job. Before a
   gardener commits the `todo/`→`doin/` claim, it consults `pool_admits` for **its
   own** account/pool (the kind it would serve). If that pool is in `backoff`, the
   gardener **declines this job and backs off to another** (exactly the claim-race
   discipline that already exists for a lost push), rather than claiming and then
   dying in the handler. This upgrades the existing `mentor-claude.sh:245` handler
   gate from "claim, then refuse inside the handler (rc=10, risking the
   claim/die/requeue hot loop the model-selection skill warns about)" to "never claim
   on an exhausted account in the first place." The handler gate stays as the
   belt-and-suspenders final backstop.

The predicate is one function; the three call sites are ~a line each. No new meter,
no new ledger, no new source of truth.

## 3. Metered (non-Claude) pools

For a metered pool the ceiling is real dollars and the spend is a fold of
`usage/*.jsonl` `total_cost_usd` over the week, not a session-log token sum. The same
`pool_admits` verdict applies with a dollar comparison. Because these calls are
individually priced (a real API charge per call), their `usage/` rows are the
authoritative record and the 28.8% attribution gap is largely irrelevant here — the
gap is about *which PR* a cost belongs to, not *whether the cost was recorded*. The
one residual gap is the same off-spine one: a standing service that calls a metered
provider without `complete-job.sh` writes no row. Today the standing services are
Claude-only, so this is latent, not live; if a metered standing service is ever
added, it must record its spend (the omega design's recommendation to move residual
proactive spend onto the measured spine, §2.4, applies identically).

## 4. The boundary: defer, do not refuse; warn always

At the ceiling, work is **parked, never refused, and never revoked**. The precedent
is explicit: on 2026-08-15 garden1 burned 20% of its weekly Anthropic quota in the
first ~13 hours after the Friday 21:00 PT reset while garden2 burned 5% with zero
gardeners running; the response was a **rebalance** (raise garden2's gardener count),
not a refusal. The flat subscription makes this the correct instinct — a refused job
saves no money (marginal cost ~0) and the quota resets weekly, so refusing loses work
for nothing. Three dispositions, in the order the system applies them:

1. **Rebalance first (soft, the common case).** While *some* pool has headroom, the
   leveling controller (§5) shifts worker capacity toward it. Dispatch continues.
2. **Park (hard, at a pool's high-water mark).** When a pool hits `backoff`, new work
   that would draw it parks in `plan/` under **`--budget-hold`** — a gate that
   **already exists**: `post-plan.sh --budget-hold` writes `park_reason:
   over-token-budget`, and `budget-refresh.sh` promotes those plans back to `todo/`
   on quota-window rollover. So the deferral disposition and its automatic return are
   built; this design routes budget-exhausted admissions into them. Work already in
   `doin/` is **never** revoked (matching phase 1's "admission controls the next
   promotion; it does not revoke work" and the liveness-reaping design).
3. **Refuse — rejected.** Never the disposition, for the reasons above. Parking is
   strictly better: it preserves the work and returns it automatically at reset.

**Warn always.** Every zone transition (a pool crossing 0.85, a pool exhausting, the
leveling controller changing a worker count) emits one maintainer-inbox notice. The
liaison "noticing" the imbalance is exactly what this design removes; the notices make
the automatic action visible without requiring the liaison to act.

**Align the window to the real reset.** `usage-meter.sh` uses a *trailing* 7-day
window because it documents the subscription reset as "not machine-readable." The
reset **is** now known and confirmed: Friday 21:00 America/Los_Angeles
(`recurring-budget-calibration.md` §1). This design sets the meter's cutoff to that
**fixed weekly anchor** per account (a calendar cutoff `meter_window_total` already
contemplates as a TODO in its header) so the enforced spend matches the real quota
window rather than a rolling approximation that over-counts near a reset. The anchor
is the same one phase 2's calibration and `budget-refresh.sh`'s rollover use, so all
three agree on when the week turns.

## 5. Budget-derived worker leveling (the automatic rebalance)

The manual step this design removes: reading each account's burn and running
`set-workers.sh gardener N` (or the `sysop set-workers` op) to move capacity to the
under-spent host. Make it a deterministic, **leader-only, no-LLM** controller —
`budget-level.sh`, run on the existing scheduler/timer substrate (the same
leader-only singleton class as the foreman and `budget-refresh.sh`; §Alternatives on
why not a new timer).

Each tick, for each account/pool, it computes `remaining = ceiling − spend_since_reset`
(the same derived, never-stored quantity phase 1/2 insist on — no counter to drift),
then sets each host's per-kind worker count toward a target proportional to that
pool's *fractional* remaining headroom, writing through the **existing**
`set-workers.sh` path (which writes `hosts/<host>`'s `<kind>: N` line and refuses
cross-host writes) via the **existing** `sysop set-workers` op for a remote host
(`send-host-op.sh <GARDEN> op=set-workers`). The count it writes is the same
`hosts/<host>` line `gardener-scaler.sh` reads via `read_desired_count` to reconcile
each host's live pool, so the controller steers real worker counts with no new
plumbing. Concretely:

- A pool at/over its high-water mark (`backoff`) → its kind's count on that host
  drops toward a floor (not necessarily 0; the model-selection skill requires each
  host retain at least one qualified non-Claude worker, and `set-workers.sh` already
  refuses `gardeners: 0` without one).
- A pool with ample headroom → its kind's count rises toward a ceiling, up to a
  configured max per host.
- The controller only ever *narrows the gap*; it never sets a count it could not
  justify from the reading, and every change is one `set-workers`/sysop op with a
  logged reason and a maintainer notice.

This directly encodes the 2026-08-15 rebalance: garden1 near its cap → its gardener
count falls; garden2 with headroom and zero workers → its gardener count rises. It is
bidirectional (throttle the over-spender **and** spin up the under-spender), which a
claim-gate alone cannot do — a claim gate stops an over-spending host from claiming,
but cannot start an idle host with headroom, because a host with zero workers claims
nothing regardless of headroom. §2's claim gate and §5's leveling are therefore
**complementary**: the claim gate is the fast, per-job safety valve; the leveling
controller is the slow, capacity-shaping loop.

**Account asymmetry (open, from omega §4).** `hasExtraUsageEnabled` is **true** on
`endolin-garden-ece02cb4` and **false** on `endolin-garden2-5bcdff64`: only one
account can convert overage into a charge; the other simply stalls at the limit. A
leveling policy that maximizes throughput might prefer the extra-usage host for
overflow; a policy that minimizes real dollars would prefer the stalling host and let
work park. This is a maintainer policy choice (§10), not a fact the controller can
decide; until decided, the controller treats both accounts as hard-ceilinged (park at
the limit, no overage), the conservative default.

## 6. How this composes with the omega-ranked promoter

The prompt asks explicitly whether a budget-aware admission gate sits **alongside**,
**ahead of**, or **replaces part of** the omega promoter. The answer is **alongside
and ahead of, as a shared predicate — it replaces nothing in omega**.

The omega design (`omega-task-rank-and-foreman-retirement.md`) governs **ordering**:
its `garden-promoter` picks *which* parked job is promoted next, by omega rank
(human-review-blocked work at the floor, leaves before internal nodes). It says
nothing about *whether* the fleet can afford to promote anything right now. This
design supplies exactly that missing quantity. The composition:

```
garden-promoter tick:
  while todo under-subscribed:
    if not pool_admits(any relevant pool):   # THIS design — admission
        stop promoting; park nothing new; warn
    else:
        next = omega_lowest_ranked(plan_deferred)   # omega — ordering
        promote(next)
```

The budget predicate is a **guard in front of** omega's ordered pick, not a change to
the ordering. Omega decides *what*; budget decides *whether*. They share the
`plan_deferred` pool and the `--budget-hold`/`budget-refresh.sh` park-and-return
machinery: an omega-ranked job that cannot be admitted parks under `budget-hold` and
re-enters the same ranked pool at the next refresh, so its rank is preserved. Neither
design needs the other to land first — omega can order without a budget gate (today's
behavior), and this gate can admit in FIFO/`plan_deferred_ranked` order before omega's
rank exists (also today's behavior). When both land, they compose at the one line
shown above.

The two are also **independently staged**: this design's §2 claim gate and §5
leveling need only `usage-meter.sh` (present) plus a pool config and a controller; they
do **not** depend on retiring the foreman or on jcorbin's still-pending omega
definition (`omega-task-rank-and-foreman-retirement.md` §5 Q1). So this design can
land and turn live enforcement on while omega stays gated on its grounding answer.

## 7. Grounding the pr992 example

`endojs-endo-but-for-bots-pr992-gauntlet` this same window ran **6 full panel/fix
rounds (12 gardener dispatches)** and still **halted at `max_iterations=6` without
converging** (`endojs-endo-but-for-bots-pr992-gauntlet.md`). It stopped on an
**iteration count**, a proxy that is blind to spend: 6 cheap rounds and 6 expensive
rounds halt identically, and neither halt can say whether continuing was worth it.

A budget-aware gauntlet answers that. The gauntlet is itself an orchestration, so it
can carry phase 1's `--budget-tokens` (or phase 2's `--from-bucket`) **in addition
to** `max_iterations`, and halt on whichever binds first. More importantly, under this
design the gauntlet's per-round gardener dispatches pass through the §2 claim gate:
when the account is near its cap, round 6 does not get claimed at all — it parks under
`budget-hold` and resumes after the reset. So the system gains a spend-denominated
answer to "was round 6 worth it?" — *before* round 6 when the account is constrained
(the claim gate defers it), and *after the fact* in the terminal report (total
panel/fix billable tokens compared to the cap). This is the concrete win: a halt criterion
that is about the scarce resource (quota), not an arbitrary round count.

Note the omega finding tempers the ambition (`garden-budget-omega.md` §0): machine
cost is ~50–190× *below* human-review cost, so the gauntlet's token spend is small in
absolute terms. The value of gating it is not dollar savings — it is not stalling the
*whole fleet's* shared account on one non-converging PR when other work needs the
quota. The budget gate makes that tradeoff explicit and automatic.

## 8. Build slice (design only in this job; no build here)

Ordered so live enforcement can turn on before the leveling controller:

1. **Turn the meter on.** Seed `config/budget-pools` with the two Anthropic accounts
   and a maintainer-supplied per-account weekly-token cap (from `/usage`, or from
   phase 2's calibration once it lands); set `GARDEN_TOKEN_WEEKLY_QUOTA` per host from
   it. Align the window to the Friday 21:00 PT anchor.
2. **`pool_admits <pool>`** in `common.sh`/`usage-meter.sh` — generalize
   `meter_quota_status` to a pool argument (session-log sum for Anthropic, `usage/`
   dollar fold for metered pools), reusing the `off/unknown/ok/backoff` verdict and
   the 0.85 high-water mark, fail-open unchanged.
3. **Claim gate** in `claim-job.sh` — decline-and-back-off when the claiming host's
   pool is in `backoff`. Keep the `mentor-claude.sh:245` handler gate as backstop.
4. **Direct-post routing** in `post-job.sh` — route to `plan/ --budget-hold` instead
   of `todo/` when the fleet-level check is `backoff`.
5. **Promotion gate** in `foreman.sh` step 1 (and the future `garden-promoter`) —
   stop batch-promoting when all relevant pools are in `backoff`.
6. **`budget-level.sh`** — the leader-only, no-LLM leveling controller, on the
   scheduler substrate, writing per-kind counts through `set-workers.sh` / the sysop
   `set-workers` op, with logged reasons and maintainer notices.
7. **Tests:** meter-off ⇒ every gate transparent; pool at high-water ⇒ claim
   declines / post parks / promotion halts; fail-open on unreadable meter ⇒ all gates
   proceed with a warning; `doin/` work never revoked; leveling raises the under-spent
   host and lowers the over-spent one and never sets `gardeners: 0` without a
   qualified non-Claude worker; budget-held plans return at the anchor via
   `budget-refresh.sh`.

## 9. Alternatives considered

- **A single new admission chokepoint** all dispatch is funneled through. Rejected:
  the garden's dispatch surfaces are deliberately several (promote, direct-post,
  claim), and `claim-job.sh` already claims `todo/` in arbitrary order by design. One
  shared *predicate* at the existing surfaces is far less invasive than re-routing
  every producer through a new gate, and matches how the meter is already wired
  (foreman + handler).
- **Gate only at claim (skip promotion/direct-post gates).** Rejected as insufficient
  alone: claim gating throttles an over-spending host but leaves exhausted-fleet work
  sitting claimable in `todo/` (churning claim/decline cycles) and cannot spin up an
  idle host with headroom. The direct-post park and the leveling controller are what
  make the rebalance bidirectional.
- **Refuse over-budget work.** Rejected: marginal cost is ~0 on a flat plan and the
  quota resets weekly, so refusal loses work for no saving. Park-and-return is
  strictly better and already built (`--budget-hold` + `budget-refresh.sh`).
- **A stored per-pool "spent" counter.** Rejected for the same reason phases 1–2 did:
  it duplicates the session-log/ledger truth and needs transactional updates on every
  completion and requeue. Spend is derived fresh at read time.
- **A dedicated `garden-budget-level.timer`.** Deferred: the scheduler's leader-only
  singleton substrate already gives drift-free cadence, leader-only gating, and the
  handoff-follows-the-leader property for free, as phase 2 argued for its calibration.
  A second timer duplicates all of it.
- **Trailing-window meter (keep today's default).** Rejected now that the reset is
  known: a fixed Friday-21:00-PT cutoff matches the real quota window; the trailing
  window over-counts near a reset and can't agree with `budget-refresh.sh`'s rollover.

## 10. Open questions for the maintainer

Following the `garden-budget-omega` pattern — post a grounding question rather than
guess when a term or number cannot be confirmed.

1. **The per-account weekly token cap.** Still not machine-readable from the
   subscription (`usage-meter.sh` header). This design needs a number in
   `config/budget-pools` to turn the meter on. Supply it from Claude Code's `/usage`
   panel per account, or land phase 2's `weekly-capacity-calibration.sh` to measure
   it (max billable tokens over the trailing four weeks). Until then the gates stay
   `off` (transparent) — safe, but not enforcing.
2. **Account-asymmetry policy** (`hasExtraUsageEnabled` true on `…ece02cb4`, false on
   `…5bcdff64`, omega §4). Should leveling prefer the extra-usage host for overflow
   (max throughput, some real charge) or treat both as hard-ceilinged (park at the
   limit, zero overage)? Default until answered: hard-ceiling both.
3. **High-water fraction and whether to gate at 0.85 or 1.0.** The meter backs off at
   0.85 for the foreman's *generative pump* (a deliberately conservative margin for
   undirected spend). Is 0.85 also right for *directed* board work, or should ordinary
   jobs run closer to 1.0 and only the pump keep the 0.85 margin? (A per-surface
   fraction is a one-line change.)
4. **Leveling shape.** Proportional-to-headroom, or threshold/hysteresis bands (avoid
   thrashing counts each tick)? And the per-host per-kind floor/ceiling counts the
   controller moves between.
5. **Should the promotion gate be fleet-level or per-account?** Promotion has no
   claimant yet, so it can only gate fleet-wide (promote while any pool has headroom).
   Is that coarse gate acceptable, given the claim gate makes the precise per-account
   decision, or is a host-targeted promotion queue wanted (which needs omega's Phase 2
   host-aware reservation in the claim path — `budgeted-campaign-dispatch.md` §Phase 2)?
