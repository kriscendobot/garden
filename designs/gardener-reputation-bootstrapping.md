# Design: reputation bootstrapping, cost as the free variable, and explore/exploit role discovery

| Created | 2026-06-29 |
| Author  | gardener |
| Status  | Proposed |

Companion to [`gardener-bid-accept-market.md`](gardener-bid-accept-market.md),
tracking issue [kriskowal/garden#15](https://github.com/kriskowal/garden/issues/15).

The market design defined the bid/accept lifecycle and a binary accept/reject
reputation ledger. This document answers the maintainer's follow-up directive on
the same issue:

> Please also design the reputation bootstrapping. We will need to measure past
> and future jobs both in terms of effectiveness and cost. We control for
> effectiveness with the acceptance criterion, so the cost is a free variable.
> The cost should be normalized to dollars and duration. A job post may
> differentiate bids based on urgency, quality, or cost. So, we should begin to
> build a reputation of the current gardener as a basis. Then, we should have a
> framework for future evaluation. We will want to explore and exploit the
> marketplace, striving to maximize results by exploiting known winners, but
> also experimenting with new models and refined roles. A component of this
> workflow should be the refinement of roles, thus creation of new bidders with
> fresh reputations, based of watching prior jobs. And also, a cap on the number
> of roles, or hierarchically discovered roles, with an organizer or
> consolidator.

Six questions follow from that, and this document answers each in turn:

1. **What does reputation measure** (effectiveness and cost), and how is cost
   normalized to dollars and duration? (§1)
2. **How is reputation bootstrapped** from the current, undifferentiated fleet so
   we start from a measured basis rather than a blank slate? (§2)
3. **How does a job post differentiate bids** on urgency, quality, or cost? (§3)
4. **How does the market explore and exploit**, exploiting known winners while
   experimenting with new models and refined roles? (§4)
5. **How are new bidders created** by refining roles from watching prior jobs,
   and why do they start with fresh reputations? (§5)
6. **How is role proliferation bounded** by a cap, or by hierarchical discovery
   with an organizer or consolidator? (§6)

Then where it all lives in the journal (§7), how it rolls in without breaking the
fleet (§8), the open questions (§9), and what this decides versus defers (§10).

---

## 1. The measurement model: effectiveness gates, cost ranks

The directive contains the load-bearing simplification: **we control for
effectiveness with the acceptance criterion, so cost is the free variable.**
Taken precisely, that means reputation is not one scalar but two layers with
different shapes.

### 1.1 Effectiveness is a gate, not a score

A submission either passes the acceptance oracle (the objective plus subjective
split from the market design's §4: `local-verify`, CI green, the judge panel, and
the maintainer or scoring broker for the subjective term) or it does not. Pass
means **admissible**; fail means **inadmissible**. There is no partial credit on
the effectiveness axis: a half-correct PR that fails the panel is simply rejected.
That is exactly what "control for effectiveness with the acceptance criterion"
buys us. It collapses the hard-to-quantify question "how good is the work" into a
binary the garden already computes, so the *interesting* variable left to measure
is cost.

### 1.2 Cost is the free variable, normalized to dollars and duration

Among **admissible** outcomes, the differentiator is **cost**, with the two
components the maintainer named:

- **Dollars.** Token spend times model price. The garden already meters tokens
  deterministically, in plain code with no model in the loop, from Claude Code's
  own session logs (`scripts/jobs/usage-meter.sh`, which sums billable
  input + output + cache-creation tokens over a window). A per-model price table
  (`reputation/pricing.md`, journal config) converts those tokens to dollars.

  **Dollars is the normalization unit** (maintainer directive on this design):
  cost normalizes to dollars, *not* to the Claude-subscription token quota, even
  though the quota is today's binding constraint (§9). The reason is the future
  the directive names: the garden **will eventually bid across other LLM
  providers**, and dollars is the only common denominator across them. Token
  counts are not comparable across providers (different tokenizers, different
  per-token prices), and a Claude-subscription quota is Claude-specific, so
  neither survives a multi-provider market. Dollars does. We commit to it now so
  the measure is provider-agnostic from the start.

  Honesty note: today the whole fleet runs on a single Claude Max subscription,
  not a metered API key (see the billing model documented at the top of
  `usage-meter.sh`). So the marginal dollar cost of any one job is currently
  effectively zero against a flat monthly fee, and the dollar figure is therefore
  **notional**: tokens valued at public API list prices. That is still the right
  yardstick, because it makes models *comparable* (Opus costs more notional
  dollars per token than Haiku) even when the real bill is flat, and it becomes a
  *real* marginal cost the moment a metered (or competing-provider) arm bids. We
  measure notional dollars to *rank* arms today; the same dollar axis settles a
  real invoice once arms bill per token.

- **Duration.** Wall-clock from award (the accept push that moves
  `todo -> doin`) to acceptance (the oracle pass that moves `submitted -> tada`).
  Both timestamps already exist in the journal. Duration captures what dollars
  miss: a cheap model that needs five fixer rounds is slow even if each round is
  inexpensive.

Keep **both raw components** in every ledger event. A single scalar cost is
*derived* from them under a weighting (§3), never stored as the only number, so
the weighting can change without rewriting history.

### 1.3 Reputation is a cost distribution, conditioned on acceptance, per arm

The unit of reputation is an **arm**: a `(role, model)` pair (optionally refined
by skill set, §5), scored **per job kind**. An arm's reputation for a kind is the
**distribution of cost over its admissible outcomes** on that kind, not a point
estimate. A distribution, because explore/exploit (§4) needs the *uncertainty*,
not just the mean.

Effectiveness re-enters here as the arm's **acceptance rate**: the fraction of its
submissions on a kind that passed the gate. Rejections are not free. A rejected
attempt still spent dollars and duration before the panel turned it down. So the
honest figure the broker compares is **cost per accepted deliverable**, which
amortizes the wasted rejected attempts over the successes:

```
expected cost per accepted job  ≈  (mean cost per attempt) / (acceptance rate)
```

This single quantity unifies the two things the directive asked us to measure. A
cheap-but-flaky arm (low cost per attempt, low acceptance rate) and an
expensive-but-reliable arm (high cost per attempt, high acceptance rate) land on
the *same* dollars-and-duration-per-accepted-job axis and can be ranked directly.
Effectiveness was controlled for by the gate; its residue (the acceptance rate)
folds back in as a cost multiplier rather than a competing score.

---

## 2. Reputation bootstrapping: seeding from the current fleet

The directive: "we should begin to build a reputation of the current gardener as
a basis." There are two seed sources, in decreasing fidelity. Use both.

### 2.1 Retrospective seeding from journal history (the strong basis)

Every completed job already left a `tada/<base>` report; the journal carries the
claim and completion timestamps; and the usage meter (or the raw session logs it
reads) carries the token spend over that interval. So **the entire history of the
current undifferentiated fleet is already a labeled dataset.** Each past job
yields a tuple:

```
(kind, role-worn, model-used, accepted?, dollars, duration)
```

where the **acceptance label** comes from the terminal state the garden already
records: a PR merged or un-drafted, a design un-drafted, a panel that passed, a
`tada` with no rejection event is **accepted**; a job that was requeued,
abandoned, or reaped without a terminal artifact is **rejected**.

Replaying this history populates the per-arm cost distributions (§1.3) as **shadow
reputation events** before the market ever awards a live job. This is precisely
"a reputation of the current gardener as a basis": measured from what the fleet
actually did, not assumed.

Caveat, stated plainly: historical jobs were **not competitively bid**. The cost
observed is "what the one gardener that happened to be assigned incurred," not
"the cost of the best available bidder." So retrospective seeding produces a
**prior, not a verdict**. It is a good cold-start prior precisely because it is
real fleet data, and it is refined by live competitive data as the market runs.

This source needs **no new instrumentation** and can begin immediately (§8): it
reads only what the journal and the session logs already hold.

### 2.2 Active seeding by todo/tada replay (for thin arms and newcomers)

Retrospective seeding cannot score an arm that has *no* history: a brand-new model
tier, or a freshly refined role (§5). For those, specify the market design's §5.3
forward pointer as a concrete procedure:

Replay a known-good `tada` artifact as a **synthetic job**. An agent poses as the
customer with the original job's brief; the candidate arm attempts it; acceptance
is scored by **re-running the original artifact's own acceptance gate** (its tests
and panel, which the garden already has). Convergence (passing that same gate)
earns the arm a **seed cost sample** (the dollars and duration of the synthetic
attempt). This warms a new arm's distribution without waiting for live work to
accrue it.

Three disciplines keep synthetic seeding honest:

- **Score by the acceptance gate, not by diff distance.** The acceptance criterion
  is the thing we control effectiveness with (§1.1), so re-running it is the
  faithful measure. Diff distance to the historical artifact would overfit the arm
  to one particular solution rather than to the capability.
- **Seed with inflated uncertainty.** A synthetic sample is a *prior with wide
  variance*, never ground truth. The bandit (§4) still explores the arm on live
  work in proportion to that uncertainty rather than trusting the synthetic cost
  outright. This is the guard against the overfitting risk the market design
  flagged.
- **Evaluate on contemporary artifacts (maintainer directive).** Draw the replay
  set from **recent** completed jobs, not the whole archive. A contemporary
  artifact still passes its own gate on the current tree, so drift exclusion falls
  out for free (a `tada` whose tests no longer pass today is by definition not
  contemporary and is pre-filtered deterministically: re-run the gate on the
  *original* artifact first and drop it if it fails today). More importantly,
  because the set continuously refreshes with new real jobs, there is **no fixed
  corpus for an arm to overfit to**: the evaluation target moves with the codebase
  and with the current capability bar, which makes it a rolling out-of-time holdout
  rather than a static benchmark. This is the §9 synthetic-replay-overfitting
  guard made concrete.

---

## 3. Job posts differentiate bids: urgency, quality, cost

The directive: "A job post may differentiate bids based on urgency, quality, or
cost." A job post carries a **demand-weight vector** in its frontmatter:

```yaml
weights: { urgency: 0.2, quality: 0.5, cost: 0.3 }   # normalized to sum 1
```

Each weight steers the broker toward a different facet of an arm's reputation
distribution:

| Job weight | What it up-weights in the arm's reputation |
| --- | --- |
| **urgency** | Low **duration**. Pay more notional dollars, accept a pricier model, to finish sooner. |
| **cost** | Low **dollars**. Tolerate a slower arm to spend fewer notional dollars. |
| **quality** | High **acceptance rate** and the subjective-oracle track record (low rejection history, strong panel verdicts), biased toward the more capable model tier. "Quality" is "how confident are we it passes on the first try and is judged *good*," which is exactly the acceptance-rate and subjective-audit signal from §1.3 and the market design's §4.2. |

The broker's scoring function (the deterministic, no-LLM broker from the
market design's §1.3) collapses each bidding arm's distribution to a scalar
**under the job's weight vector**, then ranks. A high-urgency hotfix up-weights
duration; a cost-sensitive batch refresh up-weights dollars; a quality-critical
design up-weights acceptance rate and tier. This is the demand signal (the job's
weights) meeting the supply signal (the bid's advertised distribution). A default
weight vector lives in `reputation/weights-default.md` so a job that declares none
inherits a sensible blend.

---

## 4. Explore and exploit: the marketplace as a bandit

The directive: "explore and exploit the marketplace, striving to maximize results
by exploiting known winners, but also experimenting with new models and refined
roles." This is a textbook **contextual multi-armed bandit**, and naming it as
such gives us a principled, deterministic selection rule.

- **Arms:** the `(role, model[, skill-set])` tuples (§1.3).
- **Context:** the job's `(kind, weight vector)` (§3).
- **Reward:** negative expected cost-per-accepted-job under the job's weights
  (§1.3, §3). Maximizing reward minimizes weighted dollars-and-duration per
  accepted deliverable.

### 4.1 Thompson sampling fits because reputation is already a distribution

The selection rule is **Thompson sampling** over the per-arm cost posteriors:

1. For each eligible arm, draw one sample from its posterior cost distribution for
   this kind.
2. Collapse the sample under the job's weight vector (§3).
3. Award the arm with the best sampled (lowest weighted-cost) draw.

This **exploits** automatically (an arm with a confidently low cost almost always
samples low and wins) and **explores** automatically (an arm with wide
uncertainty, a new model or a refined role, occasionally samples low and gets
tried), in proportion to uncertainty, with **no hand-tuned exploration rate**.
Thompson sampling is the clean fit precisely because §1.3 made reputation a
distribution rather than a point: the machinery the directive asks for is already
the shape we chose to store.

It also subsumes the market design's "mild exploration bonus for newcomers": a
newcomer is just an arm with a wide prior (from §2.2 synthetic seeding or from
nothing), so it gets sampled into contention in proportion to how unsure we are,
and a few real wins quickly sharpen its posterior so it either earns exploitation
or fades.

### 4.2 Determinism and budget-awareness

- **Deterministic and auditable.** The garden forbids `Math.random` in its
  deterministic paths. The posterior draw uses a **seeded** pseudo-random
  generator keyed on a hash of the job base, so the same job and the same ledger
  always select the same arm, and any selection is reproducible and explainable
  from the journal. The broker stays no-LLM.
- **Budget-aware exploration.** The usage meter already gates the fleet against
  its weekly token quota. Exploration is the first thing to throttle when the
  budget tightens: as the trailing-window spend approaches the cap, **narrow the
  posteriors** (or fall back toward pure exploit) so the fleet rides known-cheap
  winners until the window resets, then resumes exploring. Exploration is a
  budgeted investment in better future allocation, and it yields first when the
  budget is scarce.

---

## 5. Role refinement: minting new bidders from watching prior jobs

The directive: "refinement of roles, thus creation of new bidders with fresh
reputations, based of watching prior jobs." The market should not just allocate
among a fixed set of arms. It should **grow new arms** where the evidence says the
current ones are expensive.

- A **role-refiner** runs on a cadence (like the existing design-poller: a
  scheduled job, not a standing LLM). It **watches the reputation ledger** for
  signal: a kind whose best arm still has a high cost-per-accepted-job, or a
  rejection reason the panel keeps citing on a kind. Either is a **gap** the
  current role repertoire serves poorly.
- The refiner proposes a **new or refined role**: a variant `AGENT.md` with a
  tighter skill mix, a sharper operating norm, or a different model pairing,
  targeted at the observed gap. This reuses the garden's existing
  self-improvement and "carve a role" machinery, but now **driven by reputation
  evidence** rather than by ad-hoc intuition. A refined role's lineage (its parent
  role, the gap that motivated it, its birth event) is recorded so the
  consolidator (§6) can reason about it.
- The new role enters the market as a **fresh bidder with a neutral, wide-variance
  prior**: no inherited reputation. That is what "fresh reputations" means and why
  it is correct. A refined role is an *hypothesis* ("a sharper builder will close
  test-hardening jobs cheaper"), and it must earn its standing on evidence, not
  borrow its parent's. The bandit (§4) explores it; §2.2 synthetic replay can
  pre-warm it. If it beats the incumbent on weighted cost-per-accepted-job, it
  gets exploited. If not, it is rarely selected and is eventually pruned (§6).

This closes the loop the directive describes: watch prior jobs, find where the
market is expensive, mint a fresh-reputation bidder aimed at the gap, and let the
bandit decide on evidence whether it is actually better.

---

## 6. Bounding role proliferation: a cap, a consolidator, and hierarchy

Unbounded minting (§5) would explode the arm space and **starve the bandit**: too
many arms, too little data per arm, exploration never converges and the fleet
churns forever on unproven roles. The directive names the bound directly ("a cap
on the number of roles, or hierarchically discovered roles, with an organizer or
consolidator"). Three mechanisms, in increasing sophistication.

### 6.1 A hard cap with forced churn (ship first)

A hard cap on **active roles per kind** (`reputation/role-cap`, config). When the
refiner wants to mint role N+1 and the cap is already met, it must first **retire
the worst-performing active role** for that kind (the one with the lowest exploit
share over a trailing window). This converts unbounded growth into **steady-state
churn**: the role set stays bounded, and a new hypothesis must displace a weak
incumbent rather than simply adding to the pile.

### 6.2 The consolidator (the organizer the directive names)

A scheduled **consolidator** periodically reviews the active role set and is the
garbage collector for the arm space:

- **Merge redundant roles.** Two roles whose cost-and-acceptance distributions
  over the kinds they bid on are statistically indistinguishable collapse into
  one, inheriting the **union** of their reputation evidence (so the merge loses
  no data and sharpens the survivor's posterior).
- **Prune dominated roles.** A role that is never selected because another role
  beats it on every kind it bids on is removed (its lineage record retained as
  history).

This keeps the bandit's arm count tractable and the `roles/` library legible. It
is the deterministic counterpart to the refiner: the refiner adds arms where the
market is expensive; the consolidator removes arms that are redundant or
dominated. Together they hold the role set near a useful working size.

The test that decides "statistically indistinguishable" is **not frozen at design
time**. Its three knobs — the **test** itself (the distributional comparison), its
**significance/power**, and the **trailing window** of events it reads — are a
journal **control parameter**, `reputation/consolidator-stats.md` (config, §7), so
they can be retuned without a code change. The tension is real and two-sided: a
loose setting merges too eagerly and erases distinctions the market would have
rewarded; a strict one never consolidates and lets the arm space bloat. Neither
failure is knowable in advance, so the parameter is **watched and optimized**. The
bulletin surfaces every consolidator merge and prune with the evidence that drove
it, and the maintainer (or a later scheduled tuner) ratchets the knobs against the
observed merge-and-prune rate — tightening when good arms are being merged away,
loosening when redundant arms persist. This is the explicit shape the maintainer
chose for this question (§9): a tunable journal knob with a feedback loop, not a
constant guessed at design time.

### 6.3 Hierarchical discovery (the follow-on)

The richer option the directive offers as an alternative: roles form a **tree**
rather than a flat set. A generalist parent (`builder`) has specialized children
(`web-builder`, `test-hardening-builder`) discovered by refinement. Selection
descends the tree: pick the parent by coarse kind, then the child by fine context.
The cap then applies **per level** (a bounded branching factor), and the
consolidator merges *siblings* rather than scanning the whole flat set. The
organizer maintains the tree: promote a high-performing child to a sibling of its
parent, demote a redundant child back into its parent. A balanced tree of depth
`d` and branching `b` holds `b^d` arms but needs only `O(b)` comparisons per
selection level, so specialization can be fine without the selection cost or the
data-per-arm starvation of a flat explosion.

### 6.4 Recommendation

Ship **§6.1 hard cap plus §6.2 consolidator** first: flat, simple, and enough to
bound the space and prove the refinement loop works. Treat **§6.3 hierarchy** as
the follow-on, adopted only once the flat refiner-and-consolidator loop has
demonstrated that reputation-driven role minting produces arms worth specializing.

---

## 7. Where it lives: extending the market's reputation tree

This design extends the `reputation/` journal tree the market design introduced.
Every surface is single-writer-per-file: an append-only ledger plus derived
projections, the same discipline as the rest of the journal, with **no lock
service**.

```
reputation/pricing.md                       per-model notional $/token table (config)
reputation/weights-default.md               default urgency/quality/cost demand weights (config)
reputation/role-cap                         per-kind active-role cap (config)
reputation/consolidator-stats.md            consolidator indistinguishability test, power, and trailing window (config; §6.2)
reputation/ledger/<Y>/<M>/<D>/...           append-only events (source of truth)
reputation/arms/<role>@<model>/<kind>.md    per-arm cost+acceptance posterior (derived projection)
reputation/roles/<role>.md                  role record: lineage (parent), birth event, prior, status
reputation/seeds/...                        synthetic-replay seed events (flagged, wide variance)
```

The ledger event from the market design's §3.1 gains the fields this design needs:

```yaml
---
event: accepted | rejected
gardener: <id>@<host>
arm: <role>@<model>            # the (role, model) arm, for per-arm projection
base: <job-base>
kind: <job-kind>
dollars: <notional-usd>        # tokens * pricing.md, from the usage meter
duration_s: <seconds>          # award timestamp to acceptance timestamp
accepted: true | false         # the effectiveness gate (§1.1)
attempts: <n>                  # attempts on this base so far, for amortization (§1.3)
synthetic: true | false        # a §2.2 seed sample (wide variance) vs a live outcome
oracle: panel | maintainer | scoring
at: <iso8601>
---
<one-line citation: the PR / design / SHA and the disposition reason>
```

The per-arm posteriors under `reputation/arms/` are **derived projections** the
foreman (or a dedicated reducer) recomputes from the ledger, so the contended
write surface is only the append-only event log, never a tally.

---

## 8. Migration and coexistence: additive on the market's phases

This slots into the market design's phased, race-by-default, shadow-first rollout
without changing its rollback guarantees.

- **Phase 1 (shadow), extended and startable now.** The shadow ledger records
  `dollars`, `duration_s`, and `accepted` for **all** jobs, including today's race
  jobs, retroactively seeded from journal history (§2.1). This has **zero
  behavioral effect**: it is pure measurement, and it can begin **immediately,
  even before bid/accept ships**, because it reads only what the journal and the
  session logs already record. The bulletin surfaces the shadow per-arm
  cost-per-accepted-job so the maintainer can sanity-check the measure before it
  influences anything.
- **Phase 2 (bid/accept on the opt-in kind).** The broker uses the
  cost-conditioned-on-acceptance posteriors with Thompson sampling (§4); job posts
  carry weight vectors (§3); the maintainer broker remains the override for
  expensive or novel work.
- **Phase 3 (role refinement).** Turn on the refiner (§5) and the consolidator
  (§6.2) under the hard cap (§6.1), on the opt-in kind only. Measure whether
  reputation-driven minting actually lowers cost-per-accepted-job.
- **Phase 4 (hierarchy).** Adopt §6.3 only if the flat refinement loop proves out.

Rollback stays trivial at every phase: the ledger is append-only and harmless if
ignored, weights default to a fixed vector, and the refiner off means a fixed arm
set. Nothing here can break the live race-by-default fleet.

---

## 9. Open questions

- **The token quota is today's real binding constraint.** Dollars is the settled
  normalization unit (§1.2, maintainer directive: normalize to dollars for the
  multi-provider future). Under today's flat Claude subscription, though, the
  scarce resource that actually binds is the **weekly token quota**, not dollars.
  The resolved shape: dollars is the cross-provider *cost* axis the bandit
  optimizes; the quota stays a separate *budget* gate that throttles exploration
  near the cap (§4.2). Open: whether the quota should also display as a notional
  dollar burn-down for the maintainer, or stay a distinct token gauge.
- **Duration is contended by fleet load (resolved: leave it in the noise).** A job
  can be slow because a hundred gardeners are busy, not because its arm is slow.
  The maintainer's directive settles it: **leave this in the noise.** The garden is
  not often busy, and is statistically equally busy for most jobs, so fleet-load
  contention averages out across many jobs rather than biasing any one arm.
  Duration is therefore taken **raw** — **not** normalized by concurrent fleet load
  at award time — and the bandit averages it out across the arm's history.
- **Total job cost includes sunk costs, and that is a germane criterion.**
  *(Resolved, maintainer directive on this design.)* The earlier framing treated a
  requeued job's wasted first attempt as "separate kind-level economics" and
  charged each arm only its own attempt. That under-weighted the thing most worth
  optimizing. The correction: **the total cost of a job includes its sunk costs**,
  and whether a particular agent configuration tends to result in **fewer sunk
  costs, less waste, and less attention from the maintainers** is one of the more
  germane evaluation criteria — arguably the central one. Two levels follow, and
  they do not conflict:
  - **Arm-level reputation is unchanged.** An arm is still scored on its own
    cost-per-accepted-job (§1.3), which already charges it for its own failed
    attempts through the acceptance-rate amortization. Reputation still reflects an
    arm's own efficiency, and an arm is still not penalized for a *predecessor's*
    failure on a requeue.
  - **Configuration-level cost is the objective the broker minimizes.** Above the
    individual arm sits the **configuration** — the broker policy and the arm mix
    it routes through. Its score is the **expected total cost to acceptance for the
    whole job, summed across every attempt and every arm the routing touched,
    including the sunk cost of each rejection and requeue.** A configuration that
    reaches acceptance in one cheap attempt beats one that burns three arms getting
    there, even when each individual arm looked locally efficient. Minimizing
    sunk, wasted, and maintainer-attention cost is an explicit goal here, not a
    footnote — so this measure is one the bulletin surfaces and the market is tuned
    to drive down over time.
  - **Maintainer attention is a cost.** The directive names *less attention from
    the maintainers* as waste on equal footing with sunk dollars. It is metered the
    same deterministic, no-LLM way as dollars and duration: a count of the times a
    job pulled a human in — clarifying questions, review rounds, follow-up
    directives, manual interventions — each already journaled as a comment, review,
    or inbox message. A configuration that closes a job without human steering
    costs less, on this axis, than one that needs three rounds of it, and the
    ledger says so.
- **Synthetic-replay overfitting (resolved by a contemporary evaluation set).**
  Posing-as-customer (§2.2) risked training arms to historical artifacts rather
  than to general capability. The maintainer's directive settles it: **for
  evaluation, test with contemporary historical artifacts.** A rolling, recent
  replay set (§2.2) removes the fixed corpus an arm could overfit to and keeps the
  measure aligned with the current tree and the current capability bar; together
  with acceptance-gate scoring and wide-variance seeding, the residual overfitting
  risk the market design's §5.3 flagged is bounded. Residual open: how wide the
  "contemporary" window should be, which is itself a control parameter to watch and
  tune (like the consolidator's trailing window in §6.2).

---

## 10. What this decides, and what it defers

**Decides:**

- **The measurement model:** effectiveness is a gate (binary acceptance), cost is
  the free variable, normalized to **dollars** (the cross-provider unit, metered
  tokens at list prices — notional today under a flat subscription, real once arms
  bill per token or other providers bid) and **duration** (award-to-acceptance
  wall-clock, taken raw — **not** normalized by fleet load, since the contention
  averages out across jobs, §9), unified as weighted **cost per accepted job** that
  folds the acceptance rate back in (§1).
- **Total job cost is the configuration's score, sunk costs included:** an agent
  configuration is evaluated on the expected total cost to acceptance summed across
  every attempt and arm a job touches — including the sunk cost of every rejection
  and requeue, plus **maintainer attention** as a third metered cost component.
  Fewer sunk costs, less waste, and less maintainer attention is a first-class
  evaluation criterion the market drives down (§9).
- **The bootstrap:** retrospective seeding from the journal's own
  `todo`/`tada` history as the basis for the current fleet, plus synthetic
  `tada`-replay for thin arms and newcomers, scored by re-running the original
  acceptance gate (§2).
- **Demand differentiation:** a per-job urgency/quality/cost weight vector steers
  the broker across the arm's cost distribution (§3).
- **Explore/exploit:** a contextual bandit with **Thompson sampling** over the
  per-arm cost posteriors, deterministic via a job-seeded generator and
  budget-throttled near the token quota (§4).
- **Role refinement:** a reputation-driven refiner mints **fresh-prior** bidders
  aimed at observed gaps (§5).
- **The bound:** a hard cap with forced churn plus a consolidator that merges
  redundant and prunes dominated roles, with a hierarchical role tree as the
  follow-on (§6). The consolidator's indistinguishability test, its power, and its
  trailing window are a **journal control parameter**
  (`reputation/consolidator-stats.md`), watched and optimized through the bulletin
  rather than frozen at design time (§6.2).

**Defers** (follow-on designs): the hierarchical role-tree mechanics (§6.3);
whether the token quota also displays as a notional dollar burn-down (§9); and the
meta-machine of competing gardens (still the market design's §5.2).

## References

- [`gardener-bid-accept-market.md`](gardener-bid-accept-market.md): the bid/accept
  lifecycle, the pluggable broker, the binary reputation ledger, and the AMiX
  objective/subjective acceptance oracle this design measures and bootstraps.
- [`job-board.md`](job-board.md): the `todo`/`tada` claim/complete lineage that is
  the retrospective bootstrap's labeled dataset (§2.1).
- [`gardening-state-machine.md`](gardening-state-machine.md): how a gardener
  supervises a job, including the panel that is the objective acceptance gate.
- [`../skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md): the
  per-task model-tier choice the market expresses as a bid axis and the bandit
  learns.
- `scripts/jobs/usage-meter.sh`: the deterministic, no-LLM token meter, sourced
  from Claude Code session logs, that is the dollar-cost primitive (§1.2).
- Issue [kriskowal/garden#15](https://github.com/kriskowal/garden/issues/15) and
  its grounding comments: the Gimix lineage and the reputation-for-information-
  goods framing.
- [What Agoric learned from
  AMiX](https://agoric.com/blog/technology/what-agoric-learned-from-amix): the
  objective/subjective acceptance split that §1.1 turns into the effectiveness
  gate.
